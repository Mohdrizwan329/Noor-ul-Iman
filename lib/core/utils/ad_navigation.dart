import 'package:flutter/material.dart';
import '../services/ad_service.dart';

class AdNavigator {
  /// Push a route and show interstitial ad if conditions met
  static Future<T?> push<T>(BuildContext context, Widget screen) async {
    // Try to show interstitial ad (shows every 3 navigations)
    await AdService.showInterstitialAd();

    if (!context.mounted) return null;

    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push replacement route with interstitial ad
  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget screen) async {
    await AdService.showInterstitialAd();

    if (!context.mounted) return null;

    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push and remove until with interstitial ad
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen,
    bool Function(Route<dynamic>) predicate,
  ) async {
    await AdService.showInterstitialAd();

    if (!context.mounted) return null;

    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      predicate,
    );
  }
}
