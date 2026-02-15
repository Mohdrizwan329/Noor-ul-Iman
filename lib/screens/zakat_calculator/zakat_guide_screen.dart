import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/content_service.dart';
import '../../core/utils/app_utils.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class ZakatGuideScreen extends StatefulWidget {
  const ZakatGuideScreen({super.key});

  @override
  State<ZakatGuideScreen> createState() => _ZakatGuideScreenState();
}

class _ZakatGuideScreenState extends State<ZakatGuideScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  int? _playingSectionIndex;

  // Firebase content
  final ContentService _contentService = ContentService();
  ZakatGuideContentFirestore? _guideContent;
  bool _isContentLoading = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadContent();
  }

  Future<void> _loadContent() async {
    final content = await _contentService.getZakatGuideScreenContent();
    if (mounted) {
      setState(() {
        _guideContent = content;
        _isContentLoading = false;
      });
    }
  }

  String _t(String key) {
    if (_guideContent == null) return key;
    final langCode = context.read<LanguageProvider>().languageCode;
    return _guideContent!.getString(key, langCode);
  }

  String _langCode() {
    return context.read<LanguageProvider>().languageCode;
  }

  bool _isRtl() {
    final langCode = _langCode();
    return langCode == 'ur' || langCode == 'ar';
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
          _playingSectionIndex = null;
        });
      }
    });

    _flutterTts.setErrorHandler((error) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _playingSectionIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playSection(int sectionIndex) async {
    if (_playingSectionIndex == sectionIndex && _isSpeaking) {
      await _stopPlaying();
      return;
    }

    await _stopPlaying();

    if (_guideContent == null) return;
    final section = _guideContent!.sections[sectionIndex];
    final langCode = _langCode();
    final textToSpeak = section.content.get(langCode);

    String ttsLangCode = 'en-US';
    switch (langCode) {
      case 'ur':
        ttsLangCode = await _getAvailableLanguage([
          'ur-PK',
          'ur-IN',
          'ur',
          'hi-IN',
        ]);
        break;
      case 'ar':
        ttsLangCode = await _getAvailableLanguage([
          'ar-SA',
          'ar-EG',
          'ar',
          'ur-PK',
        ]);
        break;
      case 'hi':
        ttsLangCode = await _getAvailableLanguage([
          'hi-IN',
          'hi',
          'en-IN',
          'en-US',
        ]);
        break;
      case 'en':
      default:
        ttsLangCode = 'en-US';
        break;
    }

    await _flutterTts.setLanguage(ttsLangCode);

    setState(() {
      _playingSectionIndex = sectionIndex;
      _isSpeaking = true;
    });

    await _flutterTts.speak(textToSpeak);
  }

  Future<String> _getAvailableLanguage(List<String> langCodes) async {
    for (final langCode in langCodes) {
      if (await _isLanguageAvailable(langCode)) {
        return langCode;
      }
    }
    return 'en-US';
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
      _playingSectionIndex = null;
    });
  }

  void _copySection(int sectionIndex) {
    if (_guideContent == null) return;
    final section = _guideContent!.sections[sectionIndex];
    final langCode = _langCode();
    final title = section.title.get(langCode);
    final content = section.content.get(langCode);

    Clipboard.setData(ClipboardData(text: '$title\n\n$content'));
  }

  void _shareSection(int sectionIndex) {
    if (_guideContent == null) return;
    final section = _guideContent!.sections[sectionIndex];
    final langCode = _langCode();
    final title = section.title.get(langCode);
    final content = section.content.get(langCode);
    final sharedFrom = _t('shared_from');

    Share.share('$title\n\n$content\n\n- $sharedFrom');
  }

  @override
  Widget build(BuildContext context) {
    // Watch for language changes
    context.watch<LanguageProvider>();

    if (_isContentLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final sections = _guideContent?.sections ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_t('zakat_guide')),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveUtils(context).spacing(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  SizedBox(height: ResponsiveUtils(context).spacing(24)),
                  ...List.generate(sections.length, (index) {
                    return Column(
                      children: [
                        _buildSection(sectionIndex: index),
                        SizedBox(height: ResponsiveUtils(context).spacing(20)),
                      ],
                    );
                  }),
                  _buildHadithCard(),
                  SizedBox(height: ResponsiveUtils(context).spacing(32)),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    final responsive = ResponsiveUtils(context);
    return Container(
      width: double.infinity,
      padding: responsive.paddingAll(14),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: responsive.spacing(15),
            offset: Offset(0, responsive.spacing(8)),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _t('zakat_arabic_calligraphy'),
            style: TextStyle(
              fontSize: responsive.fontSize(48),
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            _t('zakat_title'),
            style: TextStyle(
              fontSize: responsive.fontSize(24),
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            _t('zakat_subtitle'),
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: responsive.spacing(16)),
          Container(
            padding: responsive.paddingSymmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            ),
            child: Text(
              _t('zakat_percentage'),
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static IconData _mapIcon(String iconName) {
    switch (iconName) {
      case 'calculate': return Icons.calculate;
      case 'account_balance': return Icons.account_balance;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'people': return Icons.people;
      case 'calendar_today': return Icons.calendar_today;
      case 'star': return Icons.star;
      case 'menu_book': return Icons.menu_book;
      case 'info': return Icons.info;
      case 'check_circle': return Icons.check_circle;
      case 'monetization_on': return Icons.monetization_on;
      case 'balance': return Icons.balance;
      case 'favorite': return Icons.favorite;
      case 'handshake': return Icons.handshake;
      case 'shield': return Icons.shield;
      case 'mosque': return Icons.mosque;
      case 'auto_stories': return Icons.auto_stories;
      case 'library_books': return Icons.library_books;
      case 'format_quote': return Icons.format_quote;
      case 'water_drop': return Icons.water_drop;
      case 'landscape': return Icons.landscape;
      case 'nights_stay': return Icons.nights_stay;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'circle': return Icons.circle;
      default: return Icons.star;
    }
  }

  Widget _buildSection({required int sectionIndex}) {
    final responsive = ResponsiveUtils(context);
    if (_guideContent == null) return const SizedBox.shrink();
    final section = _guideContent!.sections[sectionIndex];
    final isPlaying = _playingSectionIndex == sectionIndex && _isSpeaking;
    final langCode = _langCode();
    final isRtl = _isRtl();

    final title = section.title.get(langCode);
    final content = section.content.get(langCode);
    final iconData = _mapIcon(section.icon);

    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        border: Border.all(
          color: isPlaying
              ? AppColors.primary
              : (lightGreenBorder),
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
                BoxShadow(
                  color: darkGreen.withValues(alpha: 0.08),
                  blurRadius: responsive.spacing(10),
                  offset: Offset(0, responsive.spacing(2)),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: responsive.paddingAll(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F3ED),
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
                      padding: responsive.paddingAll(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                      ),
                      child: Icon(
                        iconData,
                        color: AppColors.primary,
                        size: responsive.iconSize(24),
                      ),
                    ),
                    SizedBox(width: responsive.spacing(12)),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: responsive.fontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: isRtl ? 'Poppins' : null,
                        ),
                        textDirection:
                            isRtl ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spacing(12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying ? _t('stop') : _t('audio'),
                      onTap: () => _playSection(sectionIndex),
                      isActive: isPlaying,
                    ),
                    _buildActionButton(
                      icon: Icons.copy,
                      label: _t('copy'),
                      onTap: () => _copySection(sectionIndex),
                      isActive: false,
                    ),
                    _buildActionButton(
                      icon: Icons.share,
                      label: _t('share'),
                      onTap: () => _shareSection(sectionIndex),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: responsive.paddingAll(16),
            child: Text(
              content.trim(),
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                height: 1.6,
                color: AppColors.textSecondary,
              ),
              textDirection:
                  isRtl ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = ResponsiveUtils(context);
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
        child: Container(
          padding: responsive.paddingSymmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? emeraldGreen : lightGreenChip,
            borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: responsive.iconSize(22), color: isActive ? Colors.white : darkGreen),
              SizedBox(height: responsive.spacing(2)),
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.fontSize(10),
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

  Widget _buildHadithCard() {
    final responsive = ResponsiveUtils(context);

    return Container(
      width: double.infinity,
      padding: responsive.paddingAll(14),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote, color: Colors.white, size: responsive.iconSize(32)),
          SizedBox(height: responsive.spacing(12)),
          Text(
            _t('hadith_arabic'),
            style: TextStyle(
              fontSize: responsive.fontSize(24),
              fontFamily: 'Poppins',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsive.spacing(12)),
          Text(
            _t('hadith_translation'),
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              color: Colors.white.withValues(alpha: 0.95),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
            textDirection: _isRtl() ? TextDirection.rtl : TextDirection.ltr,
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            _t('hadith_reference'),
            style: TextStyle(
              fontSize: responsive.fontSize(12),
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
