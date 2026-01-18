import 'package:flutter/material.dart';
import '../constants/app_dimens.dart';

/// Pre-built vertical spacing widgets for consistency
class VSpace {
  VSpace._();

  static const small = SizedBox(height: AppDimens.spacingSmall);
  static const medium = SizedBox(height: AppDimens.spacingMedium);
  static const large = SizedBox(height: AppDimens.spacingLarge);
  static const xLarge = SizedBox(height: AppDimens.spacingXLarge);
  static const xxLarge = SizedBox(height: AppDimens.spacingXXLarge);
}

/// Pre-built horizontal spacing widgets for consistency
class HSpace {
  HSpace._();

  static const small = SizedBox(width: AppDimens.spacingSmall);
  static const medium = SizedBox(width: AppDimens.spacingMedium);
  static const large = SizedBox(width: AppDimens.spacingLarge);
  static const xLarge = SizedBox(width: AppDimens.spacingXLarge);
}
