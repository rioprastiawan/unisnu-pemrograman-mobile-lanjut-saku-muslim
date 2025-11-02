import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/config/app_config.dart';
import '../../../shared_widgets/islamic_widgets.dart';
import '../prayer_time_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/prayer_times_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PrayerTimeProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: () => provider.refreshPrayerTimes(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header with current time and next prayer
                  HomeHeader(
                    nextPrayer: provider.nextPrayer,
                    locationName:
                        provider.currentLocation?.displayName ?? 'Unknown',
                    minutesUntilNext:
                        provider.dailyPrayerTimes?.minutesUntilNextPrayer ?? 0,
                    onQiblaPressed:
                        () => _showQiblaDirection(context, provider),
                  ),

                  // Prayer times list
                  if (provider.dailyPrayerTimes != null)
                    PrayerTimesSection(
                      prayerTimes: provider.dailyPrayerTimes!.prayers,
                      currentPrayer: provider.currentPrayer,
                      nextPrayer: provider.nextPrayer,
                    )
                  else if (provider.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: IslamicLoadingIndicator(),
                    )
                  else if (provider.error != null)
                    _buildErrorWidget(context, provider)
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, PrayerTimeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.refreshPrayerTimes(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  void _showQiblaDirection(BuildContext context, PrayerTimeProvider provider) {
    final direction = provider.getQiblaDirection();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Arah Kiblat'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.navigation, size: 64, color: AppColors.primaryGreen),
                const SizedBox(height: 16),
                Text(
                  'Arah kiblat: ${direction.toStringAsFixed(1)}°',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Fitur kompas kiblat sedang dalam pengembangan',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tutup'),
              ),
            ],
          ),
    );
  }
}
