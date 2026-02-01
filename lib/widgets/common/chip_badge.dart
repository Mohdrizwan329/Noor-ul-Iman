import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

/// A reusable chip/badge widget for labels, counts, and references.
/// Features:
/// - Auto-sizing based on content
/// - Theme-aware colors
/// - Optional icon support
/// - Outlined or filled variants
///
/// Example usage:
/// ```dart
/// ChipBadge(
///   text: '1',
///   backgroundColor: AppColors.primary,
/// )
///
/// ChipBadge(
///   text: 'New',
///   icon: Icons.star,
///   outlined: true,
/// )
/// ```
class ChipBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool outlined;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const ChipBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.outlined = false,
    this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.primary);
    final effectiveTextColor =
        textColor ??
        (outlined ? (backgroundColor ?? AppColors.primary) : Colors.white);

    return Container(
      padding:
          padding ?? responsive.paddingSymmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : effectiveBackgroundColor,
        border: outlined
            ? Border.all(color: effectiveBackgroundColor, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? responsive.iconXSmall,
              color: effectiveTextColor,
            ),
            SizedBox(width: responsive.spaceXSmall),
          ],
          Text(
            text,
            style: AppTextStyles.caption(
              context,
            ).copyWith(color: effectiveTextColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
