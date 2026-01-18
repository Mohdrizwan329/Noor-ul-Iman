import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quran_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/surah_model.dart';

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
    shareText.writeln('- پارہ ${widget.juzNumber}');
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
    copyText.writeln('- پارہ ${widget.juzNumber}');
    Clipboard.setData(ClipboardData(text: copyText.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  // Get grouped ayahs for a card index
  List<int> _getAyahIndicesForCard(int cardIndex, int totalAyahs) {
    final startIndex = cardIndex * _ayahsPerCard;
    final endIndex = (startIndex + _ayahsPerCard).clamp(0, totalAyahs);
    return List.generate(endIndex - startIndex, (i) => startIndex + i);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Para ${widget.juzNumber}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Language Selector
          Consumer<QuranProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<QuranLanguage>(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    QuranProvider.languageNames[provider.selectedLanguage]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                onSelected: (QuranLanguage language) {
                  provider.setLanguage(language).then((_) {
                    provider.fetchJuz(widget.juzNumber);
                  });
                },
                itemBuilder: (context) => QuranLanguage.values.map((language) {
                  final isSelected = provider.selectedLanguage == language;
                  return PopupMenuItem<QuranLanguage>(
                    value: language,
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(Icons.check, color: AppColors.primary, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(
                          QuranProvider.languageNames[language]!,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
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
                  Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('Failed to load Para'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.fetchJuz(widget.juzNumber),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Calculate number of cards (grouped ayahs)
          final totalAyahs = provider.currentJuzAyahs.length;
          final cardCount = (totalAyahs / _ayahsPerCard).ceil();

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: cardCount,
            itemBuilder: (context, cardIndex) {
              final ayahIndices = _getAyahIndicesForCard(cardIndex, totalAyahs);
              final ayahs = ayahIndices.map((i) => provider.currentJuzAyahs[i]).toList();
              final translations = ayahIndices.map((i) {
                return i < provider.currentJuzTranslation.length
                    ? provider.currentJuzTranslation[i].text
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
    final isAnyPlaying = _playingCardIndex == cardIndex || ayahs.any((a) => _playingAyah == a.number);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    // Card serial number (1-based)
    final cardNumber = cardIndex + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isAnyPlaying ? AppColors.primaryLight : AppColors.lightGreenBorder,
          width: isAnyPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card header with serial number and action buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isAnyPlaying
                  ? AppColors.primaryLight.withValues(alpha: 0.1)
                  : AppColors.lightGreenChip,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // First row: Card number and Ayah range
                Row(
                  children: [
                    // Card serial number badge
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isAnyPlaying ? AppColors.primaryLight : AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$cardNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ayah ${ayahs.first.numberInSurah} - ${ayahs.last.numberInSurah}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            '${ayahs.length} Ayahs',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Second row: Action buttons with labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
                      icon: isAnyPlaying ? Icons.stop : Icons.volume_up,
                      label: isAnyPlaying ? 'Stop' : 'Audio',
                      onTap: isAnyPlaying
                          ? _stopPlaying
                          : () => _playCardAyahs(ayahs, cardIndex),
                      isActive: isAnyPlaying,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.translate,
                      label: 'Translate',
                      onTap: () => _toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onTap: () => _copyAyahs(ayahs, translations),
                      isActive: false,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: 'Share',
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: ayahs.asMap().entries.map((entry) {
                final ayah = entry.value;
                final isPlaying = _playingAyah == ayah.number;
                return GestureDetector(
                  onTap: isPlaying ? _stopPlaying : () => _playAyah(ayah),
                  child: Container(
                    margin: entry.key < ayahs.length - 1
                        ? const EdgeInsets.only(bottom: 12)
                        : EdgeInsets.zero,
                    padding: isPlaying
                        ? const EdgeInsets.all(8)
                        : EdgeInsets.zero,
                    decoration: isPlaying
                        ? BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Play indicator
                        if (isPlaying)
                          const Padding(
                            padding: EdgeInsets.only(right: 8, top: 8),
                            child: Icon(
                              Icons.volume_up,
                              size: 18,
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
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreenChip.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
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
                        ? const EdgeInsets.only(bottom: 12)
                        : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ayah number indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${ayahs[index].numberInSurah}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : AppColors.lightGreenChip,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : AppColors.primary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
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
