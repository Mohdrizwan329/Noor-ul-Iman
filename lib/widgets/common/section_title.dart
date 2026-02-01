import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';

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
    final responsive = context.responsive;

    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        responsive.hSpaceSmall,
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.heading3(context),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: AppButtonStyles.text(context),
            child: Text(
              seeAllText!,
              style: AppTextStyles.link(context, underline: false),
            ),
          ),
      ],
    );
  }
}
