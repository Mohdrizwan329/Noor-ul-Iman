import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/header_action_button.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

class SevenKalmaScreen extends StatefulWidget {
  const SevenKalmaScreen({super.key});

  @override
  State<SevenKalmaScreen> createState() => _SevenKalmaScreenState();
}

class _SevenKalmaScreenState extends State<SevenKalmaScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final ContentService _contentService = ContentService();
  int? _playingKalma;
  final Set<int> _cardsWithTranslation = {};
  List<Map<String, dynamic>> _kalmas = [];
  bool _isLoading = true;

  // Color mapping for kalmas
  static const List<Color> _kalmaColors = [
    Colors.green,   // Kalma 1
    Colors.blue,    // Kalma 2
    Colors.purple,  // Kalma 3
    Colors.orange,  // Kalma 4
    Colors.teal,    // Kalma 5
    Colors.indigo,  // Kalma 6
    Colors.red,     // Kalma 7
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadKalmas();
  }

  Future<void> _loadKalmas() async {
    try {
      // Load from Firebase via ContentService (falls back to local asset JSON)
      final firestoreKalmas = await _contentService.getKalmas();
      if (mounted) {
        setState(() {
          _kalmas = firestoreKalmas.map((k) => _convertFirestoreKalma(k)).toList();
          _isLoading = false;
        });
        debugPrint('Loaded ${_kalmas.length} kalmas');
      }
    } catch (e) {
      debugPrint('Error loading kalmas: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> _convertFirestoreKalma(KalmaFirestore k) {
    return {
      'number': k.number,
      'name': k.name.en,
      'nameUrdu': k.name.ur,
      'nameHindi': k.name.hi,
      'nameArabic': k.name.ar,
      'arabic': k.arabic,
      'transliteration': k.transliteration,
      'translationEnglish': k.translation.en,
      'translationUrdu': k.translation.ur,
      'translationHindi': k.translation.hi,
      'translationArabic': k.translation.ar,
      'color': _kalmaColors[(k.number - 1) % _kalmaColors.length],
    };
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage('ar-SA');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _playingKalma = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _playAudio(int kalmaNumber, String arabicText) async {
    if (_playingKalma == kalmaNumber) {
      await _flutterTts.stop();
      setState(() {
        _playingKalma = null;
      });
    } else {
      setState(() {
        _playingKalma = kalmaNumber;
      });
      await _flutterTts.speak(arabicText);
    }
  }

  void _toggleTranslation(int kalmaNumber) {
    setState(() {
      if (_cardsWithTranslation.contains(kalmaNumber)) {
        _cardsWithTranslation.remove(kalmaNumber);
      } else {
        _cardsWithTranslation.add(kalmaNumber);
      }
    });
  }

  void _copyKalma(Map<String, dynamic> kalma, String langCode) {
    final name = _getLocalizedName(kalma, langCode);
    final translation = _getLocalizedTranslation(kalma, langCode);

    final copyText =
        '''$name

${kalma['arabic']}

${kalma['transliteration']}

$translation''';

    Clipboard.setData(ClipboardData(text: copyText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('copied_to_clipboard')),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareKalma(Map<String, dynamic> kalma, String langCode) {
    final name = _getLocalizedName(kalma, langCode);
    final translation = _getLocalizedTranslation(kalma, langCode);

    final shareText =
        '''$name

${kalma['arabic']}

${kalma['transliteration']}

$translation

- Noor-ul-Iman App''';

    Share.share(shareText);
  }

  String _getLocalizedName(Map<String, dynamic> kalma, String langCode) {
    return langCode == 'en'
        ? kalma['name']
        : langCode == 'ur'
        ? kalma['nameUrdu']
        : langCode == 'ar'
        ? kalma['nameArabic']
        : kalma['nameHindi'];
  }

  String _getLocalizedTranslation(Map<String, dynamic> kalma, String langCode) {
    return langCode == 'en'
        ? kalma['translationEnglish']
        : langCode == 'ur'
        ? kalma['translationUrdu']
        : langCode == 'ar'
        ? kalma['translationArabic']
        : kalma['translationHindi'];
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: responsive.iconMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('seven_kalma'),
          style: TextStyle(
            color: Colors.white,
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: responsive.paddingRegular,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kalmas List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: AdListHelper.totalCount(_kalmas.length),
                    itemBuilder: (context, index) {
                      if (AdListHelper.isAdPosition(index)) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: BannerAdWidget(height: 250),
                        );
                      }
                      final dataIdx = AdListHelper.dataIndex(index);
                      final kalma = _kalmas[dataIdx];
                      return _buildKalmaCard(context, kalma);
                    },
                  ),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildKalmaCard(
    BuildContext context,
    Map<String, dynamic> kalma,
  ) {
    final responsive = ResponsiveUtils(context);
    final langCode = context.watch<LanguageProvider>().languageCode;
    final kalmaNumber = kalma['number'] as int;
    final isPlaying = _playingKalma == kalmaNumber;
    final showTranslation = _cardsWithTranslation.contains(kalmaNumber);

    final name = _getLocalizedName(kalma, langCode);
    final translation = _getLocalizedTranslation(kalma, langCode);

    // Green theme colors matching Surah details screen
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: EdgeInsets.only(bottom: responsive.spaceRegular),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isPlaying
              ? AppColors.primary
              : (lightGreenBorder),
          width: isPlaying ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with Number and Name
          Container(
            padding: responsive.paddingSymmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isPlaying
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : (lightGreenChip),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(responsive.radiusLarge),
                topRight: Radius.circular(responsive.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                // First row: Number badge and Kalma title
                Row(
                  children: [
                    Container(
                      width: responsive.spacing(40),
                      height: responsive.spacing(40),
                      decoration: BoxDecoration(
                        color: isPlaying ? AppColors.primary : darkGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: darkGreen.withValues(alpha: 0.3),
                            blurRadius: 6.0,
                            offset: const Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${kalma['number']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.textMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    responsive.hSpaceMedium,
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection: langCode == 'ur' || langCode == 'ar'
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                    ),
                  ],
                ),
                responsive.vSpaceSmall,
                // Second row: Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HeaderActionButton(
                      icon: isPlaying ? Icons.stop : Icons.volume_up,
                      label: isPlaying
                          ? context.tr('stop')
                          : context.tr('audio'),
                      onTap: () => _playAudio(kalmaNumber, kalma['arabic']),
                      isActive: isPlaying,
                    ),
                    HeaderActionButton(
                      icon: Icons.translate,
                      label: context.tr('translate'),
                      onTap: () => _toggleTranslation(kalmaNumber),
                      isActive: showTranslation,
                    ),
                    HeaderActionButton(
                      icon: Icons.copy,
                      label: context.tr('copy'),
                      onTap: () => _copyKalma(kalma, langCode),
                      isActive: false,
                    ),
                    HeaderActionButton(
                      icon: Icons.share,
                      label: context.tr('share'),
                      onTap: () => _shareKalma(kalma, langCode),
                      isActive: false,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Arabic Text
          GestureDetector(
            onTap: () => _playAudio(kalmaNumber, kalma['arabic']),
            child: Container(
              padding: responsive.paddingLarge,
              decoration: isPlaying
                  ? BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                    )
                  : null,
              child: Row(
                children: [
                  if (isPlaying)
                    Padding(
                      padding: EdgeInsets.only(right: responsive.spaceSmall),
                      child: Icon(
                        Icons.volume_up,
                        size: responsive.iconSmall,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      kalma['arabic'],
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: responsive.textXXLarge,
                        fontWeight: FontWeight.w600,
                        color: isPlaying
                            ? AppColors.primary
                            : (Colors.black87),
                        height: 2.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Translation (only visible when translate button is clicked)
          if (showTranslation)
            Container(
              padding: responsive.paddingLarge,
              decoration: BoxDecoration(
                color: showTranslation
                    ? lightGreenChip.withValues(alpha: 0.5)
                    : null,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(responsive.radiusLarge),
                  bottomRight: Radius.circular(responsive.radiusLarge),
                ),
              ),
              child: Text(
                translation,
                textAlign: langCode == 'ur' || langCode == 'ar'
                    ? TextAlign.right
                    : TextAlign.left,
                textDirection: langCode == 'ur' || langCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                style: TextStyle(
                  fontSize: responsive.textMedium,
                  color: AppColors.textSecondary,
                  height: 1.8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
