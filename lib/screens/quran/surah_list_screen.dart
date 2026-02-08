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
import '../../core/services/content_service.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ContentService _contentService = ContentService();
  String _searchQuery = '';

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
                  enableVoiceSearch: true,
                ),
              ),

              // Surah List
              Expanded(
                child: ListView.builder(
                  key: ValueKey(langProvider.languageCode),
                  padding: responsive.paddingRegular,
                  itemCount: surahList.length,
                  itemBuilder: (context, index) {
                    return _buildSurahCard(context, surahList[index], langProvider.languageCode);
                  },
                ),
              ),
              const BannerAdWidget(),
            ],
          );
        },
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
      margin: responsive.paddingOnly(bottom: 10),
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
