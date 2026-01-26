import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../home/home_screen.dart';
import '../quran/quran_screen.dart';
import '../prayer_times/prayer_times_screen.dart';
import '../settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    QuranScreen(),
    PrayerTimesScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: responsive.spacing(20),
              offset: Offset(0, responsive.spacing(-5)),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: responsive.paddingSymmetric(horizontal: 8, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.mosque_rounded, Icons.mosque_outlined, context.tr('home')),
                _buildNavItem(1, Icons.menu_book_rounded, Icons.menu_book_outlined, context.tr('quran')),
                _buildNavItem(2, Icons.schedule_rounded, Icons.schedule_outlined, context.tr('prayer_times')),
                _buildNavItem(3, Icons.person_rounded, Icons.person_outlined, context.tr('settings')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    final responsive = context.responsive;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: responsive.paddingSymmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected
                  ? AppColors.secondary
                  : Colors.white.withValues(alpha: 0.7),
              size: responsive.iconMedium,
            ),
            SizedBox(height: responsive.spaceXSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.fontSize(11),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? AppColors.secondary
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
