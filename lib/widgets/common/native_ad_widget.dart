import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/ad_service.dart';

class NativeAdWidget extends StatefulWidget {
  final double? height;

  const NativeAdWidget({super.key, this.height});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  int _retryCount = 0;
  static const int _maxRetries = 2;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: AdService.nativeAdUnitId,
      factoryId: 'listTile',
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
        mediaAspectRatio: MediaAspectRatio.any,
        requestCustomMuteThisAd: false,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          debugPrint('NativeAd: Loaded successfully');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _retryCount = 0;
            });
          } else {
            ad.dispose();
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd: Failed to load - ${error.message}');
          ad.dispose();
          _nativeAd = null;
          if (_retryCount < _maxRetries && mounted) {
            _retryCount++;
            Future.delayed(
              Duration(seconds: _retryCount * 5),
              () {
                if (mounted) _loadAd();
              },
            );
          }
        },
      ),
    );
    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _nativeAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      constraints: BoxConstraints(
        maxHeight: widget.height ?? 120,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AdWidget(ad: _nativeAd!),
      ),
    );
  }
}
