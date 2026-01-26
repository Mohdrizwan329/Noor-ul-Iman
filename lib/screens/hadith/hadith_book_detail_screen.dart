import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/utils/hadith_translator.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/hadith_model.dart';
import '../../widgets/common/search_bar_widget.dart';

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
  int? _playingCardIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initAudioPlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().fetchChapterHadiths(
        widget.collection,
        widget.bookNumber,
      );
    });
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${context.tr('audio_error')}: $message'),
            duration: const Duration(seconds: 2),
          ),
        );
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
          textToSpeak = hadith.hindi.isNotEmpty ? hadith.hindi : hadith.english;
          if (hadith.hindi.isNotEmpty) {
            ttsLangCode = await _isLanguageAvailable('hi-IN')
                ? 'hi-IN'
                : 'en-US';
            speechRate = 0.45; // Moderate speed for Hindi
          } else {
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              showTranslation
                  ? context.tr('no_translation_available_audio')
                  : context.tr('no_arabic_text_available'),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
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
        return widget.bookUrduName.isNotEmpty ? widget.bookUrduName : widget.bookName;
      case 'hi':
        return widget.bookHindiName.isNotEmpty ? widget.bookHindiName : widget.bookName;
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
          style: TextStyle(fontSize: responsive.textRegular),
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
                  enableVoiceSearch: true,
                ),
              ),
              Padding(
                padding: responsive.paddingSymmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusMedium,
                        ),
                      ),
                      child: Text(
                        '${getFilteredHadiths(provider).length} ${context.tr('hadiths')}',
                        style: TextStyle(
                          color: const Color(0xFF1E8F5A),
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.textSmall,
                        ),
                      ),
                    ),
                    SizedBox(width: responsive.spaceSmall),
                    Container(
                      padding: responsive.paddingSymmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A5C36).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          responsive.radiusMedium,
                        ),
                      ),
                      child: Text(
                        '${context.tr('book')} ${widget.bookNumber}',
                        style: TextStyle(
                          color: const Color(0xFF0A5C36),
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.textSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spaceRegular),
              Expanded(child: buildHadithList(provider, settings)),
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
              style: TextStyle(fontSize: responsive.textMedium),
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
              style: TextStyle(fontSize: responsive.textMedium),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: responsive.paddingSymmetric(horizontal: 12),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        return _buildHadithCard(
          hadiths[index],
          provider,
          settings.arabicFontSize,
          settings.translationFontSize,
          index,
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
    final isFav = provider.isFavorite(widget.collection, hadith.hadithNumber);
    final isPlaying = _playingCardIndex == cardIndex && _isPlaying;

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
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
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
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
                            blurRadius: responsive.spacing(6),
                            offset: Offset(0, responsive.spacing(2)),
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
                      Container(
                        padding: responsive.paddingSymmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getGradeColor(hadith.grade),
                          borderRadius: BorderRadius.circular(
                            responsive.radiusSmall,
                          ),
                        ),
                        child: Text(
                          HadithTranslator.translateGrade(
                            hadith.grade,
                            languageCode,
                          ),
                          style: TextStyle(
                            fontSize: responsive.textXSmall,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                          : (showTranslation ? context.tr('cool') : context.tr('normal')),
                      onTap: () => playHadith(
                        hadith,
                        provider.selectedLanguage,
                        cardIndex,
                        showTranslation,
                      ),
                      isActive: isPlaying,
                      additionalWidget: !isPlaying && showTranslation
                          ? Container(
                              width: 8,
                              height: 8,
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
                    ),
                    _headerActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () =>
                          _copyHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                    ),
                    _headerActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () =>
                          _shareHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                    ),
                    _headerActionButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      label: context.tr('favorite'),
                      onTap: () => provider.toggleFavorite(
                        widget.collection,
                        hadith.hadithNumber,
                      ),
                      isActive: isFav,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hadith.arabic.isNotEmpty)
            Padding(
              padding: responsive.paddingRegular,
              child: GestureDetector(
                onTap: () {
                  if (isPlaying && !showTranslation) {
                    _stopPlaying();
                  } else if (!showTranslation) {
                    playHadith(
                      hadith,
                      provider.selectedLanguage,
                      cardIndex,
                      false,
                    );
                  }
                },
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
                            fontFamily: 'Amiri',
                            fontSize: arabicFontSize,
                            height: 2.0,
                            color: (isPlaying && !showTranslation)
                                ? AppColors.primary
                                : AppColors.arabicText,
                          ),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
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
              child: GestureDetector(
                onTap: () {
                  if (isPlaying && showTranslation) {
                    _stopPlaying();
                  } else {
                    playHadith(
                      hadith,
                      provider.selectedLanguage,
                      cardIndex,
                      true,
                    );
                  }
                },
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (provider.selectedLanguage ==
                                HadithLanguage.hindi) ...[
                              if (hadith.hindi.isNotEmpty)
                                Text(
                                  hadith.hindi,
                                  style: TextStyle(
                                    fontSize: translationFontSize,
                                    height: 1.5,
                                    color: (isPlaying && showTranslation)
                                        ? AppColors.primary
                                        : Colors.black87,
                                  ),
                                )
                              else if (hadith.english.isNotEmpty) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 12,
                                        height: 12,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.orange.shade800,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.tr('translating_to_hindi'),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  hadith.english,
                                  style: TextStyle(
                                    fontSize: translationFontSize,
                                    height: 1.5,
                                    color: (isPlaying && showTranslation)
                                        ? AppColors.primary
                                        : Colors.black54,
                                  ),
                                ),
                              ] else
                                Text(
                                  context.tr('no_translation_available'),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ] else if (provider.selectedLanguage ==
                                    HadithLanguage.arabic &&
                                hadith.arabic.isNotEmpty)
                              Text(
                                hadith.arabic,
                                style: TextStyle(
                                  fontSize: translationFontSize,
                                  height: 1.5,
                                  fontFamily: 'Amiri',
                                  color: (isPlaying && showTranslation)
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                                textDirection: TextDirection.rtl,
                              )
                            else if (provider.selectedLanguage ==
                                    HadithLanguage.english &&
                                hadith.english.isNotEmpty)
                              Text(
                                hadith.english,
                                style: TextStyle(
                                  fontSize: translationFontSize,
                                  height: 1.5,
                                  color: (isPlaying && showTranslation)
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              )
                            else if (provider.selectedLanguage ==
                                    HadithLanguage.urdu &&
                                hadith.urdu.isNotEmpty)
                              Text(
                                hadith.urdu,
                                style: TextStyle(
                                  fontSize: translationFontSize,
                                  height: 1.5,
                                  fontFamily: 'Amiri',
                                  color: (isPlaying && showTranslation)
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                                textDirection: TextDirection.rtl,
                              )
                            else if (hadith.english.isNotEmpty)
                              Text(
                                hadith.english,
                                style: TextStyle(
                                  fontSize: translationFontSize,
                                  height: 1.5,
                                  color: (isPlaying && showTranslation)
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                              )
                            else
                              Text(
                                context.tr('no_translation_available'),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget _headerActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    Widget? additionalWidget,
  }) {
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const darkGreen = Color(0xFF0A5C36);
    final responsive = context.responsive;

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
              SizedBox(height: responsive.spacing(2)),
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
    String translation = '';
    String languageCode = 'en';

    if (language == HadithLanguage.arabic) {
      translation = hadith.arabic;
      languageCode = 'ar';
    } else if (language == HadithLanguage.hindi && hadith.hindi.isNotEmpty) {
      translation = hadith.hindi;
      languageCode = 'hi';
    } else if (language == HadithLanguage.urdu && hadith.urdu.isNotEmpty) {
      translation = hadith.urdu;
      languageCode = 'ur';
    } else if (hadith.english.isNotEmpty) {
      translation = hadith.english;
      languageCode = 'en';
    }

    final translatedReference = HadithTranslator.translateReference(
      hadith.reference,
      languageCode,
    );
    final text = '${hadith.arabic}\n\n$translation\n\n— $translatedReference';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('copied'))));
  }

  void _shareHadith(HadithModel hadith, HadithLanguage language) {
    String translation = '';
    String languageCode = 'en';

    if (language == HadithLanguage.arabic) {
      translation = hadith.arabic;
      languageCode = 'ar';
    } else if (language == HadithLanguage.hindi && hadith.hindi.isNotEmpty) {
      translation = hadith.hindi;
      languageCode = 'hi';
    } else if (language == HadithLanguage.urdu && hadith.urdu.isNotEmpty) {
      translation = hadith.urdu;
      languageCode = 'ur';
    } else if (hadith.english.isNotEmpty) {
      translation = hadith.english;
      languageCode = 'en';
    }

    final translatedReference = HadithTranslator.translateReference(
      hadith.reference,
      languageCode,
    );
    final text = '${hadith.arabic}\n\n$translation\n\n— $translatedReference';
    Share.share(text);
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
