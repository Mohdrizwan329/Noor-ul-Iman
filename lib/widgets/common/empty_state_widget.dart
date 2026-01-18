import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/spacing.dart';

/// Reusable empty state widget.
/// Displays icon, message, and optional action button.
///
/// Example usage:
/// ```dart
/// EmptyStateWidget(
///   message: 'No items found',
///   icon: Icons.search_off,
/// )
/// ```
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          VSpace.large,
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          if (actionText != null && onAction != null) ...[
            VSpace.large,
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}
