import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/allah_name_model.dart';
import '../../providers/language_provider.dart';

import '../../core/services/content_service.dart';

class NameOfAllahDetailScreen extends StatefulWidget {
  final AllahNameModel name;
  const NameOfAllahDetailScreen({super.key, required this.name});

  @override
  State<NameOfAllahDetailScreen> createState() =>
      _NameOfAllahDetailScreenState();
}

class _NameOfAllahDetailScreenState extends State<NameOfAllahDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final ContentService _contentService = ContentService();
  Map<String, String> _hindiTransliterations = {};
  Map<String, String> _urduTransliterations = {};
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;

  AllahNameLanguage _getLanguageFromCode(String langCode) {
    switch (langCode) {
      case 'ar':
      case 'en':
        return AllahNameLanguage.english;
      case 'ur':
        return AllahNameLanguage.urdu;
      case 'hi':
        return AllahNameLanguage.hindi;
      default:
        return AllahNameLanguage.english;
    }
  }

  String _transliterateToHindi(String text) {
    return _hindiTransliterations[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    return _urduTransliterations[text] ?? text;
  }

  String _getDisplayName(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return widget.name.name; // Arabic
      case 'hi':
        return _transliterateToHindi(widget.name.transliteration); // Hindi
      case 'ur':
        return _transliterateToUrdu(widget.name.transliteration); // Urdu
      default:
        return widget.name.transliteration; // English
    }
  }

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadTransliterations();
  }

  Future<void> _loadTransliterations() async {
    try {
      final data = await _contentService.getNameTransliterations('allah_names');
      if (data.isNotEmpty && mounted) {
        setState(() {
          _hindiTransliterations = data['hindi'] ?? {};
          _urduTransliterations = data['urdu'] ?? {};
        });
      }
    } catch (e) {
      debugPrint('AllahNameDetail: Error loading transliterations: $e');
    }
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

    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (playArabic) {
      textToSpeak = widget.name.name;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      setState(() {
        _isPlayingArabic = true;
      });
    } else {
      switch (selectedLanguage) {
        case AllahNameLanguage.english:
          textToSpeak =
              '${widget.name.getMeaning(selectedLanguage)}. ${widget.name.getDescription(selectedLanguage)}';
          ttsLangCode = 'en-US';
          break;
        case AllahNameLanguage.urdu:
          textToSpeak =
              '${widget.name.getMeaning(selectedLanguage)}. ${widget.name.getDescription(selectedLanguage)}';
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case AllahNameLanguage.hindi:
          textToSpeak =
              '${widget.name.getMeaning(selectedLanguage)}. ${widget.name.getDescription(selectedLanguage)}';
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
      }
      setState(() {
        _isPlayingArabic = false;
      });
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
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
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final meaning = widget.name.getMeaning(selectedLanguage);
    final description = widget.name.getDescription(selectedLanguage);
    final text = '''
${widget.name.name}
${widget.name.transliteration}
$meaning
$description
''';
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareNameDetail() {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final meaning = widget.name.getMeaning(selectedLanguage);
    final description = widget.name.getDescription(selectedLanguage);
    final shareText = '''
${widget.name.number}. ${widget.name.name}
${widget.name.transliteration}

$meaning

$description

- ${context.tr('shared_from_app')}
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final langProvider = context.watch<LanguageProvider>();
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          _getDisplayName(langProvider.languageCode),
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: responsive.paddingAll(12),
              child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusXLarge),
            border: Border.all(
              color: _isSpeaking
                  ? const Color(0xFF1E8F5A)
                  : (const Color(0xFF8AAF9A)),
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
                padding: responsive.paddingSymmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsive.radiusXLarge),
                    topRight: Radius.circular(responsive.radiusXLarge),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Number Badge
                        Container(
                          width: responsive.spacing(40),
                          height: responsive.spacing(40),
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
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.textMedium,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: responsive.spaceMedium),
                        Expanded(
                          child: Text(
                            _getDisplayName(langProvider.languageCode),
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                            textDirection: (langProvider.languageCode == 'ar' || langProvider.languageCode == 'ur')
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spaceSmall),
                    // Action Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildHeaderActionButton(
                          icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                          label: _isSpeaking ? context.tr('stop') : context.tr('audio'),
                          onTap: () => _playAudio(!_showTranslation),
                          isActive: _isSpeaking,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.translate,
                          label: context.tr('translate'),
                          onTap: _toggleTranslation,
                          isActive: _showTranslation,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.copy,
                          label: context.tr('copy'),
                          onTap: _copyNameDetail,
                          isActive: false,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.share,
                          label: context.tr('share'),
                          onTap: _shareNameDetail,
                          isActive: false,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arabic Name
              Container(
                  margin: responsive.paddingSymmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  padding: responsive.paddingAll(12),
                  decoration: (_isSpeaking && _isPlayingArabic)
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(responsive.radiusMedium),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSpeaking && _isPlayingArabic)
                        Padding(
                          padding: EdgeInsets.only(
                            right: responsive.spaceSmall,
                            top: responsive.spaceSmall,
                          ),
                          child: Icon(
                            Icons.volume_up,
                            size: responsive.iconSmall,
                            color: AppColors.primary,
                          ),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.name.name,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: responsive.fontSize(56),
                                height: 1.5,
                                color: (_isSpeaking && _isPlayingArabic)
                                    ? AppColors.primary
                                    : AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            SizedBox(height: responsive.spaceSmall),
                            Text(
                              _getDisplayName(langProvider.languageCode),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: responsive.textXLarge,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                              textDirection: (langProvider.languageCode == 'ar' || langProvider.languageCode == 'ur')
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Translation/Description (toggle)
              if (_showTranslation)
                Container(
                    margin: responsive.paddingSymmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: responsive.paddingAll(12),
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSpeaking && !_isPlayingArabic)
                          Padding(
                            padding: EdgeInsets.only(
                              right: responsive.spaceSmall,
                              top: responsive.spaceXSmall,
                            ),
                            child: Icon(
                              Icons.volume_up,
                              size: responsive.iconSmall,
                              color: AppColors.primary,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: responsive.iconSmall,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: responsive.spaceSmall),
                                  Text(
                                    context.tr('meaning'),
                                    style: TextStyle(
                                      fontSize: responsive.textSmall,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: responsive.spaceMedium),
                              Text(
                                widget.name.getDescription(selectedLanguage),
                                style: TextStyle(
                                  fontSize: responsive.textMedium,
                                  height: 1.6,
                                  color: (_isSpeaking && !_isPlayingArabic)
                                      ? AppColors.primary
                                      : (Colors.black87),
                                  fontFamily: 'Poppins',
                                ),
                                textDirection:
                                    selectedLanguage == AllahNameLanguage.urdu
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              SizedBox(height: responsive.spaceMedium),
              ],
            ),
          ),
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
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? emeraldGreen : lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.radiusMedium),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22.0,
                color: isActive ? Colors.white : darkGreen,
              ),
              SizedBox(height: responsive.spaceXSmall),
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
}
