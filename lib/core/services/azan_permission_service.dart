import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service to handle all permissions required for background Azan functionality
/// Handles: Exact Alarm (Android 12+), Notifications (Android 13+), Battery Optimization
class AzanPermissionService {
  static const MethodChannel _permissionChannel =
      MethodChannel('com.nooruliman.app/permissions');
  static const MethodChannel _batteryChannel =
      MethodChannel('com.nooruliman.app/battery');

  /// Check if all required permissions are granted for background Azan
  static Future<AzanPermissionStatus> checkAllPermissions() async {
    if (!Platform.isAndroid) {
      return AzanPermissionStatus(
        exactAlarm: true,
        notification: true,
        batteryOptimization: true,
        androidVersion: 0,
      );
    }

    try {
      final result =
          await _permissionChannel.invokeMethod('getAllPermissionStatus');
      return AzanPermissionStatus(
        exactAlarm: result['exactAlarm'] ?? true,
        notification: result['notification'] ?? true,
        batteryOptimization: result['batteryOptimization'] ?? false,
        androidVersion: result['androidVersion'] ?? 0,
      );
    } catch (e) {
      debugPrint('AzanPermissionService: Error checking permissions: $e');
      return AzanPermissionStatus(
        exactAlarm: true,
        notification: true,
        batteryOptimization: false,
        androidVersion: 0,
      );
    }
  }

  /// Check if exact alarm permission is granted (Android 12+)
  static Future<bool> canScheduleExactAlarms() async {
    if (!Platform.isAndroid) return true;

    try {
      final result =
          await _permissionChannel.invokeMethod('canScheduleExactAlarms');
      return result ?? true;
    } catch (e) {
      debugPrint('AzanPermissionService: Error checking exact alarm: $e');
      return true;
    }
  }

  /// Request exact alarm permission (opens system settings on Android 12+)
  static Future<void> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) return;

    try {
      await _permissionChannel.invokeMethod('requestExactAlarmPermission');
      debugPrint('AzanPermissionService: Requested exact alarm permission');
    } catch (e) {
      debugPrint('AzanPermissionService: Error requesting exact alarm: $e');
    }
  }

  /// Check if notification permission is granted (Android 13+)
  static Future<bool> hasNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final result =
          await _permissionChannel.invokeMethod('hasNotificationPermission');
      return result ?? true;
    } catch (e) {
      debugPrint('AzanPermissionService: Error checking notification: $e');
      return true;
    }
  }

  /// Request notification permission (Android 13+)
  static Future<void> requestNotificationPermission() async {
    if (!Platform.isAndroid) return;

    try {
      await _permissionChannel.invokeMethod('requestNotificationPermission');
      debugPrint('AzanPermissionService: Requested notification permission');
    } catch (e) {
      debugPrint('AzanPermissionService: Error requesting notification: $e');
    }
  }

  /// Check if battery optimization is disabled for this app
  static Future<bool> isBatteryOptimizationDisabled() async {
    if (!Platform.isAndroid) return true;

    try {
      final result =
          await _batteryChannel.invokeMethod('isBatteryOptimizationDisabled');
      return result ?? false;
    } catch (e) {
      debugPrint('AzanPermissionService: Error checking battery: $e');
      return false;
    }
  }

  /// Request to disable battery optimization (shows system dialog)
  static Future<void> requestDisableBatteryOptimization() async {
    if (!Platform.isAndroid) return;

    try {
      await _batteryChannel.invokeMethod('requestDisableBatteryOptimization');
      debugPrint('AzanPermissionService: Requested battery optimization disable');
    } catch (e) {
      debugPrint('AzanPermissionService: Error requesting battery: $e');
    }
  }

  /// Open app settings page
  static Future<void> openAppSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await _permissionChannel.invokeMethod('openAppSettings');
    } catch (e) {
      debugPrint('AzanPermissionService: Error opening app settings: $e');
    }
  }

  /// Open alarm settings page (Android 12+)
  static Future<void> openAlarmSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await _permissionChannel.invokeMethod('openAlarmSettings');
    } catch (e) {
      debugPrint('AzanPermissionService: Error opening alarm settings: $e');
    }
  }

  /// Open autostart settings (for Chinese phones like Xiaomi, Oppo, Vivo, Huawei)
  static Future<void> openAutoStartSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await _permissionChannel.invokeMethod('openAutoStartSettings');
    } catch (e) {
      debugPrint('AzanPermissionService: Error opening autostart settings: $e');
    }
  }

  /// Request all missing permissions for background Azan
  /// Returns true if all permissions are granted after requests
  static Future<bool> requestAllPermissions() async {
    if (!Platform.isAndroid) return true;

    final status = await checkAllPermissions();

    // Request notification permission first (runtime permission)
    if (!status.notification && status.androidVersion >= 33) {
      await requestNotificationPermission();
      // Wait a bit for user to respond
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Request exact alarm permission (opens settings)
    if (!status.exactAlarm && status.androidVersion >= 31) {
      await requestExactAlarmPermission();
      return false; // User needs to grant in settings
    }

    // Request battery optimization disable
    if (!status.batteryOptimization) {
      await requestDisableBatteryOptimization();
      return false; // User needs to confirm
    }

    // Re-check permissions
    final newStatus = await checkAllPermissions();
    return newStatus.allGranted;
  }
}

/// Status of all permissions required for background Azan
class AzanPermissionStatus {
  final bool exactAlarm;
  final bool notification;
  final bool batteryOptimization;
  final int androidVersion;

  AzanPermissionStatus({
    required this.exactAlarm,
    required this.notification,
    required this.batteryOptimization,
    required this.androidVersion,
  });

  /// Check if all permissions are granted
  bool get allGranted => exactAlarm && notification && batteryOptimization;

  /// Check if any permission is missing
  bool get hasMissingPermissions => !allGranted;

  /// Get list of missing permissions for display
  List<String> get missingPermissions {
    final missing = <String>[];
    if (!exactAlarm && androidVersion >= 31) {
      missing.add('Exact Alarm');
    }
    if (!notification && androidVersion >= 33) {
      missing.add('Notifications');
    }
    if (!batteryOptimization) {
      missing.add('Battery Optimization');
    }
    return missing;
  }

  @override
  String toString() {
    return 'AzanPermissionStatus(exactAlarm: $exactAlarm, notification: $notification, '
        'batteryOptimization: $batteryOptimization, androidVersion: $androidVersion)';
  }
}
