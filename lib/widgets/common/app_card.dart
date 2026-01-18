import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';

/// Reusable card widget that automatically handles dark mode styling.
/// Replaces 424+ repeated BoxDecoration patterns across the app.
///
/// Example usage:
/// ```dart
/// AppCard(
///   child: Text('Hello World'),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimens.borderRadiusLarge,
          ),
          child: Container(
            padding: padding ?? const EdgeInsets.all(AppDimens.paddingMedium),
            decoration: BoxDecoration(
              color: gradient == null
                  ? (backgroundColor ??
                      (isDark ? AppColors.darkCard : Colors.white))
                  : null,
              gradient: gradient,
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppDimens.borderRadiusLarge,
              ),
              border: border ??
                  Border.all(
                    color: isDark
                        ? Colors.grey.shade700
                        : AppColors.lightGreenBorder,
                    width: AppDimens.borderWidth,
                  ),
              boxShadow: boxShadow ??
                  (isDark
                      ? null
                      : [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
