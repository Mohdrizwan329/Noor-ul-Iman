import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/surah_model.dart';
import '../../data/models/firestore_models.dart';
import '../../widgets/common/search_bar_widget.dart';
import 'juz_detail_screen.dart';
import 'pdf_para_viewer_screen.dart';
import '../../core/services/content_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ContentService _contentService = ContentService();
  String _searchQuery = '';
  late TabController _tabController;

  // Firebase content
  QuranScreenContentFirestore? _quranContent;
  bool _isContentLoading = true;

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
        _isContentLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Get Surah name based on app language
  String _getSurahName(int surahNumber, String langCode) {
    if (_quranContent == null) return 'Surah $surahNumber';
    return _quranContent!.getSurahName(surahNumber, langCode);
  }

  // Get Para name based on app language
  String _getParaName(int paraNumber, String langCode) {
    if (_quranContent == null) return 'Para $paraNumber';
    return _quranContent!.getParaName(paraNumber, langCode);
  }

  List<JuzInfo> _getFilteredJuz(List<JuzInfo> juzList, QuranProvider provider) {
    if (_searchQuery.isEmpty) {
      return juzList;
    }
    final query = _searchQuery.toLowerCase();
    return juzList.where((juz) {
      // Get surah names for this juz
      String startSurahName = '';
      String endSurahName = '';
      if (provider.surahList.isNotEmpty) {
        final startSurah = provider.surahList.firstWhere(
          (s) => s.number == juz.startSurah,
          orElse: () => provider.surahList.first,
        );
        final endSurah = provider.surahList.firstWhere(
          (s) => s.number == juz.endSurah,
          orElse: () => provider.surahList.first,
        );
        startSurahName = startSurah.englishName.toLowerCase();
        endSurahName = endSurah.englishName.toLowerCase();
      }

      return juz.number.toString().contains(query) ||
          juz.arabicName.contains(query) ||
          startSurahName.contains(query) ||
          endSurahName.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    if (_isContentLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    // Listen to language changes to rebuild UI
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(context.tr('para')),
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
                Tab(text: context.tr('para')),
                Tab(text: context.tr('mushaf')),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildParaTab(responsive),
              _buildPdfParaTab(responsive),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParaTab(ResponsiveUtils responsive) {
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
                Icon(
                  Icons.error_outline,
                  size: responsive.iconHuge,
                  color: Colors.grey,
                ),
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

        // Para List with Search
        final filteredJuz = _getFilteredJuz(provider.juzList, provider);

        return Column(
          children: [
            // Last read section
            if (provider.lastReadSurah > 0)
              Padding(
                padding: responsive.paddingOnly(
                  left: 16,
                  top: 12,
                  right: 16,
                ),
                child: SearchBarWidget(
                  controller: _searchController,
                  hintText: context.tr('search_para'),
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
            Expanded(
              child: filteredJuz.isEmpty
                  ? Center(
                      child: Text(
                        context.tr('no_results_found'),
                        style: TextStyle(
                          fontSize: responsive.textMedium,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: responsive.paddingRegular,
                      itemCount: filteredJuz.length,
                      itemBuilder: (context, index) {
                        return _buildJuzCard(
                          context,
                          filteredJuz[index],
                          provider,
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPdfParaTab(ResponsiveUtils responsive) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    final langCode = context.languageProvider.languageCode;

    return ListView.builder(
      padding: responsive.paddingRegular,
      itemCount: 30,
      itemBuilder: (context, index) {
        final paraNumber = index + 1;
        final paraName = _getParaName(paraNumber, langCode);

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
                  builder: (_) => PdfParaViewerScreen(
                    paraNumber: paraNumber,
                    paraName: paraName,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(responsive.radiusLarge),
            child: Padding(
              padding: responsive.paddingAll(14),
              child: Row(
                children: [
                  // Para Number
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
                        '$paraNumber',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.textLarge,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(14)),

                  // Para Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '${context.tr('para_label')} $paraNumber',
                                style: TextStyle(
                                  fontSize: responsive.textSmall,
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            responsive.hSpaceXSmall,
                            Flexible(
                              child: Container(
                                padding: responsive.paddingSymmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F3ED),
                                  borderRadius: BorderRadius.circular(
                                    responsive.radiusSmall,
                                  ),
                                ),
                                child: Text(
                                  paraName,
                                  style: TextStyle(
                                    fontSize: responsive.textXSmall,
                                    fontWeight: FontWeight.w600,
                                    color: emeraldGreen,
                                    fontFamily:
                                        langCode == 'ar' || langCode == 'ur'
                                        ? 'Poppins'
                                        : null,
                                  ),
                                  textDirection:
                                      langCode == 'ar' || langCode == 'ur'
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.spacing(2)),
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book_rounded,
                              size: responsive.fontSize(12),
                              color: emeraldGreen,
                            ),
                            SizedBox(width: responsive.spacing(4)),
                            Text(
                              context.tr('quran_pages'),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Arrow
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
      },
    );
  }

  Widget _buildJuzCard(
    BuildContext context,
    JuzInfo juz,
    QuranProvider provider,
  ) {
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);

    // Get Surah names for range display (localized based on app language)
    final langCode = context.languageProvider.languageCode;
    final startSurahName = _getSurahName(juz.startSurah, langCode);
    final endSurahName = _getSurahName(juz.endSurah, langCode);

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
          Navigator.push(context, MaterialPageRoute(builder: (_) => JuzDetailScreen(juzNumber: juz.number)));
        },
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Juz Number
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
                    '${juz.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              SizedBox(width: responsive.spacing(14)),

              // Juz Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${context.tr('para_label')} ${juz.number}',
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        responsive.hSpaceXSmall,
                        Flexible(
                          child: Container(
                            padding: responsive.paddingSymmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F3ED),
                              borderRadius: BorderRadius.circular(
                                responsive.radiusSmall,
                              ),
                            ),
                            child: Text(
                              _getParaName(juz.number, langCode),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                                fontFamily:
                                    langCode == 'ar' || langCode == 'ur'
                                    ? 'Poppins'
                                    : null,
                              ),
                              textDirection:
                                  langCode == 'ar' || langCode == 'ur'
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(4)),
                    // Surah range info
                    if (startSurahName.isNotEmpty)
                      Text(
                        juz.startSurah == juz.endSurah
                            ? startSurahName
                            : '$startSurahName - $endSurahName',
                        style: TextStyle(
                          fontSize: responsive.textXSmall,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: responsive.spacing(2)),
                    // Ayah range
                    Text(
                      '${context.tr('ayah')} ${juz.startAyah} - ${juz.endAyah}',
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow only
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
}
