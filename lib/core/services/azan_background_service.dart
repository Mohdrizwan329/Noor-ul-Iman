import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Azan URLs (using Islamic Network CDN)
  static const Map<String, String> adhanUrls = {
    'makkah':
        'https://cdn.islamic.network/adhaan/128/ar.abdullahbasfaralhuthaify.mp3',
    'madinah':
        'https://cdn.islamic.network/adhaan/128/ar.abdullahawadaljuhani.mp3',
    'alaqsa': 'https://cdn.islamic.network/adhaan/64/ar.misharyalafasy.mp3',
    'mishary': 'https://cdn.islamic.network/adhaan/128/ar.misharyalafasy.mp3',
    'abdul_basit':
        'https://cdn.islamic.network/adhaan/128/ar.abdulbasitabdussamad.mp3',
  };

  /// Initialize the service (no-op, native service handles everything)
  static Future<void> initialize() async {
    debugPrint('AzanBackgroundService initialized (using native Android service)');
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

    // Save prayer times for recovery after device reboot
    await prefs.setString('last_fajr_time', prayerTimes.fajr);
    await prefs.setString('last_dhuhr_time', prayerTimes.dhuhr);
    await prefs.setString('last_asr_time', prayerTimes.asr);
    await prefs.setString('last_maghrib_time', prayerTimes.maghrib);
    await prefs.setString('last_isha_time', prayerTimes.isha);
    debugPrint('Prayer times saved for boot recovery');

    // Schedule each prayer's Azan (except Sunrise)
    await _scheduleAzanAlarm(_fajrAlarmId, prayerTimes.fajr, 'Fajr', azanUrl);
    await _scheduleAzanAlarm(_dhuhrAlarmId, prayerTimes.dhuhr, 'Dhuhr', azanUrl);
    await _scheduleAzanAlarm(_asrAlarmId, prayerTimes.asr, 'Asr', azanUrl);
    await _scheduleAzanAlarm(_maghribAlarmId, prayerTimes.maghrib, 'Maghrib', azanUrl);
    await _scheduleAzanAlarm(_ishaAlarmId, prayerTimes.isha, 'Isha', azanUrl);

    debugPrint('All Azan alarms scheduled using native Android service');
  }

  /// Schedule a single Azan alarm using native Android AlarmManager
  static Future<void> _scheduleAzanAlarm(
    int alarmId,
    String time,
    String prayerName,
    String azanUrl,
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

      await _channel.invokeMethod('playAzan', {
        'url': azanUrl,
        'prayerName': prayerName ?? 'Azan',
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
