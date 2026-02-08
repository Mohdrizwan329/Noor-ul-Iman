import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static bool _isInitialized = false;

  // Interstitial ad instance
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  // Navigation counter for interstitial ads (show every 3 navigations)
  static int _navigationCount = 0;
  static const int _showInterstitialAfter = 3;

  // ⚠️ IMPORTANT: Play Store publish se pehle false karna!
  // true = test ads (testing ke liye)
  // false = production ads (Play Store ke liye)
  static const bool _useTestAds = false;

  /// Initialize Mobile Ads SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;
    await MobileAds.instance.initialize();

    // Disable debug features like native ad validator popup
    // This suppresses the "AdMob native ad validator" dialog
    if (_useTestAds) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
        ),
      );
    }

    _isInitialized = true;
    debugPrint('AdMob initialized (debug: $kDebugMode, testAds: $_useTestAds)');
    // Pre-load interstitial ad
    loadInterstitialAd();
  }

  // ========== AD UNIT IDS ==========
  // Test mode: Google test IDs (emulator/real device testing)
  // Production: Real IDs (Play Store release)

  static String get bannerAdUnitId {
    if (kDebugMode || _useTestAds) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8174132057030501/9469127339';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8174132057030501/9469127339';
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode || _useTestAds) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8174132057030501/4858529567';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8174132057030501/4858529567';
    }
    return '';
  }

  static String get nativeAdUnitId {
    if (kDebugMode || _useTestAds) {
      return 'ca-app-pub-3940256099942544/2247696110';
    }
    if (Platform.isAndroid) {
      return 'ca-app-pub-8174132057030501/8571086438';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-8174132057030501/8571086438';
    }
    return '';
  }

  // ========== INTERSTITIAL AD METHODS ==========

  /// Load interstitial ad
  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('InterstitialAd: Loaded successfully');
          _interstitialAd = ad;
          _isInterstitialAdReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              debugPrint('InterstitialAd: Dismissed');
              ad.dispose();
              _isInterstitialAdReady = false;
              _interstitialAd = null;
              // Pre-load next ad
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('InterstitialAd: Failed to show - ${error.message}');
              ad.dispose();
              _isInterstitialAdReady = false;
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('InterstitialAd: Failed to load - ${error.message}');
          _isInterstitialAdReady = false;
          _interstitialAd = null;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), loadInterstitialAd);
        },
      ),
    );
  }

  /// Show interstitial ad if ready and navigation count reached
  static Future<bool> showInterstitialAd({bool forceShow = false}) async {
    _navigationCount++;
    debugPrint('InterstitialAd: Navigation count: $_navigationCount/$_showInterstitialAfter');

    if (!forceShow && _navigationCount < _showInterstitialAfter) {
      return false;
    }

    if (_isInterstitialAdReady && _interstitialAd != null) {
      _navigationCount = 0; // Reset counter
      await _interstitialAd!.show();
      return true;
    } else {
      debugPrint('InterstitialAd: Not ready, loading...');
      loadInterstitialAd();
      return false;
    }
  }

  /// Check if interstitial ad is ready
  static bool get isInterstitialReady => _isInterstitialAdReady;
}
