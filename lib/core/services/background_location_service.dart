import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_service.dart';
import 'prayer_time_service.dart';
import 'geo_restriction_service.dart';
import 'azan_background_service.dart';
import '../../providers/adhan_provider.dart';

class BackgroundLocationService {
  static final BackgroundLocationService _instance =
      BackgroundLocationService._internal();
  factory BackgroundLocationService() => _instance;
  BackgroundLocationService._internal();

  final LocationService _locationService = LocationService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();

  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _lastKnownPosition;
  Timer? _midnightTimer;

  // Minimum distance change to trigger update (5 km)
  static const double _minDistanceForUpdate = 5000; // meters

  /// Start background location tracking
  Future<void> startLocationTracking() async {
    // Check if we have permission
    bool hasPermission = await _locationService.checkPermission();
    if (!hasPermission) {
      return;
    }

    // Load last known position
    await _loadLastPosition();

    // Start listening to location changes
    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update every 100 meters movement
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _handleLocationUpdate(position);
      },
      onError: (error) {
        debugPrint('Location tracking error: $error');
      },
    );

    // Schedule midnight refresh
    _scheduleMidnightRefresh();
  }

  /// Stop background location tracking
  Future<void> stopLocationTracking() async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _midnightTimer?.cancel();
    _midnightTimer = null;
  }

  /// Handle location updates
  Future<void> _handleLocationUpdate(Position newPosition) async {
    // Check if location is in restricted region
    final isRestricted = GeoRestrictionService.isRestrictedLocation(
      newPosition.latitude,
      newPosition.longitude,
    );

    if (isRestricted) {
      debugPrint('User entered restricted region. Stopping location tracking.');
      await stopLocationTracking();
      return;
    }

    // If we have a last known position, check if we've moved significantly
    if (_lastKnownPosition != null) {
      final distance = Geolocator.distanceBetween(
        _lastKnownPosition!.latitude,
        _lastKnownPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // Only update if moved more than minimum distance
      if (distance < _minDistanceForUpdate) {
        return;
      }

      debugPrint(
        'Location changed by ${(distance / 1000).toStringAsFixed(2)} km. Updating prayer times...',
      );
    }

    // Update prayer times for new location
    await _updatePrayerTimes(newPosition);

    // Save new position
    _lastKnownPosition = newPosition;
    await _saveLastPosition(newPosition);
  }

  /// Update prayer times for current location
  Future<void> _updatePrayerTimes(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final calculationMethod = prefs.getInt('calculation_method') ?? 1;

      // Fetch new prayer times
      final prayerTimes = await _prayerTimeService.getPrayerTimes(
        latitude: position.latitude,
        longitude: position.longitude,
        method: calculationMethod,
      );

      if (prayerTimes != null) {
        // Use the existing AdhanProvider instance from the static reference
        // instead of creating a new throwaway instance
        final existingProvider = AdhanProvider.instance;
        if (existingProvider != null) {
          final city = _locationService.currentCity ?? '';
          existingProvider.updateLocation(
            city: city,
            latitude: position.latitude,
            longitude: position.longitude,
          );
          await existingProvider.schedulePrayerNotifications(prayerTimes);
        } else {
          // Fallback: at minimum schedule native Azan alarms directly
          await AzanBackgroundService.scheduleAzanAlarms(prayerTimes);
        }

        debugPrint('Prayer times updated for new location');
        debugPrint('City: ${_locationService.currentCity}, Lat: ${position.latitude}, Lon: ${position.longitude}');
      }
    } catch (e) {
      debugPrint('Error updating prayer times: $e');
    }
  }

  /// Schedule midnight refresh for prayer times
  void _scheduleMidnightRefresh() {
    // Cancel existing timer
    _midnightTimer?.cancel();

    // Calculate time until next midnight
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final timeUntilMidnight = tomorrow.difference(now);

    // Schedule midnight update
    _midnightTimer = Timer(timeUntilMidnight, () async {
      debugPrint('Midnight refresh triggered');

      // Get current position
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        await _updatePrayerTimes(position);
      }

      // Schedule next midnight refresh
      _scheduleMidnightRefresh();
    });

    debugPrint(
      'Next midnight refresh scheduled in ${timeUntilMidnight.inHours} hours',
    );
  }

  /// Load last known position from storage
  Future<void> _loadLastPosition() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lat = prefs.getDouble('last_latitude');
      final lon = prefs.getDouble('last_longitude');

      if (lat != null && lon != null) {
        _lastKnownPosition = Position(
          latitude: lat,
          longitude: lon,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }
    } catch (e) {
      debugPrint('Error loading last position: $e');
    }
  }

  /// Save last known position to storage
  Future<void> _saveLastPosition(Position position) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('last_latitude', position.latitude);
      await prefs.setDouble('last_longitude', position.longitude);
    } catch (e) {
      debugPrint('Error saving last position: $e');
    }
  }

  /// Manually trigger prayer time update
  Future<void> refreshPrayerTimes() async {
    final position = await _locationService.getCurrentLocation();
    if (position != null) {
      await _updatePrayerTimes(position);
    }
  }
}
