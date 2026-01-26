import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import '../data/models/prayer_time_model.dart';

class AdhanProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _notificationsEnabled = true;
  bool _adhanSoundEnabled = true;
  String _selectedAdhan = 'makkah';
  bool _isInitialized = false;

  final Map<String, bool> _prayerNotifications = {
    'Fajr': true,
    'Sunrise': false,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get adhanSoundEnabled => _adhanSoundEnabled;
  String get selectedAdhan => _selectedAdhan;
  Map<String, bool> get prayerNotifications => _prayerNotifications;

  // Adhan options
  static const Map<String, String> adhanOptions = {
    'makkah': 'Makkah Adhan',
    'madinah': 'Madinah Adhan',
    'alaqsa': 'Al-Aqsa Adhan',
    'mishary': 'Mishary Rashid',
    'abdul_basit': 'Abdul Basit',
  };

  // Adhan URLs (using Islamic Network CDN)
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

  Future<void> initialize() async {
    if (_isInitialized) return;

    await _initializeTimezone();
    await _initNotifications();
    await _loadPreferences();
    _isInitialized = true;
  }

  Future<void> _initializeTimezone() async {
    tz_data.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permissions for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    // Request exact alarm permission for Android 12+
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - play adhan if enabled
    if (_adhanSoundEnabled) {
      playAdhan();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('adhan_notifications') ?? true;
    _adhanSoundEnabled = prefs.getBool('adhan_sound') ?? true;
    _selectedAdhan = prefs.getString('selected_adhan') ?? 'makkah';

    // Load individual prayer notifications
    for (final prayer in _prayerNotifications.keys) {
      _prayerNotifications[prayer] =
          prefs.getBool('notify_$prayer') ?? _prayerNotifications[prayer]!;
    }

    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_notifications', _notificationsEnabled);
    await prefs.setBool('adhan_sound', _adhanSoundEnabled);
    await prefs.setString('selected_adhan', _selectedAdhan);

    for (final entry in _prayerNotifications.entries) {
      await prefs.setBool('notify_${entry.key}', entry.value);
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _savePreferences();

    if (!enabled) {
      await _notifications.cancelAll();
    }

    notifyListeners();
  }

  Future<void> setAdhanSoundEnabled(bool enabled) async {
    _adhanSoundEnabled = enabled;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> setSelectedAdhan(String adhan) async {
    _selectedAdhan = adhan;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> setPrayerNotification(String prayer, bool enabled) async {
    _prayerNotifications[prayer] = enabled;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> schedulePrayerNotifications(PrayerTimeModel prayerTimes) async {
    if (!_notificationsEnabled) return;

    // Ensure timezone is initialized before scheduling
    if (!_isInitialized) {
      await initialize();
    }

    // Cancel existing notifications
    await _notifications.cancelAll();

    final prayers = {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    int notificationId = 0;
    for (final entry in prayers.entries) {
      if (_prayerNotifications[entry.key] == true) {
        await _scheduleNotification(
          id: notificationId++,
          prayerName: entry.key,
          time: entry.value,
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required int id,
    required String prayerName,
    required String time,
  }) async {
    final timeParts = time.split(':');
    if (timeParts.length != 2) return;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Prayer Times',
      channelDescription: 'Notifications for Islamic prayer times',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.zonedSchedule(
        id,
        '$prayerName Prayer Time',
        'It\'s time for $prayerName prayer. ${_getArabicPrayerName(prayerName)}',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
      );
      debugPrint('Scheduled $prayerName notification for $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  String _getArabicPrayerName(String prayer) {
    const arabicNames = {
      'Fajr': 'صلاة الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'صلاة الظهر',
      'Asr': 'صلاة العصر',
      'Maghrib': 'صلاة المغرب',
      'Isha': 'صلاة العشاء',
    };
    return arabicNames[prayer] ?? '';
  }

  Future<void> playAdhan() async {
    if (!_adhanSoundEnabled) return;

    try {
      final url = adhanUrls[_selectedAdhan] ?? adhanUrls['makkah']!;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing adhan: $e');
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }

  Future<void> previewAdhan(String adhanKey) async {
    try {
      final url = adhanUrls[adhanKey] ?? adhanUrls['makkah']!;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();

      // Stop after 10 seconds preview
      Future.delayed(const Duration(seconds: 10), () {
        _audioPlayer.stop();
      });
    } catch (e) {
      debugPrint('Error playing adhan preview: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
