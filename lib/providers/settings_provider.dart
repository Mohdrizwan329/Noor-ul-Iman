import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _calculationMethodKey = 'calculation_method';
  static const String _methodManuallySetKey = 'calculation_method_manually_set';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _arabicFontSizeKey = 'arabic_font_size';
  static const String _translationFontSizeKey = 'translation_font_size';
  static const String _countryCodeKey = 'country_code';
  static const String _profileNameKey = 'profile_name';
  static const String _profileLocationKey = 'profile_location';
  static const String _profileImagePathKey = 'profile_image_path';

  int _calculationMethod = 1;
  bool _methodManuallySet = false;
  String _language = 'en';
  bool _notificationsEnabled = true;
  double _arabicFontSize = 28.0;
  double _translationFontSize = 16.0;
  String _countryCode = 'IN'; // Default country - India
  String _profileName = 'User';
  String _profileLocation = '';
  String? _profileImagePath;

  // Getters
  int get calculationMethod => _calculationMethod;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  double get arabicFontSize => _arabicFontSize;
  double get translationFontSize => _translationFontSize;
  String get countryCode => _countryCode;
  String get profileName => _profileName;
  String get profileLocation => _profileLocation;
  String? get profileImagePath => _profileImagePath;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _calculationMethod = prefs.getInt(_calculationMethodKey) ?? 1;
    _methodManuallySet = prefs.getBool(_methodManuallySetKey) ?? false;
    _language = prefs.getString(_languageKey) ?? 'en';
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _arabicFontSize = prefs.getDouble(_arabicFontSizeKey) ?? 28.0;
    _translationFontSize = prefs.getDouble(_translationFontSizeKey) ?? 16.0;
    _countryCode = prefs.getString(_countryCodeKey) ?? 'IN';
    _profileName = prefs.getString(_profileNameKey) ?? 'User';
    _profileLocation = prefs.getString(_profileLocationKey) ?? '';
    _profileImagePath = prefs.getString(_profileImagePathKey);

    notifyListeners();
  }

  Future<void> setCalculationMethod(int method, {bool manual = true}) async {
    _calculationMethod = method;
    if (manual) _methodManuallySet = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_calculationMethodKey, method);
    if (manual) await prefs.setBool(_methodManuallySetKey, true);
    notifyListeners();
  }

  /// Auto-detect calculation method based on user's country code (from geocoding).
  /// Only applies if user hasn't manually chosen a method.
  Future<void> autoDetectFromCountry(String countryCode) async {
    if (_methodManuallySet) return;
    final method = getRecommendedMethod(countryCode);
    if (method != _calculationMethod) {
      await setCalculationMethod(method, manual: false);
    }
  }

  /// Get recommended Aladhan API calculation method for a country
  static int getRecommendedMethod(String countryCode) {
    const countryToMethod = {
      // Indian Subcontinent → method 1
      'IN': 1, 'PK': 1, 'BD': 1, 'LK': 1, 'NP': 1, 'AF': 1, 'MM': 1,
      // North America → method 2 (ISNA)
      'US': 2, 'CA': 2, 'MX': 2,
      // Saudi Arabia → method 4 (Umm Al-Qura)
      'SA': 4,
      // UAE, Gulf → method 8
      'AE': 8, 'BH': 8, 'OM': 8,
      // Kuwait → method 9
      'KW': 9,
      // Qatar → method 10
      'QA': 10,
      // Egypt → method 5
      'EG': 5,
      // Turkey → method 13
      'TR': 13,
      // Iran → method 7
      'IR': 7,
      // Singapore, Malaysia, Indonesia → method 11
      'SG': 11, 'MY': 11, 'ID': 11, 'BN': 11,
      // France → method 12
      'FR': 12,
      // Russia → method 14
      'RU': 14,
      // UK, Europe → method 15 (Moonsighting Committee)
      'GB': 15, 'DE': 15, 'NL': 15, 'BE': 15, 'SE': 15,
      'NO': 15, 'DK': 15, 'IT': 15, 'ES': 15, 'AT': 15,
      'CH': 15, 'PL': 15, 'UA': 15, 'IE': 15, 'PT': 15,
      // North Africa → method 5 (Egyptian)
      'LY': 5, 'SD': 5, 'DZ': 3, 'MA': 3, 'TN': 3,
      // Iraq, Jordan, Lebanon, Syria → method 3 (MWL)
      'IQ': 3, 'JO': 3, 'LB': 3, 'SY': 3, 'PS': 3, 'YE': 3,
      // Australia → method 15
      'AU': 15, 'NZ': 15,
      // Philippines, Thailand, Vietnam → method 3 (MWL)
      'PH': 3, 'TH': 3, 'VN': 3,
      // South Africa, Nigeria → method 3 (MWL)
      'ZA': 3, 'NG': 3, 'KE': 3, 'TZ': 3, 'ET': 3,
    };
    return countryToMethod[countryCode.toUpperCase()] ?? 3; // Default: MWL
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

  // Profile methods
  Future<void> setProfileName(String name) async {
    _profileName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileNameKey, name);
    notifyListeners();
  }

  Future<void> setProfileLocation(String location) async {
    _profileLocation = location;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileLocationKey, location);
    notifyListeners();
  }

  Future<void> setProfileImagePath(String? path) async {
    _profileImagePath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString(_profileImagePathKey, path);
    } else {
      await prefs.remove(_profileImagePathKey);
    }
    notifyListeners();
  }

  Future<void> updateProfile({
    required String name,
    required String location,
    String? imagePath,
  }) async {
    await setProfileName(name);
    await setProfileLocation(location);
    await setProfileImagePath(imagePath);

    // Note: Firebase sync should be called from UI with AuthProvider
    // This method only handles local storage
  }

  // Sync profile with Firebase (called from UI after updateProfile)
  Future<void> syncWithFirebase(dynamic authProvider) async {
    // This will be called from the UI with context.read<AuthProvider>()
    // authProvider.syncProfileData(name: _profileName, location: _profileLocation, profileImagePath: _profileImagePath);
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

  // Calculation method names (user-friendly short names)
  String getCalculationMethodName(int method) {
    const methods = {
      0: 'Shia Ithna-Ashari',
      1: 'Indian Subcontinent',
      2: 'North America (ISNA)',
      3: 'Muslim World League',
      4: 'Umm Al-Qura, Makkah',
      5: 'Egypt',
      7: 'Tehran',
      8: 'Gulf Region',
      9: 'Kuwait',
      10: 'Qatar',
      11: 'Singapore',
      12: 'France',
      13: 'Turkey (Diyanet)',
      14: 'Russia',
      15: 'Moonsighting Committee',
    };
    return methods[method] ?? 'Unknown';
  }
}
