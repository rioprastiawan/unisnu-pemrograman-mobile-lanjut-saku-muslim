import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola status premium user
class PremiumService {
  static const String _premiumKey = 'is_premium';
  static const String _premiumTypeKey = 'premium_type';
  static const String _premiumExpiryKey = 'premium_expiry';
  static const String _purchaseTokenKey = 'purchase_token';
  static const String _autoRenewingKey = 'auto_renewing';

  /// 🧪 DEBUG MODE: Set true untuk testing premium features tanpa IAP
  /// Set false untuk production!
  static const bool debugPremiumMode = false;

  // Singleton pattern
  static final PremiumService _instance = PremiumService._internal();
  factory PremiumService() => _instance;
  PremiumService._internal();

  SharedPreferences? _prefs;

  /// Initialize premium service
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Check if user is premium
  Future<bool> isPremium() async {
    // 🧪 DEBUG: Auto-grant premium untuk testing
    if (debugPremiumMode) return true;

    await initialize();

    // Check if premium
    final isPremium = _prefs?.getBool(_premiumKey) ?? false;
    if (!isPremium) return false;

    // Check if subscription expired
    final premiumType = _prefs?.getString(_premiumTypeKey);
    if (premiumType == 'subscription') {
      final expiryString = _prefs?.getString(_premiumExpiryKey);
      if (expiryString != null) {
        final expiry = DateTime.parse(expiryString);
        if (DateTime.now().isAfter(expiry)) {
          // Subscription expired
          await _clearPremiumStatus();
          return false;
        }
      }
    }

    return true;
  }

  /// Get premium type (lifetime, subscription)
  Future<String?> getPremiumType() async {
    await initialize();
    return _prefs?.getString(_premiumTypeKey);
  }

  /// Get subscription expiry date
  Future<DateTime?> getExpiryDate() async {
    await initialize();
    final expiryString = _prefs?.getString(_premiumExpiryKey);
    if (expiryString != null) {
      return DateTime.parse(expiryString);
    }
    return null;
  }

  /// Set premium status (called after successful purchase)
  Future<void> setPremium({
    required String premiumType,
    DateTime? expiryDate,
    String? purchaseToken,
    bool autoRenewing = true,
  }) async {
    await initialize();
    await _prefs?.setBool(_premiumKey, true);
    await _prefs?.setString(_premiumTypeKey, premiumType);
    await _prefs?.setBool(_autoRenewingKey, autoRenewing);

    if (expiryDate != null) {
      await _prefs?.setString(_premiumExpiryKey, expiryDate.toIso8601String());
    }

    if (purchaseToken != null) {
      await _prefs?.setString(_purchaseTokenKey, purchaseToken);
    }
  }

  /// Clear premium status
  Future<void> _clearPremiumStatus() async {
    await initialize();
    await _prefs?.setBool(_premiumKey, false);
    await _prefs?.remove(_premiumTypeKey);
    await _prefs?.remove(_premiumExpiryKey);
  }

  /// Remove all premium data (for testing or logout)
  Future<void> clearAllPremiumData() async {
    await initialize();
    await _prefs?.remove(_premiumKey);
    await _prefs?.remove(_premiumTypeKey);
    await _prefs?.remove(_premiumExpiryKey);
    await _prefs?.remove(_purchaseTokenKey);
  }

  /// Get purchase token
  Future<String?> getPurchaseToken() async {
    await initialize();
    return _prefs?.getString(_purchaseTokenKey);
  }

  /// Get auto-renewing status
  Future<bool> isAutoRenewing() async {
    await initialize();
    // Default true jika belum pernah diset (backward compatibility)
    return _prefs?.getBool(_autoRenewingKey) ?? true;
  }

  /// Check specific premium features
  Future<bool> hasFeature(PremiumFeature feature) async {
    // 🧪 DEBUG: Auto-grant all features untuk testing
    if (debugPremiumMode) return true;

    final isPremium = await this.isPremium();
    if (!isPremium) return false;

    // All premium users have access to all features
    return true;
  }

  /// Get days remaining for subscription
  Future<int?> getDaysRemaining() async {
    final premiumType = await getPremiumType();
    if (premiumType != 'subscription') return null;

    final expiry = await getExpiryDate();
    if (expiry == null) return null;

    final now = DateTime.now();
    if (now.isAfter(expiry)) return 0;

    return expiry.difference(now).inDays;
  }

  /// Check if trial is available (can be used for future trial feature)
  Future<bool> isTrialAvailable() async {
    await initialize();
    final hasUsedTrial = _prefs?.getBool('has_used_trial') ?? false;
    return !hasUsedTrial;
  }

  /// Activate trial
  Future<void> activateTrial({required int days}) async {
    await initialize();
    final expiryDate = DateTime.now().add(Duration(days: days));
    await setPremium(premiumType: 'trial', expiryDate: expiryDate);
    await _prefs?.setBool('has_used_trial', true);
  }
}

/// Enum untuk premium features
enum PremiumFeature {
  offlineAudio,
  unlimitedBookmarks,
  darkMode,
  customThemes,
  masjidTerdekat,
  kalkulatorZakat,
  exportData,
  widgets,
}
