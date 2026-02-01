import 'package:flutter/material.dart';
import '../../core/utils/app_utils.dart';

/// Reusable error state widget.
/// Displays error icon, message, and optional retry button.
///
/// Example usage:
/// ```dart
/// ErrorStateWidget(
///   message: 'Failed to load data',
///   onRetry: () => _loadData(),
/// )
/// ```
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryButtonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: responsive.iconXXLarge,
            color: isDark ? Colors.grey.shade600 : Colors.grey,
          ),
          VSpace.large,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(context),
          ),
          if (onRetry != null) ...[
            VSpace.large,
            ElevatedButton(
              onPressed: onRetry,
              child: Text(retryButtonText),
            ),
          ],
        ],
      ),
    );
  }
}
