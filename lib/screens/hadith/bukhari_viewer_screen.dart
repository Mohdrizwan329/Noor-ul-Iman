import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/common/banner_ad_widget.dart';

class BukhariViewerScreen extends StatefulWidget {
  final int volumeNumber;

  const BukhariViewerScreen({
    super.key,
    required this.volumeNumber,
  });

  @override
  State<BukhariViewerScreen> createState() => _BukhariViewerScreenState();
}

class _BukhariViewerScreenState extends State<BukhariViewerScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  late final int _totalPages;

  // Page counts per volume (leaf 0 to N-1)
  static const List<int> _volumePageCounts = [
    761, 529, 609, 569, 497, 601, 689, 513, 449, 528,
  ];

  @override
  void initState() {
    super.initState();
    _totalPages = _volumePageCounts[widget.volumeNumber - 1];
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPageImageUrl(int pageIndex) {
    final paddedPage = pageIndex.toString().padLeft(4, '0');
    final vol = 'sahih-al-bukhari-arabic-vol-${widget.volumeNumber}';
    return 'https://iiif.archive.org/image/iiif/3/'
        'sahih-al-bukhari-arabic-full%2F${vol}_jp2.zip%2F${vol}_jp2%2F${vol}_$paddedPage.jp2'
        '/full/max/0/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          '${context.tr('sahih_bukhari')} - ${context.tr('volume')} ${widget.volumeNumber}',
          style: TextStyle(fontSize: responsive.fontSize(16)),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentPage + 1} / $_totalPages',
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _totalPages,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                  color: const Color(0xFFF5F0E8),
                  child: CachedNetworkImage(
                    imageUrl: _getPageImageUrl(index),
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: responsive.spacing(12)),
                          Text(
                            '${context.tr('loading')} - ${index + 1}/$_totalPages',
                            style: TextStyle(
                              fontSize: responsive.fontSize(14),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: responsive.iconSize(48),
                            color: Colors.red,
                          ),
                          SizedBox(height: responsive.spacing(8)),
                          Text(
                            context.tr('error'),
                            style: TextStyle(
                              fontSize: responsive.fontSize(16),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
