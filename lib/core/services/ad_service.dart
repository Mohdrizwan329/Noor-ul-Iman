import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static bool _isInitialized = false;
  static final Completer<void> _initCompleter = Completer<void>();

  // ⚠️ IMPORTANT: Play Store publish se pehle false karna!
  // true = test ads (testing ke liye)
  // false = production ads (Play Store ke liye)
  static const bool _useTestAds = true;

  /// Check if SDK is initialized
  static bool get isInitialized => _isInitialized;

  /// Wait for SDK initialization to complete
  static Future<void> waitForInit() => _initCompleter.future;

  /// Initialize Mobile Ads SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;

    for (int attempt = 1; attempt <= 3; attempt++) {
      try {
        debugPrint('AdMob: Initializing (attempt $attempt)...');
        await MobileAds.instance.initialize();
        debugPrint('AdMob: SDK initialized successfully');
        break;
      } catch (e) {
        debugPrint('AdMob: Init attempt $attempt failed: $e');
        if (attempt == 3) {
          debugPrint('AdMob: All init attempts failed');
          if (!_initCompleter.isCompleted) _initCompleter.complete();
          return;
        }
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    // Configure request settings
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
      ),
    );

    _isInitialized = true;
    if (!_initCompleter.isCompleted) _initCompleter.complete();

    debugPrint('AdMob: Ready (testAds: $_useTestAds, platform: ${Platform.operatingSystem})');
    debugPrint('AdMob: Banner=$bannerAdUnitId');
  }

  // ========== AD UNIT IDS ==========

  static String get bannerAdUnitId {
    if (kDebugMode || _useTestAds) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8174132057030501/9469127339';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8174132057030501/9469127339';
    }
    return '';
  }

  static String get nativeAdUnitId {
    if (kDebugMode || _useTestAds) {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/2247696110'
          : 'ca-app-pub-3940256099942544/3986624511';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8174132057030501/8571086438';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8174132057030501/8571086438';
    }
    return '';
  }
}
