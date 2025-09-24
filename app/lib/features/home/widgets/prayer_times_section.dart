import 'package:flutter/material.dart';
import '../../../app/config/app_config.dart';
import '../../../core/models/prayer_time_model.dart';

/// Widget for displaying today's prayer times
class PrayerTimesSection extends StatelessWidget {
  const PrayerTimesSection({
    super.key,
    required this.prayerTimes,
    this.currentPrayer,
    this.nextPrayer,
  });

  final List<PrayerTime> prayerTimes;
  final PrayerTime? currentPrayer;
  final PrayerTime? nextPrayer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(AppConstants.spacingL),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: AppColors.getPrimaryColor(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  size: AppConstants.iconM,
                ),
                SizedBox(width: AppConstants.spacingS),
                Text(
                  'Prayer Times Today',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimaryColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Prayer Times List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prayerTimes.length,
            itemBuilder: (context, index) {
              final prayer = prayerTimes[index];
              final isNext = nextPrayer?.name == prayer.name;
              final isCurrent = currentPrayer?.name == prayer.name;
              final isPassed = _isPrayerPassed(prayer);

              return PrayerTimeCard(
                prayer: prayer,
                isNext: isNext,
                isCurrent: isCurrent,
                isPassed: isPassed,
                isLast: index == prayerTimes.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isPrayerPassed(PrayerTime prayer) {
    final now = DateTime.now();
    final currentTimeInMinutes = now.hour * 60 + now.minute;
    final prayerTimeparts = prayer.time.split(':');
    final prayerTimeInMinutes =
        int.parse(prayerTimeparts[0]) * 60 + int.parse(prayerTimeparts[1]);

    return prayerTimeInMinutes < currentTimeInMinutes;
  }
}

/// Individual prayer time card
class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.isNext,
    required this.isCurrent,
    required this.isPassed,
    required this.isLast,
  });

  final PrayerTime prayer;
  final bool isNext;
  final bool isCurrent;
  final bool isPassed;
  final bool isLast;

  IconData _getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'sunrise':
        return Icons.wb_sunny;
      case 'dhuhr':
        return Icons.wb_sunny_outlined;
      case 'asr':
        return Icons.wb_cloudy;
      case 'maghrib':
        return Icons.wb_twilight_outlined;
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.schedule;
    }
  }

  Color _getStatusColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isNext) {
      return isDark ? AppColors.prayerUpcomingDark : AppColors.prayerUpcoming;
    } else if (isCurrent) {
      return isDark ? AppColors.prayerActiveDark : AppColors.prayerActive;
    } else if (isPassed) {
      return isDark ? AppColors.prayerPassedDark : AppColors.prayerPassed;
    } else {
      return isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(context);

    return Container(
      margin: EdgeInsets.only(
        left: AppConstants.spacingL,
        right: AppConstants.spacingL,
        bottom: isLast ? AppConstants.spacingL : AppConstants.spacingS,
      ),
      padding: EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color:
            isNext
                ? (isDark
                    ? AppColors.primaryGreenLightDark
                    : AppColors.primaryGreenLighter)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusM),
        border:
            isNext
                ? Border.all(
                  color:
                      isDark
                          ? AppColors.primaryGreenLight
                          : AppColors.primaryGreen,
                  width: 1,
                )
                : null,
      ),
      child: Row(
        children: [
          // Prayer Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getPrayerIcon(prayer.name),
              color: statusColor,
              size: 20,
            ),
          ),

          SizedBox(width: AppConstants.spacingM),

          // Prayer Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.nameIndonesian,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeL,
                    fontWeight: FontWeight.w600,
                    color:
                        isNext
                            ? (isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimary)
                            : statusColor,
                  ),
                ),
                Text(
                  prayer.name,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeS,
                    color: statusColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // Prayer Time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prayer.time,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeL,
                  fontWeight: FontWeight.w600,
                  color:
                      isNext
                          ? (isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary)
                          : statusColor,
                ),
              ),
              if (isNext) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.primaryGreenLight
                            : AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Selanjutnya',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else if (isCurrent) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isDark
                            ? AppColors.prayerActiveDark
                            : AppColors.prayerActive,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Sekarang',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ] else if (isPassed) ...[
                Text(
                  'Selesai',
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
