import 'package:flutter/material.dart';
import '../services/premium_service.dart';
import '../pages/premium_page.dart';

/// Example: Cara menggunakan Premium Features di code Anda
/// File ini adalah CONTOH SAJA, tidak perlu diimport ke aplikasi

class PremiumFeatureExamples {
  final PremiumService _premiumService = PremiumService();

  /// Example 1: Check Premium Status
  Future<void> exampleCheckPremiumStatus() async {
    final isPremium = await _premiumService.isPremium();
    
    if (isPremium) {
      print('User adalah premium user!');
      // Allow access to premium features
    } else {
      print('User adalah free user');
      // Show premium prompt
    }
  }

  /// Example 2: Lock Feature Behind Premium
  Future<void> exampleLockFeature(BuildContext context) async {
    final isPremium = await _premiumService.isPremium();
    
    if (!isPremium) {
      // Show premium dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Premium Feature'),
          content: const Text(
            'Fitur ini hanya tersedia untuk pengguna premium. '
            'Upgrade sekarang untuk menikmati fitur lengkap!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Nanti'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumPage(),
                  ),
                );
              },
              child: const Text('Upgrade'),
            ),
          ],
        ),
      );
      return;
    }
    
    // User is premium, continue with feature
    print('Access granted!');
  }

  /// Example 3: Check Specific Feature
  Future<void> exampleCheckSpecificFeature() async {
    // Check offline audio feature
    final canDownload = await _premiumService.hasFeature(
      PremiumFeature.offlineAudio,
    );
    
    if (canDownload) {
      print('User dapat download audio offline');
      // Start download
    } else {
      print('User tidak bisa download - perlu upgrade');
      // Show upgrade prompt
    }
    
    // Check masjid terdekat feature
    final canAccessMasjid = await _premiumService.hasFeature(
      PremiumFeature.masjidTerdekat,
    );
    
    if (canAccessMasjid) {
      print('User dapat akses fitur Masjid Terdekat');
      // Show nearby mosques
    }
    
    // Check kalkulator zakat feature
    final canAccessZakat = await _premiumService.hasFeature(
      PremiumFeature.kalkulatorZakat,
    );
    
    if (canAccessZakat) {
      print('User dapat akses Kalkulator Zakat');
      // Show zakat calculator
    }
  }

  /// Example 4: Show Premium Badge on Button
  Widget examplePremiumButton(BuildContext context) {
    return FutureBuilder<bool>(
      future: _premiumService.isPremium(),
      builder: (context, snapshot) {
        final isPremium = snapshot.data ?? false;
        
        return Stack(
          clipBehavior: Clip.none,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                if (!isPremium) {
                  // Show upgrade prompt
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumPage(),
                    ),
                  );
                  return;
                }
                
                // Execute premium feature
                print('Premium feature executed!');
              },
              icon: const Icon(Icons.cloud_download),
              label: const Text('Download Offline'),
            ),
            
            // Premium badge
            if (!isPremium)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Example 5: Conditional UI Based on Premium Status
  Widget exampleConditionalUI(BuildContext context) {
    return FutureBuilder<bool>(
      future: _premiumService.isPremium(),
      builder: (context, snapshot) {
        final isPremium = snapshot.data ?? false;
        
        if (isPremium) {
          // Premium user UI
          return Column(
            children: [
              const Icon(Icons.verified, color: Colors.amber, size: 48),
              const Text('Premium Active'),
              ElevatedButton(
                onPressed: () {
                  // Premium feature
                },
                child: const Text('Use Premium Feature'),
              ),
            ],
          );
        } else {
          // Free user UI
          return Column(
            children: [
              const Icon(Icons.lock, color: Colors.grey, size: 48),
              const Text('Premium Required'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PremiumPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text('Upgrade Now'),
              ),
            ],
          );
        }
      },
    );
  }

  /// Example 6: Get Premium Info
  Future<void> exampleGetPremiumInfo() async {
    final isPremium = await _premiumService.isPremium();
    
    if (isPremium) {
      final premiumType = await _premiumService.getPremiumType();
      print('Premium Type: $premiumType'); // lifetime, subscription, trial
      
      if (premiumType == 'subscription') {
        final daysRemaining = await _premiumService.getDaysRemaining();
        print('Days remaining: $daysRemaining');
        
        if (daysRemaining != null && daysRemaining < 7) {
          print('⚠️ Subscription akan expired dalam $daysRemaining hari!');
          // Show renewal reminder
        }
      }
    }
  }

  /// Example 7: Limit Feature for Free Users
  Future<bool> exampleLimitedFeature(BuildContext context) async {
    final isPremium = await _premiumService.isPremium();
    
    if (!isPremium) {
      // Check usage count for free users
      // Example: Max 5 bookmarks for free users
      const maxFreeBookmarks = 5;
      final currentBookmarks = 3; // Get from database
      
      if (currentBookmarks >= maxFreeBookmarks) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Limit bookmark tercapai. Upgrade ke Premium untuk unlimited bookmarks!',
            ),
            action: SnackBarAction(
              label: 'Upgrade',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PremiumPage(),
                  ),
                );
              },
            ),
          ),
        );
        return false;
      }
    }
    
    // Allow feature
    return true;
  }

  /// Example 8: Show Premium Badge on List Item
  Widget exampleListItemWithBadge({
    required String title,
    required bool isPremiumFeature,
    required VoidCallback onTap,
  }) {
    return FutureBuilder<bool>(
      future: _premiumService.isPremium(),
      builder: (context, snapshot) {
        final isPremium = snapshot.data ?? false;
        final isLocked = isPremiumFeature && !isPremium;
        
        return ListTile(
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.featured_play_list),
              if (isLocked)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          title: Row(
            children: [
              Text(title),
              if (isLocked) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: const Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            if (isLocked) {
              // Show premium prompt
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PremiumPage(),
                ),
              );
            } else {
              onTap();
            }
          },
        );
      },
    );
  }

  /// Example 9: Analytics Event
  Future<void> exampleTrackPremiumEvent() async {
    final isPremium = await _premiumService.isPremium();
    
    // Send to analytics (Firebase, etc.)
    // analytics.logEvent(
    //   name: 'feature_used',
    //   parameters: {
    //     'feature': 'offline_download',
    //     'is_premium': isPremium,
    //   },
    // );
    
    print('Event tracked: isPremium=$isPremium');
  }

  /// Example 10: Test Premium Locally (Development Only!)
  Future<void> exampleTestPremiumLocally() async {
    // ⚠️ ONLY FOR TESTING - Remove in production!
    
    // Activate premium for testing
    await _premiumService.setPremium(
      premiumType: 'lifetime',
    );
    print('✅ Premium activated for testing');
    
    // Check status
    final isPremium = await _premiumService.isPremium();
    print('Is Premium: $isPremium');
    
    // Clear premium (back to free)
    // await _premiumService.clearAllPremiumData();
    // print('✅ Premium cleared');
  }
}

/// Example Usage in Your Pages:
/// 
/// ```dart
/// // In any widget:
/// class MyFeaturePage extends StatelessWidget {
///   final PremiumService _premiumService = PremiumService();
///   
///   @override
///   Widget build(BuildContext context) {
///     return FutureBuilder<bool>(
///       future: _premiumService.isPremium(),
///       builder: (context, snapshot) {
///         final isPremium = snapshot.data ?? false;
///         
///         if (!isPremium) {
///           return PremiumLockWidget(
///             featureName: 'My Feature',
///             description: 'This feature requires premium',
///           );
///         }
///         
///         return YourActualFeatureWidget();
///       },
///     );
///   }
/// }
/// ```
