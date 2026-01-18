import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/hadith_provider.dart';
import '../../providers/settings_provider.dart';
import '../../data/models/hadith_model.dart';

class HadithBookDetailScreen extends StatefulWidget {
  final HadithCollection collection;
  final int bookNumber;
  final String bookName;
  final String bookArabicName;

  const HadithBookDetailScreen({
    super.key,
    required this.collection,
    required this.bookNumber,
    required this.bookName,
    required this.bookArabicName,
  });

  @override
  State<HadithBookDetailScreen> createState() => _HadithBookDetailScreenState();
}

class _HadithBookDetailScreenState extends State<HadithBookDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  final Set<int> _cardsWithTranslation = {};
  final FlutterTts _flutterTts = FlutterTts();
  int? _playingCardIndex;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HadithProvider>().fetchChapterHadiths(
        widget.collection,
        widget.bookNumber,
      );
    });
  }

  Future<void> _initTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCardIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((message) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCardIndex = null;
        });
      }
    });
  }

  Future<void> playHadith(HadithModel hadith, HadithLanguage language, int cardIndex, bool showTranslation) async {
    if (_playingCardIndex == cardIndex && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (showTranslation) {
      switch (language) {
        case HadithLanguage.english:
          textToSpeak = hadith.english;
          ttsLangCode = 'en-US';
          break;
        case HadithLanguage.urdu:
          textToSpeak = hadith.urdu.isNotEmpty ? hadith.urdu : hadith.english;
          if (hadith.urdu.isNotEmpty) {
            ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          } else {
            ttsLangCode = 'en-US';
          }
          break;
        case HadithLanguage.hindi:
          textToSpeak = hadith.hindi.isNotEmpty ? hadith.hindi : hadith.english;
          if (hadith.hindi.isNotEmpty) {
            ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          } else {
            ttsLangCode = 'en-US';
          }
          break;
      }
    } else {
      textToSpeak = hadith.arabic;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(showTranslation ? 'No translation available for audio' : 'No Arabic text available')),
        );
      }
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);
    setState(() {
      _playingCardIndex = cardIndex;
      _isSpeaking = true;
    });
    await _flutterTts.speak(textToSpeak);
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
    await _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
      _playingCardIndex = null;
    });
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookName,
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.bookArabicName,
              style: const TextStyle(fontSize: 12, fontFamily: 'Amiri'),
            ),
          ],
        ),
        actions: [
          Consumer<HadithProvider>(
            builder: (context, provider, child) {
              return PopupMenuButton<HadithLanguage>(
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    HadithProvider.languageNames[provider.selectedLanguage]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
                onSelected: (HadithLanguage language) {
                  provider.setLanguage(language);
                },
                itemBuilder: (context) => HadithLanguage.values.map((language) {
                  final isSelected = provider.selectedLanguage == language;
                  return PopupMenuItem<HadithLanguage>(
                    value: language,
                    child: Row(
                      children: [
                        if (isSelected)
                          Icon(Icons.check, color: AppColors.primary, size: 18)
                        else
                          const SizedBox(width: 18),
                        const SizedBox(width: 8),
                        Text(
                          HadithProvider.languageNames[language]!,
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
      body: Consumer<HadithProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFF8AAF9A),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0A5C36).withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                    decoration: InputDecoration(
                      hintText: 'Search hadith...',
                      hintStyle: TextStyle(color: AppColors.textHint),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF0A5C36)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${getFilteredHadiths(provider).length} Hadiths',
                        style: const TextStyle(
                          color: Color(0xFF1E8F5A),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A5C36).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Book ${widget.bookNumber}',
                        style: const TextStyle(
                          color: Color(0xFF0A5C36),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: buildHadithList(provider, settings),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildHadithList(HadithProvider provider, SettingsProvider settings) {
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
            Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(provider.error ?? 'Failed to load hadiths'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                provider.fetchChapterHadiths(widget.collection, widget.bookNumber);
              },
              child: const Text('Retry'),
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
            Icon(Icons.menu_book, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('No hadiths found'),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemCount: hadiths.length,
      itemBuilder: (context, index) {
        return _buildHadithCard(
          hadiths[index],
          provider,
          settings.arabicFontSize,
          settings.translationFontSize,
          index,
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
  ) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final isFav = provider.isFavorite(widget.collection, hadith.hadithNumber);
    final isPlaying = _playingCardIndex == cardIndex && _isSpeaking;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPlaying ? emeraldGreen : lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying ? emeraldGreen.withValues(alpha: 0.1) : lightGreenChip,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPlaying ? emeraldGreen : darkGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${cardIndex + 1}',
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
                            'Hadith #${hadith.hadithNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                            ),
                          ),
                          if (hadith.narrator.isNotEmpty)
                            Text(
                              hadith.narrator,
                              style: const TextStyle(
                                fontSize: 11,
                                color: emeraldGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (hadith.grade.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getGradeColor(hadith.grade),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hadith.grade,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HeaderActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying ? 'Stop' : 'Audio',
                      onTap: () => playHadith(hadith, provider.selectedLanguage, cardIndex, showTranslation),
                      isActive: isPlaying,
                    ),
                    HeaderActionButton(
                      icon: Icons.translate,
                      label: 'Translate',
                      onTap: () => toggleCardTranslation(cardIndex),
                      isActive: showTranslation,
                    ),
                    HeaderActionButton(
                      icon: Icons.copy,
                      label: 'Copy',
                      onTap: () => _copyHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                    ),
                    HeaderActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () => _shareHadith(hadith, provider.selectedLanguage),
                      isActive: false,
                    ),
                    HeaderActionButton(
                      icon: isFav ? Icons.favorite : Icons.favorite_border,
                      label: 'Favorite',
                      onTap: () => provider.toggleFavorite(widget.collection, hadith.hadithNumber),
                      isActive: isFav,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (hadith.arabic.isNotEmpty)
            GestureDetector(
              onTap: () {
                if (isPlaying && !showTranslation) {
                  _stopPlaying();
                } else if (!showTranslation) {
                  playHadith(hadith, provider.selectedLanguage, cardIndex, false);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: (isPlaying && !showTranslation)
                    ? BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlaying && !showTranslation)
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: const Icon(
                          Icons.volume_up,
                          size: 18,
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
                          color: (isPlaying && !showTranslation) ? AppColors.primary : AppColors.arabicText,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (showTranslation)
            GestureDetector(
              onTap: () {
                if (isPlaying && showTranslation) {
                  _stopPlaying();
                } else {
                  playHadith(hadith, provider.selectedLanguage, cardIndex, true);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (isPlaying && showTranslation)
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPlaying && showTranslation)
                      const Padding(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Icon(
                          Icons.volume_up,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (provider.selectedLanguage == HadithLanguage.hindi) ...[
                            if (hadith.hindi.isNotEmpty)
                              Text(
                                hadith.hindi,
                                style: TextStyle(
                                  fontSize: translationFontSize,
                                  height: 1.5,
                                  color: (isPlaying && showTranslation) ? AppColors.primary : Colors.black87,
                                ),
                              )
                            else if (hadith.english.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                    const Text(
                                      'हिंदी में अनुवाद हो रहा है...',
                                      style: TextStyle(
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
                                  color: (isPlaying && showTranslation) ? AppColors.primary : Colors.black54,
                                ),
                              ),
                            ]
                            else
                              const Text(
                                'Translation not available',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ]
                          else if (provider.selectedLanguage == HadithLanguage.english && hadith.english.isNotEmpty)
                            Text(
                              hadith.english,
                              style: TextStyle(
                                fontSize: translationFontSize,
                                height: 1.5,
                                color: (isPlaying && showTranslation) ? AppColors.primary : Colors.black87,
                              ),
                            )
                          else if (provider.selectedLanguage == HadithLanguage.urdu && hadith.urdu.isNotEmpty)
                            Text(
                              hadith.urdu,
                              style: TextStyle(
                                fontSize: translationFontSize,
                                height: 1.5,
                                fontFamily: 'Amiri',
                                color: (isPlaying && showTranslation) ? AppColors.primary : Colors.black87,
                              ),
                              textDirection: TextDirection.rtl,
                            )
                          else if (hadith.english.isNotEmpty)
                            Text(
                              hadith.english,
                              style: TextStyle(
                                fontSize: translationFontSize,
                                height: 1.5,
                                color: (isPlaying && showTranslation) ? AppColors.primary : Colors.black87,
                              ),
                            )
                          else
                            const Text(
                              'Translation not available',
                              style: TextStyle(
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: lightGreenBorder.withValues(alpha: 0.5))),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              hadith.reference,
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

  Widget HeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const darkGreen = Color(0xFF0A5C36);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? emeraldGreen : lightGreenChip,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : darkGreen,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
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
    if (language == HadithLanguage.hindi && hadith.hindi.isNotEmpty) {
      translation = hadith.hindi;
    } else if (language == HadithLanguage.urdu && hadith.urdu.isNotEmpty) {
      translation = hadith.urdu;
    } else if (hadith.english.isNotEmpty) {
      translation = hadith.english;
    }

    final text = '${hadith.arabic}\n\n$translation\n\n— ${hadith.reference}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _shareHadith(HadithModel hadith, HadithLanguage language) {
    String translation = '';
    if (language == HadithLanguage.hindi && hadith.hindi.isNotEmpty) {
      translation = hadith.hindi;
    } else if (language == HadithLanguage.urdu && hadith.urdu.isNotEmpty) {
      translation = hadith.urdu;
    } else if (hadith.english.isNotEmpty) {
      translation = hadith.english;
    }

    final text = '${hadith.arabic}\n\n$translation\n\n— ${hadith.reference}';
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
