import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../services/location_service.dart';
import '../services/prayer_time_api_service.dart';
import '../models/prayer_schedule.dart';
import '../models/city.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  final PrayerTimeApiService _prayerApiService = PrayerTimeApiService();
  
  Timer? _clockTimer;
  bool _showColon = true;
  String _currentTime = '';
  String _currentDate = '';
  String _locationName = 'Memuat lokasi...';
  PrayerSchedule? _prayerSchedule;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePage();
    _startClock();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  // Initialize page - get location and prayer times
  Future<void> _initializePage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get location info
      final locationInfo = await _locationService.getLocationInfo();
      
      if (locationInfo == null) {
        setState(() {
          _errorMessage = 'Gagal mendapatkan lokasi. Pastikan GPS aktif dan izin lokasi diberikan.';
          _isLoading = false;
        });
        return;
      }

      final cityName = locationInfo['cityName'];
      
      if (cityName == null || cityName.isEmpty) {
        setState(() {
          _errorMessage = 'Gagal mendapatkan nama kota dari lokasi Anda.';
          _isLoading = false;
        });
        return;
      }

      // Search for city in API
      final cities = await _prayerApiService.searchCity(cityName);
      
      if (cities.isEmpty) {
        setState(() {
          _errorMessage = 'Kota "$cityName" tidak ditemukan dalam database.';
          _isLoading = false;
        });
        return;
      }

      // Use first matching city
      final City selectedCity = cities.first;
      
      // Get today's prayer schedule
      final schedule = await _prayerApiService.getTodayPrayerSchedule(selectedCity.id);
      
      if (schedule == null) {
        setState(() {
          _errorMessage = 'Gagal mendapatkan jadwal sholat.';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _locationName = selectedCity.lokasi;
        _prayerSchedule = schedule;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  // Start clock timer with blinking colon
  void _startClock() {
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
      setState(() {
        _showColon = !_showColon;
      });
    });
  }

  // Update current time and date
  void _updateTime() {
    final now = DateTime.now();
    
    // Format tanggal dalam bahasa Indonesia
    final List<String> days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final List<String> months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    
    setState(() {
      _currentTime = DateFormat('HH mm').format(now);
      _currentDate = '$dayName, ${now.day} $monthName ${now.year}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializePage,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializePage,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _initializePage,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTimeLocationCard(),
              const SizedBox(height: 20),
              _buildPrayerTimesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLocationCard() {
    final timeParts = _currentTime.split(' ');
    final hour = timeParts.isNotEmpty ? timeParts[0] : '00';
    final minute = timeParts.length > 1 ? timeParts[1] : '00';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade700,
              Colors.green.shade500,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Clock with blinking colon
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  hour,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 16,
                  child: Text(
                    _showColon ? ':' : ' ',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  minute,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Date
            Text(
              _currentDate,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Colors.white54, thickness: 1),
            const SizedBox(height: 8),
            // Location
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _locationName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    if (_prayerSchedule == null) {
      return const Center(child: Text('Tidak ada data jadwal sholat'));
    }

    final jadwal = _prayerSchedule!.jadwal;

    final List<Map<String, dynamic>> prayerTimes = [
      {'name': 'Imsak', 'time': jadwal.imsak, 'icon': Icons.nightlight_round},
      {'name': 'Subuh', 'time': jadwal.subuh, 'icon': Icons.wb_twilight},
      {'name': 'Terbit', 'time': jadwal.terbit, 'icon': Icons.wb_sunny},
      {'name': 'Dhuha', 'time': jadwal.dhuha, 'icon': Icons.wb_sunny_outlined},
      {'name': 'Dzuhur', 'time': jadwal.dzuhur, 'icon': Icons.light_mode},
      {'name': 'Ashar', 'time': jadwal.ashar, 'icon': Icons.wb_cloudy},
      {'name': 'Maghrib', 'time': jadwal.maghrib, 'icon': Icons.wb_twilight},
      {'name': 'Isya', 'time': jadwal.isya, 'icon': Icons.nights_stay},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jadwal Sholat Hari Ini',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prayerTimes.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final prayer = prayerTimes[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(
                    prayer['icon'] as IconData,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                ),
                title: Text(
                  prayer['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                trailing: Text(
                  prayer['time'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
