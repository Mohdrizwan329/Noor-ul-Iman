class PrayerTimeModel {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;
  final String hijriDate;

  PrayerTimeModel({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.hijriDate,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>;
    final date = json['date'] as Map<String, dynamic>;
    final hijri = date['hijri'] as Map<String, dynamic>;

    return PrayerTimeModel(
      fajr: _cleanTime(timings['Fajr']),
      sunrise: _cleanTime(timings['Sunrise']),
      dhuhr: _cleanTime(timings['Dhuhr']),
      asr: _cleanTime(timings['Asr']),
      maghrib: _cleanTime(timings['Maghrib']),
      isha: _cleanTime(timings['Isha']),
      date: date['readable'] ?? '',
      hijriDate: '${hijri['day']} ${hijri['month']['en']} ${hijri['year']}',
    );
  }

  static String _cleanTime(String? time) {
    if (time == null) return '';
    // Remove timezone info like (PKT)
    String cleaned = time.replaceAll(RegExp(r'\s*\([^)]*\)'), '').trim();

    // Convert 24-hour format to 12-hour format
    return _convertTo12Hour(cleaned);
  }

  static String _convertTo12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length < 2) return time24;

      int hour = int.parse(parts[0]);
      final minute = parts[1];

      String period = 'AM';
      if (hour >= 12) {
        period = 'PM';
        if (hour > 12) hour -= 12;
      }
      if (hour == 0) hour = 12;

      return '$hour:$minute $period';
    } catch (e) {
      return time24;
    }
  }

  Map<String, String> toMap() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }

  List<PrayerItem> toPrayerList() {
    return [
      PrayerItem(name: 'Fajr', time: fajr, icon: '🌙'),
      PrayerItem(name: 'Sunrise', time: sunrise, icon: '🌅'),
      PrayerItem(name: 'Dhuhr', time: dhuhr, icon: '☀️'),
      PrayerItem(name: 'Asr', time: asr, icon: '🌤️'),
      PrayerItem(name: 'Maghrib', time: maghrib, icon: '🌇'),
      PrayerItem(name: 'Isha', time: isha, icon: '🌃'),
    ];
  }
}

class PrayerItem {
  final String name;
  final String time;
  final String icon;

  PrayerItem({
    required this.name,
    required this.time,
    required this.icon,
  });
}
