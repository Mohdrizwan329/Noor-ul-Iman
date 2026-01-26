import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/quran_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/surah_model.dart';
import '../../widgets/common/search_bar_widget.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  // Track which cards have translation visible
  final Set<int> _cardsWithTranslation = {};
  // Number of ayahs per card (4 ayahs = ~35 cards for 141 ayahs)
  static const int _ayahsPerCard = 4;
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    _searchController.dispose();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('copied'))),
    );
  }

  // Get grouped ayahs for a card index
  List<int> _getAyahIndicesForCard(int cardIndex, int totalAyahs) {
    final startIndex = cardIndex * _ayahsPerCard;
    final endIndex = (startIndex + _ayahsPerCard).clamp(0, totalAyahs);
    return List.generate(endIndex - startIndex, (i) => startIndex + i);
  }

  // Filter ayahs based on search query
  List<AyahModel> _getFilteredAyahs(List<AyahModel> ayahs, List<AyahModel> translations) {
    if (_searchQuery.isEmpty) {
      return ayahs;
    }
    final query = _searchQuery.toLowerCase();
    final filteredIndices = <int>[];

    for (int i = 0; i < ayahs.length; i++) {
      final ayah = ayahs[i];
      final translation = i < translations.length ? translations[i].text : '';

      if (ayah.text.contains(query) ||
          translation.toLowerCase().contains(query) ||
          ayah.numberInSurah.toString().contains(query)) {
        filteredIndices.add(i);
      }
    }

    return filteredIndices.map((i) => ayahs[i]).toList();
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
          '${context.tr('para_label')} ${widget.juzNumber}',
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
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
                  Icon(Icons.error_outline, size: responsive.iconXLarge * 1.5, color: Colors.grey.shade400),
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

          // Filter ayahs based on search query
          final filteredAyahs = _getFilteredAyahs(
            provider.currentJuzAyahs,
            provider.currentJuzTranslation,
          );

          // Calculate number of cards (grouped ayahs) from filtered results
          final totalAyahs = filteredAyahs.length;
          final cardCount = (totalAyahs / _ayahsPerCard).ceil();

          return Column(
            children: [
              Padding(
                padding: responsive.paddingOnly(left: 12, top: 12, right: 12),
                child: SearchBarWidget(
                  controller: _searchController,
                  hintText: context.tr('search_ayahs'),
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
                child: filteredAyahs.isEmpty
                    ? Center(
                        child: Text(
                          context.tr('no_ayahs_found'),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: responsive.paddingAll(12),
                        itemCount: cardCount,
                        itemBuilder: (context, cardIndex) {
                          final ayahIndices = _getAyahIndicesForCard(cardIndex, totalAyahs);
                          final ayahs = ayahIndices.map((i) => filteredAyahs[i]).toList();

                          // Get translations for filtered ayahs by matching ayah numbers
                          final translations = ayahs.map((ayah) {
                            final originalIndex = provider.currentJuzAyahs.indexWhere(
                              (a) => a.number == ayah.number,
                            );
                            return originalIndex >= 0 && originalIndex < provider.currentJuzTranslation.length
                                ? provider.currentJuzTranslation[originalIndex].text
                                : null;
                          }).toList();

                          return _buildGroupedAyahCard(
                            ayahs,
                            translations,
                            provider,
                            settings.arabicFontSize,
                            settings.translationFontSize,
                            cardIndex,
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
    QuranProvider provider,
    double arabicFontSize,
    double translationFontSize,
    int cardIndex,
  ) {
    final responsive = context.responsive;
    final isAnyPlaying = _playingCardIndex == cardIndex || ayahs.any((a) => _playingAyah == a.number);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    // Card serial number (1-based)
    final cardNumber = cardIndex + 1;

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isAnyPlaying ? AppColors.primaryLight : AppColors.lightGreenBorder,
          width: isAnyPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
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
                        color: isAnyPlaying ? AppColors.primaryLight : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: responsive.spacing(6),
                            offset: Offset(0, responsive.spacing(2)),
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
                      child: Text(
                        '${context.tr('ayah')} ${ayahs.first.numberInSurah} - ${ayahs.last.numberInSurah}',
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Second row: Action buttons with labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
                      icon: isAnyPlaying ? Icons.stop : Icons.volume_up,
                      label: isAnyPlaying ? context.tr('stop') : context.tr('audio'),
                      onTap: isAnyPlaying
                          ? _stopPlaying
                          : () => _playCardAyahs(ayahs, cardIndex),
                      isActive: isAnyPlaying,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyAyahs(ayahs, translations),
                      isActive: false,
                    ),
                    _buildHeaderActionButton(
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
                return GestureDetector(
                  onTap: isPlaying ? _stopPlaying : () => _playAyah(ayah),
                  child: Container(
                    margin: entry.key < ayahs.length - 1
                        ? responsive.paddingOnly(bottom: 12)
                        : EdgeInsets.zero,
                    padding: isPlaying
                        ? responsive.paddingAll(8)
                        : EdgeInsets.zero,
                    decoration: isPlaying
                        ? BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(responsive.radiusMedium),
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
                              fontFamily: 'Amiri',
                              fontSize: arabicFontSize,
                              height: 2.0,
                              color: isPlaying ? AppColors.primary : Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
                          padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(responsive.radiusMedium),
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
                          textDirection: provider.selectedLanguage == QuranLanguage.urdu
                              ? TextDirection.rtl
                              : TextDirection.ltr,
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

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = context.responsive;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : AppColors.lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: responsive.iconSmall,
                color: isActive ? Colors.white : AppColors.primary,
              ),
              responsive.vSpaceXSmall,
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive ? Colors.white : AppColors.primary,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
