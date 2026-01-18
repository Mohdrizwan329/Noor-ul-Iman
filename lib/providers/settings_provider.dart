import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _calculationMethodKey = 'calculation_method';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _arabicFontSizeKey = 'arabic_font_size';
  static const String _translationFontSizeKey = 'translation_font_size';
  static const String _countryCodeKey = 'country_code';

  ThemeMode _themeMode = ThemeMode.light;
  int _calculationMethod = 1; // Karachi
  String _language = 'en';
  bool _notificationsEnabled = true;
  double _arabicFontSize = 28.0;
  double _translationFontSize = 16.0;
  String _countryCode = 'IN'; // Default country - India

  // Getters
  ThemeMode get themeMode => _themeMode;
  int get calculationMethod => _calculationMethod;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  String get countryCode => _countryCode;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    _themeMode = ThemeMode.values[themeIndex];

    _calculationMethod = prefs.getInt(_calculationMethodKey) ?? 1;
    _language = prefs.getString(_languageKey) ?? 'en';
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 28.0;
    _translationFontSize = prefs.getDouble(_translationFontSizeKey) ?? 16.0;
    _countryCode = prefs.getString(_countryCodeKey) ?? 'IN';

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final newMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  Future<void> setCalculationMethod(int method) async {
    _calculationMethod = method;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_calculationMethodKey, method);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, enabled);
    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    _arabicFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_arabicFontSizeKey, size);
    notifyListeners();
  }

  Future<void> setTranslationFontSize(double size) async {
    _translationFontSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_translationFontSizeKey, size);
    notifyListeners();
  }

  Future<void> setCountryCode(String code) async {
    _countryCode = code;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_countryCodeKey, code);
    notifyListeners();
  }

  // Set country from phone number country code
  Future<void> setCountryFromPhoneCode(String phoneCode) async {
    final country = _phoneCodeToCountry[phoneCode] ?? 'IN';
    await setCountryCode(country);
  }

  // Phone code to country mapping
  static const Map<String, String> _phoneCodeToCountry = {
    '+1': 'US',
    '+91': 'IN',
    '+92': 'PK',
    '+880': 'BD',
    '+966': 'SA',
    '+971': 'AE',
    '+44': 'GB',
    '+49': 'DE',
    '+33': 'FR',
    '+90': 'TR',
    '+62': 'ID',
    '+60': 'MY',
    '+65': 'SG',
    '+20': 'EG',
    '+234': 'NG',
    '+27': 'ZA',
    '+61': 'AU',
    '+81': 'JP',
    '+86': 'CN',
    '+82': 'KR',
    '+55': 'BR',
    '+52': 'MX',
    '+7': 'RU',
    '+39': 'IT',
    '+34': 'ES',
    '+31': 'NL',
    '+46': 'SE',
    '+47': 'NO',
    '+45': 'DK',
    '+41': 'CH',
    '+43': 'AT',
    '+32': 'BE',
    '+48': 'PL',
    '+380': 'UA',
    '+63': 'PH',
    '+84': 'VN',
    '+66': 'TH',
    '+98': 'IR',
    '+964': 'IQ',
    '+962': 'JO',
    '+961': 'LB',
    '+965': 'KW',
    '+968': 'OM',
    '+974': 'QA',
    '+973': 'BH',
    '+212': 'MA',
    '+213': 'DZ',
    '+216': 'TN',
    '+218': 'LY',
    '+249': 'SD',
  };

  // Calculation method names
  String getCalculationMethodName(int method) {
    const methods = {
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
    return methods[method] ?? 'Unknown';
  }
}
