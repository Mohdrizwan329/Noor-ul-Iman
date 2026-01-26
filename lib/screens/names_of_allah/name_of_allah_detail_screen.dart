import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../data/models/allah_name_model.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';
import '../../providers/settings_provider.dart';

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
    final Map<String, String> map = {
      'Allah': 'अल्लाह', 'Ar-Rahman': 'अर-रहमान', 'Ar-Raheem': 'अर-रहीम',
      'Al-Malik': 'अल-मलिक', 'Al-Quddus': 'अल-कुद्दूस', 'As-Salam': 'अस-सलाम',
      'Al-Mumin': 'अल-मुमिन', 'Al-Muhaymin': 'अल-मुहैमिन', 'Al-Aziz': 'अल-अज़ीज़',
      'Al-Jabbar': 'अल-जब्बार', 'Al-Mutakabbir': 'अल-मुतकब्बिर', 'Al-Khaliq': 'अल-ख़ालिक़',
      'Al-Bari': 'अल-बारी', 'Al-Musawwir': 'अल-मुसव्विर', 'Al-Ghaffar': 'अल-ग़फ़्फ़ार',
      'Al-Qahhar': 'अल-क़ह्हार', 'Al-Wahhab': 'अल-वह्हाब', 'Ar-Razzaq': 'अर-रज़्ज़ाक़',
      'Al-Fattah': 'अल-फ़त्ताह', 'Al-Alim': 'अल-अलीम', 'Al-Qabid': 'अल-क़ाबिद',
      'Al-Basit': 'अल-बासित', 'Al-Khafid': 'अल-ख़ाफ़िद', 'Ar-Rafi': 'अर-राफ़ि',
      'Al-Muizz': 'अल-मुइज़्ज़', 'Al-Mudhill': 'अल-मुज़िल्ल', 'As-Sami': 'अस-समी',
      'Al-Basir': 'अल-बसीर', 'Al-Hakam': 'अल-हकम', 'Al-Adl': 'अल-अद्ल',
      'Al-Latif': 'अल-लतीफ़', 'Al-Khabir': 'अल-ख़बीर', 'Al-Halim': 'अल-हलीम',
      'Al-Azim': 'अल-अज़ीम', 'Al-Ghafur': 'अल-ग़फ़ूर', 'Ash-Shakur': 'अश-शकूर',
      'Al-Ali': 'अल-अली', 'Al-Kabir': 'अल-कबीर', 'Al-Hafiz': 'अल-हाफ़िज़',
      'Al-Muqit': 'अल-मुक़ीत', 'Al-Hasib': 'अल-हसीब', 'Al-Jalil': 'अल-जलील',
      'Al-Karim': 'अल-करीम', 'Ar-Raqib': 'अर-रक़ीब', 'Al-Mujib': 'अल-मुजीब',
      'Al-Wasi': 'अल-वासि', 'Al-Hakim': 'अल-हकीम', 'Al-Wadud': 'अल-वदूद',
      'Al-Majid': 'अल-मजीद', 'Al-Baith': 'अल-बाइस', 'Ash-Shahid': 'अश-शहीद',
      'Al-Haqq': 'अल-हक़्क़', 'Al-Wakil': 'अल-वकील', 'Al-Qawiyy': 'अल-क़वीय्य',
      'Al-Matin': 'अल-मतीन', 'Al-Waliyy': 'अल-वलीय्य', 'Al-Hamid': 'अल-हमीद',
      'Al-Muhsi': 'अल-मुहसी', 'Al-Mubdi': 'अल-मुब्दि', 'Al-Muid': 'अल-मुईद',
      'Al-Muhyi': 'अल-मुह्यी', 'Al-Mumit': 'अल-मुमीत', 'Al-Hayy': 'अल-हय्य',
      'Al-Qayyum': 'अल-क़य्यूम', 'Al-Wajid': 'अल-वाजिद', 'Al-Wahid': 'अल-वाहिद',
      'Al-Ahad': 'अल-अहद', 'As-Samad': 'अस-समद', 'Al-Qadir': 'अल-क़ादिर',
      'Al-Muqtadir': 'अल-मुक़्तदिर', 'Al-Muqaddim': 'अल-मुक़द्दिम', 'Al-Muakhkhir': 'अल-मुअख़्ख़िर',
      'Al-Awwal': 'अल-अव्वल', 'Al-Akhir': 'अल-आख़िर', 'Az-Zahir': 'अज़-ज़ाहिर',
      'Al-Batin': 'अल-बातिन', 'Al-Wali': 'अल-वाली', 'Al-Mutaali': 'अल-मुताली',
      'Al-Barr': 'अल-बर्र', 'At-Tawwab': 'अत-तव्वाब', 'Al-Muntaqim': 'अल-मुन्तक़िम',
      'Al-Afuww': 'अल-अफ़ुव्व', 'Ar-Rauf': 'अर-रऊफ़', 'Malik-ul-Mulk': 'मलिक-उल-मुल्क',
      'Dhul-Jalal-wal-Ikram': 'ज़ुल-जलाल-वल-इकराम', 'Al-Muqsit': 'अल-मुक़सित',
      'Al-Jami': 'अल-जामि', 'Al-Ghani': 'अल-ग़नी', 'Al-Mughni': 'अल-मुग़नी',
      'Al-Mani': 'अल-मानि', 'Ad-Darr': 'अद-दर्र', 'An-Nafi': 'अन-नाफ़ि',
      'An-Nur': 'अन-नूर', 'Al-Hadi': 'अल-हादी', 'Al-Badi': 'अल-बदी',
      'Al-Baqi': 'अल-बाक़ी', 'Al-Warith': 'अल-वारिस', 'Ar-Rashid': 'अर-रशीद',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      'Allah': 'اللہ', 'Ar-Rahman': 'الرحمان', 'Ar-Raheem': 'الرحیم',
      'Al-Malik': 'الملک', 'Al-Quddus': 'القدوس', 'As-Salam': 'السلام',
      'Al-Mumin': 'المومن', 'Al-Muhaymin': 'المہیمن', 'Al-Aziz': 'العزیز',
      'Al-Jabbar': 'الجبار', 'Al-Mutakabbir': 'المتکبر', 'Al-Khaliq': 'الخالق',
      'Al-Bari': 'الباری', 'Al-Musawwir': 'المصور', 'Al-Ghaffar': 'الغفار',
      'Al-Qahhar': 'القہار', 'Al-Wahhab': 'الوہاب', 'Ar-Razzaq': 'الرزاق',
      'Al-Fattah': 'الفتاح', 'Al-Alim': 'العلیم', 'Al-Qabid': 'القابض',
      'Al-Basit': 'الباسط', 'Al-Khafid': 'الخافض', 'Ar-Rafi': 'الرافع',
      'Al-Muizz': 'المعز', 'Al-Mudhill': 'المذل', 'As-Sami': 'السمیع',
      'Al-Basir': 'البصیر', 'Al-Hakam': 'الحکم', 'Al-Adl': 'العدل',
      'Al-Latif': 'اللطیف', 'Al-Khabir': 'الخبیر', 'Al-Halim': 'الحلیم',
      'Al-Azim': 'العظیم', 'Al-Ghafur': 'الغفور', 'Ash-Shakur': 'الشکور',
      'Al-Ali': 'العلی', 'Al-Kabir': 'الکبیر', 'Al-Hafiz': 'الحفیظ',
      'Al-Muqit': 'المقیت', 'Al-Hasib': 'الحسیب', 'Al-Jalil': 'الجلیل',
      'Al-Karim': 'الکریم', 'Ar-Raqib': 'الرقیب', 'Al-Mujib': 'المجیب',
      'Al-Wasi': 'الواسع', 'Al-Hakim': 'الحکیم', 'Al-Wadud': 'الودود',
      'Al-Majid': 'المجید', 'Al-Baith': 'الباعث', 'Ash-Shahid': 'الشہید',
      'Al-Haqq': 'الحق', 'Al-Wakil': 'الوکیل', 'Al-Qawiyy': 'القوی',
      'Al-Matin': 'المتین', 'Al-Waliyy': 'الولی', 'Al-Hamid': 'الحمید',
      'Al-Muhsi': 'المحصی', 'Al-Mubdi': 'المبدی', 'Al-Muid': 'المعید',
      'Al-Muhyi': 'المحیی', 'Al-Mumit': 'الممیت', 'Al-Hayy': 'الحی',
      'Al-Qayyum': 'القیوم', 'Al-Wajid': 'الواجد', 'Al-Wahid': 'الواحد',
      'Al-Ahad': 'الاحد', 'As-Samad': 'الصمد', 'Al-Qadir': 'القادر',
      'Al-Muqtadir': 'المقتدر', 'Al-Muqaddim': 'المقدم', 'Al-Muakhkhir': 'المؤخر',
      'Al-Awwal': 'الاول', 'Al-Akhir': 'الآخر', 'Az-Zahir': 'الظاہر',
      'Al-Batin': 'الباطن', 'Al-Wali': 'الوالی', 'Al-Mutaali': 'المتعالی',
      'Al-Barr': 'البر', 'At-Tawwab': 'التواب', 'Al-Muntaqim': 'المنتقم',
      'Al-Afuww': 'العفو', 'Ar-Rauf': 'الرؤوف', 'Malik-ul-Mulk': 'مالک الملک',
      'Dhul-Jalal-wal-Ikram': 'ذوالجلال والاکرام', 'Al-Muqsit': 'المقسط',
      'Al-Jami': 'الجامع', 'Al-Ghani': 'الغنی', 'Al-Mughni': 'المغنی',
      'Al-Mani': 'المانع', 'Ad-Darr': 'الضار', 'An-Nafi': 'النافع',
      'An-Nur': 'النور', 'Al-Hadi': 'الہادی', 'Al-Badi': 'البدیع',
      'Al-Baqi': 'الباقی', 'Al-Warith': 'الوارث', 'Ar-Rashid': 'الرشید',
    };
    return map[text] ?? text;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.tr('no_audio_available'))),
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('copied'))));
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
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final langProvider = context.watch<LanguageProvider>();
    final selectedLanguage = _getLanguageFromCode(langProvider.languageCode);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          _getDisplayName(langProvider.languageCode),
          style: TextStyle(
            fontSize: responsive.textLarge,
            fontWeight: FontWeight.bold,
            fontFamily: langProvider.languageCode == 'ar'
                ? 'Amiri'
                : (langProvider.languageCode == 'ur' ? 'NotoNastaliq' : null),
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
                  ? const Color(0xFF1E8F5A)
                  : (isDark ? Colors.grey.shade700 : const Color(0xFF8AAF9A)),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
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
              GestureDetector(
                onTap: () {
                  if (_isSpeaking && _isPlayingArabic) {
                    _stopPlaying();
                  } else {
                    _playAudio(true);
                  }
                },
                child: Container(
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
                                fontFamily: 'Amiri',
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
                                fontSize: responsive.textXLarge,
                                fontFamily: langProvider.languageCode == 'ar'
                                    ? 'Amiri'
                                    : (langProvider.languageCode == 'ur' ? 'NotoNastaliq' : null),
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
                    margin: responsive.paddingSymmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    padding: responsive.paddingAll(12),
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? Colors.grey.shade800 : Colors.grey.shade50),
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
                                      : (isDark ? AppColors.darkTextPrimary : Colors.black87),
                                  fontFamily: selectedLanguage == AllahNameLanguage.urdu
                                      ? 'NotoNastaliq'
                                      : null,
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
                size: responsive.iconSize(22),
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
