import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../core/services/location_service.dart';
import '../core/services/prayer_time_service.dart';
import '../data/models/prayer_time_model.dart';
import 'settings_provider.dart';
import 'adhan_provider.dart';

class PrayerProvider with ChangeNotifier {
  final LocationService _locationService = LocationService();
  final PrayerTimeService _prayerTimeService = PrayerTimeService();

  PrayerTimeModel? _todayPrayerTimes;
  List<PrayerTimeModel> _monthlyPrayerTimes = [];
  String _nextPrayer = '';
  Duration _timeUntilNextPrayer = Duration.zero;
  bool _isLoading = false;
  bool _isInitializing = false;
  String? _error;
  Position? _currentPosition;
  int _calculationMethod = 1; // Default: india
  Timer? _countdownTimer;

  // Getters
  PrayerTimeModel? get todayPrayerTimes => _todayPrayerTimes;
  List<PrayerTimeModel> get monthlyPrayerTimes => _monthlyPrayerTimes;
  String get nextPrayer {
    // On Friday, show Jummah instead of Dhuhr
    if (_nextPrayer.toLowerCase() == 'dhuhr' && DateTime.now().weekday == 5) {
      return 'Jummah';
    }
    return _nextPrayer;
  }
  Duration get timeUntilNextPrayer => _timeUntilNextPrayer;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;
  int get calculationMethod => _calculationMethod;
  String get formattedTimeRemaining =>
      _prayerTimeService.formatDuration(_timeUntilNextPrayer);

  Future<void> initialize() async {
    // Prevent concurrent initialization
    if (_isInitializing) return;
    _isInitializing = true;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition != null) {
        // Fetch city and country from coordinates
        await _updateLocationDetails();
        await fetchTodayPrayerTimes();
        _startCountdownTimer();
      } else {
        _error = 'Location permission required';
      }
    } catch (e) {
      _error = 'Failed to initialize: $e';
    }

    _isLoading = false;
    _isInitializing = false;
    notifyListeners();
  }

  Future<void> _updateLocationDetails() async {
    if (_currentPosition == null) return;

    try {
      final placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final city = placemark.locality ??
                     placemark.subAdministrativeArea ??
                     placemark.administrativeArea ??
                     'Unknown';
        final country = placemark.country ?? '';
        final isoCountryCode = placemark.isoCountryCode ?? '';

        _locationService.updateCity(city, country);

        // Auto-detect calculation method from user's country
        if (isoCountryCode.isNotEmpty) {
          _calculationMethod = SettingsProvider.getRecommendedMethod(isoCountryCode);
          debugPrint('📍 Auto-detected calculation method: $_calculationMethod for $isoCountryCode');
        }

        debugPrint('📍 Location updated: $city, $country ($isoCountryCode)');
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
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
        // Automatically schedule notifications when prayer times are fetched
        _autoScheduleNotifications();
      }
    } catch (e) {
      _error = 'Failed to fetch prayer times: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Automatically schedule notifications via AdhanProvider when prayer times are available
  void _autoScheduleNotifications({int retryCount = 0}) {
    if (_todayPrayerTimes == null) return;

    final adhanProvider = AdhanProvider.instance;
    if (adhanProvider == null) {
      debugPrint('🔔 PrayerProvider: AdhanProvider not yet initialized (attempt ${retryCount + 1})');
      // Retry up to 5 times with increasing delay
      if (retryCount < 5) {
        Future.delayed(Duration(seconds: 2 * (retryCount + 1)), () {
          _autoScheduleNotifications(retryCount: retryCount + 1);
        });
      } else {
        debugPrint('🔔 PrayerProvider: AdhanProvider still not ready after $retryCount retries, giving up');
      }
      return;
    }

    // Ensure AdhanProvider is fully initialized before scheduling
    if (!adhanProvider.isInitialized) {
      debugPrint('🔔 PrayerProvider: Waiting for AdhanProvider to finish initializing...');
      adhanProvider.initialize().then((_) {
        _scheduleWithProvider(adhanProvider);
      }).catchError((e) {
        debugPrint('🔔 PrayerProvider: AdhanProvider init failed: $e');
      });
      return;
    }

    _scheduleWithProvider(adhanProvider);
  }

  /// Actually schedule notifications using the initialized AdhanProvider
  void _scheduleWithProvider(AdhanProvider adhanProvider) {
    if (_todayPrayerTimes == null) return;

    // Update location in AdhanProvider
    final city = _locationService.currentCity ?? '';
    if (_currentPosition != null) {
      adhanProvider.updateLocation(
        city: city,
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
      );
    }

    // Schedule prayer notifications (fire and forget - don't await in sync context)
    adhanProvider.schedulePrayerNotifications(_todayPrayerTimes!).then((_) {
      debugPrint('🔔 PrayerProvider: Auto-scheduled prayer notifications');
    }).catchError((e) {
      debugPrint('🔔 PrayerProvider: Auto-schedule failed: $e');
    });

    // Schedule Islamic reminders (only once per app session)
    adhanProvider.scheduleAllIslamicNotifications().catchError((e) {
      debugPrint('🔔 PrayerProvider: Auto-schedule Islamic reminders failed: $e');
    });
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
