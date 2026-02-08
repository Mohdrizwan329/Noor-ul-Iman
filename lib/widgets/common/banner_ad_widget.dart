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
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bannerAd == null) {
      _loadAd();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _bannerAd?.dispose();
    _bannerAd = null;
    _isLoaded = false;
    _retryCount = 0;
    _loadAd();
  }

  void _loadAd() {
    final width = MediaQuery.of(context).size.width.truncate();
    debugPrint('BannerAd: Loading ad, screen width: $width');

    // If custom height specified, use appropriate ad size
    if (widget.height != null) {
      AdSize effectiveSize;
      if (widget.height! >= 250) {
        effectiveSize = AdSize.mediumRectangle; // 300x250
      } else if (widget.height! >= 100) {
        effectiveSize = AdSize.largeBanner; // 320x100
      } else {
        effectiveSize = AdSize.banner; // 320x50
      }
      debugPrint(
        'BannerAd: Using fixed size: ${effectiveSize.width}x${effectiveSize.height} for height: ${widget.height}',
      );
      _createAndLoadAd(effectiveSize);
      return;
    }

    AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.portrait, width).then((
      adSize,
    ) {
      // Fallback to standard banner if adaptive size fails
      final effectiveSize = adSize ?? AdSize.banner;
      debugPrint(
        'BannerAd: Ad size: ${effectiveSize.width}x${effectiveSize.height} (adaptive: ${adSize != null})',
      );
      _createAndLoadAd(effectiveSize);
    });
  }

  void _createAndLoadAd(AdSize size) {
    if (!mounted) return;

    final bannerAd = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('BannerAd: Ad loaded successfully!');
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _isLoaded = true;
              _retryCount = 0;
            });
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
            'BannerAd: Failed to load - code: ${error.code}, message: ${error.message}, domain: ${error.domain}',
          );
          ad.dispose();
          // Retry with exponential backoff
          if (_retryCount < _maxRetries && mounted) {
            _retryCount++;
            final delay = Duration(seconds: _retryCount * 5);
            debugPrint(
              'BannerAd: Retrying in ${delay.inSeconds}s (attempt $_retryCount/$_maxRetries)',
            );
            Future.delayed(delay, () {
              if (mounted) _loadAd();
            });
          } else {
            debugPrint('BannerAd: All retries exhausted, ad will not show');
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
      // Show placeholder with height if specified
      if (widget.height != null) {
        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    // If custom height provided, use it with centered ad
    if (widget.height != null) {
      return Container(
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        ),
        child: Center(
          child: SizedBox(
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
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
