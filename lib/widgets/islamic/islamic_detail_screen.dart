import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/islamic_content_model.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

/// Reusable detail screen for Islamic content (Kalma, Dua, etc.)
class IslamicDetailScreen extends StatefulWidget {
  final IslamicContentModel content;
  final String screenTitle;
  final Color themeColor;

  const IslamicDetailScreen({
    super.key,
    required this.content,
    required this.screenTitle,
    this.themeColor = AppColors.primary,
  });

  @override
  State<IslamicDetailScreen> createState() => _IslamicDetailScreenState();
}

class _IslamicDetailScreenState extends State<IslamicDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;

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

    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (playArabic) {
      textToSpeak = widget.content.arabic;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      setState(() => _isPlayingArabic = true);
    } else {
      textToSpeak = '${widget.content.getMeaning(langProvider.languageCode)}. ${widget.content.getDescription(langProvider.languageCode)}';

      switch (langProvider.languageCode) {
        case 'ur':
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case 'hi':
          ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
          break;
        default:
          ttsLangCode = 'en-US';
      }
      setState(() => _isPlayingArabic = false);
    }

    if (textToSpeak.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('no_audio_available'))),
        );
      }
      return;
    }

    await _flutterTts.setLanguage(ttsLangCode);
    setState(() => _isSpeaking = true);
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
    setState(() => _showTranslation = !_showTranslation);
  }

  void _copyContent() {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final meaning = widget.content.getMeaning(langProvider.languageCode);
    final description = widget.content.getDescription(langProvider.languageCode);
    final text = '''
${widget.content.titleArabic}
${widget.content.transliteration}

$meaning

$description
''';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('copied'))),
    );
  }

  void _shareContent() {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final title = widget.content.getTitle(langProvider.languageCode);
    final meaning = widget.content.getMeaning(langProvider.languageCode);
    final description = widget.content.getDescription(langProvider.languageCode);
    final shareText = '''
${widget.content.number}. ${widget.content.titleArabic}
$title

$meaning

$description

- Shared from Noor-ul-Iman App
''';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final langProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: widget.themeColor,
        title: Text(
          widget.screenTitle,
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: responsive.paddingAll(12),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusXLarge),
            border: Border.all(
              color: _isSpeaking
                  ? widget.themeColor
                  : (isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A)),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: widget.themeColor.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Card Header
              Container(
                padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : const Color(0xFFE8F3ED),
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
                          width: responsive.iconSize(40),
                          height: responsive.iconSize(40),
                          decoration: BoxDecoration(
                            color: widget.themeColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.themeColor.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '${widget.content.number}',
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
                            widget.content.getTitle(langProvider.languageCode),
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.w600,
                              fontFamily: langProvider.languageCode == 'ar'
                                  ? 'Amiri'
                                  : (langProvider.languageCode == 'ur' ? 'NotoNastaliq' : null),
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
                          responsive: responsive,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.translate,
                          label: context.tr('translate'),
                          onTap: _toggleTranslation,
                          isActive: _showTranslation,
                          responsive: responsive,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.copy,
                          label: context.tr('copy'),
                          onTap: _copyContent,
                          isActive: false,
                          responsive: responsive,
                        ),
                        _buildHeaderActionButton(
                          icon: Icons.share,
                          label: context.tr('share'),
                          onTap: _shareContent,
                          isActive: false,
                          responsive: responsive,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arabic Text
              GestureDetector(
                onTap: () {
                  if (_isSpeaking && _isPlayingArabic) {
                    _stopPlaying();
                  } else {
                    _playAudio(true);
                  }
                },
                child: Container(
                  margin: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
                  padding: responsive.paddingAll(12),
                  decoration: (_isSpeaking && _isPlayingArabic)
                      ? BoxDecoration(
                          color: widget.themeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(responsive.radiusMedium),
                        )
                      : null,
                  child: Column(
                    children: [
                      if (_isSpeaking && _isPlayingArabic)
                        Padding(
                          padding: EdgeInsets.only(bottom: responsive.spaceSmall),
                          child: Icon(
                            Icons.volume_up,
                            size: responsive.iconSmall,
                            color: widget.themeColor,
                          ),
                        ),
                      Text(
                        widget.content.arabic,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: responsive.fontSize(56),
                          height: 1.5,
                          color: (_isSpeaking && _isPlayingArabic)
                              ? widget.themeColor
                              : widget.themeColor,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                      SizedBox(height: responsive.spaceSmall),
                      Text(
                        widget.content.transliteration,
                        style: TextStyle(
                          fontSize: responsive.textLarge,
                          fontStyle: FontStyle.italic,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
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
                    margin: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
                    padding: responsive.paddingAll(12),
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? widget.themeColor.withValues(alpha: 0.1)
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade50),
                      borderRadius: BorderRadius.circular(responsive.radiusMedium),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (_isSpeaking && !_isPlayingArabic)
                              Padding(
                                padding: EdgeInsets.only(right: responsive.spaceSmall),
                                child: Icon(
                                  Icons.volume_up,
                                  size: responsive.iconSmall,
                                  color: widget.themeColor,
                                ),
                              ),
                            Icon(
                              Icons.info_outline,
                              size: responsive.iconSmall,
                              color: widget.themeColor,
                            ),
                            SizedBox(width: responsive.spaceSmall),
                            Text(
                              context.tr('meaning'),
                              style: TextStyle(
                                fontSize: responsive.textSmall,
                                fontWeight: FontWeight.bold,
                                color: widget.themeColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: responsive.spaceMedium),
                        Text(
                          widget.content.getMeaning(langProvider.languageCode),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                            color: isDark ? AppColors.darkTextPrimary : Colors.black87,
                            fontFamily: langProvider.languageCode == 'ur' ? 'NotoNastaliq' : null,
                          ),
                          textDirection: langProvider.languageCode == 'ur'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        SizedBox(height: responsive.spaceMedium),
                        Text(
                          widget.content.getDescription(langProvider.languageCode),
                          style: TextStyle(
                            fontSize: responsive.textMedium,
                            height: 1.6,
                            color: isDark ? AppColors.darkTextSecondary : Colors.black87,
                            fontFamily: langProvider.languageCode == 'ur' ? 'NotoNastaliq' : null,
                          ),
                          textDirection: langProvider.languageCode == 'ur'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: responsive.spaceMedium),
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
    required ResponsiveUtils responsive,
  }) {
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
                size: responsive.iconSize(22),
                color: isActive ? Colors.white : widget.themeColor,
              ),
              SizedBox(height: responsive.spaceXSmall),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive ? Colors.white : widget.themeColor,
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
