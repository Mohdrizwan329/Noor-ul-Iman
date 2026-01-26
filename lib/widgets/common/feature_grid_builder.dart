import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';

/// Reusable grid builder for feature cards with responsive design
/// Automatically adjusts columns based on screen size and orientation
/// Used in home screen and other screens with grid layouts
class FeatureGridBuilder extends StatelessWidget {
  final List<FeatureGridItem> items;
  final int? crossAxisCount; // Now optional, will auto-calculate if null
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double childAspectRatio;

  const FeatureGridBuilder({
    super.key,
    required this.items,
    this.crossAxisCount, // Removed default value
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;

    // Auto-calculate responsive grid columns if not specified
    final int columns = crossAxisCount ?? responsive.gridColumnCount;

    // Use responsive spacing or defaults
    final double spacing = crossAxisSpacing ?? responsive.gridSpacing;
    final double mainSpacing = mainAxisSpacing ?? responsive.gridSpacing;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: mainSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _FeatureGridCard(item: item, isDark: isDark);
      },
    );
  }
}

/// Feature grid item model
class FeatureGridItem {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final String? emoji;

  const FeatureGridItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.emoji,
  });
}

/// Internal feature grid card widget with responsive design
class _FeatureGridCard extends StatelessWidget {
  final FeatureGridItem item;
  final bool isDark;

  const _FeatureGridCard({
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(responsive.radiusLarge),
      child: Container(
        padding: responsive.paddingAll(8),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: responsive.paddingAll(12),
              decoration: BoxDecoration(
                color: isDark
                    ? item.color.withValues(alpha: 0.2)
                    : AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: responsive.spacing(8),
                          offset: Offset(0, responsive.spacing(2)),
                        ),
                      ],
              ),
              child: item.emoji != null
                  ? Text(
                      item.emoji!,
                      style: TextStyle(fontSize: responsive.fontSize(24)),
                    )
                  : Icon(
                      item.icon,
                      color: isDark ? item.color : Colors.white,
                      size: responsive.iconMedium,
                    ),
            ),
            SizedBox(height: responsive.spaceSmall),
            Text(
              item.title,
              style: TextStyle(
                fontSize: responsive.fontSize(12),
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: responsive.isTablet ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
