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
import '../../core/utils/ad_navigation.dart';
import '../../core/services/content_service.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ContentService _contentService = ContentService();
  String _searchQuery = '';

  // Firebase content
  QuranScreenContentFirestore? _quranContent;
  bool _isContentLoading = true;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  // Get Surah name based on language
  String _getSurahName(int surahNumber, QuranLanguage language) {
    if (_quranContent == null) return 'Surah $surahNumber';
    final langCode = _langCodeFromQuranLanguage(language);
    return _quranContent!.getSurahName(surahNumber, langCode);
  }

  // Get Para name based on language
  String _getParaName(int paraNumber, QuranLanguage language) {
    if (_quranContent == null) return 'Para $paraNumber';
    final langCode = _langCodeFromQuranLanguage(language);
    return _quranContent!.getParaName(paraNumber, langCode);
  }

  String _langCodeFromQuranLanguage(QuranLanguage language) {
    switch (language) {
      case QuranLanguage.hindi:
        return 'hi';
      case QuranLanguage.urdu:
        return 'ur';
      case QuranLanguage.arabic:
        return 'ar';
      default:
        return 'en';
    }
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
          ),
          body: Consumer<QuranProvider>(
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
                        enableVoiceSearch: true,
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

    // Get Surah names for range display (localized based on selected language)
    final startSurahName = _getSurahName(
      juz.startSurah,
      provider.selectedLanguage,
    );
    final endSurahName = _getSurahName(juz.endSurah, provider.selectedLanguage);

    return Container(
      margin: responsive.paddingOnly(bottom: 10),
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
          AdNavigator.push(context, JuzDetailScreen(juzNumber: juz.number));
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
                              _getParaName(
                                juz.number,
                                provider.selectedLanguage,
                              ),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                                fontFamily:
                                    provider.selectedLanguage ==
                                            QuranLanguage.arabic ||
                                        provider.selectedLanguage ==
                                            QuranLanguage.urdu
                                    ? 'Poppins'
                                    : null,
                              ),
                              textDirection:
                                  provider.selectedLanguage ==
                                          QuranLanguage.arabic ||
                                      provider.selectedLanguage ==
                                          QuranLanguage.urdu
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
