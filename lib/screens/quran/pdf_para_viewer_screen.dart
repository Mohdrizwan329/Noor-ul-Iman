import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
class PdfParaViewerScreen extends StatefulWidget {
  final int paraNumber;
  final String paraName;

  const PdfParaViewerScreen({
    super.key,
    required this.paraNumber,
    required this.paraName,
  });

  @override
  State<PdfParaViewerScreen> createState() => _PdfParaViewerScreenState();
}

class _PdfParaViewerScreenState extends State<PdfParaViewerScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  late final int _totalPages;

  // 13 Line Quran (Nurul Huda Publications) - per-para page counts
  // Source: archive.org/details/qip13
  // Each Juz has files 0000 (cover), 0001 (contents), 0002+ (Quran pages)
  // Content pages start at file 0002
  static const List<int> _paraPageCounts = [
    28, 29, 29, 29, 29, 29, 29, 29, 29, 29, // Juz 1-10
    29, 29, 29, 29, 29, 29, 29, 29, 29, 27, // Juz 11-20
    29, 27, 29, 27, 31, 31, 31, 31, 33, 31, // Juz 21-30
  ];

  @override
  void initState() {
    super.initState();
    _totalPages = _paraPageCounts[widget.paraNumber - 1];
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _getPageImageUrl(int pageIndex) {
    final juz = widget.paraNumber.toString().padLeft(2, '0');
    // pageIndex 0 = file 0002 (first Quran content page)
    final fileNum = (pageIndex + 2).toString().padLeft(4, '0');
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
          '${context.tr('para_label')} ${widget.paraNumber} - ${widget.paraName}',
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
      body: PageView.builder(
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
    );
  }
}
