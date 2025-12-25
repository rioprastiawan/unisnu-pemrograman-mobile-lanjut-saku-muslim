import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../models/prayer_time.dart';
import 'package:intl/intl.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  final NotificationService _notificationService = NotificationService();
  final TextEditingController _minutesController = TextEditingController(text: '1');
  final TimeOfDay _testTime = TimeOfDay.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  Future<void> _testImmediateNotification() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.showImmediateNotification(
        title: '🧪 Test Notification',
        body: 'Ini adalah test notification. Suara adzan akan berbunyi!',
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Notifikasi dikirim!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testScheduledNotification() async {
    final minutes = int.tryParse(_minutesController.text) ?? 1;
    
    if (minutes < 1 || minutes > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Menit harus antara 1-60'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final scheduledTime = DateTime.now().add(Duration(minutes: minutes));
      
      // Create a test prayer time with the scheduled time
      final testPrayerTime = PrayerTime(
        tanggal: DateFormat('yyyy-MM-dd').format(scheduledTime),
        imsak: DateFormat('HH:mm').format(scheduledTime.subtract(const Duration(minutes: 10))),
        subuh: DateFormat('HH:mm').format(scheduledTime),
        terbit: DateFormat('HH:mm').format(scheduledTime.add(const Duration(hours: 1))),
        dhuha: DateFormat('HH:mm').format(scheduledTime.add(const Duration(hours: 2))),
        dzuhur: '12:00',
        ashar: '15:00',
        maghrib: '18:00',
        isya: '19:30',
        date: DateFormat('yyyy-MM-dd').format(scheduledTime),
      );
      
      // Schedule the notification (will use subuh time)
      await _notificationService.scheduleDailyPrayerNotifications(testPrayerTime);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Notifikasi dijadwalkan untuk ${DateFormat('HH:mm:ss').format(scheduledTime)}\n'
              'Tunggu $minutes menit...',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testCustomTimeNotification() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _testTime,
      helpText: 'Pilih Waktu Test Notifikasi',
    );
    
    if (picked == null) return;
    
    setState(() => _isLoading = true);
    
    try {
      final now = DateTime.now();
      var scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      
      // If time has passed, schedule for tomorrow
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }
      
      // Create test prayer time
      final testPrayerTime = PrayerTime(
        tanggal: DateFormat('yyyy-MM-dd').format(scheduledTime),
        imsak: DateFormat('HH:mm').format(scheduledTime.subtract(const Duration(minutes: 10))),
        subuh: DateFormat('HH:mm').format(scheduledTime),
        terbit: DateFormat('HH:mm').format(scheduledTime.add(const Duration(hours: 1))),
        dhuha: DateFormat('HH:mm').format(scheduledTime.add(const Duration(hours: 2))),
        dzuhur: '12:00',
        ashar: '15:00',
        maghrib: '18:00',
        isya: '19:30',
        date: DateFormat('yyyy-MM-dd').format(scheduledTime),
      );
      
      await _notificationService.scheduleDailyPrayerNotifications(testPrayerTime);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Notifikasi dijadwalkan untuk:\n'
              '${DateFormat('dd MMM yyyy HH:mm', 'id_ID').format(scheduledTime)}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelAllNotifications() async {
    setState(() => _isLoading = true);
    
    try {
      await _notificationService.cancelAllNotifications();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Semua notifikasi dibatalkan'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧪 Test Notifikasi'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Warning banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Mode Testing - Untuk developer only',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Immediate test
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flash_on, color: Colors.amber.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Test Langsung',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Kirim notifikasi segera untuk test suara dan tampilan',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _testImmediateNotification,
                          icon: const Icon(Icons.notifications_active),
                          label: const Text('Kirim Sekarang'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Scheduled test with minutes
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.schedule, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Test dengan Delay',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jadwalkan notifikasi X menit ke depan',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _minutesController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Menit',
                                  border: OutlineInputBorder(),
                                  suffixText: 'menit',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _testScheduledNotification,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Jadwalkan'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Custom time test
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.purple.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Test Waktu Custom',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pilih waktu spesifik untuk test notifikasi',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _testCustomTimeNotification,
                          icon: const Icon(Icons.access_time),
                          label: const Text('Pilih Waktu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel all
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Batalkan Semua',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Hapus semua notifikasi yang terjadwal',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: _cancelAllNotifications,
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('Cancel All'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                            side: BorderSide(color: Colors.red.shade700),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Tips Testing',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTip('Test dengan 1-2 menit untuk cepat'),
                      _buildTip('Pastikan app di background saat test'),
                      _buildTip('Check Settings → Notifications → Allowed'),
                      _buildTip('Battery optimization: Don\'t optimize'),
                      _buildTip('File adzan harus ada di res/raw/adzan.mp3'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
