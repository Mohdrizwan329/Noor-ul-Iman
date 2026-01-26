import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Service to check geographic restrictions
class GeoRestrictionService {
  /// Check if location is in restricted region
  static bool isRestrictedLocation(double latitude, double longitude) {
    // Israel geographic boundaries
    // Latitude range: approximately 29.5° to 33.3° N
    // Longitude range: approximately 34.2° to 35.9° E
    const double israelMinLat = 29.5;
    const double israelMaxLat = 33.3;
    const double israelMinLon = 34.2;
    const double israelMaxLon = 35.9;

    // Check if coordinates fall within Israel's boundaries
    if (latitude >= israelMinLat &&
        latitude <= israelMaxLat &&
        longitude >= israelMinLon &&
        longitude <= israelMaxLon) {
      return true;
    }

    return false;
  }

  /// Check current location and return restriction status
  static Future<bool> checkCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return isRestrictedLocation(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error checking location: $e');
      // If we can't determine location, allow the app to run
      return false;
    }
  }

  /// Show restriction dialog
  static void showRestrictionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(
          'Service Not Available',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: const Text(
          'This application is not available in your region.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Close the app
              Navigator.of(context).pop();
              // Force exit
              Future.delayed(const Duration(milliseconds: 500), () {
                // This will minimize the app on Android
                // On iOS, apps cannot programmatically exit
              });
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
