import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../data/models/prayer_time_model.dart';

/// Background service for playing Azan at prayer times
/// Uses native Android AlarmManager + Foreground Service for reliable background execution
class AzanBackgroundService {
  static const String _prefKeyAzanEnabled = 'azan_sound';
  static const MethodChannel _channel = MethodChannel('com.nooruliman.app/azan');

  // Alarm IDs for each prayer
  static const int _fajrAlarmId = 100;
  static const int _dhuhrAlarmId = 101;
  static const int _asrAlarmId = 102;
  static const int _maghribAlarmId = 103;
  static const int _ishaAlarmId = 104;

  // Adhan URLs (using Al Adhan CDN - reliable)
  static const Map<String, String> adhanUrls = {
    'makkah': 'https://cdn.aladhan.com/audio/adhans/a1.mp3',
    'madinah': 'https://cdn.aladhan.com/audio/adhans/a2.mp3',
    'alaqsa': 'https://cdn.aladhan.com/audio/adhans/a3.mp3',
    'mishary': 'https://cdn.aladhan.com/audio/adhans/a4.mp3',
    'abdul_basit': 'https://cdn.aladhan.com/audio/adhans/a9.mp3',
  };

  /// Initialize the service and pre-cache selected azan audio
  static Future<void> initialize() async {
    debugPrint('AzanBackgroundService initialized (using native Android service)');
    // Pre-cache the selected azan audio in background (don't block app startup)
    cacheSelectedAzan().then((_) {
      debugPrint('Azan audio pre-cached for offline playback');
    }).catchError((e) {
      debugPrint('Azan cache failed (will retry later): $e');
      return null;
    });
  }

  /// Pre-cache the currently selected azan audio file for offline playback
  static Future<String?> cacheSelectedAzan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedAzan = prefs.getString('selected_adhan') ?? 'makkah';
      final azanUrl = adhanUrls[selectedAzan] ?? adhanUrls['makkah']!;

      // Check if already cached
      final cachedPath = await _getCachedAzanPath(selectedAzan);
      if (cachedPath != null) {
        debugPrint('Azan already cached: $cachedPath');
        await prefs.setString('cached_azan_path', cachedPath);
        return cachedPath;
      }

      // Download and cache
      debugPrint('Downloading azan audio for offline cache: $selectedAzan');
      final response = await http.get(Uri.parse(azanUrl)).timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final azanDir = Directory('${dir.path}/azan_cache');
        if (!await azanDir.exists()) {
          await azanDir.create(recursive: true);
        }

        final file = File('${azanDir.path}/$selectedAzan.mp3');
        await file.writeAsBytes(response.bodyBytes);

        final path = file.path;
        await prefs.setString('cached_azan_path', path);
        debugPrint('Azan cached successfully: $path');
        return path;
      } else {
        debugPrint('Failed to download azan: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error caching azan audio: $e');
      return null;
    }
  }

  /// Get cached azan file path if it exists
  static Future<String?> _getCachedAzanPath(String azanName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/azan_cache/$azanName.mp3');
      if (await file.exists() && await file.length() > 0) {
        return file.path;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Cache a specific azan by name (called when user changes azan selection)
  static Future<void> cacheAzan(String azanName) async {
    final azanUrl = adhanUrls[azanName];
    if (azanUrl == null) return;

    try {
      final response = await http.get(Uri.parse(azanUrl)).timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final azanDir = Directory('${dir.path}/azan_cache');
        if (!await azanDir.exists()) {
          await azanDir.create(recursive: true);
        }

        final file = File('${azanDir.path}/$azanName.mp3');
        await file.writeAsBytes(response.bodyBytes);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_azan_path', file.path);
        debugPrint('Azan "$azanName" cached: ${file.path}');
      }
    } catch (e) {
      debugPrint('Error caching azan "$azanName": $e');
    }
  }

  /// Schedule Azan alarms for all prayer times using native Android AlarmManager
  static Future<void> scheduleAzanAlarms(PrayerTimeModel prayerTimes) async {
    // Only works on Android
    if (!Platform.isAndroid) {
      debugPrint('Azan background service is only supported on Android');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final azanEnabled = prefs.getBool(_prefKeyAzanEnabled) ?? true;

    if (!azanEnabled) {
      await cancelAllAlarms();
      debugPrint('Azan sound disabled, skipping alarm scheduling');
      return;
    }

    final selectedAzan = prefs.getString('selected_adhan') ?? 'makkah';
    final azanUrl = adhanUrls[selectedAzan] ?? adhanUrls['makkah']!;
    final cachedPath = prefs.getString('cached_azan_path') ?? '';

    // Save prayer times for recovery after device reboot
    await prefs.setString('last_fajr_time', prayerTimes.fajr);
    await prefs.setString('last_dhuhr_time', prayerTimes.dhuhr);
    await prefs.setString('last_asr_time', prayerTimes.asr);
    await prefs.setString('last_maghrib_time', prayerTimes.maghrib);
    await prefs.setString('last_isha_time', prayerTimes.isha);
    debugPrint('Prayer times saved for boot recovery');

    // Schedule each prayer's Azan, respecting per-prayer toggles
    final prayers = {
      'Fajr': {'id': _fajrAlarmId, 'time': prayerTimes.fajr},
      'Dhuhr': {'id': _dhuhrAlarmId, 'time': prayerTimes.dhuhr},
      'Asr': {'id': _asrAlarmId, 'time': prayerTimes.asr},
      'Maghrib': {'id': _maghribAlarmId, 'time': prayerTimes.maghrib},
      'Isha': {'id': _ishaAlarmId, 'time': prayerTimes.isha},
    };

    for (final entry in prayers.entries) {
      final prayerName = entry.key;
      final alarmId = entry.value['id'] as int;
      final time = entry.value['time'] as String;
      final isEnabled = prefs.getBool('notify_$prayerName') ?? true;

      if (isEnabled) {
        await _scheduleAzanAlarm(alarmId, time, prayerName, azanUrl, cachedPath);
      } else {
        // Cancel alarm for disabled prayer
        await cancelAlarm(alarmId);
        debugPrint('$prayerName azan alarm cancelled (notification disabled)');
      }
    }

    debugPrint('All Azan alarms scheduled using native Android service');
  }

  /// Schedule a single Azan alarm using native Android AlarmManager
  static Future<void> _scheduleAzanAlarm(
    int alarmId,
    String time,
    String prayerName,
    String azanUrl,
    String cachedPath,
  ) async {
    final parsedTime = _parseTimeString(time);
    if (parsedTime == null) {
      debugPrint('Failed to parse time for $prayerName: $time');
      return;
    }

    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsedTime['hour']!,
      parsedTime['minute']!,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    try {
      await _channel.invokeMethod('scheduleAzanAlarm', {
        'alarmId': alarmId,
        'triggerTimeMillis': scheduledTime.millisecondsSinceEpoch,
        'url': azanUrl,
        'prayerName': prayerName,
        'cachedPath': cachedPath,
      });

      debugPrint('Scheduled $prayerName Azan for $scheduledTime (ID: $alarmId)');
    } catch (e) {
      debugPrint('Error scheduling $prayerName Azan alarm: $e');
    }
  }

  /// Cancel all Azan alarms
  static Future<void> cancelAllAlarms() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('cancelAllAzanAlarms');
      debugPrint('All Azan alarms cancelled');
    } catch (e) {
      debugPrint('Error cancelling Azan alarms: $e');
    }
  }

  /// Cancel a specific Azan alarm
  static Future<void> cancelAlarm(int alarmId) async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('cancelAzanAlarm', {'alarmId': alarmId});
      debugPrint('Azan alarm $alarmId cancelled');
    } catch (e) {
      debugPrint('Error cancelling Azan alarm: $e');
    }
  }

  /// Play Azan immediately (for testing or manual trigger)
  static Future<void> playAzan({String? prayerName}) async {
    if (!Platform.isAndroid) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final selectedAzan = prefs.getString('selected_adhan') ?? 'makkah';
      final azanUrl = adhanUrls[selectedAzan] ?? adhanUrls['makkah']!;
      final cachedPath = prefs.getString('cached_azan_path') ?? '';

      await _channel.invokeMethod('playAzan', {
        'url': azanUrl,
        'prayerName': prayerName ?? 'Azan',
        'cachedPath': cachedPath,
      });
      debugPrint('Playing Azan...');
    } catch (e) {
      debugPrint('Error playing Azan: $e');
    }
  }

  /// Stop Azan playback
  static Future<void> stopAzan() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod('stopAzan');
      debugPrint('Azan stopped');
    } catch (e) {
      debugPrint('Error stopping Azan: $e');
    }
  }

  /// Parse time string in both "5:30 AM" and "17:30" formats
  static Map<String, int>? _parseTimeString(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toUpperCase();
      final isPM = cleanTime.contains('PM');
      final isAM = cleanTime.contains('AM');

      String timeOnly =
          cleanTime.replaceAll('AM', '').replaceAll('PM', '').trim();

      final parts = timeOnly.split(':');
      if (parts.length < 2) return null;

      int hour = int.parse(parts[0].trim());
      final minute = int.parse(parts[1].trim());

      if (isPM || isAM) {
        if (isPM && hour != 12) {
          hour += 12;
        } else if (isAM && hour == 12) {
          hour = 0;
        }
      }

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      return null;
    }
  }
}
