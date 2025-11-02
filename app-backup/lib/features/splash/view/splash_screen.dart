import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/config/app_config.dart';
import '../../../shared_widgets/shared_widgets.dart';
import '../../home/home.dart';

/// Splash screen for Saku Muslim app
/// Shows app logo, name, and tagline with Islamic aesthetic
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _navigateToHome();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppConstants.longAnimation * 2, // 1.2 seconds
      vsync: this,
    );

    // Fade animation for overall visibility
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Scale animation for logo
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Slide animation for text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainAppScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark
              ? AppColors.backgroundPrimaryDark
              : AppColors.backgroundPrimary,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:
                      isDark
                          ? [
                            AppColors.backgroundPrimaryDark,
                            AppColors.primaryGreenLightDark,
                          ]
                          : [
                            AppColors.backgroundPrimary,
                            AppColors.primaryGreenLighter,
                          ],
                ),
              ),
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo/Icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: AppLogo(
                          size: AppConstants.iconXXL * 2, // 128px
                          showShadow: true,
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXL),

                      // App Name and Tagline
                      SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          children: [
                            // App Name
                            AnimatedAppName(
                              animation: _fadeAnimation,
                              fontSize: AppConstants.fontSizeTitle,
                            ),

                            SizedBox(height: AppConstants.spacingS),

                            // Arabic Text (بسم الله)
                            const IslamicPhrase(),

                            SizedBox(height: AppConstants.spacingM),

                            // Tagline
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppConstants.spacingXL,
                              ),
                              child: Text(
                                AppConstants.appDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeM,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isDark
                                          ? AppColors.textSecondaryDark
                                          : AppColors.textSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingXXL),

                      // Loading Indicator
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: IslamicLoadingIndicator(
                          size: AppConstants.iconL,
                          color:
                              isDark
                                  ? AppColors.primaryGreenLight
                                  : AppColors.primaryGreen,
                        ),
                      ),

                      SizedBox(height: AppConstants.spacingL),

                      // Loading Text
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          'Mempersiapkan aplikasi...',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeS,
                            color:
                                isDark
                                    ? AppColors.textTertiaryDark
                                    : AppColors.textTertiary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
