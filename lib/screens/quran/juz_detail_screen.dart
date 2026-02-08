import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/quran_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/surah_model.dart';
import '../../data/models/firestore_models.dart';
import '../../widgets/common/header_action_button.dart';
import '../../core/services/content_service.dart';

class JuzDetailScreen extends StatefulWidget {
  final int juzNumber;
  const JuzDetailScreen({super.key, required this.juzNumber});

  @override
  State<JuzDetailScreen> createState() => _JuzDetailScreenState();
}

class _JuzDetailScreenState extends State<JuzDetailScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingAyah;
  late QuranProvider _quranProvider;
  final ScrollController _scrollController = ScrollController();
  // Track which cards have translation visible
  final Set<int> _cardsWithTranslation = {};
  // Track which cards have transliteration visible
  final Set<int> _cardsWithTransliteration = {};
  // Number of ayahs per card (4 ayahs = ~35 cards for 141 ayahs)
  static const int _ayahsPerCard = 4;
  final ContentService _contentService = ContentService();
  // Firebase content
  QuranScreenContentFirestore? _quranContent;
  // Track current card being played and ayahs queue
  int? _playingCardIndex;
  List<AyahModel> _ayahsQueue = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _quranProvider = context.read<QuranProvider>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quranProvider.fetchJuz(widget.juzNumber);
      _loadContent();
    });
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        if (state.processingState == ProcessingState.completed) {
          // Play next ayah in queue if available
          if (_ayahsQueue.isNotEmpty) {
            final nextAyah = _ayahsQueue.removeAt(0);
            _playAyah(nextAyah);
          } else {
            setState(() {
              _playingAyah = null;
              _playingCardIndex = null;
            });
          }
        }
      }
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
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Play single ayah
  Future<void> _playAyah(AyahModel ayah) async {
    final audioUrl = _quranProvider.getAudioUrl(0, ayah.number);
    try {
      setState(() {
        _playingAyah = ayah.number;
      });
      await _audioPlayer.setUrl(audioUrl);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      setState(() {
        _playingAyah = null;
      });
    }
  }

  // Stop playing
  void _stopPlaying() {
    _audioPlayer.stop();
    _ayahsQueue.clear();
    setState(() {
      _playingAyah = null;
      _playingCardIndex = null;
    });
  }

  // Play all ayahs in a card sequentially
  Future<void> _playCardAyahs(List<AyahModel> ayahs, int cardIndex) async {
    if (ayahs.isEmpty) return;
    // Stop any current playback
    _stopPlaying();
    // Set up the queue (all except first, which we'll play immediately)
    _ayahsQueue = ayahs.skip(1).toList();
    setState(() {
      _playingCardIndex = cardIndex;
    });
    // Play the first ayah
    await _playAyah(ayahs.first);
  }

  // Toggle translation for card (group of ayahs)
  void _toggleCardTranslation(int cardIndex) {
    setState(() {
      if (_cardsWithTranslation.contains(cardIndex)) {
        _cardsWithTranslation.remove(cardIndex);
      } else {
        _cardsWithTranslation.add(cardIndex);
      }
    });
  }

  // Share multiple ayahs
  void _shareAyahs(List<AyahModel> ayahs, List<String?> translations) {
    final StringBuffer shareText = StringBuffer();
    for (int i = 0; i < ayahs.length; i++) {
      shareText.writeln(ayahs[i].text);
      if (translations[i] != null) {
        shareText.writeln(translations[i]);
      }
      shareText.writeln();
    }
    shareText.writeln('- ${context.tr('para_label')} ${widget.juzNumber}');
    Share.share(shareText.toString());
  }

  // Copy multiple ayahs to clipboard
  void _copyAyahs(List<AyahModel> ayahs, List<String?> translations) {
    final StringBuffer copyText = StringBuffer();
    for (int i = 0; i < ayahs.length; i++) {
      copyText.writeln(ayahs[i].text);
      if (translations[i] != null) {
        copyText.writeln(translations[i]);
      }
      copyText.writeln();
    }
    copyText.writeln('- ${context.tr('para_label')} ${widget.juzNumber}');
    Clipboard.setData(ClipboardData(text: copyText.toString()));
  }

  // Get grouped ayahs for a card index
  List<int> _getAyahIndicesForCard(int cardIndex, int totalAyahs) {
    final startIndex = cardIndex * _ayahsPerCard;
    final endIndex = (startIndex + _ayahsPerCard).clamp(0, totalAyahs);
    return List.generate(endIndex - startIndex, (i) => startIndex + i);
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

  // Get Surah name based on language
  String _getSurahName(int surahNumber, QuranLanguage language) {
    if (_quranContent != null) {
      return _quranContent!.getSurahName(surahNumber, _langCodeFromQuranLanguage(language));
    }
    return 'Surah $surahNumber';
  }

  // Get Para name based on language
  String _getParaName(int paraNumber, QuranLanguage language) {
    if (_quranContent != null) {
      return _quranContent!.getParaName(paraNumber, _langCodeFromQuranLanguage(language));
    }
    return 'Para $paraNumber';
  }

  // Build Para header with complete details
  Widget _buildParaHeader(
    JuzInfo juzInfo,
    String startSurahName,
    String endSurahName,
    int totalAyahs,
    QuranProvider provider,
  ) {
    return const SizedBox.shrink();
  }

  // Build Surah divider widget
  Widget _buildSurahDivider(int surahNumber, QuranLanguage language) {
    return Row(
      children: [
        // Arabic name - Placeholder for future implementation
      ],
    );
  }

  // Check if this card starts with a new Surah
  bool _startsNewSurah(List<AyahModel> ayahs) {
    if (ayahs.isEmpty) return false;
    return ayahs.first.numberInSurah == 1;
  }

  // Get the Surah number for the first ayah in the card
  int _getFirstSurahNumber(List<AyahModel> ayahs) {
    if (ayahs.isEmpty) return 0;
    return ayahs.first.surahNumber;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final settings = context.watch<SettingsProvider>();
    // Listen to language changes to rebuild UI
    context.watch<LanguageProvider>();
    final quranProvider = context.watch<QuranProvider>();
    final paraName = _getParaName(
      widget.juzNumber,
      quranProvider.selectedLanguage,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${context.tr('para_label')} ${widget.juzNumber}',
              style: TextStyle(
                fontSize: responsive.textMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              ' - ',
              style: TextStyle(
                fontSize: responsive.textMedium,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            Flexible(
              child: Text(
                paraName,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  fontWeight: FontWeight.normal,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (provider.currentJuzAyahs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: responsive.iconXLarge * 1.5,
                    color: Colors.grey.shade400,
                  ),
                  responsive.vSpaceRegular,
                  Text(context.tr('error')),
                  responsive.vSpaceSmall,
                  ElevatedButton(
                    onPressed: () => provider.fetchJuz(widget.juzNumber),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          // Calculate number of cards (grouped ayahs)
          final totalAyahs = provider.currentJuzAyahs.length;
          final cardCount = (totalAyahs / _ayahsPerCard).ceil();

          // Get Juz info for header
          final juzInfo = provider.juzList[widget.juzNumber - 1];
          final startSurahName = _getSurahName(
            juzInfo.startSurah,
            provider.selectedLanguage,
          );
          final endSurahName = _getSurahName(
            juzInfo.endSurah,
            provider.selectedLanguage,
          );

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: responsive.paddingAll(12),
                  itemCount: cardCount + 1, // +1 for header
                  itemBuilder: (context, index) {
                    // First item is the header
                    if (index == 0) {
                      return _buildParaHeader(
                        juzInfo,
                        startSurahName,
                        endSurahName,
                        provider.currentJuzAyahs.length,
                        provider,
                      );
                    }

                    // Ayah cards (adjust index for header)
                    final cardIndex = index - 1;
                    final ayahIndices = _getAyahIndicesForCard(cardIndex, totalAyahs);
                    final ayahs = ayahIndices
                        .map((i) => provider.currentJuzAyahs[i])
                        .toList();

                    // Get translations using direct indices
                    final translations = ayahIndices.map((i) {
                      return i < provider.currentJuzTranslation.length
                          ? provider.currentJuzTranslation[i].text
                          : null;
                    }).toList();

                    // Get transliterations using direct indices
                    final transliterations = ayahIndices.map((i) {
                      return i < provider.currentJuzTransliteration.length
                          ? provider.currentJuzTransliteration[i].text
                          : null;
                    }).toList();

                    // Check if this card starts with a new Surah
                    final showSurahDivider = _startsNewSurah(ayahs);
                    final surahNumber = _getFirstSurahNumber(ayahs);

                    return Column(
                      children: [
                        // Show Surah divider if this card starts a new Surah
                        if (showSurahDivider && surahNumber > 0)
                          _buildSurahDivider(surahNumber, provider.selectedLanguage),
                        _buildGroupedAyahCard(
                          ayahs,
                          translations,
                          transliterations,
                          provider,
                          settings.arabicFontSize,
                          settings.translationFontSize,
                          cardIndex,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGroupedAyahCard(
    List<AyahModel> ayahs,
    List<String?> translations,
    List<String?> transliterations,
    QuranProvider provider,
    double arabicFontSize,
    double translationFontSize,
    int cardIndex,
  ) {
    final responsive = context.responsive;
    final isAnyPlaying =
        _playingCardIndex == cardIndex ||
        ayahs.any((a) => _playingAyah == a.number);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final showTransliteration = _cardsWithTransliteration.contains(cardIndex);
    // Card serial number (1-based)
    final cardNumber = cardIndex + 1;

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isAnyPlaying
              ? AppColors.primaryLight
              : AppColors.lightGreenBorder,
          width: isAnyPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header with serial number and action buttons
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isAnyPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.lightGreenChip,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // First row: Card number and Ayah range
                Row(
                  children: [
                    // Card serial number badge
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isAnyPlaying
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6.0,
                            offset: Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$cardNumber',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.textMedium,
                          ),
                        ),
                      ),
                    ),
                    responsive.hSpaceMedium,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${context.tr('ayah')} ${ayahs.first.numberInSurah} - ${ayahs.last.numberInSurah}',
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          responsive.vSpaceXSmall,
                          // Page and Hizb info
                          Wrap(
                            spacing: responsive.spacing(8),
                            runSpacing: responsive.spacing(4),
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: responsive.fontSize(12),
                                    color: Colors.grey[600],
                                  ),
                                  responsive.hSpaceXSmall,
                                  Text(
                                    '${context.tr('page')} ${ayahs.first.page}',
                                    style: TextStyle(
                                      fontSize: responsive.textXSmall,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.bookmark_border,
                                    size: responsive.fontSize(12),
                                    color: Colors.grey[600],
                                  ),
                                  responsive.hSpaceXSmall,
                                  Text(
                                    '${context.tr('hizb')} ${((ayahs.first.hizbQuarter - 1) ~/ 4) + 1}',
                                    style: TextStyle(
                                      fontSize: responsive.textXSmall,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Second row: Action buttons with labels
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  spacing: responsive.spacing(8),
                  runSpacing: responsive.spacing(8),
                  children: [
                    HeaderActionButton(
                      icon: isAnyPlaying ? Icons.stop : Icons.volume_up,
                      label: isAnyPlaying
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: isAnyPlaying
                          ? _stopPlaying
                          : () => _playCardAyahs(ayahs, cardIndex),
                      isActive: isAnyPlaying,
                    ),
                    HeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),

                    HeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyAyahs(ayahs, translations),
                      isActive: false,
                    ),
                    HeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareAyahs(ayahs, translations),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Arabic texts for all ayahs in this card
          Padding(
            padding: responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ayahs.asMap().entries.map((entry) {
                final ayah = entry.value;
                final isPlaying = _playingAyah == ayah.number;
                return Container(
                    margin: entry.key < ayahs.length - 1
                        ? responsive.paddingOnly(bottom: 12)
                        : EdgeInsets.zero,
                    padding: isPlaying
                        ? responsive.paddingAll(8)
                        : EdgeInsets.zero,
                    decoration: isPlaying
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
                        // Play indicator
                        if (isPlaying)
                          Padding(
                            padding: responsive.paddingOnly(right: 8, top: 8),
                            child: Icon(
                              Icons.volume_up,
                              size: responsive.iconSmall,
                              color: AppColors.primary,
                            ),
                          ),
                        // Arabic text
                        Expanded(
                          child: Text(
                            ayah.text,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: arabicFontSize,
                              height: 2.0,
                              color: isPlaying
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ),
                  );
              }).toList(),
            ),
          ),
          // Transliterations (if visible)
          if (showTransliteration)
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: (!showTranslation)
                    ? BorderRadius.only(
                        bottomLeft: Radius.circular(responsive.radiusLarge),
                        bottomRight: Radius.circular(responsive.radiusLarge),
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Section header
                  Row(
                    children: [
                      Icon(
                        Icons.text_fields,
                        size: responsive.iconSmall,
                        color: Colors.blue[700],
                      ),
                      responsive.hSpaceXSmall,
                      Text(
                        context.tr('transliteration'),
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  responsive.vSpaceSmall,
                  ...transliterations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final transliteration = entry.value;
                    if (transliteration == null) return const SizedBox.shrink();

                    return Container(
                      margin: index < transliterations.length - 1
                          ? responsive.paddingOnly(bottom: 8)
                          : EdgeInsets.zero,
                      child: Text(
                        transliteration,
                        style: TextStyle(
                          fontSize: translationFontSize,
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[800],
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }),
                ],
              ),
            ),
          // Translations (if visible)
          if (showTranslation)
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: AppColors.lightGreenChip.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(responsive.radiusLarge),
                  bottomRight: Radius.circular(responsive.radiusLarge),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: translations.asMap().entries.map((entry) {
                  final index = entry.key;
                  final translation = entry.value;
                  if (translation == null) return const SizedBox.shrink();

                  return Container(
                    margin: index < translations.length - 1
                        ? responsive.paddingOnly(bottom: 12)
                        : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayah number indicator
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              responsive.radiusMedium,
                            ),
                          ),
                          child: Text(
                            '${ayahs[index].numberInSurah}',
                            style: TextStyle(
                              fontSize: responsive.fontSize(11),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        responsive.vSpaceSmall,
                        Text(
                          translation,
                          style: TextStyle(
                            fontSize: translationFontSize,
                            height: 1.5,
                          ),
                          textDirection:
                              provider.selectedLanguage == QuranLanguage.urdu
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
