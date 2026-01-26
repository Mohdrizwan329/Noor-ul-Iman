import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Local colors not in AppColors
  static const lightGreenChip = Color(0xFFE8F3ED);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('notifications'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: _buildEmptyState(context, isDark, responsive),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, ResponsiveUtils responsive) {
    return Center(
      child: Padding(
        padding: responsive.paddingAll(32),
        child: Container(
          padding: responsive.paddingAll(24),
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
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: responsive.iconSize(100),
                height: responsive.iconSize(100),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: responsive.iconXXLarge,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: responsive.spaceLarge),
              Text(
                context.tr('no_notifications'),
                style: TextStyle(
                  fontSize: responsive.textXLarge,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
                ),
              ),
              SizedBox(height: responsive.spaceMedium),
              Text(
                context.tr('all_caught_up'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: isDark ? AppColors.darkTextSecondary : const Color(0xFF6B7F73),
                  height: 1.5,
                ),
              ),
              SizedBox(height: responsive.spaceLarge),
              Container(
                padding: responsive.paddingSymmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: lightGreenChip,
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  border: Border.all(color: AppColors.lightGreenBorder, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: responsive.iconSmall,
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: responsive.spaceSmall),
                    Text(
                      context.tr('coming_soon'),
                      style: TextStyle(
                        fontSize: responsive.textMedium,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
