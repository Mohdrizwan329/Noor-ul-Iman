import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';

enum BasicAmalLanguage { english, urdu, hindi }

class BasicAmalDetailScreen extends StatefulWidget {
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String contentEnglish;
  final String contentUrdu;
  final String contentHindi;
  final IconData icon;
  final Color color;
  final String category;
  final int? number;
  final String? reference;
  final String? importance;
  final String? warning;
  final String? tip;

  const BasicAmalDetailScreen({
    super.key,
    required this.title,
    this.titleUrdu = '',
    this.titleHindi = '',
    required this.contentEnglish,
    this.contentUrdu = '',
    this.contentHindi = '',
    required this.icon,
    required this.color,
    required this.category,
    this.number,
    this.reference,
    this.importance,
    this.warning,
    this.tip,
  });

  @override
  State<BasicAmalDetailScreen> createState() => _BasicAmalDetailScreenState();
}

class _BasicAmalDetailScreenState extends State<BasicAmalDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showTranslation = false;
  BasicAmalLanguage _selectedLanguage = BasicAmalLanguage.english;

  static const Map<BasicAmalLanguage, String> languageNames = {
    BasicAmalLanguage.english: 'English',
    BasicAmalLanguage.urdu: 'اردو',
    BasicAmalLanguage.hindi: 'हिंदी',
  };

  String get _currentTitle {
    switch (_selectedLanguage) {
      case BasicAmalLanguage.urdu:
        return widget.titleUrdu.isNotEmpty ? widget.titleUrdu : widget.title;
      case BasicAmalLanguage.hindi:
        return widget.titleHindi.isNotEmpty ? widget.titleHindi : widget.title;
      default:
        return widget.title;
    }
  }

  String get _currentContent {
    switch (_selectedLanguage) {
      case BasicAmalLanguage.urdu:
        return widget.contentUrdu.isNotEmpty ? widget.contentUrdu : widget.contentEnglish;
      case BasicAmalLanguage.hindi:
        return widget.contentHindi.isNotEmpty ? widget.contentHindi : widget.contentEnglish;
      default:
        return widget.contentEnglish;
    }
  }

  bool hasTranslation() {
    return widget.contentUrdu.isNotEmpty || widget.contentHindi.isNotEmpty;
  }

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
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> playAudio() async {
    if (_isSpeaking) {
      await _stopPlaying();
      return;
    }

    String textToSpeak = _currentContent;
    String ttsLangCode = 'en-US';

    switch (_selectedLanguage) {
      case BasicAmalLanguage.english:
        ttsLangCode = 'en-US';
        break;
      case BasicAmalLanguage.urdu:
        ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
        break;
      case BasicAmalLanguage.hindi:
        ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
        break;
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No text available for audio'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
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
    });
  }

  void toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void copyDetails(BuildContext context) {
    final text = '''
$_currentTitle
${widget.category}

$_currentContent

- From Jiyan Islamic Academy App
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void shareDetails() {
    final text = '''
${widget.number != null ? '${widget.number}. ' : ''}$_currentTitle

$_currentContent

- Shared from Jiyan Islamic Academy App
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final isRtl = _selectedLanguage == BasicAmalLanguage.urdu;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: Text(
          _currentTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<BasicAmalLanguage>(
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
            onSelected: (BasicAmalLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => BasicAmalLanguage.values.map((language) {
              final isSelected = _selectedLanguage == language;
              return PopupMenuItem<BasicAmalLanguage>(
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
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isSpeaking ? AppColors.primaryLight : AppColors.lightGreenBorder,
                  width: _isSpeaking ? 2 : 1.5,
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
                      color: _isSpeaking
                          ? AppColors.primaryLight.withValues(alpha: 0.1)
                          : const Color(0xFFE8F3ED),
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
                                color: _isSpeaking ? AppColors.primaryLight : AppColors.primary,
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
                                child: Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentTitle,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Text(
                                    widget.category,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HeaderActionButton(
                              icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                              label: _isSpeaking ? 'Stop' : 'Audio',
                              onTap: playAudio,
                              isActive: _isSpeaking,
                            ),
                            HeaderActionButton(
                              icon: Icons.translate,
                              label: 'Translate',
                              onTap: toggleTranslation,
                              isActive: _showTranslation,
                            ),
                            HeaderActionButton(
                              icon: Icons.copy,
                              label: 'Copy',
                              onTap: () => copyDetails(context),
                              isActive: false,
                            ),
                            HeaderActionButton(
                              icon: Icons.share,
                              label: 'Share',
                              onTap: shareDetails,
                              isActive: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_isSpeaking) {
                        _stopPlaying();
                      } else {
                        playAudio();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _currentContent,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: _isSpeaking
                              ? AppColors.primary
                              : (isDark ? AppColors.darkTextSecondary : Colors.black87),
                        ),
                        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                  ),
                  if (_showTranslation && hasTranslation())
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (widget.contentUrdu.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'اردو',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.contentUrdu,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.8,
                              ),
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                            ),
                          ],
                          if (widget.contentHindi.isNotEmpty) ...[
                            if (widget.contentUrdu.isNotEmpty) const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'हिंदी',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.contentHindi,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.8,
                              ),
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (widget.reference != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                title: _selectedLanguage == BasicAmalLanguage.urdu
                    ? 'حوالہ'
                    : _selectedLanguage == BasicAmalLanguage.hindi
                        ? 'संदर्भ'
                        : 'Reference',
                content: widget.reference!,
                icon: Icons.book_outlined,
                isDark: isDark,
                isRtl: isRtl,
              ),
            ],
            if (widget.importance != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                title: _selectedLanguage == BasicAmalLanguage.urdu
                    ? 'اہمیت'
                    : _selectedLanguage == BasicAmalLanguage.hindi
                        ? 'महत्व'
                        : 'Importance',
                content: widget.importance!,
                icon: Icons.star_outline,
                isDark: isDark,
                isRtl: isRtl,
              ),
            ],
            if (widget.warning != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                title: _selectedLanguage == BasicAmalLanguage.urdu
                    ? 'احتیاط'
                    : _selectedLanguage == BasicAmalLanguage.hindi
                        ? 'सावधानी'
                        : 'Warning',
                content: widget.warning!,
                icon: Icons.warning_amber_outlined,
                isDark: isDark,
                isRtl: isRtl,
                isWarning: true,
              ),
            ],
            if (widget.tip != null) ...[
              const SizedBox(height: 12),
              _buildInfoCard(
                title: _selectedLanguage == BasicAmalLanguage.urdu
                    ? 'مشورہ'
                    : _selectedLanguage == BasicAmalLanguage.hindi
                        ? 'सुझाव'
                        : 'Tip',
                content: widget.tip!,
                icon: Icons.lightbulb_outline,
                isDark: isDark,
                isRtl: isRtl,
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget HeaderActionButton({
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

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required bool isDark,
    required bool isRtl,
    bool isWarning = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isWarning
              ? Colors.orange.withValues(alpha: 0.5)
              : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isWarning ? Colors.orange : AppColors.primary).withValues(alpha: 0.08),
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
              color: isWarning
                  ? Colors.orange.withValues(alpha: 0.1)
                  : const Color(0xFFE8F3ED),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isWarning ? Colors.orange : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isWarning ? Colors.orange : AppColors.primary).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isWarning ? Colors.orange.shade700 : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: isDark ? AppColors.darkTextSecondary : Colors.black87,
              ),
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              textAlign: isRtl ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
