import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

/// Reusable header action button widget used in detail screens
/// Supports both light and dark themes automatically
class HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;

  const HeaderActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;
    final buttonColor = isActive
        ? (activeColor ?? AppColors.primary)
        : (inactiveColor ??
            (isDark ? Colors.grey.shade700 : Colors.grey.shade300));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.radiusMedium),
      child: Container(
        padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(responsive.radiusMedium),
          boxShadow: isActive && !isDark
              ? [
                  BoxShadow(
                    color: (activeColor ?? AppColors.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive || isDark ? Colors.white : Colors.grey.shade700,
              size: responsive.iconSmall,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption(context).copyWith(
                fontWeight: FontWeight.w600,
                color: isActive || isDark ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
