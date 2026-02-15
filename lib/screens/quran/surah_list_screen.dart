import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/surah_model.dart';
import '../../data/models/firestore_models.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'surah_detail_screen.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import '../../core/services/content_service.dart';
import 'pdf_surah_viewer_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mushafSearchController = TextEditingController();
  final ContentService _contentService = ContentService();
  String _searchQuery = '';
  String _mushafSearchQuery = '';
  late TabController _tabController;

  // Surah number (1-indexed) to Para/Juz number mapping
  static const List<int> _surahToParaMap = [
    1, 1, 3, 4, 6, 7, 8, 9, 10, 11,       // Surah 1-10
    11, 12, 13, 13, 14, 14, 15, 15, 16, 16, // Surah 11-20
    17, 17, 18, 18, 18, 19, 19, 20, 20, 21, // Surah 21-30
    21, 21, 21, 22, 22, 22, 23, 23, 23, 24, // Surah 31-40
    24, 25, 25, 25, 25, 26, 26, 26, 26, 26, // Surah 41-50
    26, 27, 27, 27, 27, 27, 27, 28, 28, 28, // Surah 51-60
    28, 28, 28, 28, 28, 28, 29, 29, 29, 29, // Surah 61-70
    29, 29, 29, 29, 29, 29, 29, 30, 30, 30, // Surah 71-80
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // Surah 81-90
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // Surah 91-100
    30, 30, 30, 30, 30, 30, 30, 30, 30, 30, // Surah 101-110
    30, 30, 30, 30,                           // Surah 111-114
  ];

  // Firebase content
  QuranScreenContentFirestore? _quranContent;

  String _cleanArabicName(String arabicName) {
    return arabicName
        .replaceAll('سُورَةُ ', '')
        .replaceAll('سورة ', '')
        .replaceAll(RegExp(r'[ًٌٍَُِّْٰۡـٓ]'), '')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ى', 'ي')
        .trim();
  }

  // Get transliterated Surah name for Urdu from Firebase
  String _getUrduName(String arabicName) {
    final cleanName = _cleanArabicName(arabicName);
    if (_quranContent != null) {
      return _quranContent!.getUrduTransliteration(cleanName, arabicName);
    }
    return arabicName;
  }

  // Get transliterated Surah name for Hindi from Firebase
  String _getHindiName(String arabicName) {
    final cleanName = _cleanArabicName(arabicName);
    if (_quranContent != null) {
      return _quranContent!.getHindiTransliteration(cleanName, arabicName);
    }
    return arabicName;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().initialize();
      _loadContent();
    });
  }

  Future<void> _loadContent() async {
    final content = await _contentService.getQuranScreenContent();
    if (mounted) {
      setState(() {
        _quranContent = content;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mushafSearchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          context.tr('surah'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: TextStyle(
            fontSize: responsive.fontSize(14),
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: responsive.fontSize(14),
          ),
          tabs: [
            Tab(text: context.tr('surah')),
            Tab(text: context.tr('mushaf')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSurahTab(langProvider),
          _buildMushafTab(langProvider),
        ],
      ),
    );
  }

  Widget _buildSurahTab(LanguageProvider langProvider) {
    final responsive = context.responsive;

    return Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.surahList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.error != null && provider.surahList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: responsive.iconHuge, color: Colors.grey),
                  responsive.vSpaceRegular,
                  Text(provider.error!),
                  responsive.vSpaceRegular,
                  ElevatedButton(
                    onPressed: () => provider.fetchSurahList(),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          final surahList = provider.searchSurah(_searchQuery);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: responsive.paddingOnly(left: 16, top: 12, right: 16),
                child: SearchBarWidget(
                  controller: _searchController,
                  hintText: context.tr('search_surah'),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onClear: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),

              // Surah List
              Expanded(
                child: ListView.builder(
                  key: ValueKey(langProvider.languageCode),
                  padding: responsive.paddingRegular,
                  itemCount: AdListHelper.totalCount(surahList.length),
                  itemBuilder: (context, index) {
                    if (AdListHelper.isAdPosition(index)) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: BannerAdWidget(height: 250),
                      );
                    }
                    final dataIdx = AdListHelper.dataIndex(index);
                    return _buildSurahCard(context, surahList[dataIdx], langProvider.languageCode);
                  },
                ),
              ),
              const BannerAdWidget(),
            ],
          );
        },
    );
  }

  Widget _buildMushafTab(LanguageProvider langProvider) {
    final responsive = context.responsive;

    return Consumer<QuranProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.surahList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final surahList = provider.searchSurah(_mushafSearchQuery);

        return Column(
          children: [
            Padding(
              padding: responsive.paddingOnly(left: 16, top: 12, right: 16),
              child: SearchBarWidget(
                controller: _mushafSearchController,
                hintText: context.tr('search_surah'),
                onChanged: (value) {
                  setState(() {
                    _mushafSearchQuery = value;
                  });
                },
                onClear: () {
                  setState(() {
                    _mushafSearchQuery = '';
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                key: ValueKey('mushaf_${langProvider.languageCode}'),
                padding: responsive.paddingRegular,
                itemCount: AdListHelper.totalCount(surahList.length),
                itemBuilder: (context, index) {
                  if (AdListHelper.isAdPosition(index)) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: BannerAdWidget(height: 250),
                    );
                  }
                  final dataIdx = AdListHelper.dataIndex(index);
                  return _buildMushafSurahCard(
                    context,
                    surahList[dataIdx],
                    langProvider.languageCode,
                  );
                },
              ),
            ),
            const BannerAdWidget(),
          ],
        );
      },
    );
  }

  Widget _buildMushafSurahCard(BuildContext context, SurahInfo surah, String languageCode) {
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    String displayName;
    if (_quranContent != null) {
      displayName = _quranContent!.getSurahName(surah.number, languageCode);
    } else {
      switch (languageCode) {
        case 'ar':
          displayName = surah.name;
          break;
        case 'ur':
          displayName = _getUrduName(surah.name);
          break;
        case 'hi':
          displayName = _getHindiName(surah.name);
          break;
        case 'en':
        default:
          displayName = surah.englishName;
      }
    }

    final paraNumber = _surahToParaMap[surah.number - 1];

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfSurahViewerScreen(
                surahNumber: surah.number,
                surahName: displayName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (languageCode == 'ar' || languageCode == 'ur')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            size: responsive.fontSize(12),
                            color: emeraldGreen,
                          ),
                          SizedBox(width: responsive.spacing(4)),
                          Text(
                            '${context.tr('para_label')} $paraNumber',
                            style: TextStyle(
                              fontSize: responsive.textXSmall,
                              fontWeight: FontWeight.w600,
                              color: emeraldGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: emeraldGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahCard(BuildContext context, SurahInfo surah, String languageCode) {
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    // Get display name based on language - all from Firebase
    String displayName;
    if (_quranContent != null) {
      displayName = _quranContent!.getSurahName(surah.number, languageCode);
    } else {
      switch (languageCode) {
        case 'ar':
          displayName = surah.name;
          break;
        case 'ur':
          displayName = _getUrduName(surah.name);
          break;
        case 'hi':
          displayName = _getHindiName(surah.name);
          break;
        case 'en':
        default:
          displayName = surah.englishName;
      }
    }

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          AdNavigator.push(context, SurahDetailScreen(surahNumber: surah.number));
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Surah Number Badge
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${surah.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Surah Name and Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Surah Name (Language-based)
                    Text(
                      displayName,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (languageCode == 'ar' || languageCode == 'ur')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Ayahs count chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Text(
                        '${surah.numberOfAyahs} ${context.tr('ayahs')}',
                        style: TextStyle(
                          fontSize: responsive.textXSmall,
                          fontWeight: FontWeight.w600,
                          color: emeraldGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8F5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.iconSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
