import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/config/app_config.dart';
import 'features/splash/splash.dart';
import 'features/home/prayer_time_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SakuMuslimApp());
}

class SakuMuslimApp extends StatelessWidget {
  const SakuMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PrayerTimeProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Theme configuration
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Follows system theme
        // Home screen
        home: const SplashScreen(),

        // App-wide configurations
        builder: (context, child) {
          return MediaQuery(
            // Prevent font scaling issues
            data: MediaQuery.of(context).copyWith(
              textScaler: MediaQuery.of(
                context,
              ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.2),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
