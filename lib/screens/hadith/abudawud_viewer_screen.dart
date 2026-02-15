import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/common/banner_ad_widget.dart';

class AbuDawudViewerScreen extends StatefulWidget {
  final int volumeNumber;

  const AbuDawudViewerScreen({
    super.key,
    required this.volumeNumber,
  });

  @override
  State<AbuDawudViewerScreen> createState() => _AbuDawudViewerScreenState();
}

class _AbuDawudViewerScreenState extends State<AbuDawudViewerScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  late final int _totalPages;
  late final int _startPage;

  // Page counts per volume (split 878 pages into 10 parts)
  static const List<int> _volumePageCounts = [
    88, 88, 88, 88, 88, 88, 88, 88, 87, 87,
  ];

  @override
  void initState() {
    super.initState();
    _totalPages = _volumePageCounts[widget.volumeNumber - 1];
    _startPage = _getStartPage();
    _pageController = PageController();
  }

  int _getStartPage() {
    int start = 0;
    for (int i = 0; i < widget.volumeNumber - 1; i++) {
      start += _volumePageCounts[i];
    }
    return start;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPageImageUrl(int pageIndex) {
    final absolutePage = _startPage + pageIndex;
    final paddedPage = absolutePage.toString().padLeft(4, '0');
    return 'https://iiif.archive.org/image/iiif/3/'
        'sunanabidawoodarabic%2FSunan%20Abi%20Dawood-%20Arabic_jp2.zip%2FSunan%20Abi%20Dawood-%20Arabic_jp2%2FSunan%20Abi%20Dawood-%20Arabic_$paddedPage.jp2'
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
          '${context.tr('sunan_abu_dawud')} - ${context.tr('volume')} ${widget.volumeNumber}',
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
