import 'package:flutter/material.dart';

/// Base dimension constants for responsive scaling
/// These values are used as BASE values and will be scaled by ResponsiveUtils
class AppDimens {
  AppDimens._();

  // Responsive breakpoints
  static const double breakpointSmall = 360.0;
  static const double breakpointMedium = 600.0;
  static const double breakpointLarge = 900.0;
  static const double breakpointXLarge = 1200.0;

  // Base Border Radius (will be scaled responsively)
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 18.0;
  static const double borderRadiusXLarge = 20.0;

  // Base Padding (will be scaled responsively)
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 20.0;
  static const double paddingXLarge = 24.0;
  static const double paddingXXLarge = 32.0;

  // Base Spacing for SizedBox (will be scaled responsively)
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;
  static const double spacingHuge = 32.0;

  // Base Icon Sizes (will be scaled responsively)
  static const double iconSizeXSmall = 16.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 28.0;
  static const double iconSizeXLarge = 32.0;
  static const double iconSizeXXLarge = 48.0;
  static const double iconSizeHuge = 80.0;

  // Card/Container Sizes
  static const double cardElevation = 2.0;
  static const double cardElevationHover = 4.0;
  static const double borderWidth = 1.5;

  // Base Font Sizes (will be scaled responsively)
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeNormal = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeHeading = 26.0;
  static const double fontSizeTitle = 28.0;
  static const double fontSizeDisplay = 32.0;
  static const double fontSizeHero = 48.0;

  // Badge/Number Display Sizes (will be scaled responsively)
  static const double badgeSize = 40.0;
  static const double badgeSizeLarge = 60.0;

  // Border Radius for Special Cases
  static const double borderRadiusCircular = 15.0;

  // Opacity Values (non-responsive)
  static const double opacityLight = 0.1;
  static const double opacityMedium = 0.2;
  static const double opacityShadow = 0.08;

  // Grid Settings
  static const int gridColumnCountSmallPhone = 2;
  static const int gridColumnCountPhone = 3;
  static const int gridColumnCountPhoneLandscape = 4;
  static const int gridColumnCountTablet = 4;
  static const int gridColumnCountTabletLandscape = 5;
  static const int gridColumnCountDesktop = 6;

  // Content Max Width
  static const double maxContentWidthTablet = 720.0;
  static const double maxContentWidthDesktop = 960.0;

  // Helper method to get responsive EdgeInsets
  static EdgeInsets getPadding(BuildContext context, {
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = _getScaleFactor(screenWidth);

    if (all > 0) {
      return EdgeInsets.all(all * scaleFactor);
    }
    if (horizontal > 0 || vertical > 0) {
      return EdgeInsets.symmetric(
        horizontal: horizontal * scaleFactor,
        vertical: vertical * scaleFactor,
      );
    }
    return EdgeInsets.only(
      left: left * scaleFactor,
      top: top * scaleFactor,
      right: right * scaleFactor,
      bottom: bottom * scaleFactor,
    );
  }

  // Helper method to get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    return baseSize * _getScaleFactor(screenWidth);
  }

  // Helper method to get responsive spacing
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    return baseSpacing * _getScaleFactor(screenWidth);
  }

  // Private helper to calculate scale factor
  static double _getScaleFactor(double screenWidth) {
    if (screenWidth < breakpointSmall) return 0.85;
    if (screenWidth < breakpointMedium) return 1.0;
    if (screenWidth < breakpointLarge) return 1.15;
    if (screenWidth < breakpointXLarge) return 1.3;
    return 1.5;
  }
}
