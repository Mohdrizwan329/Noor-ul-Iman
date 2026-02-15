import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/hadith_translator.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/hadith_model.dart';
import '../../widgets/common/search_bar_widget.dart';
import '../../widgets/common/chip_badge.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import '../../core/services/content_service.dart';

class HadithBookDetailScreen extends StatefulWidget {
  final HadithCollection collection;
  final int bookNumber;
  final String bookName;
  final String bookArabicName;
  final String bookUrduName;
  final String bookHindiName;

  const HadithBookDetailScreen({
    super.key,
    required this.collection,
    required this.bookNumber,
    required this.bookName,
    required this.bookArabicName,
    this.bookUrduName = '',
    this.bookHindiName = '',
  });

  @override
  State<HadithBookDetailScreen> createState() => _HadithBookDetailScreenState();
}

class _HadithBookDetailScreenState extends State<HadithBookDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  final Set<int> _cardsWithTranslation = {};
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  final ContentService _contentService = ContentService();
  int? _playingCardIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initAudioPlayer();
    _loadHadithTranslations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hadithProvider = context.read<HadithProvider>();
      final langCode = context.read<LanguageProvider>().languageCode;
      hadithProvider.syncWithAppLanguage(langCode);
      hadithProvider.fetchChapterHadiths(
        widget.collection,
        widget.bookNumber,
      );
    });
  }

  Future<void> _loadHadithTranslations() async {
    try {
      final data = await _contentService.getHadithTranslations();
      if (data.isNotEmpty) {
        HadithTranslator.loadFromFirestore(data);
      }
    } catch (e) {
      debugPrint('HadithBookDetail: Error loading translations: $e');
    }
  }

  void _initAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
            _playingCardIndex = null;
          });
        }
      }
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);

    // Enhanced settings for better Arabic pronunciation
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // Set initial speech rate (will be adjusted based on language)
    await _flutterTts.setSpeechRate(0.45);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playingCardIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _playingCardIndex = null;
        });
      }
    });

    _flutterTts.setStartHandler(() {
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    });
  }

  Future<void> playHadith(
    HadithModel hadith,
    HadithLanguage language,
    int cardIndex,
    bool showTranslation,
  ) async {
    if (_playingCardIndex == cardIndex && _isPlaying) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    String textToSpeak = '';
    String ttsLangCode = 'en-US';
    double speechRate = 0.45; // Default speech rate

    if (showTranslation) {
      // Cool mode - Play translation
      switch (language) {
        case HadithLanguage.english:
          textToSpeak = hadith.english;
          ttsLangCode = 'en-US';
          speechRate = 0.5; // Normal speed for English
          break;
        case HadithLanguage.urdu:
          textToSpeak = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
          if (hadith.urdu.isNotEmpty) {
            ttsLangCode = await _isLanguageAvailable('ur-PK')
                ? 'ur-PK'
                : 'en-US';
            speechRate = 0.42; // Slightly slower for Urdu
          } else {
            ttsLangCode = 'en-US';
            speechRate = 0.5;
          }
          break;
        case HadithLanguage.hindi:
          if (hadith.hindi.isNotEmpty) {
            textToSpeak = hadith.hindi;
            ttsLangCode = await _isLanguageAvailable('hi-IN')
                ? 'hi-IN'
                : 'en-US';
            speechRate = 0.45;
          } else {
            textToSpeak = hadith.english;
            ttsLangCode = 'en-US';
            speechRate = 0.5;
          }
          break;
        case HadithLanguage.arabic:
          textToSpeak = hadith.arabic;
          ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
          speechRate = 0.38; // Slower for Arabic
          break;
      }
    } else {
      // Normal mode - Play Arabic
      textToSpeak = hadith.arabic;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      speechRate = 0.38; // Slower for Arabic to ensure proper pronunciation
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {}
      return;
    }

    // Clean text for better TTS (remove HTML tags, extra spaces, etc.)
    textToSpeak = _cleanTextForTts(textToSpeak);

    await _flutterTts.setLanguage(ttsLangCode);
    await _flutterTts.setSpeechRate(speechRate);

    setState(() {
      _playingCardIndex = cardIndex;
      _isPlaying = true;
    });

    await _flutterTts.speak(textToSpeak);
  }

  // Clean text for better TTS pronunciation
  String _cleanTextForTts(String text) {
    String cleaned = text;

    // Remove HTML tags
    cleaned = cleaned.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove extra whitespace
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Remove brackets and their content (often references)
    cleaned = cleaned.replaceAll(RegExp(r'\[.*?\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\(.*?\)'), '');

    return cleaned.trim();
  }

  Future<bool> _isLanguageAvailable(String langCode) async {
    try {
      final result = await _flutterTts.isLanguageAvailable(langCode);
      return result == 1 || result == true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _stopPlaying() async {
    await _audioPlayer.stop();
    await _flutterTts.stop();
    setState(() {
      _isPlaying = false;
      _playingCardIndex = null;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void toggleCardTranslation(int cardIndex) {
    setState(() {
      if (_cardsWithTranslation.contains(cardIndex)) {
        _cardsWithTranslation.remove(cardIndex);
      } else {
        _cardsWithTranslation.add(cardIndex);
      }
    });
  }

  List<HadithModel> getFilteredHadiths(HadithProvider provider) {
    if (_searchQuery.isEmpty) return provider.currentHadiths;
    return provider.searchHadiths(_searchQuery);
  }

  String _getBookNameForLanguage(BuildContext context) {
    final languageCode = context.watch<LanguageProvider>().languageCode;
    switch (languageCode) {
      case 'ur':
        return widget.bookUrduName.isNotEmpty
            ? widget.bookUrduName
            : widget.bookName;
      case 'hi':
        return widget.bookHindiName.isNotEmpty
            ? widget.bookHindiName
            : widget.bookName;
      case 'ar':
        return widget.bookArabicName;
      default:
        return widget.bookName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          _getBookNameForLanguage(context),
          style: TextStyle(color: Colors.white, fontSize: responsive.textRegular),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: responsive.paddingAll(12),
                child: SearchBarWidget(
                  controller: _searchController,
                  hintText: context.tr('search_hadith'),
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
              Padding(
                padding: responsive.paddingSymmetric(horizontal: 12),
                child: Row(
                  children: [
                    ChipBadge(
                      text:
                          '${getFilteredHadiths(provider).length} ${context.tr('hadiths')}',
                      backgroundColor: const Color(0xFFE8F3ED),
                      textColor: const Color(0xFF1E8F5A),
                    ),
                    SizedBox(width: responsive.spaceSmall),
                    ChipBadge(
                      text: '${context.tr('book')} ${widget.bookNumber}',
                      backgroundColor: const Color(
                        0xFF0A5C36,
                      ).withValues(alpha: 0.1),
                      textColor: const Color(0xFF0A5C36),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spaceRegular),
              Expanded(child: buildHadithList(provider, settings)),
              const BannerAdWidget(),
            ],
          );
        },
      ),
    );
  }

  Widget buildHadithList(HadithProvider provider, SettingsProvider settings) {
    final responsive = context.responsive;

    if (provider.isLoading && provider.currentHadiths.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.error != null && provider.currentHadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: responsive.iconXXLarge,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: responsive.spaceRegular),
            Text(
              provider.error ?? context.tr('error'),
              style: TextStyle(color: AppColors.primary, fontSize: responsive.textMedium),
            ),
            SizedBox(height: responsive.spaceSmall),
            ElevatedButton(
              onPressed: () {
                provider.fetchChapterHadiths(
                  widget.collection,
                  widget.bookNumber,
                );
              },
              child: Text(context.tr('retry')),
            ),
          ],
        ),
      );
    }

    final hadiths = getFilteredHadiths(provider);
    if (hadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: responsive.iconXXLarge,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: responsive.spaceRegular),
            Text(
              context.tr('no_hadiths_found'),
              style: TextStyle(color: AppColors.primary, fontSize: responsive.textMedium),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: responsive.paddingSymmetric(horizontal: 12),
      itemCount: AdListHelper.totalCount(hadiths.length),
      itemBuilder: (context, index) {
        if (AdListHelper.isAdPosition(index)) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: BannerAdWidget(height: 250),
          );
        }
        final dataIdx = AdListHelper.dataIndex(index);
        return _buildHadithCard(
          hadiths[dataIdx],
          provider,
          settings.arabicFontSize,
          settings.translationFontSize,
          dataIdx,
          context.watch<LanguageProvider>().languageCode,
        );
      },
    );
  }

  Widget _buildHadithCard(
    HadithModel hadith,
    HadithProvider provider,
    double arabicFontSize,
    double translationFontSize,
    int cardIndex,
    String languageCode,
  ) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    final responsive = context.responsive;
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final isPlaying = _playingCardIndex == cardIndex && _isPlaying;

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying ? emeraldGreen : lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? emeraldGreen.withValues(alpha: 0.1)
                  : lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isPlaying ? emeraldGreen : darkGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withValues(alpha: 0.3),
                            blurRadius: 6.0,
                            offset: Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${cardIndex + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.textSmall,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.spaceMedium),
                    Expanded(
                      child: Text(
                        '${context.tr('hadith_number')}${hadith.hadithNumber}',
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.w600,
                          color: darkGreen,
                        ),
                      ),
                    ),
                    if (hadith.grade.isNotEmpty)
                      ChipBadge(
                        text: HadithTranslator.translateGrade(
                          hadith.grade,
                          languageCode,
                        ),
                        backgroundColor: _getGradeColor(hadith.grade),
                        textColor: Colors.white,
                      ),
                  ],
                ),
                SizedBox(height: responsive.spaceSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _headerActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying
                          ? context.tr('stop')
                          : (showTranslation
                                ? context.tr('cool')
                                : context.tr('normal')),
                      onTap: () => playHadith(
                        hadith,
                        provider.selectedLanguage,
                        cardIndex,
                        showTranslation,
                      ),
                      isActive: isPlaying,
                      responsive: responsive,
                      additionalWidget: !isPlaying && showTranslation
                          ? Container(
                              width: responsive.spacing(8),
                              height: responsive.spacing(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A90E2),
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                    _headerActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                      responsive: responsive,
                    ),
                    _headerActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () =>
                          _copyHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                      responsive: responsive,
                    ),
                    _headerActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () =>
                          _shareHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                      responsive: responsive,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hadith.arabic.isNotEmpty)
            Padding(
              padding: responsive.paddingRegular,
              child: Container(
                padding: isPlaying && !showTranslation
                    ? responsive.paddingAll(8)
                    : EdgeInsets.zero,
                decoration: (isPlaying && !showTranslation)
                    ? BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusMedium,
                        ),
                      )
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlaying && !showTranslation)
                      Padding(
                        padding: responsive.paddingOnly(right: 8, top: 8),
                        child: Icon(
                          Icons.volume_up,
                          size: responsive.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        hadith.arabic,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: arabicFontSize,
                          height: 2.0,
                          color: (isPlaying && !showTranslation)
                              ? AppColors.primary
                              : AppColors.arabicText,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showTranslation)
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3ED).withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(responsive.radiusLarge),
                  bottomRight: Radius.circular(responsive.radiusLarge),
                ),
              ),
              child: Container(
                padding: isPlaying && showTranslation
                    ? responsive.paddingAll(8)
                    : EdgeInsets.zero,
                decoration: (isPlaying && showTranslation)
                    ? BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusMedium,
                        ),
                      )
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlaying && showTranslation)
                      Padding(
                        padding: responsive.paddingOnly(right: 8, top: 4),
                        child: Icon(
                          Icons.volume_up,
                          size: responsive.iconSmall,
                          color: AppColors.primary,
                        ),
                      ),
                    Expanded(
                        child: _buildTranslationText(
                          hadith,
                          languageCode,
                          translationFontSize,
                          isPlaying && showTranslation,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: lightGreenBorder.withValues(alpha: 0.5)),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              HadithTranslator.translateReference(
                hadith.reference,
                languageCode,
              ),
              style: const TextStyle(
                fontSize: 11,
                color: emeraldGreen,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Get the best translation text for the current language
  String _getTranslationForDisplay(HadithModel hadith, String langCode) {
    switch (langCode) {
      case 'ur':
        return hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
      case 'ar':
        return hadith.arabic;
      case 'hi':
        return hadith.hindi.isNotEmpty ? hadith.hindi : hadith.english;
      default:
        return hadith.english;
    }
  }

  /// Check if language code is RTL
  bool _isRtlLanguage(String langCode, HadithModel hadith) {
    switch (langCode) {
      case 'ur':
        return hadith.urdu.isNotEmpty;
      case 'ar':
        return true;
      default:
        return false;
    }
  }

  Widget _buildTranslationText(
    HadithModel hadith,
    String langCode,
    double fontSize,
    bool isHighlighted,
  ) {
    final textColor = isHighlighted ? AppColors.primary : Colors.black87;
    final text = _getTranslationForDisplay(hadith, langCode);
    final isRtl = _isRtlLanguage(langCode, hadith);

    if (text.isEmpty) {
      return Text(
        context.tr('no_translation_available'),
        style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
      );
    }

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        height: isRtl ? 1.8 : 1.5,
        fontFamily: isRtl ? 'Poppins' : null,
        color: textColor,
      ),
      textDirection: isRtl ? TextDirection.rtl : null,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }

  Widget _headerActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    required ResponsiveUtils responsive,
    Widget? additionalWidget,
  }) {
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const darkGreen = Color(0xFF0A5C36);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? emeraldGreen : lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusSmall),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Icon(
                    icon,
                    size: responsive.iconMedium,
                    color: isActive ? Colors.white : darkGreen,
                  ),
                  if (additionalWidget != null)
                    Positioned(right: -4, top: -4, child: additionalWidget),
                ],
              ),
              SizedBox(height: 2.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive ? Colors.white : darkGreen,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyHadith(HadithModel hadith, HadithLanguage language) {
    final langCode = context.read<LanguageProvider>().languageCode;
    final translation = _getTranslationForDisplay(hadith, langCode);

    ActionHelpers.copyFormattedContent(
      context,
      arabicText: hadith.arabic,
      translation: translation,
      reference: HadithTranslator.translateReference(
        hadith.reference,
        langCode,
      ),
    );
  }

  void _shareHadith(HadithModel hadith, HadithLanguage language) {
    final langCode = context.read<LanguageProvider>().languageCode;
    final translation = _getTranslationForDisplay(hadith, langCode);

    ActionHelpers.shareFormattedContent(
      arabicText: hadith.arabic,
      translation: translation,
      reference: HadithTranslator.translateReference(
        hadith.reference,
        langCode,
      ),
    );
  }

  Color _getGradeColor(String grade) {
    final lowerGrade = grade.toLowerCase();
    if (lowerGrade.contains('sahih')) {
      return AppColors.success;
    } else if (lowerGrade.contains('hasan')) {
      return Colors.orange;
    } else if (lowerGrade.contains('daif') || lowerGrade.contains('weak')) {
      return Colors.red;
    }
    return AppColors.textSecondary;
  }
}
