import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class TasbihProvider with ChangeNotifier {
  static const String _countKey = 'tasbih_count';
  static const String _targetKey = 'tasbih_target';
  static const String _totalCountKey = 'tasbih_total_count';
  static const String _vibrationKey = 'tasbih_vibration';
  static const String _soundKey = 'tasbih_sound';
  static const String _lapCountKey = 'tasbih_lap_count';
  static const String _historyKey = 'tasbih_history';

  int _count = 0;
  int _target = 100;
  int _totalCount = 0;
  int _lapCount = 0;
  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  int _selectedDhikrIndex = 0;
  Position? _currentLocation;
  String? _currentCity;
  String? _currentCountry;
  bool _isLoadingLocation = false;
  List<TasbihHistoryItem> _history = [];

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
  Position? get currentLocation => _currentLocation;
  String? get currentCity => _currentCity;
  String? get currentCountry => _currentCountry;
  bool get isLoadingLocation => _isLoadingLocation;
  List<TasbihHistoryItem> get history => _history;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _count = prefs.getInt(_countKey) ?? 0;
    _target = prefs.getInt(_targetKey) ?? 100;
    _totalCount = prefs.getInt(_totalCountKey) ?? 0;
    _lapCount = prefs.getInt(_lapCountKey) ?? 0;
    _vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    _soundEnabled = prefs.getBool(_soundKey) ?? true;
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

  Future<void> fetchCurrentLocation() async {
    _isLoadingLocation = true;
    notifyListeners();
    try {
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();
      if (position != null) {
        _currentLocation = position;
        _currentCity = locationService.currentCity;
        _currentCountry = locationService.currentCountry;
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
    } finally {
      _isLoadingLocation = false;
      notifyListeners();
    }
  }

  void addToHistory() {
    final location = _currentCity != null && _currentCountry != null
        ? '$_currentCity, $_currentCountry'
        : null;

    final historyItem = TasbihHistoryItem(
      dhikr: currentDhikr.transliteration,
      count: _totalCount,
      laps: _lapCount,
      timestamp: DateTime.now(),
      location: location,
    );

    _history.insert(0, historyItem);
    if (_history.length > 10) {
      _history = _history.sublist(0, 10);
    }
    _saveHistory();
    notifyListeners();
  }

  void addNoteToHistory(String note) {
    final location = _currentCity != null && _currentCountry != null
        ? '$_currentCity, $_currentCountry'
        : null;

    final historyItem = TasbihHistoryItem(
      dhikr: 'Note',
      count: 0,
      laps: 0,
      timestamp: DateTime.now(),
      location: location,
      notes: note,
    );

    _history.insert(0, historyItem);
    if (_history.length > 10) {
      _history = _history.sublist(0, 10);
    }
    _saveHistory();
    notifyListeners();
  }

  void addNoteToHistoryWithCount(String note, int count) {
    final historyItem = TasbihHistoryItem(
      dhikr: 'Note',
      count: count,
      laps: 0,
      timestamp: DateTime.now(),
      notes: note,
    );

    _history.insert(0, historyItem);
    if (_history.length > 10) {
      _history = _history.sublist(0, 10);
    }
    _saveHistory();
    notifyListeners();
  }

  void editHistoryItem(int index, String newNote) {
    if (index >= 0 && index < _history.length) {
      final updatedItem = TasbihHistoryItem(
        dhikr: _history[index].dhikr,
        count: _history[index].count,
        laps: _history[index].laps,
        timestamp: _history[index].timestamp,
        location: _history[index].location,
        notes: newNote,
      );
      _history[index] = updatedItem;
      _saveHistory();
      notifyListeners();
    }
  }

  void editHistoryItemWithCount(int index, String newNote, int newCount) {
    if (index >= 0 && index < _history.length) {
      final updatedItem = TasbihHistoryItem(
        dhikr: _history[index].dhikr,
        count: newCount,
        laps: _history[index].laps,
        timestamp: _history[index].timestamp,
        location: _history[index].location,
        notes: newNote,
      );
      _history[index] = updatedItem;
      _saveHistory();
      notifyListeners();
    }
  }

  void editHistoryCount(int index, int newCount, int newLaps) {
    if (index >= 0 && index < _history.length) {
      final updatedItem = TasbihHistoryItem(
        dhikr: _history[index].dhikr,
        count: newCount,
        laps: newLaps,
        timestamp: _history[index].timestamp,
        location: _history[index].location,
        notes: _history[index].notes,
      );
      _history[index] = updatedItem;
      _saveHistory();
      notifyListeners();
    }
  }

  void deleteHistoryItem(int index) {
    if (index >= 0 && index < _history.length) {
      _history.removeAt(index);
      _saveHistory();
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = _history.map((item) => item.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(historyJson));
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyStr = prefs.getString(_historyKey);
      if (historyStr != null && historyStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(historyStr);
        _history = decoded
            .map((item) => TasbihHistoryItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
      _history = [];
    }
  }

  Future<void> clearHistory() async {
    _history = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    notifyListeners();
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

class TasbihHistoryItem {
  final String dhikr;
  final int count;
  final int laps;
  final DateTime timestamp;
  final String? location;
  final String? notes;

  TasbihHistoryItem({
    required this.dhikr,
    required this.count,
    required this.laps,
    required this.timestamp,
    this.location,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'dhikr': dhikr,
      'count': count,
      'laps': laps,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'notes': notes,
    };
  }

  factory TasbihHistoryItem.fromJson(Map<String, dynamic> json) {
    return TasbihHistoryItem(
      dhikr: json['dhikr'] as String,
      count: json['count'] as int,
      laps: json['laps'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: json['location'] as String?,
      notes: json['notes'] as String?,
    );
  }
}
