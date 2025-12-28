import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'premium_service.dart';

/// Service untuk mengelola In-App Purchase menggunakan Google Play Billing
class IAPService {
  static const String premiumLifetimeId = 'premium_lifetime';
  static const String premiumMonthlyId = 'premium_monthly';
  static const String premiumYearlyId = 'premium_yearly';

  // Singleton pattern
  static final IAPService _instance = IAPService._internal();
  factory IAPService() => _instance;
  IAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  final PremiumService _premiumService = PremiumService();

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _loading = true;

  // Completer untuk menunggu hasil purchase
  Completer<bool>? _purchaseCompleter;

  // Getters
  bool get isAvailable => _isAvailable;
  bool get loading => _loading;
  List<ProductDetails> get products => _products;

  /// Initialize IAP service
  Future<void> initialize() async {
    // Check if IAP is available
    _isAvailable = await _iap.isAvailable();

    if (!_isAvailable) {
      _loading = false;
      debugPrint('IAP not available');
      return;
    }

    // Load products
    await _loadProducts();

    // Listen to purchase updates
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) => debugPrint('Purchase stream error: $error'),
    );

    _loading = false;
  }

  /// Load available products from Play Store
  Future<void> _loadProducts() async {
    try {
      final Set<String> ids = {
        premiumLifetimeId,
        premiumMonthlyId,
        premiumYearlyId,
      };

      final ProductDetailsResponse response = await _iap.queryProductDetails(
        ids,
      );

      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Product IDs not found: ${response.notFoundIDs}');
      }

      if (response.error != null) {
        debugPrint('Error loading products: ${response.error}');
        return;
      }

      _products = response.productDetails;
      debugPrint('Loaded ${_products.length} products');
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  /// Get product by ID
  ProductDetails? getProduct(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Purchase a product
  Future<bool> purchaseProduct(ProductDetails product) async {
    if (!_isAvailable) {
      debugPrint('IAP not available');
      return false;
    }

    try {
      // Create new completer untuk purchase ini
      _purchaseCompleter = Completer<bool>();

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Determine if it's a subscription or one-time purchase
      bool requestStarted;
      if (product.id == premiumLifetimeId) {
        // One-time purchase
        requestStarted = await _iap.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
      } else {
        // Subscription
        requestStarted = await _iap.buyNonConsumable(
          purchaseParam: purchaseParam,
        );
        // Note: For subscriptions, use the same buyNonConsumable in IAP v3
        // The difference is in the product type configured in Play Console
      }

      if (!requestStarted) {
        debugPrint('Failed to start purchase request');
        _purchaseCompleter?.complete(false);
        return false;
      }

      // Tunggu hasil purchase dari _onPurchaseUpdate (max 60 detik)
      return await _purchaseCompleter!.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          debugPrint('Purchase timeout');
          return false;
        },
      );
    } catch (e) {
      debugPrint('Error purchasing product: $e');
      _purchaseCompleter?.complete(false);
      return false;
    }
  }

  /// Handle purchase updates
  Future<void> _onPurchaseUpdate(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      debugPrint('Purchase status: ${purchaseDetails.status}');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show pending UI
        debugPrint('Purchase pending...');
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Show error
        debugPrint('Purchase error: ${purchaseDetails.error}');
        // Complete dengan false jika ada error
        if (_purchaseCompleter != null && !_purchaseCompleter!.isCompleted) {
          _purchaseCompleter!.complete(false);
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // User canceled
        debugPrint('Purchase canceled by user');
        if (_purchaseCompleter != null && !_purchaseCompleter!.isCompleted) {
          _purchaseCompleter!.complete(false);
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Verify and deliver product
        await _verifyAndDeliverProduct(purchaseDetails);
        // Complete dengan true jika sukses
        if (_purchaseCompleter != null && !_purchaseCompleter!.isCompleted) {
          _purchaseCompleter!.complete(true);
        }
      }

      // Complete the purchase (important!)
      if (purchaseDetails.pendingCompletePurchase) {
        await _iap.completePurchase(purchaseDetails);
      }
    }
  }

  /// Verify purchase and activate premium
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    // In production, you should verify the purchase on your backend server
    // For now, we'll trust the purchase

    final String productId = purchaseDetails.productID;
    String premiumType;
    DateTime? expiryDate;
    bool autoRenewing = true;

    if (productId == premiumLifetimeId) {
      premiumType = 'lifetime';
      expiryDate = null; // No expiry
      autoRenewing = true; // Lifetime tidak ada renewal
    } else if (productId == premiumMonthlyId) {
      premiumType = 'subscription';
      expiryDate = DateTime.now().add(const Duration(days: 30));
      // Check if subscription is auto-renewing
      // Note: pendingCompletePurchase akan true jika masih aktif
      autoRenewing = purchaseDetails.status != PurchaseStatus.canceled;
    } else if (productId == premiumYearlyId) {
      premiumType = 'subscription';
      expiryDate = DateTime.now().add(const Duration(days: 365));
      autoRenewing = purchaseDetails.status != PurchaseStatus.canceled;
    } else {
      debugPrint('Unknown product ID: $productId');
      return;
    }

    // Activate premium
    await _premiumService.setPremium(
      premiumType: premiumType,
      expiryDate: expiryDate,
      purchaseToken: purchaseDetails.verificationData.serverVerificationData,
      autoRenewing: autoRenewing,
    );

    debugPrint(
      'Premium activated: $premiumType (auto-renewing: $autoRenewing)',
    );
  }

  /// Restore previous purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      debugPrint('IAP not available');
      return;
    }

    try {
      await _iap.restorePurchases();
      debugPrint('Restore purchases completed');
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  /// Check if user has active purchases
  Future<bool> checkActivePurchases() async {
    if (!_isAvailable) return false;

    try {
      // For in_app_purchase 3.x, we use restorePurchases which will trigger
      // the purchase stream with past purchases
      await restorePurchases();

      // Check premium status after restore
      return await _premiumService.isPremium();
    } catch (e) {
      debugPrint('Error checking purchases: $e');
      return false;
    }
  }

  /// Format price for display
  String formatPrice(ProductDetails product) {
    return product.price;
  }

  /// Get product description
  String getProductDescription(String productId) {
    switch (productId) {
      case premiumLifetimeId:
        return 'Akses selamanya ke semua fitur premium';
      case premiumMonthlyId:
        return 'Langganan bulanan - perpanjang otomatis';
      case premiumYearlyId:
        return 'Langganan tahunan - hemat lebih banyak!';
      default:
        return '';
    }
  }

  /// Dispose
  void dispose() {
    _subscription?.cancel();
  }
}
