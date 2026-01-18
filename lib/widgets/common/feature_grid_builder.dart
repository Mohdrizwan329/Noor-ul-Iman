import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Reusable grid builder for feature cards
/// Used in home screen and other screens with grid layouts
class FeatureGridBuilder extends StatelessWidget {
  final List<FeatureGridItem> items;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

  const FeatureGridBuilder({
    super.key,
    required this.items,
    this.crossAxisCount = 3,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
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

/// Internal feature grid card widget
class _FeatureGridCard extends StatelessWidget {
  final FeatureGridItem item;
  final bool isDark;

  const _FeatureGridCard({
    required this.item,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
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
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: item.emoji != null
                  ? Text(item.emoji!, style: const TextStyle(fontSize: 24))
                  : Icon(
                      item.icon,
                      color: isDark ? item.color : Colors.white,
                      size: 24,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.primary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
