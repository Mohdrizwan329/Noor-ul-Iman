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
          width: 5,
          height: 24,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A5C36), Color(0xFF2DA86B)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        responsive.hSpaceSmall,
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.heading3(context).copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
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
