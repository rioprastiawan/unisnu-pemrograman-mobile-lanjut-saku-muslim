import 'package:flutter/foundation.dart';
import 'dart:async';

import '../../core/models/prayer_time_model.dart';
import '../../core/services/prayer_time_service.dart';
import '../../core/services/location_service.dart';

/// Provider for managing prayer times state
class PrayerTimeProvider extends ChangeNotifier {
  final PrayerTimeService _prayerTimeService;
  final LocationService _locationService;

  // State
  DailyPrayerTimes? _dailyPrayerTimes;
  LocationData? _currentLocation;
  bool _isLoading = false;
  String? _error;
  Timer? _timer;

  // Constructor
  PrayerTimeProvider({
    PrayerTimeService? prayerTimeService,
    LocationService? locationService,
  }) : _prayerTimeService = prayerTimeService ?? PrayerTimeService(),
       _locationService = locationService ?? LocationService() {
    _initializeProvider();
  }

  // Getters
  DailyPrayerTimes? get dailyPrayerTimes => _dailyPrayerTimes;
  LocationData? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PrayerTime? get nextPrayer => _dailyPrayerTimes?.nextPrayer;
  PrayerTime? get currentPrayer => _dailyPrayerTimes?.currentPrayer;
  String get timeUntilNextPrayer =>
      _dailyPrayerTimes?.timeUntilNextPrayer ?? '';

  /// Initialize provider
  void _initializeProvider() {
    _loadPrayerTimes();
    _startTimer();
  }

  /// Load prayer times
  Future<void> _loadPrayerTimes() async {
    _setLoading(true);
    _clearError();

    try {
      // Get location first
      await _getCurrentLocation();

      if (_currentLocation != null) {
        // Get prayer times using coordinates
        final response = await _prayerTimeService.getPrayerTimesByCoordinates(
          latitude: _currentLocation!.latitude,
          longitude: _currentLocation!.longitude,
        );

        if (response.success && response.data != null) {
          _dailyPrayerTimes = response.data;
        } else {
          _setError(response.message ?? 'Gagal mendapatkan waktu sholat');
        }
      } else {
        // Use default location if can't get current location
        final defaultLocation = _locationService.getDefaultLocation();
        _currentLocation = defaultLocation;

        final response = await _prayerTimeService.getPrayerTimesByCoordinates(
          latitude: defaultLocation.latitude,
          longitude: defaultLocation.longitude,
        );

        if (response.success && response.data != null) {
          _dailyPrayerTimes = response.data;
        } else {
          _setError(response.message ?? 'Gagal mendapatkan waktu sholat');
        }
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
    }

    _setLoading(false);
  }

  /// Get current location
  Future<void> _getCurrentLocation() async {
    try {
      final location = await _locationService.getCurrentLocation();
      if (location != null) {
        _currentLocation = location;
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  /// Refresh prayer times
  Future<void> refreshPrayerTimes() async {
    await _loadPrayerTimes();
  }

  /// Update location and refresh prayer times
  Future<void> updateLocation(LocationData location) async {
    _currentLocation = location;
    _setLoading(true);
    _clearError();

    try {
      final response = await _prayerTimeService.getPrayerTimesByCoordinates(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      if (response.success && response.data != null) {
        _dailyPrayerTimes = response.data;
      } else {
        _setError(response.message ?? 'Gagal mendapatkan waktu sholat');
      }
    } catch (e) {
      _setError('Terjadi kesalahan: ${e.toString()}');
    }

    _setLoading(false);
  }

  /// Search location and update
  Future<void> searchAndUpdateLocation(String cityName) async {
    _setLoading(true);
    _clearError();

    try {
      final location = await _locationService.getLocationFromCity(cityName);
      if (location != null) {
        await updateLocation(location);
      } else {
        _setError('Lokasi tidak ditemukan');
        _setLoading(false);
      }
    } catch (e) {
      _setError('Gagal mencari lokasi: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Get qibla direction
  double getQiblaDirection() {
    if (_currentLocation != null) {
      return _locationService.calculateQiblaDirection(
        _currentLocation!.latitude,
        _currentLocation!.longitude,
      );
    }
    return 0.0;
  }

  /// Start timer for real-time updates
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Update prayer status if needed
      if (_dailyPrayerTimes != null) {
        final updatedTimes = _dailyPrayerTimes!.updatePrayerStatuses();
        if (updatedTimes != _dailyPrayerTimes) {
          _dailyPrayerTimes = updatedTimes;
          notifyListeners();
        }
      }
    });
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _prayerTimeService.dispose();
    super.dispose();
  }
}
