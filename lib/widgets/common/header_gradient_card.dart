import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/utils/app_utils.dart';

/// Header card with gradient background and icon.
/// Used in category screens like Dua list, Hadith, etc.
///
/// Example usage:
/// ```dart
/// HeaderGradientCard(
///   icon: '🤲',
///   title: 'Morning Duas',
///   subtitle: '12 Duas',
/// )
/// ```
class HeaderGradientCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Gradient? gradient;

  const HeaderGradientCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      margin: const EdgeInsets.all(AppDimens.paddingMedium),
      padding: const EdgeInsets.all(AppDimens.paddingLarge),
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.headerGradient,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusXLarge),
      ),
      child: Row(
        children: [
          Container(
            width: responsive.iconXLarge,
            height: responsive.iconXLarge,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
            child: Center(
              child: Text(
                icon,
                style: const TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          ),
          HSpace.large,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                VSpace.small,
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
