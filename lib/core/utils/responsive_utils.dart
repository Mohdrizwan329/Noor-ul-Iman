import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
/// Provides helpers for responsive font sizes, spacing, and layouts
class ResponsiveUtils {
  final BuildContext context;
  late final MediaQueryData _mediaQuery;
  late final double _screenWidth;
  late final double _screenHeight;
  late final Orientation _orientation;

  ResponsiveUtils(this.context) {
    _mediaQuery = MediaQuery.of(context);
    _screenWidth = _mediaQuery.size.width;
    _screenHeight = _mediaQuery.size.height;
    _orientation = _mediaQuery.orientation;
  }

  // Screen dimensions
  double get screenWidth => _screenWidth;
  double get screenHeight => _screenHeight;
  Orientation get orientation => _orientation;

  // Device type detection
  bool get isSmallPhone => _screenWidth < 360;
  bool get isPhone => _screenWidth < 600;
  bool get isTablet => _screenWidth >= 600 && _screenWidth < 900;
  bool get isDesktop => _screenWidth >= 900;
  bool get isLandscape => _orientation == Orientation.landscape;
  bool get isPortrait => _orientation == Orientation.portrait;

  // Breakpoints
  static const double breakpointSmall = 360;
  static const double breakpointMedium = 600;
  static const double breakpointLarge = 900;
  static const double breakpointXLarge = 1200;

  // Scale factors based on screen width
  double get scaleFactor {
    if (_screenWidth < breakpointSmall) return 0.85;
    if (_screenWidth < breakpointMedium) return 1.0;
    if (_screenWidth < breakpointLarge) return 1.15;
    if (_screenWidth < breakpointXLarge) return 1.3;
    return 1.5;
  }

  // Responsive font sizes
  double fontSize(double baseSize) {
    return baseSize * scaleFactor;
  }

  // Predefined text sizes
  double get textXSmall => fontSize(10);
  double get textSmall => fontSize(12);
  double get textMedium => fontSize(14);
  double get textRegular => fontSize(16);
  double get textLarge => fontSize(18);
  double get textXLarge => fontSize(20);
  double get textXXLarge => fontSize(24);
  double get textHeading => fontSize(26);
  double get textTitle => fontSize(28);
  double get textDisplay => fontSize(32);
  double get textHero => fontSize(48);

  // Responsive spacing
  double spacing(double baseSpacing) {
    return baseSpacing * scaleFactor;
  }

  // Predefined spacings
  double get spaceXSmall => spacing(4);
  double get spaceSmall => spacing(8);
  double get spaceMedium => spacing(12);
  double get spaceRegular => spacing(16);
  double get spaceLarge => spacing(20);
  double get spaceXLarge => spacing(24);
  double get spaceXXLarge => spacing(32);
  double get spaceHuge => spacing(40);

  // Responsive padding
  EdgeInsets paddingAll(double value) {
    return EdgeInsets.all(spacing(value));
  }

  EdgeInsets paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: spacing(horizontal),
      vertical: spacing(vertical),
    );
  }

  EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: spacing(left),
      top: spacing(top),
      right: spacing(right),
      bottom: spacing(bottom),
    );
  }

  // Predefined paddings
  EdgeInsets get paddingXSmall => paddingAll(4);
  EdgeInsets get paddingSmall => paddingAll(8);
  EdgeInsets get paddingMedium => paddingAll(12);
  EdgeInsets get paddingRegular => paddingAll(16);
  EdgeInsets get paddingLarge => paddingAll(20);
  EdgeInsets get paddingXLarge => paddingAll(24);

  // Responsive icon sizes
  double iconSize(double baseSize) {
    return baseSize * scaleFactor;
  }

  double get iconXSmall => iconSize(16);
  double get iconSmall => iconSize(20);
  double get iconMedium => iconSize(24);
  double get iconLarge => iconSize(28);
  double get iconXLarge => iconSize(32);
  double get iconXXLarge => iconSize(48);
  double get iconHuge => iconSize(80);

  // Grid column count based on screen size
  int get gridColumnCount {
    if (isSmallPhone) return 2;
    if (isPhone && isPortrait) return 3;
    if (isPhone && isLandscape) return 4;
    if (isTablet && isPortrait) return 4;
    if (isTablet && isLandscape) return 5;
    return 6;
  }

  // Responsive grid spacing
  double get gridSpacing {
    if (isSmallPhone) return spacing(8);
    if (isPhone) return spacing(12);
    if (isTablet) return spacing(16);
    return spacing(20);
  }

  // Responsive border radius
  double borderRadius(double baseRadius) {
    return baseRadius * scaleFactor;
  }

  double get radiusSmall => borderRadius(4);
  double get radiusMedium => borderRadius(8);
  double get radiusLarge => borderRadius(12);
  double get radiusXLarge => borderRadius(16);
  double get radiusXXLarge => borderRadius(20);

  // Responsive container constraints
  double get maxContentWidth {
    if (isPhone) return _screenWidth;
    if (isTablet) return 720;
    return 960;
  }

  // Calculate responsive size based on percentage of screen
  double widthPercent(double percent) {
    return _screenWidth * (percent / 100);
  }

  double heightPercent(double percent) {
    return _screenHeight * (percent / 100);
  }

  // Adaptive layout helpers
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  // SizedBox helpers
  SizedBox get vSpaceXSmall => SizedBox(height: spaceXSmall);
  SizedBox get vSpaceSmall => SizedBox(height: spaceSmall);
  SizedBox get vSpaceMedium => SizedBox(height: spaceMedium);
  SizedBox get vSpaceRegular => SizedBox(height: spaceRegular);
  SizedBox get vSpaceLarge => SizedBox(height: spaceLarge);
  SizedBox get vSpaceXLarge => SizedBox(height: spaceXLarge);
  SizedBox get vSpaceXXLarge => SizedBox(height: spaceXXLarge);

  SizedBox get hSpaceXSmall => SizedBox(width: spaceXSmall);
  SizedBox get hSpaceSmall => SizedBox(width: spaceSmall);
  SizedBox get hSpaceMedium => SizedBox(width: spaceMedium);
  SizedBox get hSpaceRegular => SizedBox(width: spaceRegular);
  SizedBox get hSpaceLarge => SizedBox(width: spaceLarge);
  SizedBox get hSpaceXLarge => SizedBox(width: spaceXLarge);
  SizedBox get hSpaceXXLarge => SizedBox(width: spaceXXLarge);

  // Fixed (non-responsive) values for maintaining exact UI dimensions
  // Use these when you want consistent sizes across all screen sizes

  // Fixed text sizes
  double get fixedTextXSmall => 10;
  double get fixedTextSmall => 12;
  double get fixedTextMedium => 14;
  double get fixedTextRegular => 16;
  double get fixedTextLarge => 18;
  double get fixedTextXLarge => 20;
  double get fixedTextXXLarge => 24;
  double get fixedTextHeading => 26;
  double get fixedTextTitle => 28;

  // Fixed icon sizes
  double get fixedIconXSmall => 16.0;
  double get fixedIconSmall => 20.0;
  double get fixedIconMedium => 24.0;
  double get fixedIconLarge => 28.0;
  double get fixedIconXLarge => 60.0;  // For header cards
  double get fixedIconXXLarge => 48.0;
  double get fixedIconHuge => 100.0;   // For logos

  // Fixed spacing
  double get fixedSpaceXSmall => 4.0;
  double get fixedSpaceSmall => 8.0;
  double get fixedSpaceMedium => 12.0;
  double get fixedSpaceRegular => 16.0;
  double get fixedSpaceLarge => 20.0;
  double get fixedSpaceXLarge => 24.0;
  double get fixedSpaceXXLarge => 32.0;

  // Fixed border radius
  double get fixedRadiusSmall => 4.0;
  double get fixedRadiusMedium => 15.0;  // For header cards
  double get fixedRadiusLarge => 12.0;
  double get fixedRadiusXLarge => 16.0;
  double get fixedRadiusCard => 24.0;    // For main containers

  // Fixed padding helpers
  EdgeInsets fixedPaddingAll(double value) => EdgeInsets.all(value);

  EdgeInsets fixedPaddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }
}

/// Extension to easily access ResponsiveUtils from BuildContext
extension ResponsiveExtension on BuildContext {
  ResponsiveUtils get responsive => ResponsiveUtils(this);
}

/// Responsive Text widget that scales automatically
class ResponsiveText extends StatelessWidget {
  final String text;
  final double baseFontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final double? height;

  const ResponsiveText(
    this.text, {
    super.key,
    this.baseFontSize = 16,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Text(
      text,
      style: TextStyle(
        fontSize: responsive.fontSize(baseFontSize),
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Responsive Container with adaptive sizing
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Container(
      width: width != null ? responsive.spacing(width!) : null,
      height: height != null ? responsive.spacing(height!) : null,
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      alignment: alignment,
      child: child,
    );
  }
}
