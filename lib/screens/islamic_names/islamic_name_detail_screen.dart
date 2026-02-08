import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/services/content_service.dart';

enum IslamicNameLanguage { english, urdu, hindi, arabic }

class IslamicNameDetailScreen extends StatefulWidget {
  final String arabicName;
  final String transliteration;
  final String meaning;
  final String meaningUrdu;
  final String meaningHindi;
  final String description;
  final String descriptionUrdu;
  final String descriptionHindi;
  final String category;
  final int number;
  final IconData icon;
  final Color color;
  final String? fatherName;
  final String? motherName;
  final String? birthDate;
  final String? birthPlace;
  final String? deathDate;
  final String? deathPlace;
  final String? spouse;
  final String? children;
  final String? knownFor;
  final String? title;
  final String? tribe;
  final String? era;

  const IslamicNameDetailScreen({
    super.key,
    required this.arabicName,
    required this.transliteration,
    required this.meaning,
    this.meaningUrdu = '',
    this.meaningHindi = '',
    required this.description,
    this.descriptionUrdu = '',
    this.descriptionHindi = '',
    required this.category,
    required this.number,
    required this.icon,
    required this.color,
    this.fatherName,
    this.motherName,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.spouse,
    this.children,
    this.knownFor,
    this.title,
    this.tribe,
    this.era,
  });

  @override
  State<IslamicNameDetailScreen> createState() =>
      _IslamicNameDetailScreenState();
}

class _IslamicNameDetailScreenState extends State<IslamicNameDetailScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final ContentService _contentService = ContentService();
  Map<String, String>? _firestoreNameHindiMap;
  Map<String, String>? _firestoreNameUrduMap;
  Map<String, String>? _firestoreBioHindiMap;
  Map<String, String>? _firestoreBioUrduMap;
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;

  IslamicNameLanguage _getLanguageFromCode(String langCode) {
    switch (langCode) {
      case 'ar':
        return IslamicNameLanguage.arabic;
      case 'en':
        return IslamicNameLanguage.english;
      case 'ur':
        return IslamicNameLanguage.urdu;
      case 'hi':
        return IslamicNameLanguage.hindi;
      default:
        return IslamicNameLanguage.english;
    }
  }

  String _getCurrentMeaning(IslamicNameLanguage selectedLanguage) {
    switch (selectedLanguage) {
      case IslamicNameLanguage.arabic:
        // Arabic uses Urdu translation (both use Arabic script)
        return widget.meaningUrdu.isNotEmpty
            ? widget.meaningUrdu
            : widget.meaning;
      case IslamicNameLanguage.urdu:
        return widget.meaningUrdu.isNotEmpty
            ? widget.meaningUrdu
            : widget.meaning;
      case IslamicNameLanguage.hindi:
        return widget.meaningHindi.isNotEmpty
            ? widget.meaningHindi
            : widget.meaning;
      case IslamicNameLanguage.english:
        return widget.meaning;
    }
  }

  String _getCurrentDescription(IslamicNameLanguage selectedLanguage) {
    switch (selectedLanguage) {
      case IslamicNameLanguage.arabic:
        // Arabic uses Urdu translation (both use Arabic script)
        return widget.descriptionUrdu.isNotEmpty
            ? widget.descriptionUrdu
            : widget.description;
      case IslamicNameLanguage.urdu:
        return widget.descriptionUrdu.isNotEmpty
            ? widget.descriptionUrdu
            : widget.description;
      case IslamicNameLanguage.hindi:
        return widget.descriptionHindi.isNotEmpty
            ? widget.descriptionHindi
            : widget.description;
      case IslamicNameLanguage.english:
        return widget.description;
    }
  }

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    try {
      final nameData = await _contentService.getNameTransliterations('islamic_names');
      final bioData = await _contentService.getNameTransliterations('biographical');
      if (mounted) {
        setState(() {
          if (nameData.isNotEmpty) {
            _firestoreNameHindiMap = nameData['hindi'];
            _firestoreNameUrduMap = nameData['urdu'];
          }
          if (bioData.isNotEmpty) {
            _firestoreBioHindiMap = bioData['hindi'];
            _firestoreBioUrduMap = bioData['urdu'];
          }
        });
      }
    } catch (e) {
      debugPrint('IslamicNameDetail: Error loading from Firestore: $e');
    }
    // Fallback to local asset JSON if Firebase data not loaded
    if (_firestoreNameHindiMap == null) {
      await _loadFromAssets();
    }
  }

  Future<void> _loadFromAssets() async {
    try {
      final nameJsonStr = await rootBundle.loadString(
        'assets/data/firebase/islamic_names_transliterations.json',
      );
      final nameJson = jsonDecode(nameJsonStr) as Map<String, dynamic>;
      final bioJsonStr = await rootBundle.loadString(
        'assets/data/firebase/biographical_transliterations.json',
      );
      final bioJson = jsonDecode(bioJsonStr) as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _firestoreNameHindiMap = (nameJson['hindi'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String));
          _firestoreNameUrduMap = (nameJson['urdu'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String));
          _firestoreBioHindiMap = (bioJson['hindi'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String));
          _firestoreBioUrduMap = (bioJson['urdu'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v as String));
        });
      }
    } catch (e) {
      debugPrint('IslamicNameDetail: Error loading from assets: $e');
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

  Future<void> playAudio(bool playArabic) async {
    if (_isSpeaking) {
      await _stopPlaying();
      return;
    }

    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final currentMeaning = _getCurrentMeaning(selectedLanguage);
    final currentDescription = _getCurrentDescription(selectedLanguage);

    String textToSpeak = '';
    String ttsLangCode = 'en-US';

    if (playArabic) {
      textToSpeak = widget.arabicName;
      ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'ar';
      setState(() {
        _isPlayingArabic = true;
      });
    } else {
      switch (selectedLanguage) {
        case IslamicNameLanguage.english:
          textToSpeak = '$currentMeaning. $currentDescription';
          ttsLangCode = 'en-US';
          break;
        case IslamicNameLanguage.arabic:
          textToSpeak = '$currentMeaning. $currentDescription';
          ttsLangCode = await _isLanguageAvailable('ar-SA') ? 'ar-SA' : 'en-US';
          break;
        case IslamicNameLanguage.urdu:
          textToSpeak = '$currentMeaning. $currentDescription';
          ttsLangCode = await _isLanguageAvailable('ur-PK') ? 'ur-PK' : 'en-US';
          break;
        case IslamicNameLanguage.hindi:
          textToSpeak = '$currentMeaning. $currentDescription';
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

  void toggleTranslation() {
    setState(() {
      _showTranslation = !_showTranslation;
    });
  }

  void copyDetails(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final currentMeaning = _getCurrentMeaning(selectedLanguage);
    final currentDescription = _getCurrentDescription(selectedLanguage);
    final text =
        '''
${widget.arabicName}
${widget.transliteration}

$currentMeaning

$currentDescription

- ${context.tr('from_app')}
''';
    Clipboard.setData(ClipboardData(text: text));
  }

  void shareDetails() {
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final currentMeaning = _getCurrentMeaning(selectedLanguage);
    final currentDescription = _getCurrentDescription(selectedLanguage);
    final text =
        '''
${widget.number}. ${widget.arabicName}
${widget.transliteration}

$currentMeaning

$currentDescription

- ${context.tr('shared_from_app')}
''';
    Share.share(text);
  }

  String _transliterateToHindi(String text) {
    return _firestoreNameHindiMap?[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    return _firestoreNameUrduMap?[text] ?? text;
  }

  String _translateBiographicalValue(
    String value,
    IslamicNameLanguage selectedLanguage,
  ) {
    // Check if value contains pipe-separated translations (format: English | Urdu | Hindi)
    if (value.contains(' | ')) {
      final parts = value.split(' | ');
      if (parts.length == 3) {
        switch (selectedLanguage) {
          case IslamicNameLanguage.english:
            return parts[0].trim();
          case IslamicNameLanguage.arabic:
            return parts[1].trim();
          case IslamicNameLanguage.urdu:
            return parts[1].trim();
          case IslamicNameLanguage.hindi:
            return parts[2].trim();
        }
      }
    }

    final hindiTranslations = _firestoreBioHindiMap ?? {};
    final urduTranslations = _firestoreBioUrduMap ?? {};

    switch (selectedLanguage) {
      case IslamicNameLanguage.arabic:
        return urduTranslations[value] ?? value;
      case IslamicNameLanguage.urdu:
        return urduTranslations[value] ?? value;
      case IslamicNameLanguage.hindi:
        return hindiTranslations[value] ?? value;
      case IslamicNameLanguage.english:
        return value;
    }
  }

  String _getDisplayName(IslamicNameLanguage selectedLanguage) {
    switch (selectedLanguage) {
      case IslamicNameLanguage.arabic:
        // Arabic shows Arabic name directly
        return widget.arabicName;
      case IslamicNameLanguage.urdu:
        return _transliterateToUrdu(widget.transliteration);
      case IslamicNameLanguage.hindi:
        return _transliterateToHindi(widget.transliteration);
      case IslamicNameLanguage.english:
        return widget.transliteration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);
    final currentMeaning = _getCurrentMeaning(selectedLanguage);
    final currentDescription = _getCurrentDescription(selectedLanguage);
    final displayName = _getDisplayName(selectedLanguage);
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const softGold = Color(0xFFC9A24D);
    final isRtl = selectedLanguage == IslamicNameLanguage.urdu || selectedLanguage == IslamicNameLanguage.arabic;

    // Helper function to get category translation key
    String getCategoryKey(String category) {
      switch (category) {
        case 'Panjatan Pak':
          return 'panjatan_pak';
        case 'Ahlul Bayt':
          return 'ahlul_bayt';
        case 'Imam of Ahlul Bayt':
          return 'imam_of_ahlul_bayt';
        case 'Rightly Guided Caliph':
          return 'rightly_guided_caliph';
        case 'Companion of Prophet ﷺ':
          return 'companion_of_prophet';
        case 'Prophet of Allah':
          return 'prophet_of_allah';
        default:
          return category;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.tr(getCategoryKey(widget.category)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: responsive.paddingMedium,
              child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusXLarge),
            border: Border.all(
              color: _isSpeaking
                  ? emeraldGreen
                  : (lightGreenBorder),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.08),
                      blurRadius: 10.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _isSpeaking
                      ? emeraldGreen.withValues(alpha: 0.1)
                      : (lightGreenChip),
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
                          width: responsive.spacing(40),
                          height: responsive.spacing(40),
                          decoration: BoxDecoration(
                            color: _isSpeaking ? emeraldGreen : darkGreen,
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
                              '${widget.number}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.textMedium,
                              ),
                            ),
                          ),
                        ),
                        responsive.hSpaceSmall,
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.w600,
                              color: darkGreen,
                              fontFamily:
                                  selectedLanguage ==
                                      IslamicNameLanguage.urdu
                                  ? 'Poppins'
                                  : null,
                            ),
                            textDirection:
                                selectedLanguage == IslamicNameLanguage.urdu
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                    responsive.vSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _headerActionButton(
                          context: context,
                          icon: _isSpeaking ? Icons.stop : Icons.volume_up,
                          label: _isSpeaking
                              ? context.tr('stop')
                              : context.tr('audio'),
                          onTap: () => playAudio(!_showTranslation),
                          isActive: _isSpeaking,
                        ),
                        _headerActionButton(
                          context: context,
                          icon: Icons.translate,
                          label: context.tr('translate'),
                          onTap: toggleTranslation,
                          isActive: _showTranslation,
                        ),
                        _headerActionButton(
                          context: context,
                          icon: Icons.copy,
                          label: context.tr('copy'),
                          onTap: () => copyDetails(context),
                          isActive: false,
                        ),
                        _headerActionButton(
                          context: context,
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
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  padding: responsive.paddingRegular,
                  decoration: (_isSpeaking && _isPlayingArabic)
                      ? BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            responsive.radiusMedium,
                          ),
                        )
                      : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isSpeaking && _isPlayingArabic)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8),
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
                              widget.arabicName,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 56,
                                height: 1.5,
                                color: (_isSpeaking && _isPlayingArabic)
                                    ? AppColors.primary
                                    : (softGold),
                              ),
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                            ),
                            responsive.vSpaceSmall,
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: responsive.textLarge,
                                fontWeight: FontWeight.w600,
                                color: darkGreen,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                              textDirection:
                                  selectedLanguage == IslamicNameLanguage.urdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
              Center(
                child: Container(
                  margin: responsive.paddingSymmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreenChip,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: lightGreenBorder,
                    ),
                  ),
                  child: Text(
                    currentMeaning,
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.w600,
                      color: softGold,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
              ),
              if (_showTranslation)
                Container(
                    margin: const EdgeInsets.all(12),
                    padding: responsive.paddingRegular,
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (lightGreenChip.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isSpeaking && !_isPlayingArabic)
                          Padding(
                            padding: const EdgeInsets.only(right: 8, top: 4),
                            child: Icon(
                              Icons.volume_up,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: isRtl
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isRtl
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: responsive.iconSmall,
                                    color: AppColors.primary,
                                  ),
                                  responsive.hSpaceSmall,
                                  Text(
                                    context.tr('about'),
                                    style: TextStyle(
                                      fontSize: responsive.textSmall,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontFamily:
                                          selectedLanguage ==
                                              IslamicNameLanguage.urdu
                                          ? 'Poppins'
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              responsive.vSpaceMedium,
                              Text(
                                currentDescription,
                                style: TextStyle(
                                  fontSize: responsive.textRegular,
                                  height: 1.8,
                                  color: (_isSpeaking && !_isPlayingArabic)
                                      ? AppColors.primary
                                      : (Colors.black87),
                                  fontFamily:
                                      selectedLanguage ==
                                          IslamicNameLanguage.urdu
                                      ? 'Poppins'
                                      : null,
                                ),
                                textDirection: isRtl
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                textAlign: isRtl
                                    ? TextAlign.right
                                    : TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              if (!_showTranslation)
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: responsive.paddingRegular,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isRtl
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: isRtl
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          responsive.hSpaceSmall,
                          Text(
                            context.tr('about'),
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      responsive.vSpaceMedium,
                      Text(
                        currentDescription,
                        style: TextStyle(
                          fontSize: responsive.textRegular,
                          height: 1.8,
                          color: AppColors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                        textDirection: isRtl
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        textAlign: isRtl ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              if (_hasBiographicalDetails())
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: responsive.paddingRegular,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          responsive.hSpaceSmall,
                          Text(
                            context.tr('biographical_details'),
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      responsive.vSpaceRegular,
                      _buildBiographicalGrid(
                        context,
                        darkGreen,
                        emeraldGreen,
                        selectedLanguage,
                      ),
                    ],
                  ),
                ),
              responsive.vSpaceMedium,
            ],
          ),
            ),
          ),
        ),
        const BannerAdWidget(),
      ],
    ),
    );
  }

  Widget _headerActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final responsive = context.responsive;
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenChip = Color(0xFFE8F3ED);
    const darkGreen = Color(0xFF0A5C36);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.radiusSmall),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 6.0,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? emeraldGreen
                : (lightGreenChip),
            borderRadius: BorderRadius.circular(responsive.radiusSmall),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: responsive.iconMedium,
                color: isActive
                    ? Colors.white
                    : (darkGreen),
              ),
              responsive.vSpaceXSmall,
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive
                      ? Colors.white
                      : (darkGreen),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasBiographicalDetails() {
    return widget.fatherName != null ||
        widget.motherName != null ||
        widget.birthDate != null ||
        widget.birthPlace != null ||
        widget.deathDate != null ||
        widget.deathPlace != null ||
        widget.spouse != null ||
        widget.children != null ||
        widget.knownFor != null ||
        widget.title != null ||
        widget.tribe != null ||
        widget.era != null;
  }

  Widget _buildBiographicalGrid(
    BuildContext context,
    Color darkGreen,
    Color emeraldGreen,
    IslamicNameLanguage selectedLanguage,
  ) {
    final details = <Map<String, String>>[];

    if (widget.title != null) {
      details.add({
        'label': context.tr('title_label'),
        'value': widget.title!,
        'icon': 'star',
      });
    }
    if (widget.fatherName != null) {
      details.add({
        'label': context.tr('father_label'),
        'value': widget.fatherName!,
        'icon': 'father',
      });
    }
    if (widget.motherName != null) {
      details.add({
        'label': context.tr('mother_label'),
        'value': widget.motherName!,
        'icon': 'mother',
      });
    }
    if (widget.spouse != null) {
      details.add({
        'label': context.tr('spouse_label'),
        'value': widget.spouse!,
        'icon': 'spouse',
      });
    }
    if (widget.children != null) {
      details.add({
        'label': context.tr('children_label'),
        'value': widget.children!,
        'icon': 'children',
      });
    }
    if (widget.birthDate != null) {
      details.add({
        'label': context.tr('birth_date_label'),
        'value': widget.birthDate!,
        'icon': 'birth',
      });
    }
    if (widget.birthPlace != null) {
      details.add({
        'label': context.tr('birth_place_label'),
        'value': widget.birthPlace!,
        'icon': 'place',
      });
    }
    if (widget.deathDate != null) {
      details.add({
        'label': context.tr('death_date_label'),
        'value': widget.deathDate!,
        'icon': 'death',
      });
    }
    if (widget.deathPlace != null) {
      details.add({
        'label': context.tr('death_place_label'),
        'value': widget.deathPlace!,
        'icon': 'place',
      });
    }
    if (widget.tribe != null) {
      details.add({
        'label': context.tr('tribe_label'),
        'value': widget.tribe!,
        'icon': 'tribe',
      });
    }
    if (widget.era != null) {
      details.add({
        'label': context.tr('era_label'),
        'value': widget.era!,
        'icon': 'era',
      });
    }
    if (widget.knownFor != null) {
      details.add({
        'label': context.tr('known_for_label'),
        'value': widget.knownFor!,
        'icon': 'known',
      });
    }

    return Builder(
      builder: (context) => Column(
        children: details
            .map(
              (detail) => _buildDetailRow(
                context,
                detail['label']!,
                detail['value']!,
                _getIconForDetail(detail['icon']!),
                darkGreen,
                emeraldGreen,
                selectedLanguage,
              ),
            )
            .toList(),
      ),
    );
  }

  IconData _getIconForDetail(String iconType) {
    switch (iconType) {
      case 'star':
        return Icons.star_outline;
      case 'father':
        return Icons.person_outline;
      case 'mother':
        return Icons.person_2_outlined;
      case 'spouse':
        return Icons.favorite_outline;
      case 'children':
        return Icons.child_care;
      case 'birth':
        return Icons.cake_outlined;
      case 'death':
        return Icons.event_outlined;
      case 'place':
        return Icons.location_on_outlined;
      case 'tribe':
        return Icons.groups_outlined;
      case 'era':
        return Icons.access_time;
      case 'known':
        return Icons.auto_awesome_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color darkGreen,
    Color emeraldGreen,
    IslamicNameLanguage selectedLanguage,
  ) {
    final responsive = context.responsive;
    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      padding: responsive.paddingMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(responsive.radiusSmall),
            ),
            child: Icon(
              icon,
              size: responsive.iconSmall,
              color: darkGreen,
            ),
          ),
          responsive.hSpaceSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                responsive.vSpaceXSmall,
                Text(
                  _translateBiographicalValue(value, selectedLanguage),
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    fontWeight: FontWeight.w500,
                    color: darkGreen,
                    fontFamily: 'Poppins',
                  ),
                  textDirection: selectedLanguage == IslamicNameLanguage.urdu
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
