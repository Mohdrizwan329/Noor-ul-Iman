import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/spacing.dart';

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

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDark ? Colors.grey.shade600 : Colors.grey,
          ),
          VSpace.large,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
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
