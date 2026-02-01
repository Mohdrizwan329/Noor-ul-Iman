import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../auth/login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    final navigator = Navigator.of(context);
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    await languageProvider.setLanguage(languageCode);

    if (!mounted) return;

    // Request permissions before navigating
    await Permission.location.request();
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();

    if (!mounted) return;

    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final languages = [
      {
        'code': 'hi',
        'name': 'हिन्दी',
        'nativeName': 'Hindi',
        'icon': '🇮🇳',
        'gradient': const LinearGradient(
          colors: [Color(0xFFFF9933), Color(0xFF138808)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'code': 'ur',
        'name': 'اردو',
        'nativeName': 'Urdu',
        'icon': '🇵🇰',
        'gradient': const LinearGradient(
          colors: [Color(0xFF01411C), Color(0xFF64DD17)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'code': 'ar',
        'name': 'العربية',
        'nativeName': 'Arabic',
        'icon': '🇸🇦',
        'gradient': const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      {
        'code': 'en',
        'name': 'English',
        'nativeName': 'English',
        'icon': '🇬🇧',
        'gradient': const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: responsive.spacing(32),
              height: responsive.spacing(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(responsive.radiusSmall),
              ),
              padding: EdgeInsets.all(responsive.spacing(4)),
              child: Image.asset(AppAssets.appLogo, fit: BoxFit.contain),
            ),
            SizedBox(width: responsive.spacing(8)),
            Flexible(
              child: Text(
                context.tr('choose_language'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: responsive.paddingAll(20),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // Urdu Subtitle (Top)
                  Container(
                    height: responsive.spacing(80),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                AppColors.darkCard,
                                AppColors.darkCard.withValues(alpha: 0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(
                        responsive.radiusLarge,
                      ),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : AppColors.lightGreenBorder,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: responsive.spacing(10),
                          offset: Offset(0, responsive.spacing(2)),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Assalamu Alaikum',
                        style: TextStyle(
                          fontSize: responsive.textTitle,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  responsive.vSpaceSmall,
                  responsive.vSpaceSmall,

                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select Your Language',
                      style: TextStyle(
                        fontSize: responsive.fontSize(18),
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  // Language Cards in Column
                  Expanded(
                    child: SingleChildScrollView(
                      padding: responsive.paddingAll(10),
                      child: Column(
                        children: languages.map((language) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: responsive.spacing(15),
                            ),
                            child: _LanguageCard(
                              languageCode: language['code'] as String,
                              name: language['name'] as String,
                              nativeName: language['nativeName'] as String,
                              icon: language['icon'] as String,
                              gradient: language['gradient'] as LinearGradient,
                              onTap: () => _selectLanguage(
                                context,
                                language['code'] as String,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  responsive.vSpaceRegular,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final String languageCode;
  final String name;
  final String nativeName;
  final String icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.languageCode,
    required this.name,
    required this.nativeName,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : AppColors.lightGreenBorder,
              width: 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: responsive.spacing(10),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
          ),
          padding: responsive.paddingAll(20),
          child: Row(
            children: [
              // Flag Icon in Circle
              Container(
                width: responsive.spacing(60),
                height: responsive.spacing(60),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700
                        : AppColors.lightGreenBorder,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.icon,
                    style: TextStyle(fontSize: responsive.fontSize(35)),
                  ),
                ),
              ),
              responsive.hSpaceMedium,
              // Language Names
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Language Name in Native Script
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: responsive.fontSize(20),
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                        fontFamily:
                            widget.languageCode == 'ar' ||
                                widget.languageCode == 'ur'
                            ? 'Poppins'
                            : null,
                      ),
                    ),
                    responsive.vSpaceXSmall,
                    // Language Name in English
                    Text(
                      widget.nativeName,
                      style: TextStyle(
                        fontSize: responsive.fontSize(16),
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              responsive.hSpaceMedium,
              // Forward Arrow Button
              Container(
                width: responsive.spacing(32),
                height: responsive.spacing(32),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: responsive.iconXSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
