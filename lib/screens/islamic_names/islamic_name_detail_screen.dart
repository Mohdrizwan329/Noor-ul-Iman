import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';

enum IslamicNameLanguage { english, urdu, hindi }

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
  bool _isSpeaking = false;
  bool _showTranslation = false;
  bool _isPlayingArabic = false;

  IslamicNameLanguage _getLanguageFromCode(String langCode) {
    switch (langCode) {
      case 'ar':
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
      case IslamicNameLanguage.urdu:
        return widget.meaningUrdu.isNotEmpty
            ? widget.meaningUrdu
            : widget.meaning;
      case IslamicNameLanguage.hindi:
        return widget.meaningHindi.isNotEmpty
            ? widget.meaningHindi
            : widget.meaning;
      default:
        return widget.meaning;
    }
  }

  String _getCurrentDescription(IslamicNameLanguage selectedLanguage) {
    switch (selectedLanguage) {
      case IslamicNameLanguage.urdu:
        return widget.descriptionUrdu.isNotEmpty
            ? widget.descriptionUrdu
            : widget.description;
      case IslamicNameLanguage.hindi:
        return widget.descriptionHindi.isNotEmpty
            ? widget.descriptionHindi
            : widget.description;
      default:
        return widget.description;
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('no_text_for_audio')),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('copied')),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
    final Map<String, String> map = {
      // Prophets
      'Adam': 'आदम', 'Idris': 'इदरीस', 'Nuh (Noah)': 'नूह', 'Hud': 'हूद',
      'Salih': 'सालिह', 'Ibrahim (Abraham)': 'इब्राहीम', 'Lut (Lot)': 'लूत',
      'Ismail (Ishmael)': 'इस्माईल',
      'Ishaq (Isaac)': 'इसहाक़',
      'Yaqub (Jacob)': 'याक़ूब',
      'Yusuf (Joseph)': 'यूसुफ़', 'Ayyub (Job)': 'अय्यूब', 'Shuaib': 'शुऐब',
      'Musa (Moses)': 'मूसा',
      'Harun (Aaron)': 'हारून',
      'Dhul-Kifl': 'ज़ुल-किफ़्ल',
      'Dawud (David)': 'दाऊद',
      'Sulaiman (Solomon)': 'सुलैमान',
      'Ilyas (Elijah)': 'इल्यास',
      'Al-Yasa (Elisha)': 'अल-यसा',
      'Yunus (Jonah)': 'यूनुस',
      'Zakariya (Zechariah)': 'ज़करिया',
      'Yahya (John)': 'यहया',
      'Isa (Jesus)': 'ईसा',
      'Muhammad': 'मुहम्मद',
      'Muhammad ﷺ': 'मुहम्मद ﷺ',
      // Sahaba (Companions)
      'Abu Bakr As-Siddiq': 'अबू बक्र सिद्दीक़',
      'Umar ibn Al-Khattab': 'उमर बिन अल-ख़त्ताब',
      'Uthman ibn Affan': 'उस्मान बिन अफ़्फ़ान',
      'Ali ibn Abi Talib': 'अली बिन अबी तालिब',
      'Talha ibn Ubaydullah': 'तल्हा बिन उबैदुल्लाह',
      'Zubayr ibn Al-Awwam': 'ज़ुबैर बिन अल-अव्वाम',
      'Abdur Rahman ibn Awf': 'अब्दुर्रहमान बिन औफ़',
      'Saad ibn Abi Waqqas': 'साद बिन अबी वक़्क़ास',
      'Said ibn Zayd': 'सईद बिन ज़ैद',
      'Abu Ubayda ibn Al-Jarrah': 'अबू उबैदा बिन अल-जर्राह',
      'Bilal ibn Rabah': 'बिलाल बिन रबाह',
      'Abu Dharr Al-Ghifari': 'अबू ज़र ग़िफ़ारी',
      'Salman Al-Farsi': 'सलमान फ़ारसी', 'Ammar ibn Yasir': 'अम्मार बिन यासिर',
      'Hudhayfah ibn Al-Yaman': 'हुज़ैफ़ा बिन अल-यमान',
      'Abu Hurayrah': 'अबू हुरैरा',
      'Abdullah ibn Masud': 'अब्दुल्लाह बिन मसऊद',
      'Abdullah ibn Abbas': 'अब्दुल्लाह बिन अब्बास',
      'Abdullah ibn Umar': 'अब्दुल्लाह बिन उमर',
      'Anas ibn Malik': 'अनस बिन मालिक',
      // Panjatan Pak & Ahlebait
      'Khadijah bint Khuwaylid': 'ख़दीजा बिन्त ख़ुवैलिद',
      'Fatimah Az-Zahra': 'फ़ातिमा ज़हरा',
      'Hasan ibn Ali': 'हसन बिन अली', 'Husayn ibn Ali': 'हुसैन बिन अली',
      'Zaynab bint Ali': 'ज़ैनब बिन्त अली',
      'Umm Kulthum bint Ali': 'उम्मे कुलसूम बिन्त अली',
      'Aisha bint Abi Bakr': 'आयशा बिन्त अबी बक्र',
      'Hafsa bint Umar': 'हफ़सा बिन्त उमर',
      'Zaynab bint Jahsh': 'ज़ैनब बिन्त जहश', 'Umm Salamah': 'उम्मे सलमा',
    };
    return map[text] ?? text;
  }

  String _transliterateToUrdu(String text) {
    final Map<String, String> map = {
      // Prophets
      'Adam': 'آدم', 'Idris': 'ادریس', 'Nuh (Noah)': 'نوح', 'Hud': 'ہود',
      'Salih': 'صالح', 'Ibrahim (Abraham)': 'ابراہیم', 'Lut (Lot)': 'لوط',
      'Ismail (Ishmael)': 'اسماعیل',
      'Ishaq (Isaac)': 'اسحاق',
      'Yaqub (Jacob)': 'یعقوب',
      'Yusuf (Joseph)': 'یوسف', 'Ayyub (Job)': 'ایوب', 'Shuaib': 'شعیب',
      'Musa (Moses)': 'موسیٰ', 'Harun (Aaron)': 'ہارون', 'Dhul-Kifl': 'ذوالکفل',
      'Dawud (David)': 'داؤد',
      'Sulaiman (Solomon)': 'سلیمان',
      'Ilyas (Elijah)': 'الیاس',
      'Al-Yasa (Elisha)': 'الیسع',
      'Yunus (Jonah)': 'یونس',
      'Zakariya (Zechariah)': 'زکریا',
      'Yahya (John)': 'یحییٰ',
      'Isa (Jesus)': 'عیسیٰ',
      'Muhammad': 'محمد',
      'Muhammad ﷺ': 'محمد ﷺ',
      // Sahaba (Companions)
      'Abu Bakr As-Siddiq': 'ابوبکر صدیق',
      'Umar ibn Al-Khattab': 'عمر بن الخطاب',
      'Uthman ibn Affan': 'عثمان بن عفان',
      'Ali ibn Abi Talib': 'علی بن ابی طالب',
      'Talha ibn Ubaydullah': 'طلحہ بن عبیداللہ',
      'Zubayr ibn Al-Awwam': 'زبیر بن العوام',
      'Abdur Rahman ibn Awf': 'عبدالرحمان بن عوف',
      'Saad ibn Abi Waqqas': 'سعد بن ابی وقاص',
      'Said ibn Zayd': 'سعید بن زید',
      'Abu Ubayda ibn Al-Jarrah': 'ابو عبیدہ بن الجراح',
      'Bilal ibn Rabah': 'بلال بن رباح', 'Abu Dharr Al-Ghifari': 'ابوذر غفاری',
      'Salman Al-Farsi': 'سلمان فارسی', 'Ammar ibn Yasir': 'عمار بن یاسر',
      'Hudhayfah ibn Al-Yaman': 'حذیفہ بن الیمان', 'Abu Hurayrah': 'ابوہریرہ',
      'Abdullah ibn Masud': 'عبداللہ بن مسعود',
      'Abdullah ibn Abbas': 'عبداللہ بن عباس',
      'Abdullah ibn Umar': 'عبداللہ بن عمر', 'Anas ibn Malik': 'انس بن مالک',
      // Panjatan Pak & Ahlebait
      'Khadijah bint Khuwaylid': 'خدیجہ بنت خویلد',
      'Fatimah Az-Zahra': 'فاطمہ زہرا',
      'Hasan ibn Ali': 'حسن بن علی', 'Husayn ibn Ali': 'حسین بن علی',
      'Zaynab bint Ali': 'زینب بنت علی',
      'Umm Kulthum bint Ali': 'ام کلثوم بنت علی',
      'Aisha bint Abi Bakr': 'عائشہ بنت ابی بکر',
      'Hafsa bint Umar': 'حفصہ بنت عمر',
      'Zaynab bint Jahsh': 'زینب بنت جحش', 'Umm Salamah': 'ام سلمہ',
    };
    return map[text] ?? text;
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
          case IslamicNameLanguage.urdu:
            return parts[1].trim();
          case IslamicNameLanguage.hindi:
            return parts[2].trim();
        }
      }
    }

    // Common translations for biographical data
    final hindiTranslations = {
      // Prophets - Basic Info
      'Hawwa (Eve)': 'हव्वा (ईव)',
      'Qabil (Cain), Habil (Abel), Shith (Seth), and many others':
          'क़ाबिल (कैन), हाबिल (अबेल), शीस (सेठ), और अन्य',
      'Created in Paradise (Jannah)': 'जन्नत (स्वर्ग) में बनाए गए',
      'Earth (location varies in traditions)':
          'पृथ्वी (परंपराओं में स्थान भिन्न)',
      'Beginning of Humanity': 'मानवता की शुरुआत',
      'First human, First Prophet, Father of Mankind':
          'पहले इंसान, पहले नबी, मानवजाति के पिता',

      // Prophets - Spouses
      'Sarah, Hajar (Hagar)': 'सारा, हाजिरा (हागर)',
      'Leah, Rachel, Bilhah, Zilpah': 'लिआ, राहेल, बिल्हा, ज़िल्पा',
      'Saffurah (daughter of Shuaib)': 'सफ़्फ़ूरा (शुऐब की बेटी)',
      'Rifqa (Rebecca)': 'रिफ़्क़ा (रिबेका)',
      'Zulaikha (Asenath)': 'ज़ुलैख़ा (असनथ)',
      'Elisheba': 'एलीशेबा',
      'Elizabeth (Ishba)': 'एलिज़ाबेथ (इशबा)',
      'Naamah (traditions vary)': 'नाअमा (परंपराओं में भिन्न)',
      'Ra\'la (or others in traditions)': 'रअला (या परंपराओं में अन्य)',
      'Rahmat (or Leya in some traditions)': 'रहमत (या कुछ परंपराओं में लेया)',
      'Queen of Sheba (Bilqis), and others': 'सबा की रानी (बिलक़ीस), और अन्य',
      'Multiple wives': 'कई पत्नियाँ',

      // Prophets - Children
      '12 sons including Kedar, Nebaioth':
          '12 बेटे जिनमें केदार, नेबायोत शामिल हैं',
      '12 sons including Yusuf, Binyamin; progenitors of 12 tribes of Israel':
          '12 बेटे जिनमें यूसुफ़, बिन्यामीन शामिल हैं; इसराईल की 12 क़बीलों के पूर्वज',
      'Yaqub (Jacob), Esau': 'याक़ूब (जैकब), एसाव',
      'Ismail (from Hajar), Ishaq (from Sarah)':
          'इस्माईल (हाजिरा से), इसहाक़ (सारा से)',
      'Manasseh, Ephraim': 'मनश्शे, इफ़्राईम',
      'Gershom, Eliezer': 'गेर्शोम, एलीएज़र',
      'Nadab, Abihu, Eleazar, Ithamar': 'नादाब, अबीहू, एलीआज़र, इतामार',
      'Sulaiman (Solomon) and others': 'सुलैमान (सोलोमन) और अन्य',
      'Rehoboam and others': 'रहबाम और अन्य',
      'Daughters including wife of Musa':
          'बेटियाँ जिनमें मूसा की पत्नी शामिल हैं',
      'Two daughters (who survived)': 'दो बेटियाँ (जो बची रहीं)',
      'Allah blessed him with new children after trial':
          'अल्लाह ने उन्हें परीक्षा के बाद नई संतान दी',

      // Prophets - Tribes
      'Descendant of Prophet Nuh through Shem':
          'नबी नूह के वंशज शेम के माध्यम से',
      'Thamud': 'समूद',

      // Prophets - Birth Places
      'Ur, Mesopotamia': 'उर, मेसोपोटामिया',
      'Ur, Mesopotamia (modern Iraq)': 'उर, मेसोपोटामिया (आधुनिक इराक़)',
      'Babylon, Mesopotamia': 'बेबीलोन, मेसोपोटामिया',
      'Canaan (Palestine)': 'कनान (फ़िलिस्तीन)',
      'Egypt': 'मिस्र',
      'Mesopotamia': 'मेसोपोटामिया',
      'Ahqaf region, Southern Arabia': 'अहक़ाफ़ क्षेत्र, दक्षिणी अरब',
      'Among Bani Israel': 'बनी इसराईल में',
      'Bethlehem, Palestine': 'बैथलहम, फ़िलिस्तीन',
      'Ein Kerem, near Jerusalem': 'ऐन करम, यरूशलम के क़रीब',
      'Baalbek, Lebanon (traditions vary)':
          'बालबेक, लेबनान (परंपराओं में भिन्न)',
      'Gath-hepher, near Nazareth': 'गत-हेफ़र, नाज़रत के क़रीब',
      'Hauran, Syria (traditions vary)': 'हौरान, शाम (परंपराओं में भिन्न)',

      // Prophets - Death Places
      'Hebron, Palestine': 'हेब्रोन, फ़िलिस्तीन',
      'Jerusalem': 'यरूशलम',
      'Jerusalem (martyred)': 'यरूशलम (शहीद)',
      'Mount Nebo, near Jordan': 'माउंट नेबो, जॉर्डन के क़रीब',
      'Mount Hor (near Petra)': 'माउंट होर (पेट्रा के क़रीब)',
      'Madyan': 'मदयन',
      'Madyan, near Gulf of Aqaba': 'मदयन, अक़ाबा की खाड़ी के क़रीब',
      'Palestine (martyred)': 'फ़िलिस्तीन (शहीद)',
      'Hadramawt, Yemen (traditional)': 'हद्रमौत, यमन (पारंपरिक)',
      'Raised alive to heavens': 'जीवित स्वर्ग को उठाए गए',
      'Raised to the heavens': 'आसमान को उठाए गए',
      'Raised to heavens (traditions)': 'आसमान को उठाए गए (परंपराओं में)',
      'Syria or Palestine': 'शाम या फ़िलिस्तीन',
      'Palestine or Makkah (traditions vary)':
          'फ़िलिस्तीन या मक्का (परंपराओं में भिन्न)',
      'Near the Dead Sea region': 'मृत सागर क्षेत्र के क़रीब',
      'Hijr (Mada\'in Salih), Arabia': 'हिज्र (मदाईन सालिह), अरब',

      // Prophets - Eras
      'After Adam, before Nuh': 'आदम के बाद, नूह से पहले',
      'After Nuh, sent to People of Ad': 'नूह के बाद, आद की क़ौम को भेजे गए',
      'After Hud, sent to People of Thamud':
          'हूद के बाद, समूद की क़ौम को भेजे गए',
      'Contemporary of Ibrahim': 'इब्राहीम के समकालीन',
      'Son of Ibrahim': 'इब्राहीम के बेटे',
      'Before Musa, sent to Madyan': 'मूसा से पहले, मदयन को भेजे गए',
      'Contemporary of Musa': 'मूसा के समकालीन',
      'After Musa': 'मूसा के बाद',
      'After Yusuf': 'यूसुफ़ के बाद',
      'Approximately 1800 BCE': 'लगभग 1800 ईसा पूर्व',
      'Approximately 1400-1300 BCE': 'लगभग 1400-1300 ईसा पूर्व',
      'Approximately 1000 BCE, King of Israel':
          'लगभग 1000 ईसा पूर्व, इसराईल के राजा',
      'Approximately 970-930 BCE, King of Israel':
          'लगभग 970-930 ईसा पूर्व, इसराईल के राजा',
      'After Sulaiman, Kingdom of Israel': 'सुलैमान के बाद, इसराईल का राज्य',
      'Shortly before Isa': 'ईसा से कुछ समय पहले',
      'Approximately 1-33 CE': 'लगभग 1-33 ईसवी',
      'Contemporary of Isa': 'ईसा के समकालीन',

      // Prophets - Known For
      'Final Prophet, Quran, Ulul Azm Prophet, Leader of all Prophets':
          'आख़िरी नबी, क़ुरआन, उलुल अज़्म नबी, सभी नबियों के सरदार',
      'Khalilullah, Built the Kaaba, Ulul Azm Prophet':
          'ख़लीलुल्लाह, काबा बनाया, उलुल अज़्म नबी',
      'Built Kaaba, Ancestor of Prophet Muhammad ﷺ, Willingly submitted to sacrifice':
          'काबा बनाया, नबी मुहम्मद ﷺ के पूर्वज, क़ुर्बानी के लिए स्वेच्छा से तैयार',
      'Miracle birth, Ancestor of Bani Israel prophets':
          'चमत्कारी जन्म, बनी इसराईल के नबियों के पूर्वज',
      'Father of 12 Tribes of Israel, Patience during separation from Yusuf':
          'इसराईल की 12 क़बीलों के पिता, यूसुफ़ से अलगाव में सब्र',
      'Best of Stories in Quran, Treasurer of Egypt, Exceptional beauty':
          'क़ुरआन में सबसे अच्छी कहानी, मिस्र के ख़ज़ानची, असाधारण सुंदरता',
      'Ulul Azm Prophet, Torah, Parted the Red Sea, Led Exodus':
          'उलुल अज़्म नबी, तौरात, लाल सागर को विभाजित किया, निर्गमन का नेतृत्व',
      'Helper and spokesman of Musa, Eloquent, Beloved by his people':
          'मूसा के सहायक और प्रवक्ता, वाक्पटु, अपने लोगों द्वारा प्रिय',
      'Zabur (Psalms), Killed Goliath, Beautiful voice, Iron softened for him':
          'ज़बूर (भजन), जालूत को मारा, सुंदर आवाज़, लोहा उनके लिए नरम हुआ',
      'Greatest kingdom, Controlled wind/jinn/animals, Built Solomon\'s Temple':
          'महानतम राज्य, हवा/जिन्न/जानवरों को नियंत्रित किया, सुलैमान का मंदिर बनाया',
      'Ulul Azm Prophet, Injeel (Gospel), Miracles, Will return before Day of Judgment':
          'उलुल अज़्म नबी, इंजील (गॉस्पेल), चमत्कार, क़यामत से पहले वापस आएंगे',
      'Miracle birth, Wisdom as child, First named Yahya, Martyr':
          'चमत्कारी जन्म, बचपन में ही बुद्धिमान, पहले यहया नाम दिया गया, शहीद',
      'Guardian of Maryam, Father of Yahya, Devoted worshipper':
          'मरियम के संरक्षक, यहया के पिता, समर्पित उपासक',
      'Ulul Azm Prophet, Built the Ark, Second Father of Humanity':
          'उलुल अज़्म नबी, नौका बनाई, मानवता के दूसरे पिता',
      'Preached for 950 years': '950 वर्षों तक प्रचार किया',
      'Sent to People of Ad, Warned against arrogance':
          'आद की क़ौम को भेजे गए, अहंकार के ख़िलाफ़ चेतावनी दी',
      'Miracle of the She-Camel, Sent to Thamud':
          'ऊंटनी का चमत्कार, समूद को भेजे गए',
      'Eloquent speech, Father-in-law of Musa, Warned against cheating':
          'वाक्पटु भाषण, मूसा के ससुर, धोखाधड़ी के ख़िलाफ़ चेतावनी',
      'Patience and righteousness, Fulfilled his responsibilities':
          'सब्र और नेकी, अपनी ज़िम्मेदारियाँ निभाईं',
      'Symbol of patience, Tested with severe trials, Restored by Allah':
          'सब्र का प्रतीक, गंभीर परीक्षणों से परीक्षित, अल्लाह ने बहाल किया',
      'Swallowed by whale, Famous dua of repentance, Only nation saved after seeing punishment':
          'व्हेल ने निगला, तौबा की मशहूर दुआ, सज़ा देखने के बाद बचाई गई एकमात्र क़ौम',
      'Sent to Nineveh (modern Mosul, Iraq)':
          'नीनवे (आधुनिक मोसुल, इराक़) को भेजे गए',
      'Sent to Sodom and Gomorrah, Warned against immorality':
          'सदोम और अमोरा को भेजे गए, अनैतिकता के ख़िलाफ़ चेतावनी',
      'Fought against Baal worship, Raised to heaven alive':
          'बाल पूजा के ख़िलाफ़ लड़े, जीवित स्वर्ग को उठाए गए',
      'Successor of Ilyas': 'इल्यास के उत्तराधिकारी',
      'Successor of Ilyas, Performed miracles, Guided with wisdom':
          'इल्यास के उत्तराधिकारी, चमत्कार किए, बुद्धिमत्ता से मार्गदर्शन किया',
      'First to write with pen, Received 30 scriptures, Raised to high station':
          'क़लम से लिखने वाले पहले, 30 सहीफ़े प्राप्त किए, उच्च स्थान पर उठाए गए',

      // Prophets - Other Info
      'Shem, Ham, Japheth, Yam (drowned)': 'सैम, हाम, याफ़त, याम (डूब गए)',
      // Sahaba - Common locations
      'Makkah, Arabia': 'मक्का, अरब',
      'Madinah, Arabia': 'मदीना, अरब',
      'Madinah (Martyred)': 'मदीना (शहीद)',
      'Taif, Arabia': 'ताइफ़, अरब',
      'Inside the Kaaba, Makkah': 'काबा के अंदर, मक्का',
      'Kufa, Iraq (Martyred)': 'कूफ़ा, इराक़ (शहीद)',
      'Battle of Jamal, Basra': 'जंग-ए-जमल, बसरा',
      'Wadi al-Siba, near Basra': 'वादी अल-सीबा, बसरा के क़रीब',
      'Abyssinia (Ethiopia)': 'हब्शा (इथियोपिया)',
      'Damascus, Syria': 'दमिश्क़, शाम',
      // Sahaba - Tribes
      'Quraysh (Banu Taym)': 'क़ुरैश (बनू तैम)',
      'Quraysh (Banu Adi)': 'क़ुरैश (बनू अदी)',
      'Quraysh (Banu Umayya)': 'क़ुरैश (बनू उमय्या)',
      'Quraysh (Banu Hashim)': 'क़ुरैश (बनू हाशिम)',
      'Quraysh (Banu Asad)': 'क़ुरैश (बनू असद)',
      'Banu Hashim, Quraysh': 'बनू हाशिम, क़ुरैश',
      // Sahaba - Known for
      'First Caliph, Closest companion, Freed slaves, Ashara Mubashara':
          'पहले ख़लीफ़ा, सबसे क़रीबी साथी, ग़ुलामों को आज़ाद किया, अशरा मुबश्शरा',
      'Second Caliph, Empire expansion, Justice, Ashara Mubashara':
          'दूसरे ख़लीफ़ा, साम्राज्य विस्तार, इंसाफ़, अशरा मुबश्शरा',
      'Third Caliph, Compiled Quran, Ashara Mubashara':
          'तीसरे ख़लीफ़ा, क़ुरान संकलित किया, अशरा मुबश्शरा',
      'Fourth Caliph, First male Muslim, Ashara Mubashara':
          'चौथे ख़लीफ़ा, पहले मुस्लिम पुरुष, अशरा मुबश्शरा',
      'Protected Prophet at Uhud, Ashara Mubashara, Generosity':
          'उहुद में नबी की रक्षा की, अशरा मुबश्शरा, सख़ावत',
      'First to draw sword for Islam, Ashara Mubashara, Bravery':
          'इस्लाम के लिए तलवार निकालने वाले पहले, अशरा मुबश्शरा, बहादुरी',
      'First Muezzin, Patience under torture, Beautiful voice, Freed by Abu Bakr':
          'पहले मुअज़्ज़िन, यातना में सब्र, ख़ूबसूरत आवाज़, अबू बक्र ने आज़ाद किया',
      // Common titles
      'As-Siddiq (The Truthful)': 'सिद्दीक़ (सच्चा)',
      'Al-Farooq (The Distinguisher)':
          'फ़ारूक़ (हक़ और बातिल में तमीज़ करने वाला)',
      'Dhun-Nurayn (Possessor of Two Lights)': 'ज़ुन्नूरैन (दो रोशनियों वाला)',
      'Asadullah (Lion of Allah), Bab al-Ilm (Gate of Knowledge)':
          'असदुल्लाह (अल्लाह का शेर), बाब-उल-इल्म (इल्म का दरवाज़ा)',
      'Talha the Generous, Talha the Good': 'तल्हा अस-सख़ी, तल्हा अल-ख़ैर',
      'Hawari an-Nabi (Disciple of the Prophet)': 'हवारी-अन-नबी (नबी के हवारी)',
      'First Muezzin of Islam': 'इस्लाम के पहले मुअज़्ज़िन',
      // Parent names
      'Abu Quhafa (Uthman ibn Amir)': 'अबू क़ुहाफ़ा (उस्मान बिन आमिर)',
      'Salma bint Sakhar (Umm al-Khayr)': 'सलमा बिन्त सख़र (उम्म अल-ख़ैर)',
      'Al-Khattab ibn Nufayl': 'अल-ख़त्ताब बिन नुफ़ैल',
      'Hantamah bint Hashim': 'हंतमा बिन्त हाशिम',
      'Affan ibn Abi al-As': 'अफ़्फ़ान बिन अबी अल-आस',
      'Arwa bint Kurayz': 'अरवा बिन्त कुरैज़',
      'Abu Talib ibn Abd al-Muttalib': 'अबू तालिब बिन अब्द अल-मुत्तलिब',
      'Fatimah bint Asad': 'फ़ातिमा बिन्त असद',
      'Safiyyah bint Abd al-Muttalib (Prophet\'s aunt)':
          'सफ़िय्या बिन्त अब्द अल-मुत्तलिब (नबी की फूफी)',
      // Spouses
      'Qutaylah, Umm Ruman, Asma bint Umais, Habibah':
          'क़ुतैला, उम्म रूमान, अस्मा बिन्त उमैस, हबीबा',
      'Zaynab, Jamila, Atikah, Umm Kulthum bint Ali':
          'ज़ैनब, जमीला, आतिका, उम्म कुलसूम बिन्त अली',
      'Ruqayyah bint Muhammad, Umm Kulthum bint Muhammad':
          'रुक़य्या बिन्त मुहम्मद, उम्म कुलसूम बिन्त मुहम्मद',
      'Fatimah bint Muhammad': 'फ़ातिमा बिन्त मुहम्मद',
      'Asma bint Abi Bakr, and others': 'अस्मा बिन्त अबी बक्र, और अन्य',
      // Children
      'Aisha, Asma, Abdullah, Abdur Rahman, Muhammad':
          'आइशा, अस्मा, अब्दुल्लाह, अब्दुर्रहमान, मुहम्मद',
      'Abdullah, Hafsa, Asim, and others': 'अब्दुल्लाह, हफ़्सा, आसिम, और अन्य',
      'Abdullah, Amr, and others': 'अब्दुल्लाह, अम्र, और अन्य',
      'Hasan, Husayn, Zaynab, Umm Kulthum': 'हसन, हुसैन, ज़ैनब, उम्म कुलसूम',
      'Abdullah, Urwa, Mundhir': 'अब्दुल्लाह, उरवा, मुंज़िर',
      // Dates and Eras
      '573 CE': '573 ईस्वी',
      '584 CE': '584 ईस्वी',
      '576 CE': '576 ईस्वी',
      '600 CE': '600 ईस्वी',
      '641 CE': '641 ईस्वी',
      '632-634 CE (Caliphate)': '632-634 ईस्वी (ख़िलाफ़त)',
      '634-644 CE (Caliphate)': '634-644 ईस्वी (ख़िलाफ़त)',
      '644-656 CE (Caliphate)': '644-656 ईस्वी (ख़िलाफ़त)',
      '656-661 CE (Caliphate)': '656-661 ईस्वी (ख़िलाफ़त)',
      '22 Jumada al-Thani, 13 AH (634 CE)':
          '22 जुमादा अल-सानी, 13 हिजरी (634 ईस्वी)',
      '26 Dhu al-Hijjah, 23 AH (644 CE)': '26 ज़िलहिज्जा, 23 हिजरी (644 ईस्वी)',
      '18 Dhu al-Hijjah, 35 AH (656 CE)': '18 ज़िलहिज्जा, 35 हिजरी (656 ईस्वी)',
      '21 Ramadan, 40 AH (661 CE)': '21 रमज़ान, 40 हिजरी (661 ईस्वी)',
      '36 AH (656 CE)': '36 हिजरी (656 ईस्वी)',
      '20 AH (641 CE)': '20 हिजरी (641 ईस्वी)',
      '13 Rajab, 30 BH (600 CE)': '13 रजब, 30 हिजरी पूर्व (600 ईस्वी)',
      // 12 Imams - Parent names
      'Husayn ibn Ali': 'हुसैन बिन अली',
      'Shahrbanu (Persian Princess)': 'शहरबानू (फ़ारसी शहज़ादी)',
      'Ali Zayn al-Abidin': 'अली ज़ैनुल आबिदीन',
      'Fatimah bint Hasan': 'फ़ातिमा बिन्त हसन',
      'Muhammad al-Baqir': 'मुहम्मद अल-बाक़िर',
      'Umm Farwa bint al-Qasim': 'उम्म फ़रवा बिन्त अल-क़ासिम',
      'Ja\'far al-Sadiq': 'जाफ़र अस-सादिक़',
      'Hamida Khatun': 'हमीदा ख़ातून',
      'Musa al-Kazim': 'मूसा अल-काज़िम',
      'Najmah (Tuktam)': 'नजमा (तुकतम)',
      'Ali al-Rida': 'अली अर-रिज़ा',
      'Sabikah (Khayzuran)': 'साबिका (ख़ैज़ुरान)',
      'Muhammad al-Jawad': 'मुहम्मद अल-जवाद',
      'Sumana Khatun (Samanah)': 'सुमाना ख़ातून (समाना)',
      'Ali al-Hadi': 'अली अल-हादी',
      'Hudayth (Salil)': 'हुदयस (सलील)',
      'Hasan al-Askari': 'हसन अल-अस्करी',
      'Narjis Khatun': 'नरजिस ख़ातून',
      // 12 Imams - Spouses
      'Shahrbanu, Rabab, Layla': 'शहरबानू, रबाब, लैला',
      'Ja\'da bint al-Ash\'ath': 'जअदा बिन्त अल-अशअस',
      'Hamida Khatun, Fatimah': 'हमीदा ख़ातून, फ़ातिमा',
      'Sabikah (granddaughter of Ma\'mun)': 'साबिका (मामून की पोती)',
      'Sumana Khatun, Umm al-Fadl': 'सुमाना ख़ातून, उम्म अल-फ़ज़्ल',
      // 12 Imams - Children
      'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah':
          'अली ज़ैनुल आबिदीन, अली अकबर, अली असग़र, सकीना, फ़ातिमा',
      'Zayd, Hasan, Qasim': 'ज़ैद, हसन, क़ासिम',
      'Muhammad al-Baqir, Zayd, and others': 'मुहम्मद अल-बाक़िर, ज़ैद, और अन्य',
      'Ja\'far al-Sadiq, Abdullah, Ibrahim':
          'जाफ़र अस-सादिक़, अब्दुल्लाह, इब्राहीम',
      'Musa al-Kazim, Ismail, Muhammad, Ali':
          'मूसा अल-काज़िम, इस्माईल, मुहम्मद, अली',
      'Ali al-Rida, Ibrahim, Abbas, and others':
          'अली अर-रिज़ा, इब्राहीम, अब्बास, और अन्य',
      'Hasan al-Askari, Husayn, Muhammad': 'हसन अल-अस्करी, हुसैन, मुहम्मद',
      // 12 Imams - Birth/Death places
      'Karbala, Iraq (Martyred)': 'कर्बला, इराक़ (शहीद)',
      'Madinah, Arabia (Poisoned)': 'मदीना, अरब (ज़हर दिया गया)',
      'Madinah (Poisoned)': 'मदीना (ज़हर दिया गया)',
      'Abwa, Arabia (between Makkah and Madinah)':
          'अबवा, अरब (मक्का और मदीना के बीच)',
      'Baghdad, Iraq (Poisoned in prison)': 'बग़दाद, इराक़ (जेल में ज़हर)',
      'Tus (Mashhad), Iran (Poisoned)': 'तूस (मशहद), ईरान (ज़हर)',
      'Baghdad, Iraq (Poisoned)': 'बग़दाद, इराक़ (ज़हर)',
      'Surayya, near Madinah': 'सुरैय्या, मदीना के क़रीब',
      'Samarra, Iraq (Poisoned)': 'सामर्रा, इराक़ (ज़हर)',
      'Samarra, Iraq': 'सामर्रा, इराक़',
      'In Occultation (Alive)': 'ग़ैबत में (ज़िंदा)',
      'N/A - Awaited': 'लागू नहीं - मुंतज़िर',
      // 12 Imams - Dates
      '15 Ramadan, 3 AH (625 CE)': '15 रमज़ान, 3 हिजरी (625 ईस्वी)',
      '28 Safar, 50 AH (670 CE)': '28 सफ़र, 50 हिजरी (670 ईस्वी)',
      '3 Sha\'ban, 4 AH (626 CE)': '3 शाबान, 4 हिजरी (626 ईस्वी)',
      '10 Muharram, 61 AH (680 CE)': '10 मुहर्रम, 61 हिजरी (680 ईस्वी)',
      '5 Sha\'ban, 38 AH (659 CE)': '5 शाबान, 38 हिजरी (659 ईस्वी)',
      '25 Muharram, 95 AH (713 CE)': '25 मुहर्रम, 95 हिजरी (713 ईस्वी)',
      '1 Rajab, 57 AH (677 CE)': '1 रजब, 57 हिजरी (677 ईस्वी)',
      '7 Dhu al-Hijjah, 114 AH (733 CE)': '7 ज़िलहिज्जा, 114 हिजरी (733 ईस्वी)',
      '17 Rabi al-Awwal, 83 AH (702 CE)':
          '17 रबी-उल-अव्वल, 83 हिजरी (702 ईस्वी)',
      '25 Shawwal, 148 AH (765 CE)': '25 शव्वाल, 148 हिजरी (765 ईस्वी)',
      '7 Safar, 128 AH (745 CE)': '7 सफ़र, 128 हिजरी (745 ईस्वी)',
      '25 Rajab, 183 AH (799 CE)': '25 रजब, 183 हिजरी (799 ईस्वी)',
      '11 Dhu al-Qi\'dah, 148 AH (765 CE)':
          '11 ज़िलक़ादा, 148 हिजरी (765 ईस्वी)',
      '17 Safar, 203 AH (818 CE)': '17 सफ़र, 203 हिजरी (818 ईस्वी)',
      '10 Rajab, 195 AH (811 CE)': '10 रजब, 195 हिजरी (811 ईस्वी)',
      '29 Dhu al-Qi\'dah, 220 AH (835 CE)':
          '29 ज़िलक़ादा, 220 हिजरी (835 ईस्वी)',
      '15 Dhu al-Hijjah, 212 AH (828 CE)':
          '15 ज़िलहिज्जा, 212 हिजरी (828 ईस्वी)',
      '3 Rajab, 254 AH (868 CE)': '3 रजब, 254 हिजरी (868 ईस्वी)',
      '8 Rabi al-Thani, 232 AH (846 CE)':
          '8 रबी-उस-सानी, 232 हिजरी (846 ईस्वी)',
      '8 Rabi al-Awwal, 260 AH (874 CE)':
          '8 रबी-उल-अव्वल, 260 हिजरी (874 ईस्वी)',
      '15 Sha\'ban, 255 AH (869 CE)': '15 शाबान, 255 हिजरी (869 ईस्वी)',
      // 12 Imams - Eras
      '3-50 AH': '3-50 हिजरी',
      '4-61 AH': '4-61 हिजरी',
      '61-95 AH': '61-95 हिजरी',
      '95-114 AH': '95-114 हिजरी',
      '114-148 AH': '114-148 हिजरी',
      '148-183 AH': '148-183 हिजरी',
      '183-203 AH': '183-203 हिजरी',
      '203-220 AH': '203-220 हिजरी',
      '220-254 AH': '220-254 हिजरी',
      '254-260 AH': '254-260 हिजरी',
      '260 AH - Present (In Occultation)': '260 हिजरी - वर्तमान (ग़ैबत में)',
      // 12 Imams - Known for
      'First Imam, Fourth Caliph, Lion of Allah':
          'पहले इमाम, चौथे ख़लीफ़ा, अल्लाह का शेर',
      'Second Imam, Peace Maker, Leader of Youth of Paradise':
          'द���सरे इमाम, सुलह करवाने वाले, जन्नत के नौजवानों के सरदार',
      'Third Imam, Master of Martyrs, Hero of Karbala':
          'तीसरे इमाम, शहीदों के सरदार, कर्बला के हीरो',
      'Fourth Imam, Sahifa Sajjadiyya, Sajjad (One who prostrates)':
          'चौथे इमाम, सहीफ़ा सज्जादिया, सज्जाद (बहुत सजदा करने वाले)',
      'Fifth Imam, Baqir al-Ulum (Splitter of Knowledge)':
          'पांचवें इमाम, बाक़िर-उल-उलूम (इल्म को खोलने वाले)',
      'Sixth Imam, Ja\'fari School of Jurisprudence, Teacher of thousands':
          'छठे इमाम, जाफ़री फ़िक़्ह, हज़ारों के उस्ताद',
      'Seventh Imam, Bab al-Hawaij (Gate of Fulfilling Needs)':
          'सातवें इमाम, बाब-उल-हवाइज (ज़रूरतें पूरी करने का दरवाज़ा)',
      'Eighth Imam, Shrine in Mashhad, Heir to Caliphate':
          'आठवें इमाम, मशहद में मज़ार, ख़िलाफ़त के वलीअहद',
      'Ninth Imam, Youngest Imam (age 7), Debated scholars as child':
          'नवें इमाम, सबसे कम उम्र इमाम (7 साल), बच्चे के रूप में उलमा से मुनाज़िरे',
      'Tenth Imam, Ziyarat Jami\'a al-Kabira, Deputy System':
          'दसवें इमाम, ज़ियारत जामिआ अल-कबीरा, नियाबत का निज़ाम',
      'Eleventh Imam, Father of the Awaited Imam, House arrest in Samarra':
          'ग्यारहवें इमाम, मुंतज़िर इमाम के वालिद, सामर्रा में नज़रबंदी',
      'Twelfth Imam, Al-Mahdi, Sahib al-Zaman, Awaited Savior':
          'बारहवें इमाम, अल-महदी, साहिबुज़्ज़मान, मुंतज़िर नजातदिहंदा',

      // Panjatan Pak & Ahlebait - Parent names
      'Abdullah ibn Abd al-Muttalib': 'अब्दुल्लाह बिन अब्दुल मुत्तलिब',
      'Aminah bint Wahb': 'आमिना बिन्त वहब',
      'Khuwaylid ibn Asad': 'ख़ुवैलिद बिन असद',
      'Fatimah bint Za\'idah': 'फ़ातिमा बिन्त ज़ैदा',

      // Panjatan Pak & Ahlebait - Spouses
      'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salama, Zaynab bint Jahsh, Juwayriya, Safiyya, Umm Habiba, Maymuna, Maria':
          'ख़दीजा, सौदा, आयशा, हफ़सा, ज़ैनब, उम्मे सलमा, ज़ैनब बिन्त जहश, जुवैरिया, सफ़िय्या, उम्मे हबीबा, मैमूना, मारिया',
      'Fatimah bint Muhammad, Umm al-Banin, Layla, Asma, Umama':
          'फ़ातिमा बिन्त मुहम्मद, उम्मुल बनीन, लैला, असमा, उमामा',
      'Multiple wives including Umm Ishaq, Hafsa, Hind, Ja\'da bint al-Ash\'ath':
          'कई बीवियाँ जिनमें उम्मे इसहाक़, हफ़सा, हिंद, जअदा बिन्त अल-अशअस शामिल हैं',
      'Ja\'da bint al-Ash\'ath, Umm Ishaq': 'जअदा बिन्त अल-अशअस, उम्म इशाक़',
      'Shahrbanu, Rabab, Layla, Umm Ishaq': 'शहरबानू, रबाब, लैला, उम्म इशाक़',
      'Prophet Muhammad ﷺ (previously Zayd ibn Haritha)':
          'नबी मुहम्मद ﷺ (पहले ज़ैद बिन हारिसा)',
      'Prophet Muhammad ﷺ (previously Khunays ibn Hudhafa)':
          'नबी मुहम्मद ﷺ (पहले ख़ुनैस बिन हुज़ाफ़ा)',
      'Prophet Muhammad ﷺ (previously Abu Salamah)':
          'नबी मुहम्मद ﷺ (पहले अबू सलमा)',
      'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salamah, and others':
          'ख़दीजा, सौदा, आयशा, हफ़सा, ज़ैनब, उम्मे सलमा, और अन्य',
      'Prophet Muhammad ﷺ': 'नबी मुहम्मद ﷺ',
      'Abdullah ibn Ja\'far': 'अब्दुल्लाह बिन जाफ़र',
      'Umar ibn al-Khattab (disputed), Awn ibn Ja\'far':
          'उमर बिन अल-ख़त्ताब (विवादित), औन बिन जाफ़र',

      // Panjatan Pak & Ahlebait - Children
      'Hasan, Husayn, Zaynab, Umm Kulthum, Abbas, Muhammad ibn Hanafiyyah':
          'हसन, हुसैन, ज़ैनब, उम्मे कुलसूम, अब्बास, मुहम्मद बिन हनफ़िया',
      'Hasan, Husayn, Zaynab, Umm Kulthum, Muhsin':
          'हसन, हुसैन, ज़ैनब, उम्मे कुलसूम, मुहसिन',
      'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah, Ruqayyah':
          'अली ज़ैनुल आबिदीन, अली अकबर, अली असग़र, सकीना, फ़ातिमा, रुक़ैय्या',
      'Zayd, Hasan, Qasim, Abdullah, Amr, Abdur Rahman':
          'ज़ैद, हसन, क़ासिम, अब्दुल्लाह, अम्र, अब्दुर्रहमान',
      'Zayd, Hasan, Qasim, Abdullah': 'ज़ैद, हसन, क़ासिम, अब्दुल्लाह',
      'Qasim, Abdullah, Zaynab, Ruqayyah, Umm Kulthum, Fatimah':
          'क़ासिम, अब्दुल्लाह, ज़ैनब, रुक़ैय्या, उम्मे कुलसूम, फ़ातिमा',
      'Qasim, Abdullah, Ibrahim, Zaynab, Ruqayyah, Umm Kulthum, Fatimah':
          'क़ासिम, अब्दुल्लाह, इब्राहीम, ज़ैनब, रुक़ैय्या, उम्मे कुलसूम, फ़ातिमा',
      'Ali, Aun, Muhammad, Umm Kulthum': 'अली, औन, मुहम्मद, उम्मे कुलसूम',
      'Zayd, Ruqayyah': 'ज़ैद, रुक़ैय्या',
      'Salamah, Umar, Zaynab, Durrah': 'सलमा, उमर, ज़ैनब, दुर्रा',

      // Panjatan Pak & Ahlebait - Birth/Death dates
      '12 Rabi al-Awwal, 53 BH (570 CE)':
          '12 रबी-उल-अव्वल, 53 हिजरी पूर्व (570 ईस्वी)',
      '12 Rabi al-Awwal, 11 AH (632 CE)':
          '12 रबी-उल-अव्वल, 11 हिजरी (632 ईस्वी)',
      '20 Jumada al-Thani, 5 BH (615 CE)':
          '20 जुमादा अस-सानी, 5 हिजरी पूर्व (615 ईस्वी)',
      '3 Jumada al-Thani, 11 AH (632 CE)':
          '3 जुमादा अस-सानी, 11 हिजरी (632 ईस्वी)',
      '555 CE': '555 ईस्वी',
      '10 Ramadan, 3 BH (619 CE)': '10 रमज़ान, 3 हिजरी पूर्व (619 ईस्वी)',
      '5 Jumada al-Awwal, 6 AH (627 CE)':
          '5 जुमादा अल-अव्वल, 6 हिजरी (627 ईस्वी)',
      '15 Rajab, 62 AH (682 CE)': '15 रजब, 62 हिजरी (682 ईस्वी)',
      '6 AH (628 CE)': '6 हिजरी (628 ईस्वी)',
      'After Karbala (exact date unknown)':
          'कर्बला के बाद (सही तारीख़ मालूम नहीं)',
      '613 or 614 CE': '613 या 614 ईस्वी',
      '17 Ramadan, 58 AH (678 CE)': '17 रमज़ान, 58 हिजरी (678 ईस्वी)',
      '605 CE': '605 ईस्वी',
      '45 AH (665 CE)': '45 हिजरी (665 ईस्वी)',
      '590 CE': '590 ईस्वी',
      '596 CE': '596 ईस्वी',

      // General
      'Unknown': 'अज्ञात',
      'Muhammad al-Mahdi': 'मुहम्मद अल-महदी',

      // Panjatan Pak & Ahlebait - Known for
      'Final Prophet, Founder of Islam, Received Quran':
          'आख़िरी नबी, इस्लाम के बानी, क़ुरआन प्राप्तकर्ता',
      'Final Prophet, Founder of Islam, Received the Quran':
          'आख़िरी नबी, इस्लाम के बानी, क़ुरआन प्राप्तकर्ता',
      'First Imam, Fourth Caliph, Lion of Allah, Gate of Knowledge':
          'पहले इमाम, चौथे ख़लीफ़ा, अल्लाह का शेर, इल्म का दरवाज़ा',
      'First Imam, Fourth Caliph, Lion of Allah, Bab al-Ilm':
          'पहले इमाम, चौथे ख़लीफ़ा, अल्लाह का शेर, बाब-उल-इल्म',
      'Leader of Women of Paradise, Mother of the Imams':
          'जन्नत की ख़वातीन की सरदार, इमामों की माँ',
      'Third Imam, Hero of Karbala, Symbol of Sacrifice':
          'तीसरे इमाम, कर्बला के हीरो, क़ुर्बानी की निशानी',
      'Leader of Women of Paradise, Mother of Imams, Part of Prophet':
          'जन्नत की ख़वातीन की सरदार, इमामों की माँ, नबी का हिस्सा',
      'Second Imam, Leader of Youth of Paradise, Peace Maker':
          'दूसरे इमाम, जन्नत के नौजवानों के सरदार, सुलह करने वाले',
      'First Muslim, First wife of Prophet, Mother of Believers':
          'पहली मुस्लिम, नबी की पहली बीवी, मोमिनों की माँ',
      'Heroine of Karbala, Preserved Husayn\'s message, Eloquent speaker':
          'कर्बला की हीरोइन, हुसैन का पैग़ाम महफ़ूज़ किया, फ़साहत से बोलने वाली',
      'Supported Zaynab after Karbala, Piety and patience':
          'कर्बला के बाद ज़ैनब का साथ दिया, तक़वा और सब्र',
      'Greatest female scholar, Narrated 2200+ hadiths, Teacher':
          'सबसे बड़ी महिला आलिम, 2200+ हदीस रिवायत कीं, उस्ताद',
      'Guardian of the first Quran manuscript, Piety and fasting':
          'पहले क़ुरआन की पांडुलिपि की निगरान, तक़वा और रोज़े',
      'Mother of the Poor, Generous charity, First to die after Prophet':
          'ग़रीबों की माँ, सख़ी ख़ैरात, नबी के बाद पहली वफ़ात',
      'Wisdom, Advice at Hudaybiyyah, Longest living wife':
          'हिकमत, हुदैबिया में मश्वरा, सबसे लंबे समय तक जीवित रहीं',

      // Ahlebait - Additional names
      'Abu Bakr al-Siddiq': 'अबू बक्र सिद्दीक़',
      'Umm Ruman': 'उम्मे रुमान',
      'Zaynab bint Maz\'un': 'ज़ैनब बिन्त मज़ऊन',
      'Jahsh ibn Ri\'ab': 'जहश बिन रिआब',
      'Umaymah bint Abd al-Muttalib (Prophet\'s aunt)':
          'उमैमा बिन्त अब्दुल मुत्तलिब (नबी की फूफी)',
      'Abu Umayya ibn al-Mughira': 'अबू उमय्या बिन अल-मुग़ीरा',
      'Atikah bint Amir': 'आतिका बिन्त आमिर',
      'Umar ibn al-Khattab': 'उमर बिन अल-ख़त्ताब',
      '61 AH (680 CE)': '61 हिजरी (680 ईस्वी)',

      // Sahaba - Parent names
      'Al-Awwam ibn Khuwaylid': 'अल-अव्वाम बिन ख़ुवैलिद',
      'Ubaydullah ibn Uthman': 'उबैदुल्लाह बिन उस्मान',

      // Prophets - Parent names
      'Azar (Terah)': 'आज़र (तेरह)',
      'Hajar (Hagar)': 'हाजिरा (हागर)',
      'Haran (brother of Ibrahim)': 'हारान (इब्राहीम के भाई)',
      'Ibrahim': 'इब्राहीम',
      'Imran': 'इमरान',
      'Lamech': 'लामेक',
      'Maryam (Mary)': 'मरियम (मरी)',
      'Matta (Amittai)': 'मत्ता (अमित्तै)',
      'Rahil (Rachel)': 'राहिल (राहेल)',
      'Sarah': 'सारा',
      'Yaqub (Jacob/Israel)': 'याक़ूब (जैकब/इसराईल)',
      'Yarid (Jared)': 'यारिद (जारेड)',
      'Yishai (Jesse)': 'यिशै (जेसी)',
      'Yukhabed (Jochebed)': 'युखाबेद (योकेबेद)',
      'Zakariya': 'ज़करिया',

      // Missing Translations - Added for 100% Coverage
      // Titles
      'Umm al-Mu\'minin (Mother of the Believers)': 'उम्मुल मोमिनीन (मोमिनों की माँ)',
      'Al-Askari (The One of the Army Camp)': 'अल-अस्करी (फ़ौज के शिविर वाले)',
      'Al-Baqir (The Splitter of Knowledge)': 'अल-बाक़िर (इल्म को खोलने वाले)',
      'Al-Hadi (The Guide)': 'अल-हादी (हिदायत देने वाले)',
      'Al-Jawad (The Generous)': 'अल-जवाद (सख़ी)',
      'Al-Kazim (The One Who Suppresses Anger)': 'अल-काज़िम (ग़ुस्सा पीने वाले)',
      'Al-Mahdi (The Guided One)': 'अल-महदी (हिदायत पाने वाले)',
      'Al-Mujtaba (The Chosen One)': 'अल-मुजतबा (चुने हुए)',
      'Al-Mujtaba (The Chosen)': 'अल-मुजतबा (चुने हुए)',
      'Al-Rida (The Pleasing One)': 'अल-रिज़ा (ख़ुशनूद करने वाले)',
      'Al-Sadiq (The Truthful)': 'अल-सादिक़ (सच्चे)',
      'Al-Siddiq (The Truthful)': 'अस-सिद्दीक़ (सच्चे)',
      'Aqilat Bani Hashim (Wise Woman of Banu Hashim)': 'अक़ीलत बनी हाशिम (बनी हाशिम की अक़्लमंद ख़ातून)',
      'Az-Zahra (The Radiant), Sayyidatu Nisa al-Alamin': 'अज़-ज़हरा (रोशन), सय्यिदतुन निसा अल-आलमीन',
      'Dhun-Nun (Owner of the Fish)': 'ज़ुन्नून (मछली वाले)',
      'Granddaughter of the Prophet': 'नबी की पोती',
      'Israel (Servant of God)': 'इसराईल (ख़ुदा के बंदे)',
      'Kalimullah (One who spoke with Allah)': 'कलीमुल्लाह (अल्लाह से बात करने वाले)',
      'Khatam an-Nabiyyin (Seal of Prophets), Rahmat lil-Alameen': 'ख़ातमुन्नबियीन (आख़िरी नबी), रहमतुल लिल आलमीन',
      'Khatib al-Anbiya (Orator of the Prophets)': 'ख़तीबुल अंबिया (नबियों के ख़तीब)',
      'Prophet of Allah': 'अल्लाह के नबी',
      'Ruhullah (Spirit of Allah), Al-Masih (Messiah)': 'रूहुल्लाह (अल्लाह की रूह), अल-मसीह (मसीहा)',
      'Sayyid al-Shuhada (Master of Martyrs)': 'सय्यिद अल-शुहदा (शहीदों के सरदार)',
      'Sayyidatun Nisa (Leader of Women)': 'सय्यिदतुन निसा (ख़वातीन की सरदार)',
      'The Guarantor': 'ज़ामिन',
      'Zayn al-Abidin (Ornament of Worshippers)': 'ज़ैनुल आबिदीन (इबादत करने वालों की ज़ीनत)',

      // Father Names
      'Ali ibn Abi Talib': 'अली बिन अबी तालिब',
      'Dawud (David)': 'दाऊद (डेविड)',
      'Ishaq (Isaac)': 'इसहाक़ (आइज़क)',

      // Mother Names
      'Khadijah bint Khuwaylid': 'ख़दीजा बिन्त ख़ुवैलिद',

      // Spouse
      // 'Ali ibn Abi Talib': 'अली बिन अबी तालिब', // Already added above

      // Children
      'Yahya (John)': 'यहया (जॉन)',

      // Kunya
      'Abu Abdullah': 'अबू अब्दुल्लाह',
      'Abu Muhammad': 'अबू मुहम्मद',
      'Abu al-Hasan': 'अबुल हसन',
      'Abu al-Qasim': 'अबुल क़ासिम',

      // Relations
      'Cousin & Son-in-law': 'चचेरे भाई और दामाद',
      'Daughter of Prophet ﷺ': 'नबी ﷺ की बेटी',
      'Granddaughter of Prophet ﷺ': 'नबी ﷺ की पोती',
      'Grandson of Prophet ﷺ': 'नबी ﷺ के पोते',
      // 'Prophet of Allah': 'अल्लाह के नबी', // Already added above in titles
      'Wife of Prophet ﷺ': 'नबी ﷺ की बीवी',
    };

    final urduTranslations = {
      // Prophets - Basic Info
      'Hawwa (Eve)': 'حوا',
      'Qabil (Cain), Habil (Abel), Shith (Seth), and many others':
          'قابیل، ہابیل، شیث اور دیگر',
      'Created in Paradise (Jannah)': 'جنت میں پیدا کیے گئے',
      'Earth (location varies in traditions)': 'زمین (روایات میں مقام مختلف)',
      'Beginning of Humanity': 'انسانیت کی شروعات',
      'First human, First Prophet, Father of Mankind':
          'پہلے انسان، پہلے نبی، بنی نوع انسان کے باپ',

      // Prophets - Spouses
      'Sarah, Hajar (Hagar)': 'سارہ، ہاجرہ',
      'Leah, Rachel, Bilhah, Zilpah': 'لیہ، راحیل، بلہا، زلفا',
      'Saffurah (daughter of Shuaib)': 'صفورہ (شعیب کی بیٹی)',
      'Rifqa (Rebecca)': 'رفقہ (ربیکا)',
      'Zulaikha (Asenath)': 'زلیخا (اسنات)',
      'Elisheba': 'الیشیبا',
      'Elizabeth (Ishba)': 'الزبتھ (اشبع)',
      'Naamah (traditions vary)': 'نعمہ (روایات میں مختلف)',
      'Ra\'la (or others in traditions)': 'رعلہ (یا روایات میں دیگر)',
      'Rahmat (or Leya in some traditions)': 'رحمت (یا کچھ روایات میں لیا)',
      'Queen of Sheba (Bilqis), and others': 'ملکہ سبا (بلقیس)، اور دیگر',
      'Multiple wives': 'متعدد بیویاں',

      // Prophets - Children
      '12 sons including Kedar, Nebaioth':
          '12 بیٹے جن میں قیدار، نبایوت شامل ہیں',
      '12 sons including Yusuf, Binyamin; progenitors of 12 tribes of Israel':
          '12 بیٹے جن میں یوسف، بنیامین شامل ہیں؛ اسرائیل کے 12 قبیلوں کے آباو اجداد',
      'Yaqub (Jacob), Esau': 'یعقوب (جیکب)، عیسو',
      'Ismail (from Hajar), Ishaq (from Sarah)':
          'اسماعیل (ہاجرہ سے)، اسحاق (سارہ سے)',
      'Manasseh, Ephraim': 'منسی، افرائیم',
      'Gershom, Eliezer': 'جرشوم، الیعزر',
      'Nadab, Abihu, Eleazar, Ithamar': 'ندب، ابیہو، الیعزر، ایتھامار',
      'Sulaiman (Solomon) and others': 'سلیمان اور دیگر',
      'Rehoboam and others': 'رحبعام اور دیگر',
      'Daughters including wife of Musa':
          'بیٹیاں جن میں موسیٰ کی بیوی شامل ہیں',
      'Two daughters (who survived)': 'دو بیٹیاں (جو بچ گئیں)',
      'Allah blessed him with new children after trial':
          'اللہ نے انہیں آزمائش کے بعد نئی اولاد عطا کی',

      // Prophets - Tribes
      'Descendant of Prophet Nuh through Shem': 'نبی نوح کی اولاد سام کے ذریعے',
      'Thamud': 'ثمود',

      // Prophets - Birth Places
      'Ur, Mesopotamia': 'اور، میسوپوٹیمیا',
      'Ur, Mesopotamia (modern Iraq)': 'اور، میسوپوٹیمیا (جدید عراق)',
      'Babylon, Mesopotamia': 'بابل، میسوپوٹیمیا',
      'Canaan (Palestine)': 'کنعان (فلسطین)',
      'Egypt': 'مصر',
      'Mesopotamia': 'میسوپوٹیمیا',
      'Ahqaf region, Southern Arabia': 'احقاف کا علاقہ، جنوبی عرب',
      'Among Bani Israel': 'بنی اسرائیل میں',
      'Bethlehem, Palestine': 'بیت اللحم، فلسطین',
      'Ein Kerem, near Jerusalem': 'عین کارم، یروشلم کے قریب',
      'Baalbek, Lebanon (traditions vary)': 'بعلبک، لبنان (روایات میں مختلف)',
      'Gath-hepher, near Nazareth': 'گت ہیفر، ناصرہ کے قریب',
      'Hauran, Syria (traditions vary)': 'حوران، شام (روایات میں مختلف)',

      // Prophets - Death Places
      'Hebron, Palestine': 'حبرون، فلسطین',
      'Jerusalem': 'یروشلم',
      'Jerusalem (martyred)': 'یروشلم (شہید)',
      'Mount Nebo, near Jordan': 'ماؤنٹ نیبو، اردن کے قریب',
      'Mount Hor (near Petra)': 'ماؤنٹ ہور (پیٹرا کے قریب)',
      'Madyan': 'مدین',
      'Madyan, near Gulf of Aqaba': 'مدین، خلیج عقبہ کے قریب',
      'Palestine (martyred)': 'فلسطین (شہید)',
      'Hadramawt, Yemen (traditional)': 'حضرموت، یمن (روایتی)',
      'Raised alive to heavens': 'زندہ آسمان پر اٹھائے گئے',
      'Raised to the heavens': 'آسمانوں پر اٹھائے گئے',
      'Raised to heavens (traditions)': 'آسمانوں پر اٹھائے گئے (روایات)',
      'Syria or Palestine': 'شام یا فلسطین',
      'Palestine or Makkah (traditions vary)':
          'فلسطین یا مکہ (روایات میں مختلف)',
      'Near the Dead Sea region': 'بحیرہ مردار کے قریب',
      'Hijr (Mada\'in Salih), Arabia': 'حجر (مدائن صالح)، عرب',

      // Prophets - Eras
      'After Adam, before Nuh': 'آدم کے بعد، نوح سے پہلے',
      'After Nuh, sent to People of Ad': 'نوح کے بعد، قوم عاد کو بھیجے گئے',
      'After Hud, sent to People of Thamud':
          'ہود کے بعد، قوم ثمود کو بھیجے گئے',
      'Contemporary of Ibrahim': 'ابراہیم کے ہم عصر',
      'Son of Ibrahim': 'ابراہیم کے بیٹے',
      'Before Musa, sent to Madyan': 'موسیٰ سے پہلے، مدین کو بھیجے گئے',
      'Contemporary of Musa': 'موسیٰ کے ہم عصر',
      'After Musa': 'موسیٰ کے بعد',
      'After Yusuf': 'یوسف کے بعد',
      'Approximately 1800 BCE': 'تقریباً 1800 قبل مسیح',
      'Approximately 1400-1300 BCE': 'تقریباً 1400-1300 قبل مسیح',
      'Approximately 1000 BCE, King of Israel':
          'تقریباً 1000 قبل مسیح، اسرائیل کے بادشاہ',
      'Approximately 970-930 BCE, King of Israel':
          'تقریباً 970-930 قبل مسیح، اسرائیل کے بادشاہ',
      'After Sulaiman, Kingdom of Israel': 'سلیمان کے بعد، اسرائیل کی بادشاہت',
      'Shortly before Isa': 'عیسیٰ سے کچھ عرصہ پہلے',
      'Approximately 1-33 CE': 'تقریباً 1-33 عیسوی',
      'Contemporary of Isa': 'عیسیٰ کے ہم عصر',

      // Prophets - Known For
      'Final Prophet, Quran, Ulul Azm Prophet, Leader of all Prophets':
          'آخری نبی، قرآن، اولوالعزم نبی، تمام انبیاء کے سردار',
      'Khalilullah, Built the Kaaba, Ulul Azm Prophet':
          'خلیل اللہ، کعبہ بنایا، اولوالعزم نبی',
      'Built Kaaba, Ancestor of Prophet Muhammad ﷺ, Willingly submitted to sacrifice':
          'کعبہ بنایا، نبی محمد ﷺ کے جد امجد، قربانی کے لیے رضاکارانہ طور پر تیار',
      'Miracle birth, Ancestor of Bani Israel prophets':
          'معجزاتی پیدائش، بنی اسرائیل کے انبیاء کے جد',
      'Father of 12 Tribes of Israel, Patience during separation from Yusuf':
          'اسرائیل کے 12 قبیلوں کے والد، یوسف سے جدائی میں صبر',
      'Best of Stories in Quran, Treasurer of Egypt, Exceptional beauty':
          'قرآن میں بہترین کہانی، مصر کے خزانچی، غیر معمولی خوبصورتی',
      'Ulul Azm Prophet, Torah, Parted the Red Sea, Led Exodus':
          'اولوالعزم نبی، توریت، بحیرہ احمر کو تقسیم کیا، ہجرت کی قیادت',
      'Helper and spokesman of Musa, Eloquent, Beloved by his people':
          'موسیٰ کے مددگار اور ترجمان، فصیح، اپنی قوم کے محبوب',
      'Zabur (Psalms), Killed Goliath, Beautiful voice, Iron softened for him':
          'زبور، جالوت کو مارا، خوبصورت آواز، لوہا ان کے لیے نرم ہوا',
      'Greatest kingdom, Controlled wind/jinn/animals, Built Solomon\'s Temple':
          'عظیم ترین بادشاہت، ہوا/جن/جانوروں پر قابو، ہیکل سلیمانی تعمیر کیا',
      'Ulul Azm Prophet, Injeel (Gospel), Miracles, Will return before Day of Judgment':
          'اولوالعزم نبی، انجیل، معجزات، قیامت سے پہلے واپس آئیں گے',
      'Miracle birth, Wisdom as child, First named Yahya, Martyr':
          'معجزاتی پیدائش، بچپن میں حکمت، پہلے یحییٰ نام دیا گیا، شہید',
      'Guardian of Maryam, Father of Yahya, Devoted worshipper':
          'مریم کے سرپرست، یحییٰ کے والد، عبادت گزار',
      'Ulul Azm Prophet, Built the Ark, Second Father of Humanity':
          'اولوالعزم نبی، کشتی بنائی، انسانیت کے دوسرے باپ',
      'Preached for 950 years': '950 سال تبلیغ کی',
      'Sent to People of Ad, Warned against arrogance':
          'قوم عاد کو بھیجے گئے، تکبر کے خلاف خبردار کیا',
      'Miracle of the She-Camel, Sent to Thamud':
          'اونٹنی کا معجزہ، ثمود کو بھیجے گئے',
      'Eloquent speech, Father-in-law of Musa, Warned against cheating':
          'فصیح گفتگو، موسیٰ کے سسر، دھوکہ دہی کے خلاف متنبہ کیا',
      'Patience and righteousness, Fulfilled his responsibilities':
          'صبر اور نیکی، اپنی ذمہ داریاں پوری کیں',
      'Symbol of patience, Tested with severe trials, Restored by Allah':
          'صبر کی علامت، سخت آزمائشوں سے آزمائے گئے، اللہ نے بحال کیا',
      'Swallowed by whale, Famous dua of repentance, Only nation saved after seeing punishment':
          'مچھلی نے نگل لیا، توبہ کی مشہور دعا، سزا دیکھنے کے بعد بچائی گئی واحد قوم',
      'Sent to Nineveh (modern Mosul, Iraq)':
          'نینوا (جدید موصل، عراق) کو بھیجے گئے',
      'Sent to Sodom and Gomorrah, Warned against immorality':
          'سدوم اور عمورہ کو بھیجے گئے، بے حیائی کے خلاف خبردار کیا',
      'Fought against Baal worship, Raised to heaven alive':
          'بعل کی پوجا کے خلاف لڑے، زندہ آسمان پر اٹھائے گئے',
      'Successor of Ilyas': 'الیاس کے جانشین',
      'Successor of Ilyas, Performed miracles, Guided with wisdom':
          'الیاس کے جانشین، معجزات دکھائے، حکمت سے راہنمائی کی',
      'First to write with pen, Received 30 scriptures, Raised to high station':
          'قلم سے لکھنے والے پہلے، 30 صحیفے ملے، بلند مقام پر فائز',

      // Prophets - Other Info
      'Shem, Ham, Japheth, Yam (drowned)': 'سام، حام، یافث، یام (ڈوب گیا)',
      // Sahaba - Common locations
      'Makkah, Arabia': 'مکہ، عرب',
      'Madinah, Arabia': 'مدینہ، عرب',
      'Madinah (Martyred)': 'مدینہ (شہید)',
      'Taif, Arabia': 'طائف، عرب',
      'Inside the Kaaba, Makkah': 'کعبہ کے اندر، مکہ',
      'Kufa, Iraq (Martyred)': 'کوفہ، عراق (شہید)',
      'Battle of Jamal, Basra': 'جنگ جمل، بصرہ',
      'Wadi al-Siba, near Basra': 'وادی السباع، بصرہ کے قریب',
      'Abyssinia (Ethiopia)': 'حبشہ (ایتھوپیا)',
      'Damascus, Syria': 'دمشق، شام',
      // Sahaba - Tribes
      'Quraysh (Banu Taym)': 'قریش (بنو تیم)',
      'Quraysh (Banu Adi)': 'قریش (بنو عدی)',
      'Quraysh (Banu Umayya)': 'قریش (بنو امیہ)',
      'Quraysh (Banu Hashim)': 'قریش (بنو ہاشم)',
      'Quraysh (Banu Asad)': 'قریش (بنو اسد)',
      'Banu Hashim, Quraysh': 'بنو ہاشم، قریش',
      // Sahaba - Known for
      'First Caliph, Closest companion, Freed slaves, Ashara Mubashara':
          'پہلے خلیفہ، سب سے قریبی ساتھی، غلاموں کو آزاد کیا، عشرہ مبشرہ',
      'Second Caliph, Empire expansion, Justice, Ashara Mubashara':
          'دوسرے خلیفہ، سلطنت میں توسیع، انصاف، عشرہ مبشرہ',
      'Third Caliph, Compiled Quran, Ashara Mubashara':
          'تیسرے خلیفہ، قرآن مرتب کیا، عشرہ مبشرہ',
      'Fourth Caliph, First male Muslim, Ashara Mubashara':
          'چوتھے خلیفہ، پہلے مسلمان مرد، عشرہ مبشرہ',
      'Protected Prophet at Uhud, Ashara Mubashara, Generosity':
          'احد میں نبی کی حفاظت کی، عشرہ مبشرہ، سخاوت',
      'First to draw sword for Islam, Ashara Mubashara, Bravery':
          'اسلام کے لیے تلوار نکالنے والے پہلے، عشرہ مبشرہ، بہادری',
      'First Muezzin, Patience under torture, Beautiful voice, Freed by Abu Bakr':
          'پہلے موذن، اذیت میں صبر، خوبصورت آواز، ابوبکر نے آزاد کیا',
      // Common titles
      'As-Siddiq (The Truthful)': 'صدیق (سچا)',
      'Al-Farooq (The Distinguisher)': 'فاروق (حق و باطل میں تمیز کرنے والا)',
      'Dhun-Nurayn (Possessor of Two Lights)': 'ذوالنورین (دو روشنیوں والا)',
      'Asadullah (Lion of Allah), Bab al-Ilm (Gate of Knowledge)':
          'اسد اللہ (اللہ کا شیر)، باب العلم (علم کا دروازہ)',
      'Talha the Generous, Talha the Good': 'طلحہ السخی، طلحہ الخیر',
      'Hawari an-Nabi (Disciple of the Prophet)': 'حواری النبی (نبی کے حواری)',
      'First Muezzin of Islam': 'اسلام کے پہلے موذن',
      // Parent names
      'Abu Quhafa (Uthman ibn Amir)': 'ابو قحافہ (عثمان بن عامر)',
      'Salma bint Sakhar (Umm al-Khayr)': 'سلمیٰ بنت صخر (ام الخیر)',
      'Al-Khattab ibn Nufayl': 'الخطاب بن نفیل',
      'Hantamah bint Hashim': 'ہنتمہ بنت ہاشم',
      'Affan ibn Abi al-As': 'عفان بن ابی العاص',
      'Arwa bint Kurayz': 'ارویٰ بنت کریز',
      'Abu Talib ibn Abd al-Muttalib': 'ابو طالب بن عبدالمطلب',
      'Fatimah bint Asad': 'فاطمہ بنت اسد',
      'Safiyyah bint Abd al-Muttalib (Prophet\'s aunt)':
          'صفیہ بنت عبدالمطلب (نبی کی پھوپھی)',
      // Spouses
      'Qutaylah, Umm Ruman, Asma bint Umais, Habibah':
          'قتیلہ، ام رومان، اسماء بنت عمیس، حبیبہ',
      'Zaynab, Jamila, Atikah, Umm Kulthum bint Ali':
          'زینب، جمیلہ، عاتکہ، ام کلثوم بنت علی',
      'Ruqayyah bint Muhammad, Umm Kulthum bint Muhammad':
          'رقیہ بنت محمد، ام کلثوم بنت محمد',
      'Fatimah bint Muhammad': 'فاطمہ بنت محمد',
      'Asma bint Abi Bakr, and others': 'اسماء بنت ابی بکر، اور دیگر',
      // Children
      'Aisha, Asma, Abdullah, Abdur Rahman, Muhammad':
          'عائشہ، اسماء، عبداللہ، عبدالرحمان، محمد',
      'Abdullah, Hafsa, Asim, and others': 'عبداللہ، حفصہ، عاصم، اور دیگر',
      'Abdullah, Amr, and others': 'عبداللہ، عمرو، اور دیگر',
      'Hasan, Husayn, Zaynab, Umm Kulthum': 'حسن، حسین، زینب، ام کلثوم',
      'Abdullah, Urwa, Mundhir': 'عبداللہ، عروہ، منذر',
      // Dates and Eras
      '573 CE': '573 عیسوی',
      '584 CE': '584 عیسوی',
      '576 CE': '576 عیسوی',
      '600 CE': '600 عیسوی',
      '641 CE': '641 عیسوی',
      '632-634 CE (Caliphate)': '632-634 عیسوی (خلافت)',
      '634-644 CE (Caliphate)': '634-644 عیسوی (خلافت)',
      '644-656 CE (Caliphate)': '644-656 عیسوی (خلافت)',
      '656-661 CE (Caliphate)': '656-661 عیسوی (خلافت)',
      '22 Jumada al-Thani, 13 AH (634 CE)':
          '22 جمادی الثانی، 13 ہجری (634 عیسوی)',
      '26 Dhu al-Hijjah, 23 AH (644 CE)': '26 ذی الحجہ، 23 ہجری (644 عیسوی)',
      '18 Dhu al-Hijjah, 35 AH (656 CE)': '18 ذی الحجہ، 35 ہجری (656 عیسوی)',
      '21 Ramadan, 40 AH (661 CE)': '21 رمضان، 40 ہجری (661 عیسوی)',
      '36 AH (656 CE)': '36 ہجری (656 عیسوی)',
      '20 AH (641 CE)': '20 ہجری (641 عیسوی)',
      '13 Rajab, 30 BH (600 CE)': '13 رجب، 30 قبل ہجری (600 عیسوی)',
      // 12 Imams - Parent names
      'Husayn ibn Ali': 'حسین بن علی',
      'Shahrbanu (Persian Princess)': 'شہربانو (فارسی شہزادی)',
      'Ali Zayn al-Abidin': 'علی زین العابدین',
      'Fatimah bint Hasan': 'فاطمہ بنت حسن',
      'Muhammad al-Baqir': 'محمد الباقر',
      'Umm Farwa bint al-Qasim': 'ام فروہ بنت القاسم',
      'Ja\'far al-Sadiq': 'جعفر الصادق',
      'Hamida Khatun': 'حمیدہ خاتون',
      'Musa al-Kazim': 'موسیٰ الکاظم',
      'Najmah (Tuktam)': 'نجمہ (تکتم)',
      'Ali al-Rida': 'علی الرضا',
      'Sabikah (Khayzuran)': 'صابیکہ (خیزران)',
      'Muhammad al-Jawad': 'محمد الجواد',
      'Sumana Khatun (Samanah)': 'سمانہ خاتون',
      'Ali al-Hadi': 'علی الہادی',
      'Hudayth (Salil)': 'حدیث (سلیل)',
      'Hasan al-Askari': 'حسن العسکری',
      'Narjis Khatun': 'نرجس خاتون',
      // 12 Imams - Spouses
      'Shahrbanu, Rabab, Layla': 'شہربانو، رباب، لیلیٰ',
      'Ja\'da bint al-Ash\'ath': 'جعدہ بنت الاشعث',
      'Hamida Khatun, Fatimah': 'حمیدہ خاتون، فاطمہ',
      'Sabikah (granddaughter of Ma\'mun)': 'صابیکہ (مامون کی پوتی)',
      'Sumana Khatun, Umm al-Fadl': 'سمانہ خاتون، ام الفضل',
      // 12 Imams - Children
      'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah':
          'علی زین العابدین، علی اکبر، علی اصغر، سکینہ، فاطمہ',
      'Zayd, Hasan, Qasim': 'زید، حسن، قاسم',
      'Muhammad al-Baqir, Zayd, and others': 'محمد الباقر، زید اور دیگر',
      'Ja\'far al-Sadiq, Abdullah, Ibrahim': 'جعفر الصادق، عبداللہ، ابراہیم',
      'Musa al-Kazim, Ismail, Muhammad, Ali':
          'موسیٰ الکاظم، اسماعیل، محمد، علی',
      'Ali al-Rida, Ibrahim, Abbas, and others':
          'علی الرضا، ابراہیم، عباس اور دیگر',
      'Hasan al-Askari, Husayn, Muhammad': 'حسن العسکری، حسین، محمد',
      // 12 Imams - Birth/Death places
      'Karbala, Iraq (Martyred)': 'کربلا، عراق (شہید)',
      'Madinah, Arabia (Poisoned)': 'مدینہ، عرب (زہر)',
      'Madinah (Poisoned)': 'مدینہ (زہر)',
      'Abwa, Arabia (between Makkah and Madinah)':
          'ابواء، عرب (مکہ اور مدینہ کے درمیان)',
      'Baghdad, Iraq (Poisoned in prison)': 'بغداد، عراق (جیل میں زہر)',
      'Tus (Mashhad), Iran (Poisoned)': 'طوس (مشہد)، ایران (زہر)',
      'Baghdad, Iraq (Poisoned)': 'بغداد، عراق (زہر)',
      'Surayya, near Madinah': 'ثریا، مدینہ کے قریب',
      'Samarra, Iraq (Poisoned)': 'سامرا، عراق (زہر)',
      'Samarra, Iraq': 'سامرا، عراق',
      'In Occultation (Alive)': 'غیبت میں (زندہ)',
      'N/A - Awaited': 'لاگو نہیں - منتظر',
      // 12 Imams - Dates
      '15 Ramadan, 3 AH (625 CE)': '15 رمضان، 3 ہجری (625 عیسوی)',
      '28 Safar, 50 AH (670 CE)': '28 صفر، 50 ہجری (670 عیسوی)',
      '3 Sha\'ban, 4 AH (626 CE)': '3 شعبان، 4 ہجری (626 عیسوی)',
      '10 Muharram, 61 AH (680 CE)': '10 محرم، 61 ہجری (680 عیسوی)',
      '5 Sha\'ban, 38 AH (659 CE)': '5 شعبان، 38 ہجری (659 عیسوی)',
      '25 Muharram, 95 AH (713 CE)': '25 محرم، 95 ہجری (713 عیسوی)',
      '1 Rajab, 57 AH (677 CE)': '1 رجب، 57 ہجری (677 عیسوی)',
      '7 Dhu al-Hijjah, 114 AH (733 CE)': '7 ذی الحجہ، 114 ہجری (733 عیسوی)',
      '17 Rabi al-Awwal, 83 AH (702 CE)': '17 ربیع الاول، 83 ہجری (702 عیسوی)',
      '25 Shawwal, 148 AH (765 CE)': '25 شوال، 148 ہجری (765 عیسوی)',
      '7 Safar, 128 AH (745 CE)': '7 صفر، 128 ہجری (745 عیسوی)',
      '25 Rajab, 183 AH (799 CE)': '25 رجب، 183 ہجری (799 عیسوی)',
      '11 Dhu al-Qi\'dah, 148 AH (765 CE)':
          '11 ذی القعدہ، 148 ہجری (765 عیسوی)',
      '17 Safar, 203 AH (818 CE)': '17 صفر، 203 ہجری (818 عیسوی)',
      '10 Rajab, 195 AH (811 CE)': '10 رجب، 195 ہجری (811 عیسوی)',
      '29 Dhu al-Qi\'dah, 220 AH (835 CE)':
          '29 ذی القعدہ، 220 ہجری (835 عیسوی)',
      '15 Dhu al-Hijjah, 212 AH (828 CE)': '15 ذی الحجہ، 212 ہجری (828 عیسوی)',
      '3 Rajab, 254 AH (868 CE)': '3 رجب، 254 ہجری (868 عیسوی)',
      '8 Rabi al-Thani, 232 AH (846 CE)': '8 ربیع الثانی، 232 ہجری (846 عیسوی)',
      '8 Rabi al-Awwal, 260 AH (874 CE)': '8 ربیع الاول، 260 ہجری (874 عیسوی)',
      '15 Sha\'ban, 255 AH (869 CE)': '15 شعبان، 255 ہجری (869 عیسوی)',
      // 12 Imams - Eras
      '3-50 AH': '3-50 ہجری',
      '4-61 AH': '4-61 ہجری',
      '61-95 AH': '61-95 ہجری',
      '95-114 AH': '95-114 ہجری',
      '114-148 AH': '114-148 ہجری',
      '148-183 AH': '148-183 ہجری',
      '183-203 AH': '183-203 ہجری',
      '203-220 AH': '203-220 ہجری',
      '220-254 AH': '220-254 ہجری',
      '254-260 AH': '254-260 ہجری',
      '260 AH - Present (In Occultation)': '260 ہجری - حال (غیبت میں)',
      // 12 Imams - Known for
      'First Imam, Fourth Caliph, Lion of Allah':
          'پہلے امام، چوتھے خلیفہ، اسد اللہ',
      'Second Imam, Peace Maker, Leader of Youth of Paradise':
          'دوسرے امام، صلح کرانے والے، جنت کے نوجوانوں کے سردار',
      'Third Imam, Master of Martyrs, Hero of Karbala':
          'تیسرے امام، شہیدوں کے سردار، کربلا کے ہیرو',
      'Fourth Imam, Sahifa Sajjadiyya, Sajjad (One who prostrates)':
          'چوتھے امام، صحیفہ سجادیہ، سجاد (بہت زیادہ سجدہ کرنے والے)',
      'Fifth Imam, Baqir al-Ulum (Splitter of Knowledge)':
          'پانچویں امام، باقر العلوم (علم کو کھولنے والے)',
      'Sixth Imam, Ja\'fari School of Jurisprudence, Teacher of thousands':
          'چھٹے امام، جعفری فقہ، ہزاروں کے استاد',
      'Seventh Imam, Bab al-Hawaij (Gate of Fulfilling Needs)':
          'ساتویں امام، باب الحوائج (ضروریات پوری کرنے کا دروازہ)',
      'Eighth Imam, Shrine in Mashhad, Heir to Caliphate':
          'آٹھویں امام، مشہد میں مزار، خلافت کے ولی عہد',
      'Ninth Imam, Youngest Imam (age 7), Debated scholars as child':
          'نویں امام، سب سے کم عمر امام (7 سال)، بچے کے طور پر علماء سے مناظرے',
      'Tenth Imam, Ziyarat Jami\'a al-Kabira, Deputy System':
          'دسویں امام، زیارت جامعہ الکبیرہ، نیابت کا نظام',
      'Eleventh Imam, Father of the Awaited Imam, House arrest in Samarra':
          'گیارہویں امام، منتظر امام کے والد، سامرا میں نظربندی',
      'Twelfth Imam, Al-Mahdi, Sahib al-Zaman, Awaited Savior':
          'بارہویں امام، المہدی، صاحب الزمان، منتظر نجات دہندہ',

      // Panjatan Pak & Ahlebait - Parent names
      'Abdullah ibn Abd al-Muttalib': 'عبداللہ بن عبدالمطلب',
      'Aminah bint Wahb': 'آمنہ بنت وہب',
      'Khuwaylid ibn Asad': 'خویلد بن اسد',
      'Fatimah bint Za\'idah': 'فاطمہ بنت زعیدہ',

      // Panjatan Pak & Ahlebait - Spouses
      'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salama, Zaynab bint Jahsh, Juwayriya, Safiyya, Umm Habiba, Maymuna, Maria':
          'خدیجہ، سودہ، عائشہ، حفصہ، زینب، ام سلمہ، زینب بنت جحش، جویریہ، صفیہ، ام حبیبہ، میمونہ، ماریہ',
      'Fatimah bint Muhammad, Umm al-Banin, Layla, Asma, Umama':
          'فاطمہ بنت محمد، ام البنین، لیلیٰ، اسماء، امامہ',
      'Multiple wives including Umm Ishaq, Hafsa, Hind, Ja\'da bint al-Ash\'ath':
          'متعدد بیویاں جن میں ام اسحاق، حفصہ، ہند، جعدہ بنت الاشعث شامل ہیں',
      'Ja\'da bint al-Ash\'ath, Umm Ishaq': 'جعدہ بنت الاشعث، ام اسحاق',
      'Shahrbanu, Rabab, Layla, Umm Ishaq': 'شہربانو، رباب، لیلیٰ، ام اسحاق',
      'Prophet Muhammad ﷺ (previously Zayd ibn Haritha)':
          'نبی محمد ﷺ (پہلے زید بن حارثہ)',
      'Prophet Muhammad ﷺ (previously Khunays ibn Hudhafa)':
          'نبی محمد ﷺ (پہلے خنیس بن حذافہ)',
      'Prophet Muhammad ﷺ (previously Abu Salamah)':
          'نبی محمد ﷺ (پہلے ابو سلمہ)',
      'Khadijah, Sawda, Aisha, Hafsa, Zaynab, Umm Salamah, and others':
          'خدیجہ، سودہ، عائشہ، حفصہ، زینب، ام سلمہ، اور دیگر',
      'Prophet Muhammad ﷺ': 'نبی محمد ﷺ',
      'Abdullah ibn Ja\'far': 'عبداللہ بن جعفر',
      'Umar ibn al-Khattab (disputed), Awn ibn Ja\'far':
          'عمر بن الخطاب (متنازع)، عون بن جعفر',

      // Panjatan Pak & Ahlebait - Children
      'Hasan, Husayn, Zaynab, Umm Kulthum, Abbas, Muhammad ibn Hanafiyyah':
          'حسن، حسین، زینب، ام کلثوم، عباس، محمد بن حنفیہ',
      'Hasan, Husayn, Zaynab, Umm Kulthum, Muhsin':
          'حسن، حسین، زینب، ام کلثوم، محسن',
      'Ali Zayn al-Abidin, Ali Akbar, Ali Asghar, Sakina, Fatimah, Ruqayyah':
          'علی زین العابدین، علی اکبر، علی اصغر، سکینہ، فاطمہ، رقیہ',
      'Zayd, Hasan, Qasim, Abdullah, Amr, Abdur Rahman':
          'زید، حسن، قاسم، عبداللہ، عمرو، عبدالرحمان',
      'Zayd, Hasan, Qasim, Abdullah': 'زید، حسن، قاسم، عبداللہ',
      'Qasim, Abdullah, Zaynab, Ruqayyah, Umm Kulthum, Fatimah':
          'قاسم، عبداللہ، زینب، رقیہ، ام کلثوم، فاطمہ',
      'Qasim, Abdullah, Ibrahim, Zaynab, Ruqayyah, Umm Kulthum, Fatimah':
          'قاسم، عبداللہ، ابراہیم، زینب، رقیہ، ام کلثوم، فاطمہ',
      'Ali, Aun, Muhammad, Umm Kulthum': 'علی، عون، محمد، ام کلثوم',
      'Zayd, Ruqayyah': 'زید، رقیہ',
      'Salamah, Umar, Zaynab, Durrah': 'سلمہ، عمر، زینب، درہ',

      // Panjatan Pak & Ahlebait - Birth/Death dates
      '12 Rabi al-Awwal, 53 BH (570 CE)':
          '12 ربیع الاول، 53 ہجری سے قبل (570 عیسوی)',
      '12 Rabi al-Awwal, 11 AH (632 CE)': '12 ربیع الاول، 11 ہجری (632 عیسوی)',
      '20 Jumada al-Thani, 5 BH (615 CE)':
          '20 جمادی الثانی، 5 ہجری سے قبل (615 عیسوی)',
      '3 Jumada al-Thani, 11 AH (632 CE)':
          '3 جمادی الثانی، 11 ہجری (632 عیسوی)',
      '555 CE': '555 عیسوی',
      '10 Ramadan, 3 BH (619 CE)': '10 رمضان، 3 ہجری سے قبل (619 عیسوی)',
      '5 Jumada al-Awwal, 6 AH (627 CE)': '5 جمادی الاول، 6 ہجری (627 عیسوی)',
      '15 Rajab, 62 AH (682 CE)': '15 رجب، 62 ہجری (682 عیسوی)',
      '6 AH (628 CE)': '6 ہجری (628 عیسوی)',
      'After Karbala (exact date unknown)':
          'کربلا کے بعد (صحیح تاریخ معلوم نہیں)',
      '613 or 614 CE': '613 یا 614 عیسوی',
      '17 Ramadan, 58 AH (678 CE)': '17 رمضان، 58 ہجری (678 عیسوی)',
      '605 CE': '605 عیسوی',
      '45 AH (665 CE)': '45 ہجری (665 عیسوی)',
      '590 CE': '590 عیسوی',
      '596 CE': '596 عیسوی',

      // General
      'Unknown': 'نامعلوم',
      'Muhammad al-Mahdi': 'محمد المہدی',

      // Panjatan Pak & Ahlebait - Known for
      'Final Prophet, Founder of Islam, Received Quran':
          'آخری نبی، اسلام کے بانی، قرآن وصول کیا',
      'Final Prophet, Founder of Islam, Received the Quran':
          'آخری نبی، اسلام کے بانی، قرآن وصول کیا',
      'First Imam, Fourth Caliph, Lion of Allah, Gate of Knowledge':
          'پہلے امام، چوتھے خلیفہ، اللہ کا شیر، علم کا دروازہ',
      'First Imam, Fourth Caliph, Lion of Allah, Bab al-Ilm':
          'پہلے امام، چوتھے خلیفہ، اللہ کا شیر، باب العلم',
      'Leader of Women of Paradise, Mother of the Imams':
          'جنت کی خواتین کی سردار، اماموں کی ماں',
      'Third Imam, Hero of Karbala, Symbol of Sacrifice':
          'تیسرے امام، کربلا کے ہیرو، قربانی کی علامت',
      'Leader of Women of Paradise, Mother of Imams, Part of Prophet':
          'جنت کی خواتین کی سردار، اماموں کی ماں، نبی کا حصہ',
      'Second Imam, Leader of Youth of Paradise, Peace Maker':
          'دوسرے امام، جنت کے نوجوانوں کے سردار، صلح کرنے والے',
      'First Muslim, First wife of Prophet, Mother of Believers':
          'پہلی مسلمان، نبی کی پہلی بیوی، مومنوں کی ماں',
      'Heroine of Karbala, Preserved Husayn\'s message, Eloquent speaker':
          'کربلا کی ہیروئن، حسین کا پیغام محفوظ کیا، فصیح مقرر',
      'Supported Zaynab after Karbala, Piety and patience':
          'کربلا کے بعد زینب کا ساتھ دیا، تقویٰ اور صبر',
      'Greatest female scholar, Narrated 2200+ hadiths, Teacher':
          'سب سے بڑی خاتون عالم، 2200+ احادیث روایت کیں، استاد',
      'Guardian of the first Quran manuscript, Piety and fasting':
          'پہلے قرآن کے مسودے کی محافظ، تقویٰ اور روزے',
      'Mother of the Poor, Generous charity, First to die after Prophet':
          'غریبوں کی ماں، سخی خیرات، نبی کے بعد پہلی وفات',
      'Wisdom, Advice at Hudaybiyyah, Longest living wife':
          'حکمت، حدیبیہ میں مشورہ، سب سے زیادہ عرصے تک زندہ رہیں',

      // Ahlebait - Additional names
      'Abu Bakr al-Siddiq': 'ابوبکر صدیق',
      'Umm Ruman': 'ام رومان',
      'Zaynab bint Maz\'un': 'زینب بنت مزعون',
      'Jahsh ibn Ri\'ab': 'جحش بن رئاب',
      'Umaymah bint Abd al-Muttalib (Prophet\'s aunt)':
          'امیمہ بنت عبدالمطلب (نبی کی پھوپھی)',
      'Abu Umayya ibn al-Mughira': 'ابو امیہ بن المغیرہ',
      'Atikah bint Amir': 'عاتکہ بنت عامر',
      'Umar ibn al-Khattab': 'عمر بن الخطاب',
      '61 AH (680 CE)': '61 ہجری (680 عیسوی)',

      // Sahaba - Parent names
      'Al-Awwam ibn Khuwaylid': 'العوام بن خویلد',
      'Ubaydullah ibn Uthman': 'عبیداللہ بن عثمان',

      // Prophets - Parent names
      'Azar (Terah)': 'آزر (تارح)',
      'Hajar (Hagar)': 'ہاجرہ',
      'Haran (brother of Ibrahim)': 'ہاران (ابراہیم کے بھائی)',
      'Ibrahim': 'ابراہیم',
      'Imran': 'عمران',
      'Lamech': 'لامک',
      'Maryam (Mary)': 'مریم',
      'Matta (Amittai)': 'متّی (امتائی)',
      'Rahil (Rachel)': 'راحیل',
      'Sarah': 'سارہ',
      'Yaqub (Jacob/Israel)': 'یعقوب (جیکب/اسرائیل)',
      'Yarid (Jared)': 'یارد',
      'Yishai (Jesse)': 'یشئی (جیسی)',
      'Yukhabed (Jochebed)': 'یوکابد',
      'Zakariya': 'زکریا',

      // Missing Translations - Added for 100% Coverage
      // Titles
      'Umm al-Mu\'minin (Mother of the Believers)': 'ام المؤمنین (مومنوں کی ماں)',
      'Al-Askari (The One of the Army Camp)': 'العسکری (فوج کے شیویر والے)',
      'Al-Baqir (The Splitter of Knowledge)': 'الباقر (علم کو کھولنے والے)',
      'Al-Hadi (The Guide)': 'الہادی (ہدایت دینے والے)',
      'Al-Jawad (The Generous)': 'الجواد (سخی)',
      'Al-Kazim (The One Who Suppresses Anger)': 'الکاظم (غصہ پینے والے)',
      'Al-Mahdi (The Guided One)': 'المہدی (ہدایت پانے والے)',
      'Al-Mujtaba (The Chosen One)': 'المجتبیٰ (چنے ہوئے)',
      'Al-Mujtaba (The Chosen)': 'المجتبیٰ (چنے ہوئے)',
      'Al-Rida (The Pleasing One)': 'الرضا (خوشنود کرنے والے)',
      'Al-Sadiq (The Truthful)': 'الصادق (سچے)',
      'Al-Siddiq (The Truthful)': 'الصدیق (سچے)',
      'Aqilat Bani Hashim (Wise Woman of Banu Hashim)': 'عقیلۃ بنی ہاشم (بنی ہاشم کی عقلمند خاتون)',
      'Az-Zahra (The Radiant), Sayyidatu Nisa al-Alamin': 'الزہرا (روشن)، سیدۃ النساء العالمین',
      'Dhun-Nun (Owner of the Fish)': 'ذوالنون (مچھلی والے)',
      'Granddaughter of the Prophet': 'نبی کی پوتی',
      'Israel (Servant of God)': 'اسرائیل (خدا کے بندے)',
      'Kalimullah (One who spoke with Allah)': 'کلیم اللہ (اللہ سے بات کرنے والے)',
      'Khatam an-Nabiyyin (Seal of Prophets), Rahmat lil-Alameen': 'خاتم النبیین (آخری نبی)، رحمۃ للعالمین',
      'Khatib al-Anbiya (Orator of the Prophets)': 'خطیب الانبیاء (نبیوں کے خطیب)',
      'Prophet of Allah': 'اللہ کے نبی',
      'Ruhullah (Spirit of Allah), Al-Masih (Messiah)': 'روح اللہ (اللہ کی روح)، المسیح (مسیحا)',
      'Sayyid al-Shuhada (Master of Martyrs)': 'سید الشہداء (شہیدوں کے سردار)',
      'Sayyidatun Nisa (Leader of Women)': 'سیدۃ النساء (خواتین کی سردار)',
      'The Guarantor': 'ضامن',
      'Zayn al-Abidin (Ornament of Worshippers)': 'زین العابدین (عبادت کرنے والوں کی زینت)',

      // Father Names
      'Ali ibn Abi Talib': 'علی بن ابی طالب',
      'Dawud (David)': 'داؤد (ڈیوڈ)',
      'Ishaq (Isaac)': 'اسحاق (آئزک)',

      // Mother Names
      'Khadijah bint Khuwaylid': 'خدیجہ بنت خویلد',

      // Spouse
      // 'Ali ibn Abi Talib': 'علی بن ابی طالب', // Already added above

      // Children
      'Yahya (John)': 'یحییٰ (جان)',

      // Kunya
      'Abu Abdullah': 'ابو عبداللہ',
      'Abu Muhammad': 'ابو محمد',
      'Abu al-Hasan': 'ابوالحسن',
      'Abu al-Qasim': 'ابوالقاسم',

      // Relations
      'Cousin & Son-in-law': 'چچا زاد بھائی اور داماد',
      'Daughter of Prophet ﷺ': 'نبی ﷺ کی بیٹی',
      'Granddaughter of Prophet ﷺ': 'نبی ﷺ کی پوتی',
      'Grandson of Prophet ﷺ': 'نبی ﷺ کے پوتے',
      // 'Prophet of Allah': 'اللہ کے نبی', // Already added above in titles
      'Wife of Prophet ﷺ': 'نبی ﷺ کی بیوی',
    };

    switch (selectedLanguage) {
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
    final isDark = context.watch<SettingsProvider>().isDarkMode;
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
    final isRtl = selectedLanguage == IslamicNameLanguage.urdu;

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
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(title: Text(context.tr(getCategoryKey(widget.category)))),
      body: SingleChildScrollView(
        padding: responsive.paddingMedium,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(responsive.radiusXLarge),
            border: Border.all(
              color: _isSpeaking
                  ? emeraldGreen
                  : (isDark ? Colors.grey.shade700 : lightGreenBorder),
              width: _isSpeaking ? 2 : 1.5,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.08),
                      blurRadius: responsive.spacing(10),
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
                      : (isDark ? Colors.grey.shade800 : lightGreenChip),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : darkGreen,
                              fontFamily:
                                  selectedLanguage ==
                                      IslamicNameLanguage.urdu
                                  ? 'NotoNastaliq'
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
                          isDark: isDark,
                        ),
                        _headerActionButton(
                          context: context,
                          icon: Icons.translate,
                          label: context.tr('translate'),
                          onTap: toggleTranslation,
                          isActive: _showTranslation,
                          isDark: isDark,
                        ),
                        _headerActionButton(
                          context: context,
                          icon: Icons.copy,
                          label: context.tr('copy'),
                          onTap: () => copyDetails(context),
                          isActive: false,
                          isDark: isDark,
                        ),
                        _headerActionButton(
                          context: context,
                          icon: Icons.share,
                          label: context.tr('share'),
                          onTap: shareDetails,
                          isActive: false,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_isSpeaking && _isPlayingArabic) {
                    _stopPlaying();
                  } else {
                    playAudio(true);
                  }
                },
                child: Container(
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
                                fontFamily: 'Amiri',
                                fontSize: 56,
                                height: 1.5,
                                color: (_isSpeaking && _isPlayingArabic)
                                    ? AppColors.primary
                                    : (isDark ? AppColors.secondary : softGold),
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
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : darkGreen,
                                fontFamily:
                                    selectedLanguage == IslamicNameLanguage.urdu
                                    ? 'NotoNastaliq'
                                    : null,
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
              ),
              Center(
                child: Container(
                  margin: responsive.paddingSymmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? emeraldGreen.withValues(alpha: 0.2)
                        : lightGreenChip,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? emeraldGreen : lightGreenBorder,
                    ),
                  ),
                  child: Text(
                    currentMeaning,
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.secondary : softGold,
                      fontFamily: selectedLanguage == IslamicNameLanguage.urdu
                          ? 'NotoNastaliq'
                          : null,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: isRtl
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
              ),
              if (_showTranslation)
                GestureDetector(
                  onTap: () {
                    if (_isSpeaking && !_isPlayingArabic) {
                      _stopPlaying();
                    } else {
                      playAudio(false);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: responsive.paddingRegular,
                    decoration: BoxDecoration(
                      color: (_isSpeaking && !_isPlayingArabic)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark
                                ? Colors.grey.shade800
                                : lightGreenChip.withValues(alpha: 0.5)),
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
                                    color: isDark
                                        ? AppColors.secondary
                                        : AppColors.primary,
                                  ),
                                  responsive.hSpaceSmall,
                                  Text(
                                    context.tr('about'),
                                    style: TextStyle(
                                      fontSize: responsive.textSmall,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.secondary
                                          : AppColors.primary,
                                      fontFamily:
                                          selectedLanguage ==
                                              IslamicNameLanguage.urdu
                                          ? 'NotoNastaliq'
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
                                      : (isDark
                                            ? AppColors.darkTextSecondary
                                            : Colors.black87),
                                  fontFamily:
                                      selectedLanguage ==
                                          IslamicNameLanguage.urdu
                                      ? 'NotoNastaliq'
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
                ),
              if (!_showTranslation)
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: responsive.paddingRegular,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800
                        : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
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
                              color: isDark ? emeraldGreen : darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.tr('about'),
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : darkGreen,
                              fontFamily:
                                  selectedLanguage == IslamicNameLanguage.urdu
                                  ? 'NotoNastaliq'
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
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                          fontFamily:
                              selectedLanguage == IslamicNameLanguage.urdu
                              ? 'NotoNastaliq'
                              : null,
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
                    color: isDark
                        ? Colors.grey.shade800
                        : const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade200,
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
                              color: isDark ? emeraldGreen : darkGreen,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            context.tr('biographical_details'),
                            style: TextStyle(
                              fontSize: responsive.textRegular,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : darkGreen,
                              fontFamily:
                                  selectedLanguage == IslamicNameLanguage.urdu
                                  ? 'NotoNastaliq'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      responsive.vSpaceRegular,
                      _buildBiographicalGrid(
                        context,
                        isDark,
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
    );
  }

  Widget _headerActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isActive,
    required bool isDark,
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
            horizontal: responsive.spacing(10),
            vertical: responsive.spacing(6),
          ),
          decoration: BoxDecoration(
            color: isActive
                ? emeraldGreen
                : (isDark ? Colors.grey.shade700 : lightGreenChip),
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
                    : (isDark ? AppColors.darkTextPrimary : darkGreen),
              ),
              responsive.vSpaceXSmall,
              Text(
                label,
                style: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: isActive
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : darkGreen),
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
    bool isDark,
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
                isDark,
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
    bool isDark,
    Color darkGreen,
    Color emeraldGreen,
    IslamicNameLanguage selectedLanguage,
  ) {
    final responsive = context.responsive;
    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      padding: responsive.paddingMedium,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey.shade700.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusMedium),
        border: Border.all(
          color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(responsive.spacing(8)),
            decoration: BoxDecoration(
              color: isDark
                  ? emeraldGreen.withValues(alpha: 0.2)
                  : const Color(0xFFE8F3ED),
              borderRadius: BorderRadius.circular(responsive.radiusSmall),
            ),
            child: Icon(
              icon,
              size: responsive.iconSmall,
              color: isDark ? emeraldGreen : darkGreen,
            ),
          ),
          SizedBox(width: responsive.spacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : Colors.grey.shade600,
                  ),
                ),
                responsive.vSpaceXSmall,
                Text(
                  _translateBiographicalValue(value, selectedLanguage),
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : darkGreen,
                    fontFamily: selectedLanguage == IslamicNameLanguage.urdu
                        ? 'NotoNastaliq'
                        : null,
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
