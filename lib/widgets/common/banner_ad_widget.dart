import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/ad_service.dart';

class BannerAdWidget extends StatefulWidget {
  final double? height;

  const BannerAdWidget({super.key, this.height});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  String? _lastError;
  int _retryCount = 0;
  static const int _maxRetries = 3;
  bool _loadingStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadingStarted) {
      _loadingStarted = true;
      _initAndLoad();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    _retryCount = 0;
    _loadingStarted = true;
    _initAndLoad();
  }

  Future<void> _initAndLoad() async {
    // Wait for AdMob SDK to be ready before loading any ads
    if (!AdService.isInitialized) {
      debugPrint('BannerAd: Waiting for AdMob initialization...');
      await AdService.waitForInit();
    }

    if (!AdService.isInitialized) {
      debugPrint('BannerAd: AdMob not initialized, cannot load ad');
      if (mounted) {
        setState(() {
          _lastError = 'AdMob SDK not initialized';
        });
      }
      return;
    }

    if (!mounted) return;
    _loadAd();
  }

  void _loadAd() {
    if (!mounted) return;

    final width = MediaQuery.of(context).size.width.truncate();
    debugPrint('BannerAd: Loading ad, width: $width, unitId: ${AdService.bannerAdUnitId}');

    // If screen width is 0 (not yet laid out), use standard banner size
    if (width <= 0) {
      debugPrint('BannerAd: Width is 0, using standard AdSize.banner');
      _createAndLoadAd(AdSize.banner);
      return;
    }

    // Try adaptive size, fallback to standard banner
    AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.portrait, width).then(
      (adSize) {
        if (!mounted) return;
        final effectiveSize = adSize ?? AdSize.banner;
        debugPrint('BannerAd: Using size ${effectiveSize.width}x${effectiveSize.height}');
        _createAndLoadAd(effectiveSize);
      },
      onError: (e) {
        debugPrint('BannerAd: Adaptive size failed ($e), using standard banner');
        if (mounted) _createAndLoadAd(AdSize.banner);
      },
    );
  }

  void _createAndLoadAd(AdSize size) {
    if (!mounted) return;

    final adUnitId = AdService.bannerAdUnitId;
    debugPrint('BannerAd: Creating ad with unitId=$adUnitId, size=${size.width}x${size.height}');

    final bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd: Loaded successfully!');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
              _lastError = null;
              _retryCount = 0;
            });
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd: FAILED - code:${error.code} msg:${error.message} domain:${error.domain}');
          ad.dispose();

          if (mounted) {
            setState(() {
              _lastError = 'code:${error.code} ${error.message}';
            });
          }

          // Retry with backoff
          if (_retryCount < _maxRetries && mounted) {
            _retryCount++;
            final delay = Duration(seconds: _retryCount * 5);
            debugPrint('BannerAd: Retrying in ${delay.inSeconds}s (attempt $_retryCount/$_maxRetries)');
            Future.delayed(delay, () {
              if (mounted) _loadAd();
            });
          }
        },
      ),
    );
    bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      // Debug mode me error dikhao
      if (kDebugMode && _lastError != null && _retryCount >= _maxRetries) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          color: Colors.red.withValues(alpha: 0.1),
          child: Text(
            'Ad Error: $_lastError',
            style: const TextStyle(color: Colors.red, fontSize: 10),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    // Inline ad - card style matching list items
    if (widget.height != null) {
      final adHeight = _bannerAd!.size.height.toDouble();
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          height: adHeight + 60,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF8AAF9A), width: 1.5),
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.5),
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: adHeight,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.primary, width: 1.5)),
      ),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
