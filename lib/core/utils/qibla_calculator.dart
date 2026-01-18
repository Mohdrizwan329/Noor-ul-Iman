import 'dart:math';

class QiblaCalculator {
  // Kaaba coordinates
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  /// Calculate Qibla direction from given coordinates
  /// Returns angle in degrees from North (clockwise)
  static double getQiblaDirection(double latitude, double longitude) {
    // Convert to radians
    final lat1 = _toRadians(latitude);
    final lon1 = _toRadians(longitude);
    final lat2 = _toRadians(kaabaLatitude);
    final lon2 = _toRadians(kaabaLongitude);

    // Calculate bearing
    final dLon = lon2 - lon1;

    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    var bearing = atan2(y, x);
    bearing = _toDegrees(bearing);

    // Normalize to 0-360
    bearing = (bearing + 360) % 360;

    return bearing;
  }

  /// Calculate distance to Kaaba in kilometers
  static double getDistanceToKaaba(double latitude, double longitude) {
    const earthRadius = 6371.0; // km

    final lat1 = _toRadians(latitude);
    final lon1 = _toRadians(longitude);
    final lat2 = _toRadians(kaabaLatitude);
    final lon2 = _toRadians(kaabaLongitude);

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double _toDegrees(double radians) {
    return radians * 180 / pi;
  }

  /// Format distance in a readable way
  static String formatDistance(double distanceInKm) {
    if (distanceInKm >= 1000) {
      return '${(distanceInKm / 1000).toStringAsFixed(0)}k km';
    } else if (distanceInKm >= 100) {
      return '${distanceInKm.toStringAsFixed(0)} km';
    } else {
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }
}
