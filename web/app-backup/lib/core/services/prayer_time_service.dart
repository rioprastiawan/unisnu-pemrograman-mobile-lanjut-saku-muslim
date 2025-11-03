import '../../../app/constants/api_endpoints.dart';
import '../../../core/models/prayer_time_model.dart';
import 'api_service.dart';

/// Service for Al-Adhan API operations
class PrayerTimeService {
  final ApiService _apiService;

  PrayerTimeService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Get prayer times by coordinates
  Future<ApiResponse<DailyPrayerTimes>> getPrayerTimesByCoordinates({
    required double latitude,
    required double longitude,
    DateTime? date,
    int method = ApiEndpoints.defaultMethod,
  }) async {
    try {
      final url = ApiEndpoints.buildTimingsUrl(
        latitude: latitude,
        longitude: longitude,
        date: date,
        method: method,
      );

      final response = await _apiService.get(
        url,
        headers: ApiHeaders.defaultHeaders,
      );

      if (response.success && response.data != null) {
        final prayerTimes = _parsePrayerTimesResponse(
          response.data!,
          locationName: 'Koordinat ($latitude, $longitude)',
          latitude: latitude,
          longitude: longitude,
        );
        return ApiResponse.success(prayerTimes);
      } else {
        return ApiResponse.error(
          response.message ?? 'Gagal mendapatkan waktu sholat',
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}', 500);
    }
  }

  /// Get prayer times by city
  Future<ApiResponse<DailyPrayerTimes>> getPrayerTimesByCity({
    required String city,
    required String country,
    DateTime? date,
    int method = ApiEndpoints.defaultMethod,
  }) async {
    try {
      final url = ApiEndpoints.buildTimingsByCityUrl(
        city: city,
        country: country,
        date: date,
        method: method,
      );

      final response = await _apiService.get(
        url,
        headers: ApiHeaders.defaultHeaders,
      );

      if (response.success && response.data != null) {
        final prayerTimes = _parsePrayerTimesResponse(
          response.data!,
          locationName: '$city, $country',
        );
        return ApiResponse.success(prayerTimes);
      } else {
        return ApiResponse.error(
          response.message ?? 'Gagal mendapatkan waktu sholat',
          response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Terjadi kesalahan: ${e.toString()}', 500);
    }
  }

  /// Parse Al-Adhan API response to DailyPrayerTimes
  DailyPrayerTimes _parsePrayerTimesResponse(
    Map<String, dynamic> response, {
    String locationName = 'Unknown',
    double latitude = 0.0,
    double longitude = 0.0,
  }) {
    final data = response['data'] as Map<String, dynamic>;
    final timings = data['timings'] as Map<String, dynamic>;
    final date = data['date'] as Map<String, dynamic>;
    final hijri = date['hijri'] as Map<String, dynamic>;

    // Parse prayer times
    final prayerTimes = [
      PrayerTime(
        name: 'Fajr',
        nameIndonesian: 'Subuh',
        time: _parseTimeString(timings['Fajr'] as String),
        status: PrayerStatus.upcoming,
      ),
      PrayerTime(
        name: 'Dhuhr',
        nameIndonesian: 'Dzuhur',
        time: _parseTimeString(timings['Dhuhr'] as String),
        status: PrayerStatus.upcoming,
      ),
      PrayerTime(
        name: 'Asr',
        nameIndonesian: 'Ashar',
        time: _parseTimeString(timings['Asr'] as String),
        status: PrayerStatus.upcoming,
      ),
      PrayerTime(
        name: 'Maghrib',
        nameIndonesian: 'Maghrib',
        time: _parseTimeString(timings['Maghrib'] as String),
        status: PrayerStatus.upcoming,
      ),
      PrayerTime(
        name: 'Isha',
        nameIndonesian: 'Isya',
        time: _parseTimeString(timings['Isha'] as String),
        status: PrayerStatus.upcoming,
      ),
    ];

    // Parse Hijri date
    final hijriDate = HijriDate(
      date: hijri['date'] as String? ?? '',
      day: hijri['day'] as String? ?? '',
      month: (hijri['month'] as Map<String, dynamic>?)?['ar'] as String? ?? '',
      year: hijri['year'] as String? ?? '',
      weekday:
          (hijri['weekday'] as Map<String, dynamic>?)?['ar'] as String? ?? '',
    );

    return DailyPrayerTimes(
      prayers: prayerTimes,
      date: DateTime.parse(date['gregorian']['date'] as String),
      hijriDate: hijriDate,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Parse time string from API (format: "HH:mm (timezone)") to time string
  String _parseTimeString(String timeString) {
    // Remove timezone info if present
    final cleanTime = timeString.split(' ')[0];
    return cleanTime;
  }

  /// Dispose resources
  void dispose() {
    _apiService.dispose();
  }
}
