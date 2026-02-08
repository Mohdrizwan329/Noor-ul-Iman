import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import 'app_card.dart';

/// Reusable feature card widget for grid layouts.
/// Used in home screen and feature listing screens.
///
/// Example usage:
/// ```dart
/// FeatureCard(
///   icon: Icons.mosque,
///   title: 'Qibla',
///   color: AppColors.primary,
///   onTap: () => Navigator.push(...),
/// )
/// ```
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;
  final double? size;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return AppCard(
      padding: responsive.paddingAll(12),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: responsive.paddingAll(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: size ?? responsive.iconLarge,
              color: color,
            ),
          ),
          SizedBox(height: responsive.spaceMedium),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: responsive.spaceSmall),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
