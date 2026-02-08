import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'responsive_utils.dart';

/// Reusable container decorations and box styles
class AppDecorations {
  /// Card decoration with shadow and border
  static BoxDecoration card(
    BuildContext context, {
    Color? color,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    bool withShadow = true,
  }) {
    final responsive = context.responsive;

    return BoxDecoration(
      color: color ?? (Colors.white),
      borderRadius: BorderRadius.circular(
        borderRadius ?? responsive.radiusLarge,
      ),
      border: Border.all(
        color: borderColor ??
            AppColors.lightGreenBorder,
        width: borderWidth ?? 1.5,
      ),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  /// Gradient container decoration
  static BoxDecoration gradient(
    BuildContext context, {
    Gradient? gradient,
    double? borderRadius,
    bool withShadow = true,
  }) {
    final responsive = context.responsive;

    return BoxDecoration(
      gradient: gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF81C784), const Color(0xFF66BB6A)],
          ),
      borderRadius: BorderRadius.circular(
        borderRadius ?? responsive.radiusLarge,
      ),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: const Color(0x3081C784),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ]
          : null,
    );
  }

  /// Primary colored container decoration
  static BoxDecoration primaryContainer(
    BuildContext context, {
    double? borderRadius,
    double? opacity,
  }) {
    final responsive = context.responsive;

    return BoxDecoration(
      color: AppColors.primary.withValues(alpha: opacity ?? 0.1),
      borderRadius: BorderRadius.circular(
        borderRadius ?? responsive.radiusLarge,
      ),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.3),
        width: 1,
      ),
    );
  }

  /// Chip/Badge decoration
  static BoxDecoration chip(
    BuildContext context, {
    Color? color,
    double? borderRadius,
  }) {
    final responsive = context.responsive;

    return BoxDecoration(
      color: color ?? AppColors.lightGreenChip,
      borderRadius: BorderRadius.circular(
        borderRadius ?? responsive.radiusMedium,
      ),
    );
  }

  /// Circular avatar/icon container decoration
  static BoxDecoration circularIcon(
    BuildContext context, {
    Color? color,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      shape: BoxShape.circle,
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withAlpha(50),
                blurRadius: 15.0,
                offset: const Offset(0, 5.0),
              ),
            ]
          : null,
    );
  }

  /// Search bar decoration
  static BoxDecoration searchBar(
    BuildContext context, {
    double? borderRadius,
  }) {

    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(borderRadius ?? 18.0),
      border: Border.all(
        color: AppColors.lightGreenBorder,
        width: 1.5,
      ),
      boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 10.0,
                offset: const Offset(0, 2.0),
              ),
            ],
    );
  }

  /// Header/Banner decoration with gradient
  static BoxDecoration header(
    BuildContext context, {
    double? borderRadius,
  }) {
    return BoxDecoration(
      gradient: AppColors.headerGradient,
      borderRadius: BorderRadius.circular(
        borderRadius ?? 18.0,
      ),
    );
  }

  /// Input field decoration
  static InputDecoration inputField(
    BuildContext context, {
    required String hintText,
    String? labelText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    Color? fillColor,
  }) {
    final responsive = context.responsive;

    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      hintStyle: TextStyle(
        color: AppColors.textHint,
        fontSize: responsive.textMedium,
      ),
      labelStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: responsive.textMedium,
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: AppColors.primary,
              size: responsive.iconMedium,
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor ?? (Colors.white),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        borderSide: BorderSide(
          color: AppColors.lightGreenBorder,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        borderSide: BorderSide(
          color: AppColors.lightGreenBorder,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        borderSide: BorderSide(
          color: AppColors.error,
        ),
      ),
      contentPadding: responsive.paddingSymmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  /// Divider with icon or text in middle
  static Widget dividerWithText(
    BuildContext context, {
    required String text,
    Color? textColor,
    Color? dividerColor,
  }) {
    final responsive = context.responsive;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: dividerColor ??
                const Color(0x80FFFFFF),
            thickness: 1.5,
          ),
        ),
        Padding(
          padding: responsive.paddingSymmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ??
                  (const Color(0xE6FFFFFF)),
              fontSize: responsive.textSmall,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: dividerColor ??
                const Color(0x80FFFFFF),
            thickness: 1.5,
          ),
        ),
      ],
    );
  }

  /// Section title with accent bar
  static Widget sectionTitle(
    BuildContext context, {
    required String title,
    VoidCallback? onSeeAllTap,
    String? seeAllText,
  }) {
    final responsive = context.responsive;

    return Row(
      children: [
        Container(
          width: 4.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        responsive.hSpaceSmall,
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: responsive.textLarge,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        if (onSeeAllTap != null)
          TextButton(
            onPressed: onSeeAllTap,
            child: Text(
              seeAllText ?? 'See All',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: responsive.textSmall,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// Button style utilities
class AppButtonStyles {
  /// Primary elevated button style
  static ButtonStyle primary(
    BuildContext context, {
    Color? backgroundColor,
    Color? foregroundColor,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    final responsive = context.responsive;

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: 8,
      shadowColor: Colors.black.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? 16.0,
        ),
      ),
      padding: padding ?? responsive.paddingSymmetric(vertical: 16),
    );
  }

  /// White button with colored text (for gradient backgrounds)
  static ButtonStyle white(
    BuildContext context, {
    Color? foregroundColor,
    double? borderRadius,
    BorderSide? border,
  }) {

    return ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: foregroundColor ??
          const Color(0xFF4CAF50),
      elevation: 8,
      shadowColor: Colors.black.withAlpha(80),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? 16.0,
        ),
        side: border ?? BorderSide.none,
      ),
    );
  }

  /// Outlined button style
  static ButtonStyle outlined(
    BuildContext context, {
    Color? borderColor,
    Color? foregroundColor,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    final responsive = context.responsive;

    return OutlinedButton.styleFrom(
      foregroundColor: foregroundColor ?? AppColors.primary,
      backgroundColor: backgroundColor ?? Colors.transparent,
      side: BorderSide(
        color: borderColor ?? AppColors.primary,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius ?? 16.0,
        ),
      ),
      padding: responsive.paddingSymmetric(vertical: 12),
    );
  }

  /// Text button style
  static ButtonStyle text(
    BuildContext context, {
    Color? foregroundColor,
  }) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? AppColors.primary,
    );
  }
}
