import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../widgets/common/banner_ad_widget.dart';

class PdfSurahViewerScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const PdfSurahViewerScreen({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  State<PdfSurahViewerScreen> createState() => _PdfSurahViewerScreenState();
}

class _PdfSurahViewerScreenState extends State<PdfSurahViewerScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  late final int _juzNumber;
  late final int _startFileNum;
  late final int _totalPages;

  // 13 Line Quran (Nurul Huda Publications) - archive.org/details/qip13
  // Each Juz: files 0000 (cover), 0001 (contents), 0002+ (Quran pages)

  // Which Juz each surah starts in (index 0 = Surah 1)
  static const List<int> _surahJuz = [
    1, 1, 3, 4, 6, 7, 8, 9, 10, 11,       // 1-10
    11, 12, 13, 13, 14, 14, 15, 15, 16, 16, // 11-20
    17, 17, 18, 18, 18, 19, 19, 20, 20, 21, // 21-30
    21, 21, 21, 22, 22, 22, 23, 23, 23, 24, // 31-40
    24, 25, 25, 25, 25, 26, 26, 26, 26, 26, // 41-50
    26, 27, 27, 27, 27, 27, 27, 28, 28, 28, // 51-60
    28, 28, 28, 28, 28, 28, 29, 29, 29, 29, // 61-70
    29, 29, 29, 29, 29, 29, 29, 30, 30, 30, // 71-80
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // 81-90
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // 91-100
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // 101-110
    30, 30, 30, 30,                           // 111-114
  ];

  // File number within Juz where each surah starts (index 0 = Surah 1)
  // File 0002 = first content page of each Juz
  static const List<int> _surahFileInJuz = [
    2, 3, 2, 2, 2, 2, 2, 2, 2, 2,         // 1-10
    18, 2, 2, 17, 2, 15, 2, 14, 2, 14,    // 11-20
    2, 14, 2, 13, 24, 2, 14, 2, 16, 2,    // 21-30
    14, 19, 2, 2, 12, 19, 2, 13, 22, 2,   // 31-40
    15, 2, 9, 18, 23, 2, 8, 14, 21, 24,   // 41-50
    27, 2, 7, 12, 16, 21, 26, 2, 7, 12,   // 51-60
    16, 18, 20, 22, 25, 27, 2, 6, 10, 14, // 61-70
    17, 20, 23, 25, 28, 30, 2, 2, 7, 10,  // 71-80
    14, 16, 17, 19, 21, 23, 24, 24, 25, 27, // 81-90
    28, 28, 29, 29, 29, 29, 30, 30, 30, 30, // 91-100
    31, 31, 31, 31, 31, 32, 32, 32, 32, 32, // 101-110
    32, 32, 33, 33,                           // 111-114
  ];

  // Page count per Juz (content pages: file 0002 to last)
  static const List<int> _paraPageCounts = [
    28, 29, 29, 29, 29, 29, 29, 29, 29, 29, // Juz 1-10
    29, 29, 29, 29, 29, 29, 29, 29, 29, 27, // Juz 11-20
    29, 27, 29, 27, 31, 31, 31, 31, 33, 31, // Juz 21-30
  ];

  int _getSurahPageCount() {
    final surahIdx = widget.surahNumber - 1;
    final juz = _surahJuz[surahIdx];
    final startFile = _surahFileInJuz[surahIdx];

    if (widget.surahNumber >= 114) {
      // Last surah: goes to end of Juz 30
      final lastFile = _paraPageCounts[29] + 1;
      return (lastFile - startFile + 1).clamp(1, 100);
    }

    final nextJuz = _surahJuz[surahIdx + 1];
    final nextStartFile = _surahFileInJuz[surahIdx + 1];

    if (nextJuz == juz) {
      // Next surah is in same Juz
      return (nextStartFile - startFile).clamp(1, 100);
    } else {
      // Current surah goes to end of its Juz
      final lastFileInJuz = _paraPageCounts[juz - 1] + 1;
      return (lastFileInJuz - startFile + 1).clamp(1, 100);
    }
  }

  @override
  void initState() {
    super.initState();
    _juzNumber = _surahJuz[widget.surahNumber - 1];
    _startFileNum = _surahFileInJuz[widget.surahNumber - 1];
    _totalPages = _getSurahPageCount();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPageImageUrl(int pageIndex) {
    final juz = _juzNumber.toString().padLeft(2, '0');
    final fileNum = (_startFileNum + pageIndex).toString().padLeft(4, '0');
    return 'https://iiif.archive.org/image/iiif/3/'
        'qip13%2FJuz+$juz+IP_jp2.zip%2F'
        'Juz+$juz+IP_jp2%2F'
        'Juz+$juz+IP_$fileNum.jp2'
        '/pct:0,7,100,83/800,/0/default.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          '${widget.surahNumber}. ${widget.surahName}',
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
                  color: Colors.white,
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
