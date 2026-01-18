import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/prayer_time_model.dart';

class PrayerTimeService {
  static const String _baseUrl = 'https://api.aladhan.com/v1';

  // Calculation Methods
  static const Map<int, String> calculationMethods = {
    0: 'Shia Ithna-Ashari',
    1: 'University of Islamic Sciences, Karachi',
    2: 'Islamic Society of North America (ISNA)',
    3: 'Muslim World League',
    4: 'Umm Al-Qura University, Makkah',
    5: 'Egyptian General Authority of Survey',
    7: 'Institute of Geophysics, University of Tehran',
    8: 'Gulf Region',
    9: 'Kuwait',
    10: 'Qatar',
    11: 'Majlis Ugama Islam Singapura',
    12: 'Union Organization Islamic de France',
    13: 'Diyanet İşleri Başkanlığı, Turkey',
    14: 'Spiritual Administration of Muslims of Russia',
    15: 'Moonsighting Committee Worldwide',
  };

  Future<PrayerTimeModel?> getPrayerTimes({
    required double latitude,
    required double longitude,
    int method = 1, // Default: Karachi
    DateTime? date,
  }) async {
    try {
      final dateToUse = date ?? DateTime.now();
      final dateStr =
          '${dateToUse.day.toString().padLeft(2, '0')}-${dateToUse.month.toString().padLeft(2, '0')}-${dateToUse.year}';

      final url = Uri.parse(
        '$_baseUrl/timings/$dateStr?latitude=$latitude&longitude=$longitude&method=$method',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          return PrayerTimeModel.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<PrayerTimeModel>> getMonthlyPrayerTimes({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
    int method = 1,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/calendar/$year/$month?latitude=$latitude&longitude=$longitude&method=$method',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          final List<dynamic> daysData = data['data'];
          return daysData
              .map((day) => PrayerTimeModel.fromJson(day))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  String getNextPrayer(PrayerTimeModel prayerTimes) {
    final now = DateTime.now();
    final prayers = prayerTimes.toMap();

    for (var entry in prayers.entries) {
      final prayerTime = _parseTime(entry.value);
      if (prayerTime != null && prayerTime.isAfter(now)) {
        return entry.key;
      }
    }

    return 'Fajr'; // Next day's Fajr
  }

  Duration getTimeUntilNextPrayer(PrayerTimeModel prayerTimes) {
    final now = DateTime.now();
    final prayers = prayerTimes.toMap();

    for (var entry in prayers.entries) {
      final prayerTime = _parseTime(entry.value);
      if (prayerTime != null && prayerTime.isAfter(now)) {
        return prayerTime.difference(now);
      }
    }

    // Return time until next day's Fajr
    final fajrTime = _parseTime(prayerTimes.fajr);
    if (fajrTime != null) {
      final nextFajr = fajrTime.add(const Duration(days: 1));
      return nextFajr.difference(now);
    }

    return Duration.zero;
  }

  DateTime? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        final now = DateTime.now();
        return DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}
