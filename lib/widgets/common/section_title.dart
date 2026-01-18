import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/utils/spacing.dart';

/// Reusable section title widget with accent line.
/// Commonly used in home screen and list screens to separate sections.
///
/// Example usage:
/// ```dart
/// SectionTitle(
///   title: 'Featured',
///   onSeeAll: () => Navigator.push(...),
/// )
/// ```
class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  final String? seeAllText;

  const SectionTitle({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllText = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          ),
        ),
        HSpace.medium,
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color:
                    isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(seeAllText!),
          ),
      ],
    );
  }
}
