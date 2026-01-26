import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';
import '../language_selection/language_selection_screen.dart';
import '../permissions/permissions_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    // Navigate after checking language selection
    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;

      // Check if language is already selected
      final prefs = await SharedPreferences.getInstance();
      final hasSelectedLanguage = prefs.getString('selected_language') != null;

      if (!mounted) return;

      if (hasSelectedLanguage) {
        // Language already selected, go to permissions
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PermissionsScreen()),
        );
      } else {
        // First time, show language selection
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LanguageSelectionScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.splashGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Logo
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        children: [
                          Container(
                            width: responsive.spacing(130),
                            height: responsive.spacing(130),
                            decoration: BoxDecoration(
                              color: AppColors.appBarColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: responsive.spacing(25),
                                  offset: Offset(0, responsive.spacing(10)),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: responsive.paddingAll(8),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                padding: responsive.paddingAll(8),
                                child: ClipOval(
                                  child: Image.asset(
                                    AppAssets.appLogo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          responsive.vSpaceXLarge,
                          Text(
                            context.tr('app_name'),
                            style: TextStyle(
                              fontSize: responsive.textTitle,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                          responsive.vSpaceSmall,
                          Text(
                            context.tr('app_subtitle'),
                            style: TextStyle(
                              fontSize: responsive.textMedium,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              // Loading indicator
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(
                          width: responsive.spacing(30),
                          height: responsive.spacing(30),
                          child: CircularProgressIndicator(
                            color: AppColors.secondary,
                            strokeWidth: 2,
                          ),
                        ),
                        responsive.vSpaceRegular,
                        Text(
                          context.tr('bismillah_arabic'),
                          style: TextStyle(
                            fontSize: responsive.textLarge,
                            fontFamily: 'Amiri',
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: responsive.spaceHuge),
            ],
          ),
        ),
      ),
    );
  }
}
