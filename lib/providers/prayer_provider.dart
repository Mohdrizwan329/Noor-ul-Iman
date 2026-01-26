import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../core/services/location_service.dart';
import '../core/services/prayer_time_service.dart';
import '../data/models/prayer_time_model.dart';

class PrayerProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();

  PrayerTimeModel? _todayPrayerTimes;
  List<PrayerTimeModel> _monthlyPrayerTimes = [];
  String _nextPrayer = '';
  Duration _timeUntilNextPrayer = Duration.zero;
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  int _calculationMethod = 1; // Default: india
  Timer? _countdownTimer;

  // Getters
  PrayerTimeModel? get todayPrayerTimes => _todayPrayerTimes;
  List<PrayerTimeModel> get monthlyPrayerTimes => _monthlyPrayerTimes;
  String get nextPrayer => _nextPrayer;
  Duration get timeUntilNextPrayer => _timeUntilNextPrayer;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;
  int get calculationMethod => _calculationMethod;
  String get formattedTimeRemaining =>
      _prayerTimeService.formatDuration(_timeUntilNextPrayer);

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition != null) {
        await fetchTodayPrayerTimes();
        _startCountdownTimer();
      } else {
        _error = 'Location permission required';
      }
    } catch (e) {
      _error = 'Failed to initialize: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchTodayPrayerTimes() async {
    if (_currentPosition == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _todayPrayerTimes = await _prayerTimeService.getPrayerTimes(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        method: _calculationMethod,
      );

      if (_todayPrayerTimes != null) {
        _updateNextPrayer();
      }
    } catch (e) {
      _error = 'Failed to fetch prayer times: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMonthlyPrayerTimes(int month, int year) async {
    if (_currentPosition == null) return;

    try {
      _monthlyPrayerTimes = await _prayerTimeService.getMonthlyPrayerTimes(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        month: month,
        year: year,
        method: _calculationMethod,
      );
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch monthly prayer times: $e';
    }
  }

  void _updateNextPrayer() {
    if (_todayPrayerTimes == null) return;

    _nextPrayer = _prayerTimeService.getNextPrayer(_todayPrayerTimes!);
    _timeUntilNextPrayer = _prayerTimeService.getTimeUntilNextPrayer(
      _todayPrayerTimes!,
    );
    notifyListeners();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeUntilNextPrayer.inSeconds > 0) {
        _timeUntilNextPrayer -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        _updateNextPrayer();
      }
    });
  }

  void setCalculationMethod(int method) {
    _calculationMethod = method;
    fetchTodayPrayerTimes();
  }

  void setPosition(Position position) {
    _currentPosition = position;
    fetchTodayPrayerTimes();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
