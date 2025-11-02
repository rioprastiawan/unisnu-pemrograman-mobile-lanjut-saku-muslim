import 'package:flutter/material.dart';
import '../../../app/config/app_config.dart';
import '../view/home_screen.dart';

/// Main app navigation with bottom navigation bar
class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  // Navigation items
  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Beranda',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined),
      activeIcon: Icon(Icons.book),
      label: 'Al-Qur\'an',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.apps_outlined),
      activeIcon: Icon(Icons.apps),
      label: 'Menu',
    ),
  ];

  // Pages for each navigation item
  final List<Widget> _pages = [
    const HomeScreen(),
    const _PlaceholderPage(title: 'Al-Qur\'an', icon: Icons.book),
    const _PlaceholderPage(title: 'Menu', icon: Icons.apps),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: AppConstants.shortAnimation,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onNavItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              isDark ? AppColors.surfaceColorDark : AppColors.surfaceColor,
          selectedItemColor:
              isDark ? AppColors.primaryGreenLight : AppColors.primaryGreen,
          unselectedItemColor:
              isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          selectedLabelStyle: TextStyle(
            fontSize: AppConstants.fontSizeS,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: AppConstants.fontSizeS,
            fontWeight: FontWeight.w400,
          ),
          items: _navItems,
        ),
      ),
    );
  }
}

/// Placeholder page for features not yet implemented
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppConstants.iconXXL * 1.5,
              color:
                  isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
            ),
            SizedBox(height: AppConstants.spacingL),
            Text(
              title,
              style: TextStyle(
                fontSize: AppConstants.fontSizeXL,
                fontWeight: FontWeight.w600,
                color:
                    isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppConstants.spacingS),
            Text(
              'Fitur ini akan segera hadir',
              style: TextStyle(
                fontSize: AppConstants.fontSizeM,
                color:
                    isDark
                        ? AppColors.textTertiaryDark
                        : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
