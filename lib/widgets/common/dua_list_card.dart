import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/utils/spacing.dart';
import 'app_card.dart';

/// Reusable card for displaying duas in a list.
/// Used in Dua screens, Ramadan tracker, and other similar lists.
///
/// Example usage:
/// ```dart
/// DuaListCard(
///   index: 0,
///   title: 'Dua for Morning',
///   subtitle: 'Subhaanallahi wa bihamdihi',
///   onTap: () => Navigator.push(...),
/// )
/// ```
class DuaListCard extends StatelessWidget {
  final int index;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool showNumberBadge;

  const DuaListCard({
    super.key,
    required this.index,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
    this.showNumberBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppDimens.paddingMedium),
      onTap: onTap,
      child: Row(
        children: [
          // Number Badge
          if (showNumberBadge) ...[
            Container(
              width: AppDimens.badgeSize,
              height: AppDimens.badgeSize,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: AppDimens.opacityLight),
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: AppDimens.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            HSpace.medium,
          ],

          // Dua Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppDimens.fontSizeNormal,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  VSpace.small,
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: AppDimens.fontSizeSmall,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Trailing Widget or Arrow
          trailing ??
              const Icon(
                Icons.arrow_forward_ios,
                size: AppDimens.fontSizeLarge,
                color: AppColors.textSecondary,
              ),
        ],
      ),
    );
  }
}
