import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola tema aplikasi
class ThemeService extends ChangeNotifier {
  // Singleton pattern
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  static const String _themeKey = 'theme_mode';
  static const String _accentColorKey = 'accent_color';
  
  SharedPreferences? _prefs;
  ThemeMode _themeMode = ThemeMode.system;
  Color _accentColor = Colors.teal;

  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;

  /// Initialize theme service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadTheme();
  }

  /// Load saved theme from preferences
  Future<void> _loadTheme() async {
    final themeModeString = _prefs?.getString(_themeKey);
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeModeString,
        orElse: () => ThemeMode.system,
      );
    }

    final accentColorValue = _prefs?.getInt(_accentColorKey);
    if (accentColorValue != null) {
      _accentColor = Color(accentColorValue);
    }

    notifyListeners();
  }

  /// Set theme mode (light, dark, system)
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs?.setString(_themeKey, mode.toString());
    notifyListeners();
  }

  /// Set accent color
  Future<void> setAccentColor(Color color) async {
    _accentColor = color;
    await _prefs?.setInt(_accentColorKey, color.value);
    notifyListeners();
  }

  /// Get light theme
  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  /// Get dark theme
  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _accentColor,
        brightness: Brightness.dark,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[900],
    );
  }

  /// Predefined accent colors
  static List<Color> get availableAccentColors => [
        Colors.teal,
        Colors.blue,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.pink,
        Colors.indigo,
        Colors.deepOrange,
      ];

  /// Get accent color name
  static String getColorName(Color color) {
    if (color == Colors.teal) return 'Teal';
    if (color == Colors.blue) return 'Biru';
    if (color == Colors.green) return 'Hijau';
    if (color == Colors.purple) return 'Ungu';
    if (color == Colors.orange) return 'Oranye';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.indigo) return 'Indigo';
    if (color == Colors.deepOrange) return 'Oranye Tua';
    return 'Custom';
  }
}
