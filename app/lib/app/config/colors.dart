import 'package:flutter/material.dart';

/// Color palette for Saku Muslim app
/// Designed with Islamic aesthetic in mind using green and gold themes
/// Supports both light and dark mode with high contrast ratios
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // =====================================
  // LIGHT MODE COLORS
  // =====================================

  /// Primary Colors - Islamic Green Theme
  static const Color primaryGreen = Color(0xFF2E7D32); // Deep Green
  static const Color primaryGreenLight = Color(0xFF60AD5E); // Medium Green
  static const Color primaryGreenLighter = Color(
    0xFFE8F5E8,
  ); // Very Light Green (background cards)

  /// Accent Colors - Islamic Gold/Amber
  static const Color accentGold = Color(0xFFFFB300); // Islamic Gold
  static const Color accentGoldLight = Color(
    0xFFFFF8E1,
  ); // Light Gold background

  /// Background & Surface
  static const Color backgroundPrimary = Color(
    0xFFF5F7F5,
  ); // Soft green-tinted white
  static const Color backgroundSecondary = Color(
    0xFFFFFFFF,
  ); // Pure white for cards
  static const Color surfaceColor = Color(0xFFFFFFFF); // Card surface

  /// Text Colors
  static const Color textPrimary = Color(0xFF1B5E20); // Dark green for headers
  static const Color textSecondary = Color(
    0xFF4A4A4A,
  ); // Gray for secondary text
  static const Color textTertiary = Color(0xFF757575); // Light gray for hints
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary

  /// Prayer Time Status Colors
  static const Color prayerActive = Color(0xFF4CAF50); // Current/Active prayer
  static const Color prayerUpcoming = Color(
    0xFF81C784,
  ); // Next prayer highlight
  static const Color prayerPassed = Color(0xFFBDBDBD); // Passed prayers (muted)

  /// Semantic Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color errorColor = Color(0xFFF44336);
  static const Color infoColor = Color(0xFF2196F3);

  /// Border & Divider
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFF0F0F0);

  // =====================================
  // DARK MODE COLORS
  // =====================================

  /// Primary Colors - Darker Islamic Green
  static const Color primaryGreenDark = Color(0xFF1B5E20); // Deep forest green
  static const Color primaryGreenMediumDark = Color(0xFF2E7D32); // Medium green
  static const Color primaryGreenLightDark = Color(
    0xFF1A1A1A,
  ); // Dark background with green tint

  /// Accent Colors - Warmer Gold for dark mode
  static const Color accentGoldDark = Color(
    0xFFFFD54F,
  ); // Brighter gold for contrast
  static const Color accentGoldLightDark = Color(
    0xFF2A2A1A,
  ); // Dark gold background

  /// Background & Surface (Dark)
  static const Color backgroundPrimaryDark = Color(
    0xFF121212,
  ); // Material dark background
  static const Color backgroundSecondaryDark = Color(
    0xFF1E1E1E,
  ); // Card background
  static const Color surfaceColorDark = Color(0xFF262626); // Elevated surface

  /// Text Colors (Dark)
  static const Color textPrimaryDark = Color(
    0xFFE8F5E8,
  ); // Light green for headers
  static const Color textSecondaryDark = Color(0xFFB3B3B3); // Light gray
  static const Color textTertiaryDark = Color(0xFF8A8A8A); // Muted gray
  static const Color textOnPrimaryDark = Color(
    0xFF1B5E20,
  ); // Dark text on light primary

  /// Prayer Time Status Colors (Dark)
  static const Color prayerActiveDark = Color(0xFF66BB6A); // Brighter active
  static const Color prayerUpcomingDark = Color(0xFF81C784); // Next prayer
  static const Color prayerPassedDark = Color(0xFF616161); // Muted for passed

  /// Semantic Colors (Dark)
  static const Color successColorDark = Color(0xFF66BB6A);
  static const Color warningColorDark = Color(0xFFFFB74D);
  static const Color errorColorDark = Color(0xFFEF5350);
  static const Color infoColorDark = Color(0xFF42A5F5);

  /// Border & Divider (Dark)
  static const Color borderColorDark = Color(0xFF3A3A3A);
  static const Color dividerColorDark = Color(0xFF2A2A2A);

  // =====================================
  // HELPER METHODS
  // =====================================

  /// Get primary color based on current theme
  static Color getPrimaryColor(bool isDark) {
    return isDark ? primaryGreenDark : primaryGreen;
  }

  /// Get background color based on current theme
  static Color getBackgroundColor(bool isDark) {
    return isDark ? backgroundPrimaryDark : backgroundPrimary;
  }

  /// Get surface color based on current theme
  static Color getSurfaceColor(bool isDark) {
    return isDark ? surfaceColorDark : surfaceColor;
  }

  /// Get primary text color based on current theme
  static Color getTextPrimaryColor(bool isDark) {
    return isDark ? textPrimaryDark : textPrimary;
  }

  /// Get secondary text color based on current theme
  static Color getTextSecondaryColor(bool isDark) {
    return isDark ? textSecondaryDark : textSecondary;
  }

  /// Get accent gold color based on current theme
  static Color getAccentGoldColor(bool isDark) {
    return isDark ? accentGoldDark : accentGold;
  }

  /// Get prayer time status colors
  static Color getPrayerActiveColor(bool isDark) {
    return isDark ? prayerActiveDark : prayerActive;
  }

  static Color getPrayerUpcomingColor(bool isDark) {
    return isDark ? prayerUpcomingDark : prayerUpcoming;
  }

  static Color getPrayerPassedColor(bool isDark) {
    return isDark ? prayerPassedDark : prayerPassed;
  }

  // =====================================
  // COLOR SCHEMES FOR MATERIAL 3
  // =====================================

  /// Light theme color scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryGreen,
    onPrimary: textOnPrimary,
    secondary: primaryGreenLight,
    onSecondary: textOnPrimary,
    tertiary: accentGold,
    onTertiary: textPrimary,
    error: errorColor,
    onError: textOnPrimary,
    surface: surfaceColor,
    onSurface: textPrimary,
  );

  /// Dark theme color scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryGreenMediumDark,
    onPrimary: textOnPrimaryDark,
    secondary: primaryGreenLight,
    onSecondary: textOnPrimaryDark,
    tertiary: accentGoldDark,
    onTertiary: textPrimaryDark,
    error: errorColorDark,
    onError: textOnPrimaryDark,
    surface: surfaceColorDark,
    onSurface: textPrimaryDark,
  );

  // =====================================
  // GRADIENT DEFINITIONS
  // =====================================

  /// Primary gradient for headers and special elements
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gold gradient for accent elements
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGold, Color(0xFFFFC107)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Prayer time card gradient
  static const LinearGradient prayerCardGradient = LinearGradient(
    colors: [primaryGreenLighter, backgroundSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
