import 'package:flutter/material.dart';
import 'dart:async';
import '../../../app/config/app_config.dart';
import '../../../core/models/prayer_time_model.dart';

/// Header widget showing current time, next prayer info, and location
class HomeHeader extends StatefulWidget {
  const HomeHeader({
    super.key,
    required this.nextPrayer,
    required this.locationName,
    required this.minutesUntilNext,
    this.onQiblaPressed,
  });

  final PrayerTime? nextPrayer;
  final String locationName;
  final int minutesUntilNext;
  final VoidCallback? onQiblaPressed;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Update time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatTimeRemaining(int minutes) {
    if (minutes <= 0) return '00:00';

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isDark
                  ? [
                    AppColors.primaryGreenDark,
                    AppColors.primaryGreenMediumDark,
                  ]
                  : [AppColors.primaryGreen, AppColors.primaryGreenLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with back button and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.menu,
                    color: AppColors.textOnPrimary,
                    size: AppConstants.iconM,
                  ),
                  Icon(
                    Icons.person_outline,
                    color: AppColors.textOnPrimary,
                    size: AppConstants.iconM,
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingL),

              // Current Time Display
              Center(
                child: Column(
                  children: [
                    Text(
                      _formatTime(_currentTime),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      _currentTime.hour < 12 ? 'AM' : 'PM',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeL,
                        color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppConstants.spacingXL),

              // Next Prayer Info and Location
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Next Prayer
                        if (widget.nextPrayer != null) ...[
                          Text(
                            'Next prayer: ${widget.nextPrayer!.nameIndonesian}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeM,
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.9,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: AppConstants.spacingXS),

                          // Time Remaining
                          Text(
                            _formatTimeRemaining(widget.minutesUntilNext),
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeXL,
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],

                        SizedBox(height: AppConstants.spacingS),

                        // Location
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppConstants.iconS,
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.8,
                              ),
                            ),
                            SizedBox(width: AppConstants.spacingXS),
                            Flexible(
                              child: Text(
                                widget.locationName,
                                style: TextStyle(
                                  fontSize: AppConstants.fontSizeS,
                                  color: AppColors.textOnPrimary.withValues(
                                    alpha: 0.8,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: AppConstants.spacingM),

                  // Qibla Direction Button
                  GestureDetector(
                    onTap: widget.onQiblaPressed,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.textOnPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.textOnPrimary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ka'bah Icon (using a mosque icon as placeholder)
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? AppColors.accentGoldDark
                                      : AppColors.accentGold,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mosque,
                              size: 20,
                              color: AppColors.textPrimary,
                            ),
                          ),

                          SizedBox(height: AppConstants.spacingXS),

                          Text(
                            'Qibla Direction',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textOnPrimary.withValues(
                                alpha: 0.9,
                              ),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppConstants.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
