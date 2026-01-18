import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasbihProvider with ChangeNotifier {
  static const String _countKey = 'tasbih_count';
  static const String _targetKey = 'tasbih_target';
  static const String _totalCountKey = 'tasbih_total_count';
  static const String _vibrationKey = 'tasbih_vibration';
  static const String _soundKey = 'tasbih_sound';
  static const String _lapCountKey = 'tasbih_lap_count';

  int _count = 0;
  int _target = 100;
  int _totalCount = 0;
  int _lapCount = 0;
  bool _vibrationEnabled = true;
  bool _soundEnabled = false;
  int _selectedDhikrIndex = 0;

  // Predefined dhikr options
  final List<DhikrItem> dhikrList = [
    DhikrItem(
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'SubhanAllah',
      meaning: 'Glory be to Allah',
      defaultTarget: 33,
    ),
    DhikrItem(
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'Praise be to Allah',
      defaultTarget: 33,
    ),
    DhikrItem(
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'Allah is the Greatest',
      defaultTarget: 34,
    ),
    DhikrItem(
      arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illallah',
      meaning: 'There is no god but Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'I seek forgiveness from Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      meaning: 'Glory and praise be to Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      meaning: 'There is no power except with Allah',
      defaultTarget: 100,
    ),
  ];

  // Getters
  int get count => _count;
  int get target => _target;
  int get totalCount => _totalCount;
  int get lapCount => _lapCount;
  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  int get selectedDhikrIndex => _selectedDhikrIndex;
  DhikrItem get currentDhikr => dhikrList[_selectedDhikrIndex];
  double get progress => _target > 0 ? _count / _target : 0;
  bool get isTargetReached => _count >= _target;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _count = prefs.getInt(_countKey) ?? 0;
    _target = prefs.getInt(_targetKey) ?? 100;
    _totalCount = prefs.getInt(_totalCountKey) ?? 0;
    _lapCount = prefs.getInt(_lapCountKey) ?? 0;
    _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    _soundEnabled = prefs.getBool(_soundKey) ?? false;
    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    _totalCount++;

    // When count reaches target (100), increment lap and reset count
    if (_count >= _target) {
      _lapCount++;
      _count = 0;
    }

    await _saveCount();
    notifyListeners();
  }

  Future<void> decrement() async {
    if (_count > 0) {
      _count--;
      if (_totalCount > 0) _totalCount--;
    } else if (_lapCount > 0) {
      // If count is 0 and we have laps, go back to previous lap
      _lapCount--;
      _count = _target - 1;
      if (_totalCount > 0) _totalCount--;
    }

    await _saveCount();
    notifyListeners();
  }

  Future<void> reset() async {
    _count = 0;
    _lapCount = 0;
    await _saveCount();
    notifyListeners();
  }

  Future<void> setTarget(int target) async {
    _target = target;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_targetKey, target);
    notifyListeners();
  }

  void selectDhikr(int index) {
    if (index >= 0 && index < dhikrList.length) {
      _selectedDhikrIndex = index;
      _target = dhikrList[index].defaultTarget;
      _count = 0;
      notifyListeners();
    }
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    _vibrationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, enabled);
    notifyListeners();
  }

  Future<void> _saveCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_countKey, _count);
    await prefs.setInt(_totalCountKey, _totalCount);
    await prefs.setInt(_lapCountKey, _lapCount);
  }
}

class DhikrItem {
  final String arabic;
  final String transliteration;
  final String meaning;
  final int defaultTarget;

  DhikrItem({
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.defaultTarget,
  });
}
