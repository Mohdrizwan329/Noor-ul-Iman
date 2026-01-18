import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/allah_name_model.dart';

class NameOfAllahDetailScreen extends StatefulWidget {
  final AllahNameModel name;
  const NameOfAllahDetailScreen({super.key, required this.name});

  @override
  State<NameOfAllahDetailScreen> createState() =>
      _NameOfAllahDetailScreenState();
}

class _NameOfAllahDetailScreenState extends State<NameOfAllahDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;
  AllahNameLanguage _selectedLanguage = AllahNameLanguage.english;

  static const Map<AllahNameLanguage, String> languageNames = {
    AllahNameLanguage.english: 'English',
    AllahNameLanguage.urdu: 'Urdu',
    AllahNameLanguage.hindi: 'Hindi',
  };

  @override
  void initState() {
    super.initState();
    _initTts();
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
          _isPlayingArabic = false;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _isPlayingArabic = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playAudio(bool playArabic) async {
    if (_isSpeaking) {
      await _stopPlaying();
      return;
    }

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (playArabic) {
      textToSpeak = widget.name.name;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      setState(() {
        _isPlayingArabic = true;
      });
    } else {
      switch (_selectedLanguage) {
        case AllahNameLanguage.english:
          textToSpeak =
              '${widget.name.getMeaning(_selectedLanguage)}. ${widget.name.getDescription(_selectedLanguage)}';
          ttsLangCode = 'en-US';
          break;
        case AllahNameLanguage.urdu:
          textToSpeak =
              '${widget.name.getMeaning(_selectedLanguage)}. ${widget.name.getDescription(_selectedLanguage)}';
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case AllahNameLanguage.hindi:
          textToSpeak =
              '${widget.name.getMeaning(_selectedLanguage)}. ${widget.name.getDescription(_selectedLanguage)}';
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
      }
      setState(() {
        _isPlayingArabic = false;
      });
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No text available for audio')),
        );
      }
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);
    setState(() {
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
      _isPlayingArabic = false;
    });
  }

  void _toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void _copyNameDetail() {
    final meaning = widget.name.getMeaning(_selectedLanguage);
    final description = widget.name.getDescription(_selectedLanguage);
    final text = '''
${widget.name.name}
${widget.name.transliteration}
$meaning
$description
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  void _shareNameDetail() {
    final meaning = widget.name.getMeaning(_selectedLanguage);
    final description = widget.name.getDescription(_selectedLanguage);
    final shareText = '''
${widget.name.number}. ${widget.name.name}
${widget.name.transliteration}

$meaning

$description

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
          widget.name.transliteration,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<AllahNameLanguage>(
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
            onSelected: (AllahNameLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => AllahNameLanguage.values.map((language) {
              final isSelected = _selectedLanguage == language;
              return PopupMenuItem<AllahNameLanguage>(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isSpeaking
                  ? const Color(0xFF1E8F5A)
                  : const Color(0xFF8AAF9A),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A5C36).withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Header with number and action buttons
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Number Badge
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A5C36),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0A5C36).withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${widget.name.number}',
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
                          child: Text(
                            widget.name.transliteration,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeaderActionButton(
                          icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                          label: _isSpeaking ? 'Stop' : 'Audio',
                          onTap: () => _playAudio(!_showTranslation),
                          isActive: _isSpeaking,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.translate,
                          label: 'Translate',
                          onTap: _toggleTranslation,
                          isActive: _showTranslation,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.copy,
                          label: 'Copy',
                          onTap: _copyNameDetail,
                          isActive: false,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.share,
                          label: 'Share',
                          onTap: _shareNameDetail,
                          isActive: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arabic Name
              GestureDetector(
                onTap: () {
                  if (_isSpeaking && _isPlayingArabic) {
                    _stopPlaying();
                  } else {
                    _playAudio(true);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: (_isSpeaking && _isPlayingArabic)
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSpeaking && _isPlayingArabic)
                        const Padding(
                          padding: EdgeInsets.only(right: 8, top: 8),
                          child: Icon(
                            Icons.volume_up,
                            size: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.name.name,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 56,
                                height: 1.5,
                                color: (_isSpeaking && _isPlayingArabic)
                                    ? AppColors.primary
                                    : AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.name.transliteration,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Translation/Description (toggle)
              if (_showTranslation)
                GestureDetector(
                  onTap: () {
                    if (_isSpeaking && !_isPlayingArabic) {
                      _stopPlaying();
                    } else {
                      _playAudio(false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSpeaking && !_isPlayingArabic)
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
                                    Icons.info_outline,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Meaning (${languageNames[_selectedLanguage]})',
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
                                widget.name.getDescription(_selectedLanguage),
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: (_isSpeaking && !_isPlayingArabic)
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                                textDirection:
                                    _selectedLanguage == AllahNameLanguage.urdu
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
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);

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
}
