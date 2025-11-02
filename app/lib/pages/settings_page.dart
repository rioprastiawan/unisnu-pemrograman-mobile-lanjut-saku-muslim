import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import '../widgets/setting_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();

  Map<String, Map<String, dynamic>> _settings = {};
  bool _isLoading = true;
  bool _allEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    final settings = await _dbHelper.getAllNotificationSettings();
    final Map<String, Map<String, dynamic>> settingsMap = {};
    bool allEnabled = true;

    for (final setting in settings) {
      final prayerName = setting['prayer_name'] as String;
      settingsMap[prayerName] = setting;
      if (setting['is_enabled'] == 0) {
        allEnabled = false;
      }
    }

    setState(() {
      _settings = settingsMap;
      _allEnabled = allEnabled;
      _isLoading = false;
    });
  }

  Future<void> _toggleAllNotifications(bool enabled) async {
    await _dbHelper.toggleAllNotifications(enabled);
    
    if (!enabled) {
      // Cancel all notifications if disabling
      await _notificationService.cancelAllNotifications();
    }

    setState(() {
      _allEnabled = enabled;
      for (final key in _settings.keys) {
        _settings[key]!['is_enabled'] = enabled ? 1 : 0;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Semua notifikasi diaktifkan'
                : 'Semua notifikasi dinonaktifkan',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  Future<void> _togglePrayerNotification(String prayerName, bool enabled) async {
    // Update UI immediately for responsiveness
    setState(() {
      _settings[prayerName]!['is_enabled'] = enabled ? 1 : 0;
      // Update allEnabled status
      _allEnabled = _settings.values.every((s) => s['is_enabled'] == 1);
    });

    // Then update database
    await _dbHelper.updateNotificationSetting(
      prayerName: prayerName,
      isEnabled: enabled,
    );

    if (!enabled) {
      // Cancel this prayer's notification
      await _notificationService.cancelPrayerNotification(prayerName);
    }
  }

  Future<void> _toggleSound(String prayerName, bool enabled) async {
    // Update UI immediately
    setState(() {
      _settings[prayerName]!['sound_enabled'] = enabled ? 1 : 0;
    });

    // Then update database
    await _dbHelper.updateNotificationSetting(
      prayerName: prayerName,
      soundEnabled: enabled,
    );
  }

  Future<void> _toggleVibration(String prayerName, bool enabled) async {
    // Update UI immediately
    setState(() {
      _settings[prayerName]!['vibrate_enabled'] = enabled ? 1 : 0;
    });

    // Then update database
    await _dbHelper.updateNotificationSetting(
      prayerName: prayerName,
      vibrateEnabled: enabled,
    );
  }

  Future<void> _testNotification() async {
    await _notificationService.showImmediateNotification(
      title: 'Test Notifikasi',
      body: 'Ini adalah test notifikasi adzan',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notifikasi test dikirim'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName) {
      case 'subuh':
        return Icons.wb_twilight;
      case 'dzuhur':
        return Icons.wb_sunny;
      case 'ashar':
        return Icons.wb_sunny_outlined;
      case 'maghrib':
        return Icons.wb_twighlight;
      case 'isya':
        return Icons.nightlight;
      default:
        return Icons.access_time;
    }
  }

  String _getPrayerDisplayName(String prayerName) {
    switch (prayerName) {
      case 'subuh':
        return 'Subuh';
      case 'dzuhur':
        return 'Dzuhur';
      case 'ashar':
        return 'Ashar';
      case 'maghrib':
        return 'Maghrib';
      case 'isya':
        return 'Isya';
      default:
        return prayerName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Notifikasi'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 8),
                
                // Master toggle
                const SectionHeader(
                  title: 'Notifikasi Adzan',
                  icon: Icons.notifications_active,
                  subtitle: 'Pengaturan notifikasi waktu sholat',
                ),
                
                SettingToggleCard(
                  title: 'Aktifkan Semua Notifikasi',
                  subtitle: 'Nyalakan/matikan semua notifikasi adzan',
                  icon: Icons.notifications,
                  value: _allEnabled,
                  onChanged: _toggleAllNotifications,
                ),

                const SizedBox(height: 16),
                const SectionHeader(
                  title: 'Waktu Sholat',
                  icon: Icons.schedule,
                ),

                // Prayer notifications
                ..._settings.entries.map((entry) {
                  final prayerName = entry.key;
                  final setting = entry.value;
                  final isEnabled = setting['is_enabled'] == 1;
                  final soundEnabled = setting['sound_enabled'] == 1;
                  final vibrateEnabled = setting['vibrate_enabled'] == 1;

                  return Column(
                    children: [
                      SettingToggleCard(
                        title: 'Notifikasi ${_getPrayerDisplayName(prayerName)}',
                        subtitle: isEnabled
                            ? 'Notifikasi aktif'
                            : 'Notifikasi nonaktif',
                        icon: _getPrayerIcon(prayerName),
                        value: isEnabled,
                        onChanged: (value) =>
                            _togglePrayerNotification(prayerName, value),
                      ),
                      
                      // Sub-settings (only show if prayer notification is enabled)
                      if (isEnabled) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text(
                                    'Suara',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: soundEnabled,
                                  onChanged: (value) =>
                                      _toggleSound(prayerName, value ?? false),
                                  dense: true,
                                  activeColor: Colors.green.shade700,
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  title: const Text(
                                    'Getar',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: vibrateEnabled,
                                  onChanged: (value) =>
                                      _toggleVibration(prayerName, value ?? false),
                                  dense: true,
                                  activeColor: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                }),

                const SizedBox(height: 16),
                const SectionHeader(
                  title: 'Lainnya',
                  icon: Icons.settings,
                ),

                // Test notification button
                SettingItemCard(
                  title: 'Test Notifikasi',
                  subtitle: 'Kirim notifikasi test',
                  icon: Icons.notifications_active,
                  onTap: _testNotification,
                  trailing: Icon(
                    Icons.send,
                    color: Colors.green.shade700,
                  ),
                ),

                const SizedBox(height: 24),
                
                // Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Notifikasi akan dijadwalkan otomatis setiap hari berdasarkan lokasi Anda.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
