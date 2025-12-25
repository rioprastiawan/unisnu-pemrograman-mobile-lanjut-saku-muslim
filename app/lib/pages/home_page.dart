import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../services/location_service.dart';
import '../services/prayer_time_api_service.dart';
import '../services/database_helper.dart';
import '../services/notification_service.dart';
import '../models/prayer_schedule.dart';
import '../models/city.dart';
import '../widgets/qibla_compass.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocationService _locationService = LocationService();
  final PrayerTimeApiService _prayerApiService = PrayerTimeApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  
  Timer? _clockTimer;
  bool _showColon = true;
  String _currentTime = '';
  String _currentDate = '';
  String _locationName = 'Memuat lokasi...';
  PrayerSchedule? _prayerSchedule;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  
  String? _cachedCityId;
  double? _cachedLatitude;
  double? _cachedLongitude;

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

  // Initialize page - load from cache first, then refresh if needed
  Future<void> _initializePage({bool forceRefresh = false}) async {
    // Try to load from cache first
    final hasCache = await _loadFromCache();
    
    if (hasCache && !forceRefresh) {
      // Cache loaded successfully, show it immediately
      setState(() {
        _isLoading = false;
      });
      
      // Check if we need to refresh in background
      await _refreshIfNeeded();
    } else {
      // No cache or force refresh, show loading and fetch fresh data
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      await _fetchFreshData();
    }
  }

  // Load data from cache
  Future<bool> _loadFromCache() async {
    try {
      // Get location cache
      final locationCache = await _dbHelper.getLocationCache();
      if (locationCache == null) return false;
      
      // Get today's date
      final today = _getTodayDateString();
      
      // Get prayer schedule cache
      final scheduleCache = await _dbHelper.getPrayerScheduleCache(
        locationCache['city_id'],
        today,
      );
      
      if (scheduleCache == null) return false;
      
      // Load cached data into state
      setState(() {
        _locationName = locationCache['city_name'];
        _cachedCityId = locationCache['city_id'];
        _cachedLatitude = locationCache['latitude'];
        _cachedLongitude = locationCache['longitude'];
        
        // Reconstruct PrayerSchedule from cached data
        _prayerSchedule = PrayerSchedule.fromJson(scheduleCache['prayer_data']);
      });
      
      return true;
    } catch (e) {

      return false;
    }
  }

  // Check if refresh is needed and do it in background
  Future<void> _refreshIfNeeded() async {
    try {
      final today = _getTodayDateString();
      
      // Check if location is stale (> 10 minutes)
      final isLocationStale = await _dbHelper.isLocationStale(maxAgeMinutes: 10);
      
      // Check if prayer schedule is stale (> 10 minutes)
      final isScheduleStale = _cachedCityId != null 
          ? await _dbHelper.isPrayerScheduleStale(_cachedCityId!, today, maxAgeMinutes: 10)
          : true;
      
      // Check if location has changed
      bool locationChanged = false;
      if (_cachedLatitude != null && _cachedLongitude != null) {
        locationChanged = await _hasLocationChanged(_cachedLatitude!, _cachedLongitude!);
      }
      
      // Refresh if any condition is met
      if (isLocationStale || isScheduleStale || locationChanged) {
        await _fetchFreshData(isBackground: true);
      }
    } catch (e) {
      // Silently handle refresh check errors
    }
  }

  // Fetch fresh data from API
  Future<void> _fetchFreshData({bool isBackground = false}) async {
    if (!isBackground) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isRefreshing = true;
      });
    }

    try {
      // Get location info
      final locationInfo = await _locationService.getLocationInfo();
      
      if (locationInfo == null) {
        if (!isBackground) {
          setState(() {
            _errorMessage = 'Gagal mendapatkan lokasi. Pastikan GPS aktif dan izin lokasi diberikan.';
            _isLoading = false;
          });
        }
        return;
      }

      final cityName = locationInfo['cityName'];
      final latitude = locationInfo['latitude'];
      final longitude = locationInfo['longitude'];
      
      if (cityName == null || cityName.isEmpty) {
        if (!isBackground) {
          setState(() {
            _errorMessage = 'Gagal mendapatkan nama kota dari lokasi Anda.';
            _isLoading = false;
          });
        }
        return;
      }

      // Normalize city name to match API format
      // "Kabupaten Kudus" -> "KAB. KUDUS"
      // "Kota Semarang" -> "KOTA SEMARANG"
      final normalizedCityName = _locationService.normalizeForApiSearch(cityName);

      // Search for city in API using normalized name
      final cities = await _prayerApiService.searchCity(normalizedCityName);
      
      if (cities.isEmpty) {
        if (!isBackground) {
          setState(() {
            _errorMessage = 'Kota "$cityName" tidak ditemukan dalam database.';
            _isLoading = false;
          });
        }
        return;
      }

      // Use first matching city
      final City selectedCity = cities.first;
      
      // Get today's prayer schedule
      final schedule = await _prayerApiService.getTodayPrayerSchedule(selectedCity.id);
      
      if (schedule == null) {
        if (!isBackground) {
          setState(() {
            _errorMessage = 'Gagal mendapatkan jadwal sholat.';
            _isLoading = false;
          });
        }
        return;
      }

      // Save to cache
      await _dbHelper.saveLocationCache(
        cityId: selectedCity.id,
        cityName: selectedCity.lokasi,
        latitude: latitude,
        longitude: longitude,
      );
      
      final today = _getTodayDateString();
      await _dbHelper.savePrayerScheduleCache(
        cityId: selectedCity.id,
        date: today,
        prayerData: {
          'id': schedule.id,
          'lokasi': schedule.lokasi,
          'daerah': schedule.daerah,
          'jadwal': schedule.jadwal.toJson(),
        },
      );
      
      // Clean old schedules
      await _dbHelper.clearOldPrayerSchedules();

      setState(() {
        _locationName = selectedCity.lokasi;
        _prayerSchedule = schedule;
        _cachedCityId = selectedCity.id;
        _cachedLatitude = latitude;
        _cachedLongitude = longitude;
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });

      // Schedule notifications for today's prayer times
      try {
        await _notificationService.scheduleDailyPrayerNotifications(schedule.jadwal);
      } catch (e) {
        // Silently handle notification scheduling errors
      }
    } catch (e) {
      if (!isBackground) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
          _isLoading = false;
        });
      } else {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  // Check if location has significantly changed (> 5km)
  Future<bool> _hasLocationChanged(double cachedLat, double cachedLon) async {
    try {
      final currentLocation = await _locationService.getCurrentLocation();
      if (currentLocation == null) return false;
      
      // Calculate distance in meters using Geolocator
      final distance = await _locationService.getDistanceBetween(
        cachedLat,
        cachedLon,
        currentLocation.latitude,
        currentLocation.longitude,
      );
      
      // If moved more than 5km, consider location changed
      return distance > 5000;
    } catch (e) {
      return false;
    }
  }

  // Get today's date as string (yyyy-MM-dd)
  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // Manual refresh (pull to refresh)
  Future<void> _manualRefresh() async {
    await _initializePage(forceRefresh: true);
  }

  // Get next prayer time
  Map<String, String>? _getNextPrayerTime() {
    if (_prayerSchedule == null) return null;

    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final jadwal = _prayerSchedule!.jadwal;

    final prayerTimes = [
      {'name': 'Subuh', 'time': jadwal.subuh},
      {'name': 'Dhuha', 'time': jadwal.dhuha},
      {'name': 'Dzuhur', 'time': jadwal.dzuhur},
      {'name': 'Ashar', 'time': jadwal.ashar},
      {'name': 'Maghrib', 'time': jadwal.maghrib},
      {'name': 'Isya', 'time': jadwal.isya},
    ];

    for (var prayer in prayerTimes) {
      final prayerTime = _parseTime(prayer['time']!);
      if (prayerTime != null && _isTimeBefore(currentTime, prayerTime)) {
        return {
          'name': prayer['name']!,
          'time': prayer['time']!,
        };
      }
    }

    // If all prayers have passed (after Isya), return null
    return null;
  }

  // Parse time string (HH:mm) to TimeOfDay
  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  // Check if time1 is before time2
  bool _isTimeBefore(TimeOfDay time1, TimeOfDay time2) {
    if (time1.hour < time2.hour) return true;
    if (time1.hour > time2.hour) return false;
    return time1.minute < time2.minute;
  }

  // Calculate time difference in minutes
  int _getMinutesDifference(TimeOfDay time1, TimeOfDay time2) {
    final minutes1 = time1.hour * 60 + time1.minute;
    final minutes2 = time2.hour * 60 + time2.minute;
    return minutes2 - minutes1;
  }

  // Format time remaining (e.g., "2 jam 30 menit")
  String _formatTimeRemaining(int minutes) {
    if (minutes < 0) return '';
    
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    
    if (hours > 0 && mins > 0) {
      return '$hours jam $mins menit';
    } else if (hours > 0) {
      return '$hours jam';
    } else {
      return '$mins menit';
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

  // Show Qibla Compass BottomSheet
  void _showQiblaCompass() {
    if (_cachedLatitude == null || _cachedLongitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi belum tersedia. Silakan tunggu sebentar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Kompas content
            Expanded(
              child: QiblaCompass(
                userLatitude: _cachedLatitude!,
                userLongitude: _cachedLongitude!,
                cityName: _locationName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (_isRefreshing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _manualRefresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : _buildContent(),
      floatingActionButton: !_isLoading && _errorMessage == null
          ? FloatingActionButton.extended(
              onPressed: _showQiblaCompass,
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.explore),
              label: const Text('Arah Kiblat'),
            )
          : null,
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
              onPressed: _manualRefresh,
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
      onRefresh: _manualRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTimeLocationCard(),
              const SizedBox(height: 20),
              // Next Prayer Time Card
              _buildNextPrayerCard(),
              const SizedBox(height: 20),
              _buildPrayerTimesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextPrayerCard() {
    final nextPrayer = _getNextPrayerTime();
    
    // If no next prayer (after Isya), don't show the card
    if (nextPrayer == null) {
      return const SizedBox.shrink();
    }

    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final prayerTime = _parseTime(nextPrayer['time']!);
    
    String timeRemaining = '';
    if (prayerTime != null) {
      final minutesDiff = _getMinutesDifference(currentTime, prayerTime);
      timeRemaining = _formatTimeRemaining(minutesDiff);
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.access_time,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sholat Selanjutnya',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextPrayer['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (timeRemaining.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$timeRemaining lagi',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  nextPrayer['time']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
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
    final now = DateTime.now();
    final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
    final nextPrayer = _getNextPrayerTime();

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
              final prayerTime = _parseTime(prayer['time'] as String);
              
              // Check if this is the next prayer
              final isNextPrayer = nextPrayer != null && 
                                   prayer['name'] == nextPrayer['name'];
              
              // Check if prayer time has passed
              bool hasPassed = false;
              if (prayerTime != null) {
                hasPassed = !_isTimeBefore(currentTime, prayerTime);
              }
              
              return Container(
                decoration: BoxDecoration(
                  color: isNextPrayer 
                      ? Colors.teal.shade50 
                      : hasPassed 
                          ? Colors.grey.shade50 
                          : null,
                  borderRadius: index == 0
                      ? const BorderRadius.vertical(top: Radius.circular(12))
                      : index == prayerTimes.length - 1
                          ? const BorderRadius.vertical(bottom: Radius.circular(12))
                          : null,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isNextPrayer 
                        ? Colors.teal.shade100 
                        : hasPassed 
                            ? Colors.grey.shade200 
                            : Colors.green.shade100,
                    child: Icon(
                      prayer['icon'] as IconData,
                      color: isNextPrayer 
                          ? Colors.teal.shade700 
                          : hasPassed 
                              ? Colors.grey.shade600 
                              : Colors.green.shade700,
                      size: 24,
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(
                        prayer['name'] as String,
                        style: TextStyle(
                          fontWeight: isNextPrayer ? FontWeight.bold : FontWeight.w600,
                          fontSize: 16,
                          color: hasPassed ? Colors.grey.shade600 : null,
                        ),
                      ),
                      if (isNextPrayer) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade600,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Selanjutnya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: Text(
                    prayer['time'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: isNextPrayer ? FontWeight.bold : FontWeight.bold,
                      color: isNextPrayer 
                          ? Colors.teal.shade700 
                          : hasPassed 
                              ? Colors.grey.shade600 
                              : Colors.green.shade700,
                    ),
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
