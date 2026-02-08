import 'package:flutter/material.dart';
import '../../core/utils/app_utils.dart';

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
    final responsive = context.responsive;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: responsive.iconXXLarge,
            color: Colors.grey.shade400,
          ),
          VSpace.large,
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge(context),
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
