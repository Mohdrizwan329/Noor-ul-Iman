import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Position? _currentPosition;
  String? _currentCity;
  String? _currentCountry;

  Position? get currentPosition => _currentPosition;
  String? get currentCity => _currentCity;
  String? get currentCountry => _currentCountry;

  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('LocationService: Location services are disabled');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('LocationService: Permission denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('LocationService: Permission denied forever');
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await checkPermission();
      if (!hasPermission) {
        return null;
      }

      debugPrint('LocationService: Fetching fresh location with high accuracy...');

      // Get current position with high accuracy
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () async {
          // If timeout, try to get last known position
          debugPrint('LocationService: Timeout, trying last known position');
          final lastKnown = await Geolocator.getLastKnownPosition();
          if (lastKnown != null) {
            return lastKnown;
          }
          throw Exception('Location timeout');
        },
      );

      debugPrint('LocationService: Got position - Lat: ${_currentPosition?.latitude}, Lon: ${_currentPosition?.longitude}');
      return _currentPosition;
    } catch (e) {
      debugPrint('LocationService: Error getting location - $e');
      // Try last known as fallback
      try {
        final lastKnown = await Geolocator.getLastKnownPosition();
        if (lastKnown != null) {
          debugPrint('LocationService: Using last known position - Lat: ${lastKnown.latitude}, Lon: ${lastKnown.longitude}');
          _currentPosition = lastKnown;
          return lastKnown;
        }
      } catch (_) {}
      return null;
    }
  }

  /// Force refresh location using position stream - gets truly fresh GPS data
  Future<Position?> refreshLocation() async {
    try {
      bool hasPermission = await checkPermission();
      if (!hasPermission) {
        return null;
      }

      // Clear cached position first
      _currentPosition = null;

      debugPrint('LocationService: Force refreshing location using position stream...');

      // Use position stream to get fresh GPS coordinates
      // This bypasses any cached positions
      Position? freshPosition;

      try {
        // Get fresh position from stream (truly fresh GPS data)
        freshPosition = await Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            distanceFilter: 0,
          ),
        ).first.timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            debugPrint('LocationService: Stream timeout, falling back to getCurrentPosition');
            throw Exception('Stream timeout');
          },
        );

        debugPrint('LocationService: Stream position - Lat: ${freshPosition.latitude}, Lon: ${freshPosition.longitude}, Accuracy: ${freshPosition.accuracy}m');
      } catch (e) {
        debugPrint('LocationService: Stream failed ($e), trying getCurrentPosition...');

        // Fallback to getCurrentPosition with best accuracy
        freshPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('getCurrentPosition timeout');
          },
        );

        debugPrint('LocationService: getCurrentPosition - Lat: ${freshPosition.latitude}, Lon: ${freshPosition.longitude}, Accuracy: ${freshPosition.accuracy}m');
      }

      _currentPosition = freshPosition;
      debugPrint('LocationService: Final fresh position - Lat: ${freshPosition.latitude}, Lon: ${freshPosition.longitude}, Accuracy: ${freshPosition.accuracy}m');
      return freshPosition;
    } catch (e) {
      debugPrint('LocationService: Error refreshing location - $e');
      return null;
    }
  }

  Future<Position?> getLastKnownLocation() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  void updateCity(String city, String country) {
    _currentCity = city;
    _currentCountry = country;
  }
}
