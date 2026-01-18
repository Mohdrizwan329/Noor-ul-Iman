import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/spacing.dart';

/// Loading overlay widget that shows a circular progress indicator.
/// Can be used to show loading state over any content.
///
/// Example usage:
/// ```dart
/// LoadingOverlay(
///   isLoading: _isLoading,
///   child: YourContentWidget(),
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? loadingText;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  if (loadingText != null) ...[
                    VSpace.large,
                    Text(
                      loadingText!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
