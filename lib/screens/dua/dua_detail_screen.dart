import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/dua_model.dart';

class DuaDetailScreen extends StatefulWidget {
  final DuaModel dua;
  final DuaCategory category;
  const DuaDetailScreen({super.key, required this.dua, required this.category});

  @override
  State<DuaDetailScreen> createState() => _DuaDetailScreenState();
}

class _DuaDetailScreenState extends State<DuaDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _cardKeys = {};
  final FlutterTts _flutterTts = FlutterTts();
  final Set<int> _cardsWithTranslation = {};
  int? _playingCardIndex;
  bool _isSpeaking = false;
  DuaLanguage _selectedLanguage = DuaLanguage.hindi;

  static const Map<DuaLanguage, String> languageNames = {
    DuaLanguage.hindi: 'Hindi',
    DuaLanguage.english: 'English',
    DuaLanguage.urdu: 'Urdu',
  };

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.category.duas.length; i++) {
      _cardKeys[i] = GlobalKey();
    }
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDua();
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

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingCardIndex = null;
        });
      }
    });
  }

  void _scrollToSelectedDua() {
    final selectedIndex = widget.category.duas.indexWhere(
      (d) => d.id == widget.dua.id,
    );
    if (selectedIndex > 0 && _cardKeys.containsKey(selectedIndex)) {
      final key = _cardKeys[selectedIndex];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playDua(
    DuaModel dua,
    int cardIndex,
    bool showTranslation,
  ) async {
    if (_playingCardIndex == cardIndex && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (showTranslation) {
      switch (_selectedLanguage) {
        case DuaLanguage.english:
          textToSpeak = dua.translationEnglish ?? dua.translation;
          ttsLangCode = 'en-US';
          break;
        case DuaLanguage.urdu:
          textToSpeak = dua.translationUrdu ?? dua.translation;
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case DuaLanguage.hindi:
          textToSpeak = dua.translation;
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
      }
    } else {
      textToSpeak = dua.arabic;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
    }

    if (textToSpeak.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showTranslation
                ? 'No translation available for audio'
                : 'No Arabic text available',
          ),
        ),
      );
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

  void _toggleCardTranslation(int cardIndex) {
    setState(() {
      if (_cardsWithTranslation.contains(cardIndex)) {
        _cardsWithTranslation.remove(cardIndex);
      } else {
        _cardsWithTranslation.add(cardIndex);
      }
    });
  }

  void _copyDua(DuaModel dua) {
    final translation = dua.getTranslation(_selectedLanguage);
    final text = '''
${dua.arabic}
${dua.transliteration}
$translation
— ${dua.reference}
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  void _shareDua(DuaModel dua) {
    final shareText = '''
${dua.title}

${dua.getTranslation(_selectedLanguage)}

Reference: ${dua.reference}

- Shared from Jiyan Islamic Academy App
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.category.name.replaceAll(RegExp(r'[^\x00-\x7F]+'), '').trim(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<DuaLanguage>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                languageNames[_selectedLanguage]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (DuaLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => DuaLanguage.values.map((language) {
              final isSelected = _selectedLanguage == language;
              return PopupMenuItem<DuaLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (isSelected)
                      Icon(Icons.check, color: AppColors.primary, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(
                      languageNames[language]!,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        itemCount: widget.category.duas.length,
        itemBuilder: (context, index) {
          final dua = widget.category.duas[index];
          return _buildDuaCard(dua, index);
        },
      ),
    );
  }

  Widget _buildDuaCard(DuaModel dua, int cardIndex) {
    const lightGreenChip = Color(0xFFE8F3ED);
    final showTranslation = _cardsWithTranslation.contains(cardIndex);
    final isPlaying = _playingCardIndex == cardIndex && _isSpeaking;
    final cardNumber = cardIndex + 1;

    return Container(
      key: _cardKeys[cardIndex],
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isPlaying ? AppColors.primaryLight : AppColors.lightGreenBorder,
          width: isPlaying ? 2 : 1.5,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying ? AppColors.primaryLight.withValues(alpha: 0.1) : lightGreenChip,
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
                        color: isPlaying ? AppColors.primaryLight : AppColors.primary,
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
                            dua.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (dua.titleUrdu != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              dua.titleUrdu!,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontFamily: 'Amiri',
                              ),
                              textDirection: TextDirection.rtl,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildHeaderActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying ? 'Stop' : 'Audio',
                      onTap: () => _playDua(dua, cardIndex, showTranslation),
                      isActive: isPlaying,
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
                      onTap: () => _copyDua(dua),
                      isActive: false,
                    ),
                    _buildHeaderActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () => _shareDua(dua),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (isPlaying && !showTranslation) {
                _stopPlaying();
              } else if (!showTranslation) {
                _playDua(dua, cardIndex, false);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
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
                    const Padding(
                      padding: EdgeInsets.only(right: 8, top: 8),
                      child: Icon(
                        Icons.volume_up,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      dua.arabic,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        height: 2.0,
                        color: (isPlaying && !showTranslation)
                            ? AppColors.primary
                            : AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
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
                  _playDua(dua, cardIndex, true);
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(12),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.translate,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Translation (${languageNames[_selectedLanguage]})',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            dua.getTranslation(_selectedLanguage),
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.6,
                              color: (isPlaying && showTranslation)
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                            textDirection: _selectedLanguage == DuaLanguage.urdu
                                ? TextDirection.rtl
                                : TextDirection.ltr,
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
              border: Border(
                top: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Text(
              dua.reference,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
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
    const lightGreenChip = Color(0xFFE8F3ED);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : lightGreenChip,
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
