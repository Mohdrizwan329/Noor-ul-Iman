import 'package:flutter/material.dart';

/// Extension methods for theme-related utilities
extension ThemeExtensions on BuildContext {
  /// Check if the current theme is dark mode
  ///
  /// Usage:
  /// ```dart
  /// final isDark = context.isDarkMode;
  /// ```
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Get the current theme data
  ThemeData get theme => Theme.of(this);

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
