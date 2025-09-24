/// API endpoints and configuration for Al-Adhan API
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor

  // Base URL
  static const String baseUrl = 'https://api.aladhan.com/v1';

  // Prayer times endpoints
  static const String timings = '/timings';
  static const String timingsByCity = '/timingsByCity';
  static const String timingsByAddress = '/timingsByAddress';

  // Calendar endpoints
  static const String calendar = '/calendar';
  static const String hijriCalendar = '/hijriCalendar';

  // Methods and parameters
  static const int methodKemenagRI = 11; // Kemenag RI calculation method
  static const int defaultMethod = methodKemenagRI;

  // Build prayer times URL
  static String buildTimingsUrl({
    required double latitude,
    required longitude,
    DateTime? date,
    int method = defaultMethod,
  }) {
    final dateStr =
        date != null
            ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
            : _getCurrentDateString();

    return '$baseUrl$timings/$dateStr'
        '?latitude=$latitude'
        '&longitude=$longitude'
        '&method=$method';
  }

  // Build timings by city URL
  static String buildTimingsByCityUrl({
    required String city,
    required String country,
    DateTime? date,
    int method = defaultMethod,
  }) {
    final dateStr =
        date != null
            ? '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}'
            : _getCurrentDateString();

    return '$baseUrl$timingsByCity/$dateStr'
        '?city=$city'
        '&country=$country'
        '&method=$method';
  }

  static String _getCurrentDateString() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
  }
}

/// HTTP request headers
class ApiHeaders {
  ApiHeaders._();

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

/// API response status codes
class ApiStatus {
  ApiStatus._();

  static const int success = 200;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int internalServerError = 500;
  static const int serviceUnavailable = 503;
}
