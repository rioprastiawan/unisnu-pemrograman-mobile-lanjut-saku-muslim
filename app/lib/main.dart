import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/home_page.dart';
import 'pages/calendar_page.dart';
import 'pages/quran_page.dart';
import 'pages/menu_page.dart';
import 'pages/splash_screen.dart';
import 'pages/onboarding_page.dart';
import 'pages/notification_test_page.dart';
import 'services/notification_service.dart';
import 'services/iap_service.dart';
import 'services/premium_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize date formatting for Indonesian locale
  await initializeDateFormatting('id_ID', null);
  
  // Initialize notification service
  await NotificationService().initialize();
  
  // Initialize premium service
  await PremiumService().initialize();
  
  // Initialize IAP service (for in-app purchases)
  await IAPService().initialize();
  
  // Initialize theme service
  await ThemeService().init();
  
  runApp(const SakuMuslimApp());
}

class SakuMuslimApp extends StatefulWidget {
  const SakuMuslimApp({super.key});

  @override
  State<SakuMuslimApp> createState() => _SakuMuslimAppState();
}

class _SakuMuslimAppState extends State<SakuMuslimApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    // Listen to theme changes
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saku Muslim',
      theme: _themeService.getLightTheme(),
      darkTheme: _themeService.getDarkTheme(),
      themeMode: _themeService.themeMode,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/notification-test': (context) => const NotificationTestPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    CalendarPage(),
    QuranPage(),
    MenuPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Al Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu Lain',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
