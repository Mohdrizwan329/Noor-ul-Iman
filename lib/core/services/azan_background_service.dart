import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/prayer_time_model.dart';

/// Background service for playing Azan at prayer times
class AzanBackgroundService {
  static const String _prefKeyAzanEnabled = 'azan_sound';
  static bool _isInitialized = false;

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

  /// Initialize the alarm manager (Android only)
  static Future<void> initialize() async {
    // Only initialize on Android
    if (!Platform.isAndroid) {
      debugPrint('Azan background service is only supported on Android');
      return;
    }

    try {
      final result = await AndroidAlarmManager.initialize();
      _isInitialized = result;
      debugPrint('Azan background service initialized: $result');
    } catch (e) {
      debugPrint('Failed to initialize Azan background service: $e');
      _isInitialized = false;
    }
  }

  /// Schedule Azan alarms for all prayer times
  static Future<void> scheduleAzanAlarms(PrayerTimeModel prayerTimes) async {
    // Check if service is initialized
    if (!_isInitialized) {
      debugPrint('Azan background service not initialized, skipping alarm scheduling');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final azanEnabled = prefs.getBool(_prefKeyAzanEnabled) ?? true;

    if (!azanEnabled) {
      await cancelAllAlarms();
      return;
    }

    // Schedule each prayer's Azan
    await _scheduleAzanAlarm(_fajrAlarmId, prayerTimes.fajr, 'Fajr');
    await _scheduleAzanAlarm(_dhuhrAlarmId, prayerTimes.dhuhr, 'Dhuhr');
    await _scheduleAzanAlarm(_asrAlarmId, prayerTimes.asr, 'Asr');
    await _scheduleAzanAlarm(_maghribAlarmId, prayerTimes.maghrib, 'Maghrib');
    await _scheduleAzanAlarm(_ishaAlarmId, prayerTimes.isha, 'Isha');
  }

  /// Schedule a single Azan alarm
  static Future<void> _scheduleAzanAlarm(
    int alarmId,
    String time,
    String prayerName,
  ) async {
    final parsedTime = _parseTimeString(time);
    if (parsedTime == null) return;

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
      // Cancel existing alarm first
      await AndroidAlarmManager.cancel(alarmId);

      // Schedule new alarm
      await AndroidAlarmManager.oneShotAt(
        scheduledTime,
        alarmId,
        _playAzanCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        allowWhileIdle: true,
      );

      debugPrint(
        'Scheduled $prayerName Azan alarm for $scheduledTime (ID: $alarmId)',
      );
    } catch (e) {
      debugPrint('Error scheduling Azan alarm: $e');
    }
  }

  /// Cancel all Azan alarms
  static Future<void> cancelAllAlarms() async {
    await AndroidAlarmManager.cancel(_fajrAlarmId);
    await AndroidAlarmManager.cancel(_dhuhrAlarmId);
    await AndroidAlarmManager.cancel(_asrAlarmId);
    await AndroidAlarmManager.cancel(_maghribAlarmId);
    await AndroidAlarmManager.cancel(_ishaAlarmId);
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

/// Top-level callback function for playing Azan (must be static/top-level)
/// This runs in a separate isolate when the app is closed
@pragma('vm:entry-point')
Future<void> _playAzanCallback() async {
  debugPrint('🔊 Azan alarm triggered!');

  AudioPlayer? player;
  try {
    final prefs = await SharedPreferences.getInstance();
    final azanEnabled = prefs.getBool('azan_sound') ?? true;

    if (!azanEnabled) {
      debugPrint('🔊 Azan sound is disabled in settings');
      return;
    }

    final selectedAzan = prefs.getString('selected_adhan') ?? 'makkah';
    final azanUrl = AzanBackgroundService.adhanUrls[selectedAzan] ??
        AzanBackgroundService.adhanUrls['makkah']!;

    debugPrint('🔊 Playing Azan from: $azanUrl');

    player = AudioPlayer();

    // Set audio source with error handling
    await player.setUrl(azanUrl);

    // Set volume to max
    await player.setVolume(1.0);

    // Play the azan
    await player.play();

    // Wait for playback to complete with timeout
    await player.playerStateStream
        .firstWhere(
          (state) => state.processingState == ProcessingState.completed,
        )
        .timeout(
          const Duration(minutes: 10),
          onTimeout: () => player!.playerState,
        );

    debugPrint('🔊 Azan playback completed successfully');
  } catch (e) {
    debugPrint('🔊 Error playing Azan: $e');
  } finally {
    // Always dispose the player
    await player?.dispose();
  }
}
