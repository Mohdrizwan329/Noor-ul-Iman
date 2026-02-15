import 'package:flutter/material.dart';

class AdNavigator {
  /// Push a route (interstitial ads removed)
  static Future<T?> push<T>(BuildContext context, Widget screen) async {
    if (!context.mounted) return null;

    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push replacement route
  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget screen) async {
    if (!context.mounted) return null;

    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push and remove until
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget screen,
    bool Function(Route<dynamic>) predicate,
  ) async {
    if (!context.mounted) return null;

    return Navigator.pushAndRemoveUntil<T>(
      context,
      MaterialPageRoute(builder: (context) => screen),
      predicate,
    );
  }
}
