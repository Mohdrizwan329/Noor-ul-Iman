import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'responsive_utils.dart';

/// Reusable text styles with responsive sizing and theme awareness
class AppTextStyles {
  /// Get heading styles
  static TextStyle heading1(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textXXLarge,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.primary),
    );
  }

  static TextStyle heading2(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textXLarge,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.primary),
    );
  }

  static TextStyle heading3(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textLarge,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? (isDark ? AppColors.darkTextPrimary : AppColors.primary),
    );
  }

  /// Get body text styles
  static TextStyle bodyLarge(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textMedium,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
    );
  }

  static TextStyle bodyMedium(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textSmall,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
    );
  }

  static TextStyle bodySmall(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textXSmall,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ??
          (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
    );
  }

  /// Button text styles
  static TextStyle button(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textLarge,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Colors.white,
    );
  }

  static TextStyle buttonSmall(
    BuildContext context, {
    Color? color,
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textMedium,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Colors.white,
    );
  }

  /// Caption/hint text styles
  static TextStyle caption(
    BuildContext context, {
    Color? color,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontSize: responsive.textXSmall,
      color: color ?? (isDark ? AppColors.darkTextSecondary : AppColors.textHint),
    );
  }

  /// Link text style
  static TextStyle link(
    BuildContext context, {
    Color? color,
    bool underline = true,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textMedium,
      color: color ?? AppColors.primary,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      fontWeight: FontWeight.w600,
    );
  }

  /// Arabic text style for Quran/Duas
  static TextStyle arabic(
    BuildContext context, {
    double? fontSize,
    Color? color,
    double? height,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize ?? responsive.textXLarge,
      height: height ?? 1.5,
      color: color ?? Colors.black87,
    );
  }

  /// Urdu text style
  static TextStyle urdu(
    BuildContext context, {
    double? fontSize,
    Color? color,
  }) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: fontSize ?? responsive.textMedium,
      color: color ??
          (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
    );
  }

  /// Error text style
  static TextStyle error(BuildContext context) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textSmall,
      color: AppColors.error,
    );
  }

  /// Success text style
  static TextStyle success(BuildContext context) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textSmall,
      color: AppColors.success,
    );
  }

  /// White text styles (for colored backgrounds)
  static TextStyle whiteHeading(
    BuildContext context, {
    FontWeight? fontWeight,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textXXLarge,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle whiteBody(
    BuildContext context, {
    FontWeight? fontWeight,
    double? opacity,
  }) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textMedium,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: opacity != null
          ? Colors.white.withValues(alpha: opacity)
          : Colors.white,
    );
  }

  static TextStyle whiteCaption(BuildContext context) {
    final responsive = context.responsive;
    return TextStyle(
      fontSize: responsive.textSmall,
      color: Colors.white.withValues(alpha: 0.8),
    );
  }
}
