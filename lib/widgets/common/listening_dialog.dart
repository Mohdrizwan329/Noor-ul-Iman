import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimens.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/spacing.dart';

/// Reusable listening dialog for speech recognition.
/// Shows animated microphone icon and listening status.
///
/// Example usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ListeningDialog(
///     title: 'Listening...',
///     subtitle: 'Speak now',
///     onCancel: () => Navigator.pop(context),
///   ),
/// );
/// ```
class ListeningDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onCancel;

  const ListeningDialog({
    super.key,
    this.title = AppStrings.listening,
    this.subtitle = AppStrings.speakNow,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusXLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Microphone Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: AppDimens.opacityLight),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mic,
                size: AppDimens.iconSizeXLarge,
                color: AppColors.primary,
              ),
            ),
            VSpace.large,

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: AppDimens.fontSizeXLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            VSpace.small,

            // Subtitle
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: AppDimens.fontSizeMedium,
                color: AppColors.textSecondary,
              ),
            ),
            VSpace.large,

            // Cancel Button
            TextButton(
              onPressed: onCancel,
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(
                  fontSize: AppDimens.fontSizeMedium,
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show the listening dialog
  static Future<void> show(
    BuildContext context, {
    String title = AppStrings.listening,
    String subtitle = AppStrings.speakNow,
    required VoidCallback onCancel,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ListeningDialog(
        title: title,
        subtitle: subtitle,
        onCancel: onCancel,
      ),
    );
  }

  /// Hide the listening dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
