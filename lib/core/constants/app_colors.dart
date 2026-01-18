import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary - Dark Islamic Green
  static const Color primary = Color(0xFF0A5C36);
  static const Color primaryLight = Color(0xFF1E8F5A); // Emerald Green
  static const Color primaryDark = Color(0xFF073D24);

  // Secondary - Soft Gold (Islamic Calligraphy Color)
  static const Color secondary = Color(0xFFC9A24D);
  static const Color secondaryLight = Color(0xFFE6D8A8); // Light Gold
  static const Color secondaryDark = Color(0xFFB8892A);

  // AppBar - Dark Islamic Green
  static const Color appBarColor = Color(0xFF0A5C36);
  static const Color appBarColorLight = Color(0xFF1E8F5A);

  // Background - Soft Off-White (Eye-friendly)
  static const Color background = Color(0xFFF6F8F6);
  static const Color surface = Color(0xFFF2F7F4); // Very Light Green
  static const Color cardBackground = Colors.white;

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2D2D2D);

  // Text Colors - Islamic Theme
  static const Color textPrimary = Color(0xFF0A5C36); // Dark Green for headings
  static const Color textSecondary = Color(0xFF6B7F73); // Muted for secondary
  static const Color textHint = Color(0xFF8AAF9A); // Light Green hint
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Color(0xFF2F3E36); // Normal text
  static const Color arabicTextColor = Color(0xFF1F3D2B); // Arabic text

  // Dark Text Colors
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  // Prayer Time Colors - Soft Islamic Palette
  static const Color fajrColor = Color(0xFF4A6FA5);
  static const Color sunriseColor = Color(0xFFE8A94B);
  static const Color dhuhrColor = Color(0xFFF4C430);
  static const Color asrColor = Color(0xFFE07B39);
  static const Color maghribColor = Color(0xFFD15B47);
  static const Color ishaColor = Color(0xFF6B5B95);

  // Status Colors
  static const Color success = Color(0xFF1E8F5A); // Emerald Green
  static const Color error = Color(0xFFCD5C5C);
  static const Color warning = Color(0xFFC9A24D); // Soft Gold
  static const Color info = Color(0xFF4E6E5D); // Muted Green

  // Qibla Compass Colors
  static const Color compassNeedle = Color(0xFFCD5C5C);
  static const Color compassBackground = Color(0xFFF6F8F6);
  static const Color qiblaDirection = Color(0xFF0A5C36);

  // Tasbih Counter Colors
  static const Color tasbihBackground = Color(0xFF0A5C36);
  static const Color tasbihAccent = Color(0xFFC9A24D);

  // Quran Colors
  static const Color arabicText = Color(0xFF1F3D2B);
  static const Color translationText = Color(0xFF2F3E36);
  static const Color verseNumber = Color(0xFF0A5C36);

  // Gradient Colors - Islamic Inspired
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Header Gradient - Dark Islamic Green
  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF0A5C36), Color(0xFF1E8F5A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Splash/Account Screen Gradient
  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF0A5C36), Color(0xFF073D24)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Islamic Pattern Accent Colors
  static const Color mosqueGreen = Color(0xFF0A5C36);
  static const Color kaabahGold = Color(0xFFC9A24D);
  static const Color crescentSilver = Color(0xFFE6D8A8);

  // Additional Islamic Colors
  static const Color emeraldGreen = Color(0xFF1E8F5A);
  static const Color mutedGreen = Color(0xFF4E6E5D);
  static const Color lightGreenChip = Color(0xFFE8F3ED);
  static const Color veryLightGreen = Color(0xFFF2F7F4);
  static const Color lightGreenBorder = Color(0xFF8AAF9A);

  // Ramadan Feature Colors
  static const Color indigoBlue = Color(0xFF3949AB);
  static const Color deepOrange = Color(0xFFE65100);
  static const Color tealGreen = Color(0xFF00796B);
  static const Color purpleDeep = Color(0xFF512DA8);
  static const Color redDeep = Color(0xFFC62828);

  // Additional Gradient Colors
  static const Color lightGreen = Color(0xFF81C784);

  // QR Code Colors
  static const Color qrForeground = Color(0xFF0A5C36);
  static const Color qrBackground = Color(0xFFFFFFFF);
}
