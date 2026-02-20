import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized Hijri date service that fetches accurate Islamic dates
/// from the Aladhan API instead of relying on the local hijri package tables.
///
/// The local `hijri` package uses static Umm al-Qura tables that can be
/// 1-2 days off from the actual observed Islamic date. This service:
/// 1. Fetches the correct Hijri date from Aladhan API
/// 2. Computes a day adjustment offset vs the local package
/// 3. Provides corrected HijriCalendar objects everywhere
/// 4. Allows manual ±2 day user adjustment (for local moon sighting)
/// 5. Falls back to local package if API is unavailable
class HijriDateService {
  static final HijriDateService _instance = HijriDateService._internal();
  static HijriDateService get instance => _instance;

  HijriDateService._internal();

  static const String _baseUrl = 'https://api.aladhan.com/v1';
  static const String _adjustmentKey = 'hijri_date_adjustment';

  /// The API-computed adjustment (difference between API and local package)
  int _apiAdjustment = 0;

  /// User/regional adjustment (-2 to +2)
  /// Auto-detected from user's country, can be manually overridden
  int _userAdjustment = 0;

  /// Whether the service has been initialized
  bool _isInitialized = false;

  /// Cached API Hijri date values
  int? _apiHijriDay;
  int? _apiHijriMonth;
  int? _apiHijriYear;

  /// Total adjustment = API adjustment + user adjustment
  int get totalAdjustment => _apiAdjustment + _userAdjustment;

  /// User's manual adjustment
  int get userAdjustment => _userAdjustment;

  /// Whether service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the service - call this on app startup
  Future<void> initialize() async {
    // Load user adjustment from prefs
    await _loadUserAdjustment();

    // Fetch correct date from API
    await _fetchCorrectHijriDate();

    _isInitialized = true;
    debugPrint('HijriDateService initialized: apiAdj=$_apiAdjustment, userAdj=$_userAdjustment, total=$totalAdjustment');
  }

  /// Get the corrected Hijri date for today.
  ///
  /// Always uses HijriCalendar.fromDate() to ensure all fields
  /// (longMonthName, etc.) are properly initialized.
  HijriCalendar getHijriNow() {
    final adjustment = totalAdjustment;
    if (adjustment == 0) {
      return HijriCalendar.now();
    }
    // Shift the Gregorian date by the offset, then convert.
    // This ensures the hijri package properly initializes all fields.
    final adjustedGregorian = DateTime.now().add(Duration(days: adjustment));
    return HijriCalendar.fromDate(adjustedGregorian);
  }

  /// Get corrected Hijri date for a specific Gregorian date
  HijriCalendar getHijriFromGregorian(DateTime gregorian) {
    final adjusted = gregorian.add(Duration(days: totalAdjustment));
    final hijri = HijriCalendar.fromDate(adjusted);
    return hijri;
  }

  /// Set user's manual adjustment (-2 to +2)
  Future<void> setUserAdjustment(int adjustment) async {
    _userAdjustment = adjustment.clamp(-2, 2);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_adjustmentKey, _userAdjustment);

    debugPrint('User adjustment set to $_userAdjustment, total=$totalAdjustment');
  }

  /// Load user adjustment from SharedPreferences.
  /// If user hasn't manually set an adjustment, auto-detect from country code.
  Future<void> _loadUserAdjustment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getInt(_adjustmentKey);
      if (stored != null) {
        _userAdjustment = stored;
      } else {
        // Auto-detect from user's country (saved by SettingsProvider)
        final countryCode = prefs.getString('country_code') ?? '';
        _userAdjustment = getRegionalAdjustment(countryCode);
        debugPrint('Hijri adjustment auto-detected: $_userAdjustment (country: $countryCode)');
      }
    } catch (e) {
      debugPrint('Error loading user adjustment: $e');
    }
  }

  /// Get the recommended Hijri day adjustment for a country.
  /// Indian subcontinent moon sighting is typically 1 day behind Saudi Umm al-Qura.
  static int getRegionalAdjustment(String countryCode) {
    const subcontinentCountries = {
      'IN', 'PK', 'BD', 'LK', 'NP', 'AF', 'MM',
    };
    if (subcontinentCountries.contains(countryCode.toUpperCase())) {
      return -1;
    }
    return 0; // Saudi, Gulf, SE Asia, Europe, Americas, etc.
  }

  /// Fetch the correct Hijri date from Aladhan API
  Future<void> _fetchCorrectHijriDate() async {
    try {
      final now = DateTime.now();
      final dateStr = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Always fetch the default (Umm al-Qura) date from API.
      // User adjustment is applied locally to avoid double-counting.
      final url = '$_baseUrl/gToH/$dateStr';

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['code'] == 200 && data['data'] != null) {
          final hijriData = data['data']['hijri'];
          _apiHijriDay = int.parse(hijriData['day'].toString());
          _apiHijriMonth = hijriData['month']['number'] as int;
          _apiHijriYear = int.parse(hijriData['year'].toString());

          // Calculate offset from local package
          final localHijri = HijriCalendar.now();
          _apiAdjustment = _calculateDayDifference(
            localHijri.hYear, localHijri.hMonth, localHijri.hDay,
            _apiHijriYear!, _apiHijriMonth!, _apiHijriDay!,
          );

          debugPrint(
            'Hijri API: $_apiHijriDay/$_apiHijriMonth/$_apiHijriYear, '
            'Local: ${localHijri.hDay}/${localHijri.hMonth}/${localHijri.hYear}, '
            'Offset: $_apiAdjustment',
          );
        }
      }
    } catch (e) {
      debugPrint('Error fetching Hijri date from API: $e');
      // Fall back to local package - _apiAdjustment remains 0
    }
  }

  /// Calculate the day difference between two Hijri dates
  /// Returns positive if API date is ahead, negative if behind
  int _calculateDayDifference(
    int localYear, int localMonth, int localDay,
    int apiYear, int apiMonth, int apiDay,
  ) {
    // Simple case: same year and month
    if (localYear == apiYear && localMonth == apiMonth) {
      return apiDay - localDay;
    }

    // Convert both to approximate day count for comparison
    int localDays = localYear * 354 + localMonth * 30 + localDay;
    int apiDays = apiYear * 354 + apiMonth * 30 + apiDay;
    return apiDays - localDays;
  }

}
