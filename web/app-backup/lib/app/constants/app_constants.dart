/// Application constants and configuration values
class AppConstants {
  AppConstants._(); // Private constructor

  // =====================================
  // APP INFORMATION
  // =====================================
  static const String appName = 'Saku Muslim';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Ibadah harianmu, di ujung jari. Simpel, ringan, dan fokus pada yang terpenting.';

  // =====================================
  // THEME CONSTANTS
  // =====================================
  static const String themeKey = 'app_theme_mode';
  static const String defaultTheme = 'system'; // system, light, dark

  // =====================================
  // ANIMATION DURATIONS
  // =====================================
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // =====================================
  // SPACING CONSTANTS
  // =====================================
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // =====================================
  // BORDER RADIUS
  // =====================================
  static const double borderRadiusS = 4.0;
  static const double borderRadiusM = 8.0;
  static const double borderRadiusL = 12.0;
  static const double borderRadiusXL = 16.0;
  static const double borderRadiusCircular = 50.0;

  // =====================================
  // CARD ELEVATIONS
  // =====================================
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;

  // =====================================
  // ICON SIZES
  // =====================================
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  static const double iconXXL = 64.0;

  // =====================================
  // FONT SIZES (complementing theme.dart)
  // =====================================
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeTitle = 32.0;

  // =====================================
  // PRAYER TIME CONSTANTS
  // =====================================
  static const List<String> prayerNames = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  static const List<String> prayerNamesIndonesian = [
    'Subuh',
    'Terbit',
    'Dzuhur',
    'Ashar',
    'Maghrib',
    'Isya',
  ];

  // =====================================
  // SHARED PREFERENCES KEYS
  // =====================================
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keySavedLatitude = 'saved_latitude';
  static const String keySavedLongitude = 'saved_longitude';
  static const String keySavedLocationName = 'saved_location_name';
  static const String keyLastPrayerTimesCache = 'last_prayer_times_cache';
  static const String keyLastHijriDateCache = 'last_hijri_date_cache';
  static const String keyCacheTimestamp = 'cache_timestamp';

  // =====================================
  // ASSET PATHS
  // =====================================
  static const String assetDataPath = 'assets/data/';
  static const String assetImagesPath = 'assets/images/';
  static const String assetIconsPath = 'assets/icons/';

  // Asset file names
  static const String asmaulHusnaFile = 'asmaul_husna.json';
  static const String doaHarianFile = 'doa_harian.json';

  // =====================================
  // NETWORK CONSTANTS
  // =====================================
  static const int networkTimeoutSeconds = 15;
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // =====================================
  // VALIDATION CONSTANTS
  // =====================================
  static const int minLocationAccuracy = 100; // meters
  static const int maxLocationAge = 300; // seconds (5 minutes)
  static const int cacheValidityHours = 12; // hours

  // =====================================
  // UI CONSTANTS
  // =====================================
  static const int bottomNavItems = 4;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double fabSize = 56.0;

  // Prayer card dimensions
  static const double prayerCardHeight = 80.0;
  static const double prayerCardMinWidth = 120.0;

  // Countdown timer
  static const int countdownUpdateInterval = 1; // seconds
}
