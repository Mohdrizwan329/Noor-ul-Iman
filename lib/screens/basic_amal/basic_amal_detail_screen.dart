import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class BasicAmalDetailScreen extends StatefulWidget {
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final String contentEnglish;
  final String contentUrdu;
  final String contentHindi;
  final String contentArabic;
  final IconData icon;
  final Color color;
  final String categoryKey;
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
    this.titleArabic = '',
    required this.contentEnglish,
    this.contentUrdu = '',
    this.contentHindi = '',
    this.contentArabic = '',
    required this.icon,
    required this.color,
    required this.categoryKey,
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

  String _getCurrentTitle(String langCode) {
    switch (langCode) {
      case 'ur':
        return widget.titleUrdu.isNotEmpty ? widget.titleUrdu : widget.title;
      case 'hi':
        return widget.titleHindi.isNotEmpty ? widget.titleHindi : widget.title;
      case 'ar':
        return widget.titleArabic.isNotEmpty ? widget.titleArabic : widget.title;
      default:
        return widget.title;
    }
  }

  String _getCurrentContent(String langCode) {
    switch (langCode) {
      case 'ur':
        return widget.contentUrdu.isNotEmpty ? widget.contentUrdu : widget.contentEnglish;
      case 'hi':
        return widget.contentHindi.isNotEmpty ? widget.contentHindi : widget.contentEnglish;
      case 'ar':
        return widget.contentArabic.isNotEmpty ? widget.contentArabic : widget.contentEnglish;
      default:
        return widget.contentEnglish;
    }
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

    final langCode = context.read<LanguageProvider>().languageCode;
    String textToSpeak = _getCurrentContent(langCode);
    String ttsLangCode = 'en-US';
    switch (langCode) {
      case 'en':
        ttsLangCode = 'en-US';
        break;
      case 'ur':
        ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
        break;
      case 'hi':
        ttsLangCode = await _isLanguageAvailable('hi-IN') ? 'hi-IN' : 'en-US';
        break;
      case 'ar':
        ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'en-US';
        break;
    }

    if (textToSpeak.isEmpty) {
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

  void copyDetails(BuildContext context) {
    final langCode = context.read<LanguageProvider>().languageCode;
    final text = '''
${_getCurrentTitle(langCode)}
${context.tr(widget.categoryKey)}

${_getCurrentContent(langCode)}

- ${context.tr('from_app')}
''';
    Clipboard.setData(ClipboardData(text: text));
  }

  void shareDetails() {
    final langCode = context.read<LanguageProvider>().languageCode;
    final text = '''
${widget.number != null ? '${widget.number}. ' : ''}${_getCurrentTitle(langCode)}

${_getCurrentContent(langCode)}

- ${context.tr('shared_from_app')}
''';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isRtl = langCode == 'ur' || langCode == 'ar';
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _getCurrentTitle(langCode),
          style: TextStyle(
            fontSize: responsive.fontSize(18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: responsive.paddingAll(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
                border: Border.all(
                  color: _isSpeaking ? AppColors.primaryLight : AppColors.lightGreenBorder,
                  width: _isSpeaking ? 2 : 1.5,
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
                  Container(
                    padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isSpeaking
                          ? AppColors.primaryLight.withValues(alpha: 0.1)
                          : const Color(0xFFE8F3ED),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(responsive.borderRadius(16)),
                        topRight: Radius.circular(responsive.borderRadius(16)),
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
                                color: _isSpeaking ? AppColors.primaryLight : AppColors.primary,
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
                                child: Icon(
                                  widget.icon,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            responsive.hSpaceSmall,
                            Expanded(
                              child: Text(
                                _getCurrentTitle(langCode),
                                style: TextStyle(
                                  fontSize: responsive.fontSize(14),
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        responsive.vSpaceXSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _headerActionButton(
                              icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                              label: _isSpeaking ? context.tr('stop') : context.tr('audio'),
                              onTap: playAudio,
                              isActive: _isSpeaking,
                            ),
                            _headerActionButton(
                              icon: Icons.copy,
                              label: context.tr('copy'),
                              onTap: () => copyDetails(context),
                              isActive: false,
                            ),
                            _headerActionButton(
                              icon: Icons.share,
                              label: context.tr('share'),
                              onTap: shareDetails,
                              isActive: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: responsive.paddingAll(16),
                    child: Text(
                      _getCurrentContent(langCode),
                      style: TextStyle(
                        fontSize: responsive.fontSize(15),
                        height: 1.8,
                        color: _isSpeaking
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                      textAlign: isRtl ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.reference != null) ...[
              responsive.vSpaceSmall,
              _buildInfoCard(
                context: context,
                title: context.tr('reference'),
                content: widget.reference!,
                icon: Icons.book_outlined,
                isRtl: isRtl,
              ),
            ],
            if (widget.importance != null) ...[
              responsive.vSpaceSmall,
              _buildInfoCard(
                context: context,
                title: context.tr('importance'),
                content: widget.importance!,
                icon: Icons.star_outline,
                isRtl: isRtl,
              ),
            ],
            if (widget.warning != null) ...[
              responsive.vSpaceSmall,
              _buildInfoCard(
                context: context,
                title: context.tr('warning'),
                content: widget.warning!,
                icon: Icons.warning_amber_outlined,
                isRtl: isRtl,
                isWarning: true,
              ),
            ],
            if (widget.tip != null) ...[
              responsive.vSpaceSmall,
              _buildInfoCard(
                context: context,
                title: context.tr('tip'),
                content: widget.tip!,
                icon: Icons.lightbulb_outline,
                isRtl: isRtl,
              ),
            ],
            responsive.vSpaceRegular,
              ],
            ),
          ),
        ),
        const BannerAdWidget(),
      ],
    ),
    );
  }

  Widget _headerActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    const lightGreenChip = Color(0xFFE8F3ED);
    final responsive = context.responsive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryLight : lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22.0,
                color: isActive ? Colors.white : AppColors.primary,
              ),
              responsive.vSpaceXSmall,
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.fontSize(10),
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
    required BuildContext context,
    required String title,
    required String content,
    required IconData icon,
    required bool isRtl,
    bool isWarning = false,
  }) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        border: Border.all(
          color: isWarning
              ? Colors.orange.withValues(alpha: 0.5)
              : AppColors.lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isWarning ? Colors.orange : AppColors.primary).withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isWarning
                  ? Colors.orange.withValues(alpha: 0.1)
                  : const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.borderRadius(16)),
                topRight: Radius.circular(responsive.borderRadius(16)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: responsive.spacing(36),
                  height: responsive.spacing(36),
                  decoration: BoxDecoration(
                    color: isWarning ? Colors.orange : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isWarning ? Colors.orange : AppColors.primary).withValues(alpha: 0.3),
                        blurRadius: 6.0,
                        offset: Offset(0, 2.0),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ),
                responsive.hSpaceSmall,
                Text(
                  title,
                  style: TextStyle(
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.w600,
                    color: isWarning ? Colors.orange.shade700 : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: responsive.paddingAll(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                height: 1.6,
                color: Colors.black87,
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
