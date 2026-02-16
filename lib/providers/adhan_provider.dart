import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../data/models/prayer_time_model.dart';
import '../core/services/azan_background_service.dart';
import '../core/services/azan_permission_service.dart';

/// Export hardcoded prayer notification strings for DataMigrationService
Map<String, dynamic> getHardcodedPrayerNotificationStrings() => {
  'prayer_names': PrayerNotificationStrings.prayerNames,
  'prayer_time_title': PrayerNotificationStrings.prayerTimeTitle,
  'its_time_for': PrayerNotificationStrings.itsTimeFor,
  'prayer': PrayerNotificationStrings.prayer,
  'in_location': PrayerNotificationStrings.inLocation,
};

/// Export hardcoded Islamic reminder strings for DataMigrationService
Map<String, dynamic> getHardcodedIslamicReminderStrings() => {
  'titles': IslamicReminderStrings.titles,
  'bodies': IslamicReminderStrings.bodies,
};

/// Prayer notification translations for 4 languages
class PrayerNotificationStrings {
  static const Map<String, Map<String, String>> prayerNames = {
    'en': {
      'Fajr': 'Fajr',
      'Sunrise': 'Sunrise',
      'Dhuhr': 'Dhuhr',
      'Asr': 'Asr',
      'Maghrib': 'Maghrib',
      'Isha': 'Isha',
    },
    'ur': {
      'Fajr': 'فجر',
      'Sunrise': 'طلوع آفتاب',
      'Dhuhr': 'ظہر',
      'Asr': 'عصر',
      'Maghrib': 'مغرب',
      'Isha': 'عشاء',
    },
    'ar': {
      'Fajr': 'الفجر',
      'Sunrise': 'الشروق',
      'Dhuhr': 'الظهر',
      'Asr': 'العصر',
      'Maghrib': 'المغرب',
      'Isha': 'العشاء',
    },
    'hi': {
      'Fajr': 'फज्र',
      'Sunrise': 'सूर्योदय',
      'Dhuhr': 'ज़ुहर',
      'Asr': 'अस्र',
      'Maghrib': 'मग़रिब',
      'Isha': 'ईशा',
    },
  };

  static const Map<String, String> prayerTimeTitle = {
    'en': 'Prayer Time',
    'ur': 'نماز کا وقت',
    'ar': 'وقت الصلاة',
    'hi': 'नमाज़ का वक़्त',
  };

  static const Map<String, String> itsTimeFor = {
    'en': "It's time for",
    'ur': 'کا وقت ہو گیا',
    'ar': 'حان وقت',
    'hi': 'का वक़्त हो गया',
  };

  static const Map<String, String> prayer = {
    'en': 'prayer',
    'ur': 'نماز',
    'ar': 'صلاة',
    'hi': 'नमाज़',
  };

  static const Map<String, String> inLocation = {
    'en': 'in',
    'ur': 'میں',
    'ar': 'في',
    'hi': 'में',
  };

  // Mutable Firestore-loaded fields
  static Map<String, Map<String, String>>? _firestorePrayerNames;
  static Map<String, String>? _firestorePrayerTimeTitle;
  static Map<String, String>? _firestoreItsTimeFor;
  static Map<String, String>? _firestorePrayer;
  static Map<String, String>? _firestoreInLocation;

  /// Load notification strings from Firestore data
  static void loadFromFirestore(Map<String, dynamic> data) {
    if (data.containsKey('prayer_names')) {
      _firestorePrayerNames = (data['prayer_names'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as Map<String, dynamic>).map((k2, v2) => MapEntry(k2, v2.toString()))),
      );
    }
    if (data.containsKey('prayer_time_title')) {
      _firestorePrayerTimeTitle = (data['prayer_time_title'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()));
    }
    if (data.containsKey('its_time_for')) {
      _firestoreItsTimeFor = (data['its_time_for'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()));
    }
    if (data.containsKey('prayer')) {
      _firestorePrayer = (data['prayer'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()));
    }
    if (data.containsKey('in_location')) {
      _firestoreInLocation = (data['in_location'] as Map<String, dynamic>).map((k, v) => MapEntry(k, v.toString()));
    }
  }

  static String getNotificationTitle(String prayerName, String langCode) {
    final lang = _getSupportedLang(langCode);
    final names = _firestorePrayerNames ?? prayerNames;
    final titles = _firestorePrayerTimeTitle ?? prayerTimeTitle;
    final translatedPrayer = names[lang]?[prayerName] ?? prayerName;
    final timeText = titles[lang] ?? 'Prayer Time';

    if (lang == 'ur' || lang == 'ar') {
      return '$translatedPrayer - $timeText';
    }
    return '$translatedPrayer - $timeText';
  }

  static String getNotificationBody(String prayerName, String langCode, {String? city}) {
    final lang = _getSupportedLang(langCode);
    final names = _firestorePrayerNames ?? prayerNames;
    final translatedPrayer = names[lang]?[prayerName] ?? prayerName;
    final itsTimeMap = _firestoreItsTimeFor ?? itsTimeFor;
    final itsTime = itsTimeMap[lang] ?? "It's time for";
    final prayerMap = _firestorePrayer ?? prayer;
    final prayerWord = prayerMap[lang] ?? 'prayer';
    final inLocMap = _firestoreInLocation ?? inLocation;
    final inLoc = inLocMap[lang] ?? 'in';

    String baseMessage;
    if (lang == 'ur') {
      baseMessage = '$translatedPrayer $prayerWord $itsTime';
    } else if (lang == 'ar') {
      baseMessage = '$itsTime $translatedPrayer';
    } else if (lang == 'hi') {
      baseMessage = '$translatedPrayer $prayerWord $itsTime';
    } else {
      baseMessage = "$itsTime $translatedPrayer $prayerWord";
    }

    // Add city name if available
    if (city != null && city.isNotEmpty) {
      if (lang == 'ur' || lang == 'ar') {
        return '$baseMessage $inLoc $city';
      } else {
        return '$baseMessage $inLoc $city';
      }
    }
    return baseMessage;
  }

  static String _getSupportedLang(String langCode) {
    if (['en', 'ur', 'ar', 'hi'].contains(langCode)) {
      return langCode;
    }
    return 'en';
  }
}

/// Islamic reminder and festival notification translations
class IslamicReminderStrings {
  static const Map<String, Map<String, String>> titles = {
    'en': {
      'daily_reminder': 'Daily Islamic Reminder',
      'quran_reminder': 'Quran Reminder',
      'dhikr_reminder': 'Dhikr Reminder',
      'charity_reminder': 'Charity Reminder',
      'dua_reminder': 'Dua Reminder',
      'jumma_reminder': 'Jumma Mubarak',
      'ramadan_start': 'Ramadan Mubarak',
      'laylatul_qadr': 'Laylatul Qadr',
      'eid_ul_fitr': 'Eid ul-Fitr Mubarak',
      'eid_ul_adha': 'Eid ul-Adha Mubarak',
      'islamic_new_year': 'Islamic New Year',
      'ashura': 'Day of Ashura',
      'milad_un_nabi': 'Milad un-Nabi',
      'morning_summary': 'Good Morning! Islamic Reminder',
      'sadqa_daily': 'Daily Sadqa Reminder',
    },
    'ur': {
      'daily_reminder': 'روزانہ اسلامی یاد دہانی',
      'quran_reminder': 'قرآن کی یاد دہانی',
      'dhikr_reminder': 'ذکر کی یاد دہانی',
      'charity_reminder': 'صدقہ کی یاد دہانی',
      'dua_reminder': 'دعا کی یاد دہانی',
      'jumma_reminder': 'جمعہ مبارک',
      'ramadan_start': 'رمضان مبارک',
      'laylatul_qadr': 'لیلۃ القدر',
      'eid_ul_fitr': 'عید الفطر مبارک',
      'eid_ul_adha': 'عید الاضحی مبارک',
      'islamic_new_year': 'اسلامی نیا سال',
      'ashura': 'یوم عاشورہ',
      'milad_un_nabi': 'میلاد النبی ﷺ',
      'morning_summary': 'صبح بخیر! اسلامی یاد دہانی',
      'sadqa_daily': 'روزانہ صدقہ کی یاد دہانی',
    },
    'ar': {
      'daily_reminder': 'تذكير إسلامي يومي',
      'quran_reminder': 'تذكير بالقرآن',
      'dhikr_reminder': 'تذكير بالذكر',
      'charity_reminder': 'تذكير بالصدقة',
      'dua_reminder': 'تذكير بالدعاء',
      'jumma_reminder': 'جمعة مباركة',
      'ramadan_start': 'رمضان مبارك',
      'laylatul_qadr': 'ليلة القدر',
      'eid_ul_fitr': 'عيد الفطر مبارك',
      'eid_ul_adha': 'عيد الأضحى مبارك',
      'islamic_new_year': 'رأس السنة الهجرية',
      'ashura': 'يوم عاشوراء',
      'milad_un_nabi': 'المولد النبوي',
      'morning_summary': 'صباح الخير! تذكير إسلامي',
      'sadqa_daily': 'تذكير الصدقة اليومية',
    },
    'hi': {
      'daily_reminder': 'दैनिक इस्लामी याद',
      'quran_reminder': 'क़ुरआन की याद',
      'dhikr_reminder': 'ज़िक्र की याद',
      'charity_reminder': 'सदक़ा की याद',
      'dua_reminder': 'दुआ की याद',
      'jumma_reminder': 'जुमा मुबारक',
      'ramadan_start': 'रमज़ान मुबारक',
      'laylatul_qadr': 'लैलतुल क़द्र',
      'eid_ul_fitr': 'ईद उल-फ़ित्र मुबारक',
      'eid_ul_adha': 'ईद उल-अज़हा मुबारक',
      'islamic_new_year': 'इस्लामी नया साल',
      'ashura': 'आशूरा का दिन',
      'milad_un_nabi': 'मीलाद-उन-नबी',
      'morning_summary': 'सुप्रभात! इस्लामी याद',
      'sadqa_daily': 'रोज़ाना सदक़ा याद',
    },
  };

  static const Map<String, Map<String, String>> bodies = {
    'en': {
      'daily_reminder_message': 'Start your day with the remembrance of Allah',
      'quran_reminder_message': 'Have you read the Quran today? Even a few verses bring immense blessings',
      'dhikr_reminder_message': 'Take a moment to remember Allah. SubhanAllah, Alhamdulillah, Allahu Akbar',
      'charity_reminder_message': 'Charity does not decrease wealth. Consider helping someone in need today',
      'dua_reminder_message': 'Make dua for yourself and the Ummah. Allah loves those who ask Him',
      'jumma_reminder_message': 'Blessed Friday! Remember to recite Surah Al-Kahf and send blessings upon the Prophet ﷺ',
      'ramadan_start_message': 'The blessed month of Ramadan has begun. May Allah accept your fasts and prayers',
      'laylatul_qadr_message': 'Seek Laylatul Qadr in the last ten nights. It is better than a thousand months',
      'eid_ul_fitr_message': 'Eid Mubarak! May Allah accept your fasts and prayers during Ramadan',
      'eid_ul_adha_message': 'Eid Mubarak! May Allah accept your sacrifices and good deeds',
      'islamic_new_year_message': 'Happy Islamic New Year! May this year bring peace and blessings',
      'ashura_message': 'The Day of Ashura. Remember to fast and reflect on its significance',
      'milad_un_nabi_message': 'Celebrate the birth of Prophet Muhammad ﷺ by following his teachings',
      'morning_summary_message': 'Start your blessed day! Check today\'s prayer times, upcoming Islamic events, and remember to give Sadqa',
      'sadqa_daily_message': 'The Prophet ﷺ said: "Give charity without delay, for it stands in the way of calamity." Even a smile is Sadqa!',
    },
    'ur': {
      'daily_reminder_message': 'اپنے دن کا آغاز اللہ کی یاد سے کریں',
      'quran_reminder_message': 'کیا آپ نے آج قرآن پڑھا؟ چند آیات بھی بے پناہ برکات لاتی ہیں',
      'dhikr_reminder_message': 'اللہ کو یاد کرنے کے لیے ایک لمحہ نکالیں۔ سبحان اللہ، الحمدللہ، اللہ اکبر',
      'charity_reminder_message': 'صدقہ مال کو کم نہیں کرتا۔ آج کسی ضرورت مند کی مدد کریں',
      'dua_reminder_message': 'اپنے لیے اور امت کے لیے دعا کریں۔ اللہ مانگنے والوں سے محبت کرتا ہے',
      'jumma_reminder_message': 'جمعہ مبارک! سورۃ الکہف پڑھیں اور نبی ﷺ پر درود بھیجیں',
      'ramadan_start_message': 'رمضان المبارک شروع ہو گیا۔ اللہ آپ کے روزے اور نمازیں قبول فرمائے',
      'laylatul_qadr_message': 'آخری دس راتوں میں لیلۃ القدر تلاش کریں۔ یہ ہزار مہینوں سے بہتر ہے',
      'eid_ul_fitr_message': 'عید مبارک! اللہ رمضان کے روزے اور نمازیں قبول فرمائے',
      'eid_ul_adha_message': 'عید مبارک! اللہ آپ کی قربانیاں اور نیک اعمال قبول فرمائے',
      'islamic_new_year_message': 'اسلامی نیا سال مبارک! یہ سال امن اور برکت لائے',
      'ashura_message': 'یوم عاشورہ۔ روزہ رکھیں اور اس کی اہمیت پر غور کریں',
      'milad_un_nabi_message': 'نبی محمد ﷺ کی ولادت کا جشن ان کی تعلیمات پر عمل کر کے منائیں',
      'morning_summary_message': 'اپنے مبارک دن کا آغاز کریں! آج کے نماز کے اوقات، آنے والے اسلامی واقعات دیکھیں اور صدقہ دینا یاد رکھیں',
      'sadqa_daily_message': 'نبی ﷺ نے فرمایا: "صدقہ دینے میں تاخیر نہ کرو، یہ مصیبت کے راستے میں کھڑا ہے۔" مسکراہٹ بھی صدقہ ہے!',
    },
    'ar': {
      'daily_reminder_message': 'ابدأ يومك بذكر الله',
      'quran_reminder_message': 'هل قرأت القرآن اليوم؟ حتى بضع آيات تجلب بركات عظيمة',
      'dhikr_reminder_message': 'خذ لحظة لذكر الله. سبحان الله، الحمد لله، الله أكبر',
      'charity_reminder_message': 'الصدقة لا تنقص المال. فكر في مساعدة محتاج اليوم',
      'dua_reminder_message': 'ادع لنفسك وللأمة. الله يحب من يسأله',
      'jumma_reminder_message': 'جمعة مباركة! تذكر قراءة سورة الكهف والصلاة على النبي ﷺ',
      'ramadan_start_message': 'بدأ شهر رمضان المبارك. تقبل الله صيامك وصلاتك',
      'laylatul_qadr_message': 'ابحث عن ليلة القدر في العشر الأواخر. هي خير من ألف شهر',
      'eid_ul_fitr_message': 'عيد مبارك! تقبل الله صيامك وصلاتك في رمضان',
      'eid_ul_adha_message': 'عيد مبارك! تقبل الله أضحيتك وأعمالك الصالحة',
      'islamic_new_year_message': 'سنة هجرية سعيدة! عسى هذا العام يجلب السلام والبركات',
      'ashura_message': 'يوم عاشوراء. تذكر الصيام والتأمل في أهميته',
      'milad_un_nabi_message': 'احتفل بمولد النبي محمد ﷺ باتباع تعاليمه',
      'morning_summary_message': 'ابدأ يومك المبارك! تحقق من أوقات الصلاة اليوم والأحداث الإسلامية القادمة وتذكر الصدقة',
      'sadqa_daily_message': 'قال النبي ﷺ: "بادروا بالصدقة فإنها تحول بينكم وبين البلاء." حتى الابتسامة صدقة!',
    },
    'hi': {
      'daily_reminder_message': 'अपने दिन की शुरुआत अल्लाह की याद से करें',
      'quran_reminder_message': 'क्या आपने आज क़ुरआन पढ़ा? कुछ आयतें भी बहुत बरकत लाती हैं',
      'dhikr_reminder_message': 'अल्लाह को याद करने के लिए एक पल निकालें। सुभानअल्लाह, अलहम्दुलिल्लाह, अल्लाहु अकबर',
      'charity_reminder_message': 'सदक़ा माल को कम नहीं करता। आज किसी ज़रूरतमंद की मदद करें',
      'dua_reminder_message': 'अपने और उम्मत के लिए दुआ करें। अल्लाह मांगने वालों से प्यार करता है',
      'jumma_reminder_message': 'जुमा मुबारक! सूरह अल-कहफ़ पढ़ें और नबी ﷺ पर दरूद भेजें',
      'ramadan_start_message': 'रमज़ान का मुबारक महीना शुरू हो गया। अल्लाह आपके रोज़े और नमाज़ क़बूल करे',
      'laylatul_qadr_message': 'आखिरी दस रातों में लैलतुल क़द्र तलाश करें। यह हज़ार महीनों से बेहतर है',
      'eid_ul_fitr_message': 'ईद मुबारक! अल्लाह रमज़ान के रोज़े और नमाज़ क़बूल करे',
      'eid_ul_adha_message': 'ईद मुबारक! अल्लाह आपकी क़ुर्बानी और नेक अमल क़बूल करे',
      'islamic_new_year_message': 'इस्लामी नया साल मुबारक! यह साल अमन और बरकत लाए',
      'ashura_message': 'आशूरा का दिन। रोज़ा रखें और इसकी अहमियत पर ग़ौर करें',
      'milad_un_nabi_message': 'नबी मुहम्मद ﷺ की पैदाइश का जश्न उनकी तालीमात पर अमल करके मनाएं',
      'morning_summary_message': 'अपने मुबारक दिन की शुरुआत करें! आज की नमाज़ के वक़्त, आने वाली इस्लामी तारीखें देखें और सदक़ा देना याद रखें',
      'sadqa_daily_message': 'नबी ﷺ ने फ़रमाया: "सदक़ा देने में देरी न करो, यह मुसीबत के रास्ते में खड़ा है।" मुस्कुराहट भी सदक़ा है!',
    },
  };

  // Mutable Firestore-loaded fields
  static Map<String, Map<String, String>>? _firestoreTitles;
  static Map<String, Map<String, String>>? _firestoreBodies;

  /// Load Islamic reminder strings from Firestore data
  static void loadFromFirestore(Map<String, dynamic> data) {
    if (data.containsKey('titles')) {
      _firestoreTitles = (data['titles'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as Map<String, dynamic>).map((k2, v2) => MapEntry(k2, v2.toString()))),
      );
    }
    if (data.containsKey('bodies')) {
      _firestoreBodies = (data['bodies'] as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, (v as Map<String, dynamic>).map((k2, v2) => MapEntry(k2, v2.toString()))),
      );
    }
  }

  static String getTitle(String key, String langCode) {
    final lang = _getSupportedLang(langCode);
    final t = _firestoreTitles ?? titles;
    return t[lang]?[key] ?? t['en']?[key] ?? key;
  }

  static String getBody(String key, String langCode) {
    final lang = _getSupportedLang(langCode);
    final b = _firestoreBodies ?? bodies;
    return b[lang]?[key] ?? b['en']?[key] ?? key;
  }

  static String _getSupportedLang(String langCode) {
    if (['en', 'ur', 'ar', 'hi'].contains(langCode)) {
      return langCode;
    }
    return 'en';
  }
}

class AdhanProvider with ChangeNotifier {
  // Static instance for accessing from static notification handlers and background services
  static AdhanProvider? _instance;

  /// Get the current AdhanProvider instance (set during initialization)
  static AdhanProvider? get instance => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _notificationsEnabled = true;
  bool _adhanSoundEnabled = true;
  String _selectedAdhan = 'madinah';
  String _languageCode = 'en';
  bool _isInitialized = false;
  bool _permissionsGranted = false;
  String _currentCity = '';
  double _lastLatitude = 0.0;
  double _lastLongitude = 0.0;

  // Received notifications list
  List<ReceivedNotification> _receivedNotifications = [];

  // Unread notification count
  int _unreadCount = 0;
  DateTime? _lastReadTime;

  final Map<String, bool> _prayerNotifications = {
    'Fajr': true,
    'Sunrise': false,
    'Dhuhr': true,
    'Asr': true,
    'Maghrib': true,
    'Isha': true,
  };

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get adhanSoundEnabled => _adhanSoundEnabled;
  String get selectedAdhan => _selectedAdhan;
  Map<String, bool> get prayerNotifications => _prayerNotifications;
  bool get isInitialized => _isInitialized;
  bool get permissionsGranted => _permissionsGranted;
  String get currentCity => _currentCity;
  double get lastLatitude => _lastLatitude;
  double get lastLongitude => _lastLongitude;
  List<ReceivedNotification> get receivedNotifications => _receivedNotifications;
  int get unreadCount => _unreadCount;

  // Adhan options
  static const Map<String, String> adhanOptions = {
    'makkah': 'Makkah Adhan',
    'madinah': 'Madinah Adhan',
    'alaqsa': 'Al-Aqsa Adhan',
    'mishary': 'Mishary Rashid',
    'abdul_basit': 'Abdul Basit',
  };

  // Adhan URLs (using Al Adhan CDN - reliable)
  static const Map<String, String> adhanUrls = {
    'makkah': 'https://cdn.aladhan.com/audio/adhans/a1.mp3',
    'madinah': 'https://cdn.aladhan.com/audio/adhans/a2.mp3',
    'alaqsa': 'https://cdn.aladhan.com/audio/adhans/a3.mp3',
    'mishary': 'https://cdn.aladhan.com/audio/adhans/a4.mp3',
    'abdul_basit': 'https://cdn.aladhan.com/audio/adhans/a9.mp3',
  };

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Set static instance for notification handlers
    _instance = this;

    debugPrint('🔔 AdhanProvider: Starting initialization...');

    // Initialize each step independently - don't let one failure block everything
    try {
      await _initializeTimezone();
      debugPrint('🔔 AdhanProvider: Timezone initialized');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Timezone init error (continuing): $e');
    }

    try {
      await _initNotifications();
      debugPrint('🔔 AdhanProvider: Notifications initialized');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Notification init error (continuing): $e');
    }

    try {
      await requestNotificationPermissions();
      debugPrint('🔔 AdhanProvider: Permissions requested');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Permission request error (continuing): $e');
    }

    try {
      await _loadPreferences();
      debugPrint('🔔 AdhanProvider: Preferences loaded');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Preferences load error (continuing): $e');
    }

    try {
      await loadReceivedNotifications();
      debugPrint('🔔 AdhanProvider: Received notifications loaded');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Load notifications error (continuing): $e');
    }

    // Mark as initialized even if some steps failed - so scheduling can proceed
    _isInitialized = true;
    debugPrint('🔔 AdhanProvider: Initialization complete!');

    // Schedule Islamic reminders immediately at startup (don't depend on HomeScreen)
    scheduleAllIslamicNotifications().then((_) {
      debugPrint('🔔 AdhanProvider: Islamic reminders scheduled at startup');
    }).catchError((e) {
      debugPrint('🔔 AdhanProvider: Failed to schedule at startup: $e');
    });
  }

  Future<void> _initializeTimezone() async {
    tz_data.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint('🔔 AdhanProvider: Timezone set to $timeZoneName');
    } catch (e) {
      // Fallback to UTC if timezone detection fails
      tz.setLocalLocation(tz.getLocation('UTC'));
      debugPrint('🔔 AdhanProvider: Timezone fallback to UTC: $e');
    }
  }

  Future<void> _initNotifications() async {
    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS settings - request permissions
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final result = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _backgroundNotificationHandler,
    );

    debugPrint('🔔 AdhanProvider: Notification init result: $result');

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  Future<void> _createNotificationChannel() async {
    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Azan/Prayer notification channel
    const azanChannel = AndroidNotificationChannel(
      'azan_channel',
      'Azan Notifications',
      description: 'Notifications for Islamic prayer times with Azan sound',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    // Islamic reminders channel
    const remindersChannel = AndroidNotificationChannel(
      'islamic_reminders_channel',
      'Islamic Reminders',
      description: 'Daily Islamic reminders for Quran, Dhikr, Dua, and more',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    // Islamic festivals channel
    const festivalsChannel = AndroidNotificationChannel(
      'islamic_festivals_channel',
      'Islamic Festivals',
      description: 'Notifications for Islamic festivals like Eid, Ramadan, Jumma',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await androidPlugin.createNotificationChannel(azanChannel);
    await androidPlugin.createNotificationChannel(remindersChannel);
    await androidPlugin.createNotificationChannel(festivalsChannel);

    debugPrint('🔔 AdhanProvider: All notification channels created');
  }

  static void _onNotificationTap(NotificationResponse response) {
    debugPrint('🔔 AdhanProvider: Notification tapped: ${response.payload}');
    _saveReceivedNotificationStatic(response);
  }

  @pragma('vm:entry-point')
  static void _backgroundNotificationHandler(NotificationResponse response) {
    debugPrint('🔔 AdhanProvider: Background notification: ${response.payload}');
    _saveReceivedNotificationStatic(response);
  }

  static Future<void> _saveReceivedNotificationStatic(NotificationResponse response) async {
    if (response.notificationResponseType == NotificationResponseType.selectedNotification) {
      // Save to SharedPreferences directly for static access
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('received_notifications') ?? '[]';
      final List<dynamic> notifications = json.decode(jsonString);

      // Parse payload for type info
      String type = 'reminder';
      String title = 'Notification';
      String body = '';

      if (response.id != null && response.id! < 10) {
        type = 'prayer';
      } else if (response.id != null && response.id! >= 400) {
        type = 'festival';
      } else if (response.id != null && response.id! >= 300) {
        type = 'reminder';
      }

      // Try to get title and body from scheduled_notifications storage
      final scheduledJson = prefs.getString('scheduled_notifications');
      if (scheduledJson != null && response.id != null) {
        try {
          final List<dynamic> scheduledList = json.decode(scheduledJson);
          final match = scheduledList.where((n) => n['id'] == response.id).toList();
          if (match.isNotEmpty) {
            title = match.first['title']?.toString() ?? title;
            body = match.first['body']?.toString() ?? body;
            type = match.first['type']?.toString() ?? type;
          }
        } catch (_) {}
      }

      // Fallback to payload if title is still default
      if (title == 'Notification' && response.payload != null && response.payload!.isNotEmpty) {
        title = response.payload!;
      }

      notifications.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': title,
        'body': body,
        'type': type,
        'receivedAt': DateTime.now().toIso8601String(),
      });

      // Keep only last 100 notifications
      if (notifications.length > 100) {
        notifications.removeRange(100, notifications.length);
      }

      await prefs.setString('received_notifications', json.encode(notifications));
      debugPrint('🔔 AdhanProvider: Received notification saved - $title');

      // Update instance if available
      _instance?.loadReceivedNotifications();
    }
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('adhan_notifications') ?? true;
    _adhanSoundEnabled = prefs.getBool('azan_sound') ?? true;
    _selectedAdhan = prefs.getString('selected_adhan') ?? 'madinah';
    _languageCode = prefs.getString('selected_language') ?? 'en';

    for (final prayer in _prayerNotifications.keys) {
      _prayerNotifications[prayer] =
          prefs.getBool('notify_$prayer') ?? _prayerNotifications[prayer]!;
    }

    notifyListeners();
  }

  /// Update language code for notifications
  void updateLanguageCode(String langCode) {
    _languageCode = langCode;
  }

  /// Update user's current location for location-aware notifications
  void updateLocation({
    required String city,
    required double latitude,
    required double longitude,
  }) {
    _currentCity = city;
    _lastLatitude = latitude;
    _lastLongitude = longitude;
    debugPrint('🔔 AdhanProvider: Location updated - City: $city, Lat: $latitude, Lng: $longitude');
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('adhan_notifications', _notificationsEnabled);
    await prefs.setBool('azan_sound', _adhanSoundEnabled);
    await prefs.setString('selected_adhan', _selectedAdhan);

    for (final entry in _prayerNotifications.entries) {
      await prefs.setBool('notify_${entry.key}', entry.value);
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await _savePreferences();

    if (!enabled) {
      await _notifications.cancelAll();
      // Also cancel native azan alarms
      await AzanBackgroundService.cancelAllAlarms();
    }

    notifyListeners();
  }

  Future<void> setAdhanSoundEnabled(bool enabled) async {
    _adhanSoundEnabled = enabled;
    await _savePreferences();

    if (!enabled) {
      // Cancel native azan alarms when sound is disabled
      await AzanBackgroundService.cancelAllAlarms();
    }

    notifyListeners();
  }

  Future<void> setSelectedAdhan(String adhan) async {
    _selectedAdhan = adhan;
    await _savePreferences();
    notifyListeners();

    // Pre-cache the newly selected azan audio for offline playback
    AzanBackgroundService.cacheAzan(adhan);
  }

  Future<void> setPrayerNotification(String prayer, bool enabled) async {
    _prayerNotifications[prayer] = enabled;
    await _savePreferences();
    notifyListeners();
  }

  /// Request notification permissions
  Future<bool> requestNotificationPermissions() async {
    try {
      if (Platform.isAndroid) {
        // Request notification permission (Android 13+)
        final androidImpl = _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

        if (androidImpl != null) {
          final notificationPermission =
              await androidImpl.requestNotificationsPermission();
          debugPrint(
              '🔔 AdhanProvider: Notification permission: $notificationPermission');

          // Request exact alarm permission (Android 12+)
          final exactAlarmPermission =
              await androidImpl.requestExactAlarmsPermission();
          debugPrint(
              '🔔 AdhanProvider: Exact alarm permission: $exactAlarmPermission');

          _permissionsGranted = notificationPermission ?? false;
        }
      } else if (Platform.isIOS) {
        final iosImpl = _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

        if (iosImpl != null) {
          final result = await iosImpl.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          _permissionsGranted = result ?? false;
          debugPrint('🔔 AdhanProvider: iOS permissions: $_permissionsGranted');
        }
      }

      notifyListeners();
      return _permissionsGranted;
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Permission request error: $e');
      return false;
    }
  }

  /// Test notification - shows immediately
  Future<void> showTestNotification() async {
    debugPrint('🔔 AdhanProvider: Showing test notification...');

    const androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'Azan Notifications',
      channelDescription: 'Notifications for Islamic prayer times with Azan sound',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _notifications.show(
        999,
        'Azan Test',
        'This is a test notification. If you see this, notifications are working!',
        details,
      );
      debugPrint('🔔 AdhanProvider: Test notification sent successfully!');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Test notification error: $e');
    }
  }

  Future<void> schedulePrayerNotifications(PrayerTimeModel prayerTimes) async {
    debugPrint('🔔 AdhanProvider: schedulePrayerNotifications called');
    debugPrint('🔔 AdhanProvider: Notifications enabled: $_notificationsEnabled');

    if (!_notificationsEnabled) {
      debugPrint('🔔 AdhanProvider: Notifications disabled, skipping');
      return;
    }

    // Ensure initialized
    if (!_isInitialized) {
      debugPrint('🔔 AdhanProvider: Not initialized, initializing now...');
      await initialize();
    }

    // Re-request permissions if not granted yet
    if (!_permissionsGranted) {
      debugPrint('🔔 AdhanProvider: Permissions not granted, requesting again...');
      await requestNotificationPermissions();
    }

    // Cancel only prayer notifications (IDs 0-9), not all notifications
    for (int i = 0; i < 10; i++) {
      await _notifications.cancel(i);
    }
    debugPrint('🔔 AdhanProvider: Cancelled existing prayer notifications');

    final prayers = {
      'Fajr': prayerTimes.fajr,
      'Sunrise': prayerTimes.sunrise,
      'Dhuhr': prayerTimes.dhuhr,
      'Asr': prayerTimes.asr,
      'Maghrib': prayerTimes.maghrib,
      'Isha': prayerTimes.isha,
    };

    debugPrint('🔔 AdhanProvider: Prayer times received:');
    prayers.forEach((name, time) {
      debugPrint('   $name: $time');
    });

    int notificationId = 0;
    int scheduledCount = 0;

    for (final entry in prayers.entries) {
      if (_prayerNotifications[entry.key] == true) {
        final success = await _scheduleNotification(
          id: notificationId++,
          prayerName: entry.key,
          time: entry.value,
        );
        if (success) scheduledCount++;
      }
    }

    debugPrint('🔔 AdhanProvider: Scheduled $scheduledCount notifications');

    // Also schedule Azan alarms for background playback
    if (_adhanSoundEnabled) {
      try {
        // Check permissions before scheduling background alarms
        final permissionStatus = await AzanPermissionService.checkAllPermissions();
        debugPrint('🔔 AdhanProvider: Permission status: $permissionStatus');

        if (permissionStatus.hasMissingPermissions) {
          debugPrint('🔔 AdhanProvider: Missing permissions: ${permissionStatus.missingPermissions}');
          // Still try to schedule - it may work with fallback methods
        }

        // Ensure azan audio is cached before scheduling alarms
        try {
          await AzanBackgroundService.cacheSelectedAzan();
          debugPrint('🔔 AdhanProvider: Azan audio cached before scheduling');
        } catch (e) {
          debugPrint('🔔 AdhanProvider: Azan cache failed (continuing): $e');
        }

        await AzanBackgroundService.scheduleAzanAlarms(prayerTimes);
        debugPrint('🔔 AdhanProvider: Background Azan alarms scheduled');
      } catch (e) {
        debugPrint('🔔 AdhanProvider: Background alarm error: $e');
      }
    }

    // Log pending notifications
    final pending = await getPendingNotifications();
    debugPrint('🔔 AdhanProvider: Total pending notifications: ${pending.length}');
    for (final p in pending) {
      debugPrint('   ID: ${p.id}, Title: ${p.title}');
    }
  }

  Future<bool> _scheduleNotification({
    required int id,
    required String prayerName,
    required String time,
  }) async {
    debugPrint('🔔 AdhanProvider: Scheduling $prayerName at $time...');

    // Parse time
    final parsedTime = _parseTimeString(time);
    if (parsedTime == null) {
      debugPrint('🔔 AdhanProvider: Failed to parse time: $time');
      return false;
    }

    final hour = parsedTime['hour']!;
    final minute = parsedTime['minute']!;

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint('🔔 AdhanProvider: Scheduled time: $scheduledDate');

    const androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'Azan Notifications',
      channelDescription: 'Notifications for Islamic prayer times with Azan sound',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      autoCancel: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      // Get translated notification strings with city name
      final title = PrayerNotificationStrings.getNotificationTitle(
        prayerName,
        _languageCode,
      );
      final body = PrayerNotificationStrings.getNotificationBody(
        prayerName,
        _languageCode,
        city: _currentCity,
      );

      // Save to scheduled notifications FIRST (before flutter_local_notifications)
      // This ensures notification screen always has data even if scheduling fails
      await _saveScheduledNotification(
        id: id,
        title: title,
        body: body,
        type: 'prayer',
        scheduledTime: scheduledDate,
      );

      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (exactAlarmError) {
        // Fallback: if exact alarm permission denied (Android 12+), use inexact scheduling
        debugPrint('🔔 AdhanProvider: Exact alarm failed, using inexact fallback: $exactAlarmError');
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      debugPrint('🔔 AdhanProvider: ✅ $prayerName notification scheduled for $scheduledDate');
      return true;
    } catch (e) {
      debugPrint('🔔 AdhanProvider: ❌ Error scheduling $prayerName (saved to history): $e');
      return false;
    }
  }

  /// Save scheduled notification for later display
  Future<void> _saveScheduledNotification({
    required int id,
    required String title,
    required String body,
    required String type,
    required DateTime scheduledTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('scheduled_notifications') ?? '[]';
    final List<dynamic> notifications = json.decode(jsonString);

    // Check if old entry exists and its time has passed - if so, save it as received
    final now = DateTime.now();
    final oldEntryIndex = notifications.indexWhere((n) => n['id'] == id);
    if (oldEntryIndex >= 0) {
      final oldEntry = notifications[oldEntryIndex];
      if (oldEntry['scheduledTime'] != null) {
        try {
          final oldTime = DateTime.parse(oldEntry['scheduledTime'].toString());
          if (oldTime.isBefore(now)) {
            // Move past notification to received_notifications so it shows in the screen
            final receivedJson = prefs.getString('received_notifications') ?? '[]';
            final List<dynamic> receivedList = json.decode(receivedJson);
            // Only add if not already in received list
            final alreadyExists = receivedList.any((r) =>
                r['id'] == oldEntry['id'] &&
                r['receivedAt'] == oldEntry['scheduledTime']);
            if (!alreadyExists) {
              receivedList.insert(0, {
                'id': oldEntry['id'],
                'title': oldEntry['title'] ?? title,
                'body': oldEntry['body'] ?? body,
                'type': oldEntry['type'] ?? type,
                'receivedAt': oldEntry['scheduledTime'],
              });
              // Keep only last 100 received notifications
              if (receivedList.length > 100) {
                receivedList.removeRange(100, receivedList.length);
              }
              await prefs.setString('received_notifications', json.encode(receivedList));
            }
          }
        } catch (_) {}
      }
    }

    // Remove old entry with same id
    notifications.removeWhere((n) => n['id'] == id);

    notifications.add({
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'scheduledTime': scheduledTime.toIso8601String(),
    });

    await prefs.setString('scheduled_notifications', json.encode(notifications));
  }

  /// Parse time string in both "5:30 AM" and "17:30" formats
  Map<String, int>? _parseTimeString(String timeStr) {
    try {
      final cleanTime = timeStr.trim().toUpperCase();
      final isPM = cleanTime.contains('PM');
      final isAM = cleanTime.contains('AM');

      String timeOnly = cleanTime
          .replaceAll('AM', '')
          .replaceAll('PM', '')
          .trim();

      final parts = timeOnly.split(':');
      if (parts.length < 2) return null;

      int hour = int.parse(parts[0].trim());
      final minute = int.parse(parts[1].trim());

      if (isPM || isAM) {
        if (isPM && hour != 12) {
          hour += 12;
        } else if (isAM && hour == 12) {
          hour = 0;
        }
      }

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error parsing time: $timeStr - $e');
      return null;
    }
  }

  Future<void> playAdhan() async {
    if (!_adhanSoundEnabled) return;

    try {
      final url = adhanUrls[_selectedAdhan] ?? adhanUrls['madinah']!;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error playing adhan: $e');
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }

  Future<void> previewAdhan(String adhanKey) async {
    try {
      final url = adhanUrls[adhanKey] ?? adhanUrls['madinah']!;
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();

      Future.delayed(const Duration(seconds: 10), () {
        _audioPlayer.stop();
      });
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error playing adhan preview: $e');
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  /// Get upcoming scheduled notifications from SharedPreferences.
  /// This is more reliable than getPendingNotifications() because it doesn't
  /// depend on flutter_local_notifications successfully scheduling the alarms.
  Future<List<ReceivedNotification>> getUpcomingScheduledNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final List<ReceivedNotification> upcoming = [];

    final scheduledJson = prefs.getString('scheduled_notifications');
    if (scheduledJson != null) {
      try {
        final List<dynamic> scheduledList = json.decode(scheduledJson);
        for (final item in scheduledList) {
          if (item == null ||
              item['scheduledTime'] == null ||
              item['id'] == null ||
              item['title'] == null) {
            continue;
          }
          try {
            final scheduledTime = DateTime.parse(item['scheduledTime'].toString());
            // Only return future notifications
            if (scheduledTime.isAfter(now)) {
              upcoming.add(ReceivedNotification(
                id: item['id'] is int ? item['id'] : int.tryParse(item['id'].toString()) ?? 0,
                title: item['title'].toString(),
                body: (item['body'] ?? '').toString(),
                type: (item['type'] ?? 'reminder').toString(),
                receivedAt: scheduledTime,
              ));
            }
          } catch (_) {}
        }
      } catch (e) {
        debugPrint('🔔 AdhanProvider: Error loading upcoming notifications: $e');
      }
    }

    return upcoming;
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
    debugPrint('🔔 AdhanProvider: Notification $id cancelled');
    notifyListeners();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    debugPrint('🔔 AdhanProvider: All notifications cancelled');
    notifyListeners();
  }

  /// Schedule daily Islamic reminders
  Future<void> scheduleDailyIslamicReminders() async {
    if (!_notificationsEnabled) return;

    // Ensure initialized
    if (!_isInitialized) {
      await initialize();
    }

    // Re-request permissions if not granted yet
    if (!_permissionsGranted) {
      await requestNotificationPermissions();
    }

    // Morning Quran reminder at 6:00 AM
    await _scheduleIslamicReminder(
      id: 300,
      hour: 6,
      minute: 0,
      titleKey: 'quran_reminder',
      bodyKey: 'quran_reminder_message',
    );

    // Afternoon Dhikr reminder at 2:00 PM
    await _scheduleIslamicReminder(
      id: 301,
      hour: 14,
      minute: 0,
      titleKey: 'dhikr_reminder',
      bodyKey: 'dhikr_reminder_message',
    );

    // Evening Dua reminder at 7:00 PM
    await _scheduleIslamicReminder(
      id: 302,
      hour: 19,
      minute: 0,
      titleKey: 'dua_reminder',
      bodyKey: 'dua_reminder_message',
    );

    // Daily Islamic reminder at 9:00 AM
    await _scheduleIslamicReminder(
      id: 303,
      hour: 9,
      minute: 0,
      titleKey: 'daily_reminder',
      bodyKey: 'daily_reminder_message',
    );

    // Charity reminder at 12:00 PM
    await _scheduleIslamicReminder(
      id: 304,
      hour: 12,
      minute: 0,
      titleKey: 'charity_reminder',
      bodyKey: 'charity_reminder_message',
    );

    // Morning summary notification at 5:30 AM (before Fajr)
    await _scheduleIslamicReminder(
      id: 305,
      hour: 5,
      minute: 30,
      titleKey: 'morning_summary',
      bodyKey: 'morning_summary_message',
    );

    // Daily Sadqa reminder at 8:00 AM
    await _scheduleIslamicReminder(
      id: 306,
      hour: 8,
      minute: 0,
      titleKey: 'sadqa_daily',
      bodyKey: 'sadqa_daily_message',
    );

    debugPrint('🔔 AdhanProvider: Daily Islamic reminders scheduled');
  }

  /// Schedule Jumma (Friday) reminder
  Future<void> scheduleJummaReminder() async {
    if (!_notificationsEnabled) return;

    // Ensure initialized
    if (!_isInitialized) {
      await initialize();
    }

    final now = tz.TZDateTime.now(tz.local);
    var nextFriday = now;

    // Find next Friday
    while (nextFriday.weekday != DateTime.friday) {
      nextFriday = nextFriday.add(const Duration(days: 1));
    }

    // Set time to 11:30 AM (before Jumma)
    var scheduledDate = tz.TZDateTime(
      tz.local,
      nextFriday.year,
      nextFriday.month,
      nextFriday.day,
      11,
      30,
    );

    // If it's already past Friday 11:30 AM, schedule for next Friday
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    final title = IslamicReminderStrings.getTitle('jumma_reminder', _languageCode);
    final body = IslamicReminderStrings.getBody('jumma_reminder_message', _languageCode);

    const androidDetails = AndroidNotificationDetails(
      'islamic_reminders_channel',
      'Islamic Reminders',
      channelDescription: 'Daily Islamic reminders and festival notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Save to scheduled notifications FIRST
    await _saveScheduledNotification(
      id: 307,
      title: title,
      body: body,
      type: 'jumma',
      scheduledTime: scheduledDate,
    );

    try {
      try {
        await _notifications.zonedSchedule(
          307,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      } catch (exactAlarmError) {
        debugPrint('🔔 AdhanProvider: Exact alarm failed for Jumma, using inexact: $exactAlarmError');
        await _notifications.zonedSchedule(
          307,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }

      debugPrint('🔔 AdhanProvider: Jumma reminder scheduled for $scheduledDate');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error scheduling Jumma (saved to history): $e');
    }
  }

  /// Schedule Islamic festival notifications based on Hijri calendar
  Future<void> scheduleIslamicFestivalNotifications() async {
    if (!_notificationsEnabled) return;

    // Ensure initialized
    if (!_isInitialized) {
      await initialize();
    }

    // Schedule upcoming festival reminders (hardcoded dates for 2025)
    // These should ideally be calculated based on Hijri calendar
    final festivals = [
      {'id': 400, 'key': 'ramadan_start', 'month': 3, 'day': 1},
      {'id': 401, 'key': 'laylatul_qadr', 'month': 3, 'day': 27},
      {'id': 402, 'key': 'eid_ul_fitr', 'month': 3, 'day': 30},
      {'id': 403, 'key': 'eid_ul_adha', 'month': 6, 'day': 7},
      {'id': 404, 'key': 'islamic_new_year', 'month': 7, 'day': 7},
      {'id': 405, 'key': 'ashura', 'month': 7, 'day': 17},
      {'id': 406, 'key': 'milad_un_nabi', 'month': 9, 'day': 5},
    ];

    for (final festival in festivals) {
      await _scheduleFestivalNotification(
        id: festival['id'] as int,
        festivalKey: festival['key'] as String,
        month: festival['month'] as int,
        day: festival['day'] as int,
      );
    }

    debugPrint('🔔 AdhanProvider: Islamic festival notifications scheduled');
  }

  Future<void> _scheduleIslamicReminder({
    required int id,
    required int hour,
    required int minute,
    required String titleKey,
    required String bodyKey,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final title = IslamicReminderStrings.getTitle(titleKey, _languageCode);
    final body = IslamicReminderStrings.getBody(bodyKey, _languageCode);

    // Determine notification type based on titleKey
    String notificationType = 'reminder';
    if (titleKey == 'quran_reminder') {
      notificationType = 'quran';
    } else if (titleKey == 'dhikr_reminder') {
      notificationType = 'dhikr';
    } else if (titleKey == 'dua_reminder') {
      notificationType = 'dua';
    } else if (titleKey == 'charity_reminder') {
      notificationType = 'charity';
    } else if (titleKey == 'sadqa_daily') {
      notificationType = 'sadqa';
    } else if (titleKey == 'morning_summary') {
      notificationType = 'morning_summary';
    }

    // Save to scheduled notifications FIRST (before flutter_local_notifications)
    // This ensures the notification screen always has data even if scheduling fails
    await _saveScheduledNotification(
      id: id,
      title: title,
      body: body,
      type: notificationType,
      scheduledTime: scheduledDate,
    );

    const androidDetails = AndroidNotificationDetails(
      'islamic_reminders_channel',
      'Islamic Reminders',
      channelDescription: 'Daily Islamic reminders and festival notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (exactAlarmError) {
        debugPrint('🔔 AdhanProvider: Exact alarm failed for reminder, using inexact: $exactAlarmError');
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      debugPrint('🔔 AdhanProvider: Islamic reminder $titleKey scheduled for $scheduledDate');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error scheduling Islamic reminder (saved to history): $e');
    }
  }

  Future<void> _scheduleFestivalNotification({
    required int id,
    required String festivalKey,
    required int month,
    required int day,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, month, day, 8, 0); // 8 AM

    // If date has passed this year, schedule for next year
    if (scheduledDate.isBefore(now)) {
      scheduledDate = DateTime(now.year + 1, month, day, 8, 0);
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);
    final title = IslamicReminderStrings.getTitle(festivalKey, _languageCode);
    final body = IslamicReminderStrings.getBody('${festivalKey}_message', _languageCode);

    // Save to scheduled notifications FIRST (before flutter_local_notifications)
    await _saveScheduledNotification(
      id: id,
      title: title,
      body: body,
      type: 'festival',
      scheduledTime: tzScheduledDate,
    );

    const androidDetails = AndroidNotificationDetails(
      'islamic_festivals_channel',
      'Islamic Festivals',
      channelDescription: 'Notifications for Islamic festivals and events',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      try {
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      } catch (exactAlarmError) {
        debugPrint('🔔 AdhanProvider: Exact alarm failed for festival, using inexact: $exactAlarmError');
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          tzScheduledDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      debugPrint('🔔 AdhanProvider: Festival $festivalKey scheduled for $tzScheduledDate');
    } catch (e) {
      debugPrint('🔔 AdhanProvider: Error scheduling festival (saved to history): $e');
    }
  }

  /// Schedule all Islamic notifications (call this on app startup)
  Future<void> scheduleAllIslamicNotifications() async {
    await scheduleDailyIslamicReminders();
    await scheduleJummaReminder();
    await scheduleIslamicFestivalNotifications();
  }

  /// Check if battery optimization is disabled for the app
  Future<bool> isBatteryOptimizationDisabled() async {
    if (!Platform.isAndroid) return true;

    try {
      const platform = MethodChannel('com.nooruliman.app/battery');
      final bool isDisabled =
          await platform.invokeMethod('isBatteryOptimizationDisabled');
      return isDisabled;
    } catch (e) {
      debugPrint('🔋 Error checking battery optimization: $e');
      return false;
    }
  }

  /// Request to disable battery optimization
  Future<bool> requestDisableBatteryOptimization() async {
    if (!Platform.isAndroid) return true;

    try {
      const platform = MethodChannel('com.nooruliman.app/battery');
      final bool result =
          await platform.invokeMethod('requestDisableBatteryOptimization');
      return result;
    } catch (e) {
      debugPrint('🔋 Error requesting battery optimization disable: $e');
      return false;
    }
  }

  /// Add a received notification to the list
  Future<void> addReceivedNotification({
    required int id,
    required String title,
    required String body,
    required String type,
  }) async {
    final notification = ReceivedNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      receivedAt: DateTime.now(),
    );
    _receivedNotifications.insert(0, notification);
    await _saveReceivedNotifications();
    notifyListeners();
  }

  /// Delete a received notification
  Future<void> deleteReceivedNotification(int id) async {
    _receivedNotifications.removeWhere((n) => n.id == id);

    // Also remove from scheduled_notifications storage
    final prefs = await SharedPreferences.getInstance();
    final scheduledJson = prefs.getString('scheduled_notifications');
    if (scheduledJson != null) {
      final List<dynamic> scheduledList = json.decode(scheduledJson);
      scheduledList.removeWhere((n) => n['id'] == id);
      await prefs.setString('scheduled_notifications', json.encode(scheduledList));
    }

    await _saveReceivedNotifications();
    notifyListeners();
  }

  /// Clear all received notifications
  Future<void> clearReceivedNotifications() async {
    _receivedNotifications.clear();
    await _saveReceivedNotifications();
    notifyListeners();
  }

  /// Load received notifications from storage (scheduled notifications whose time has passed)
  Future<void> loadReceivedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    // Load last read time
    final lastReadTimeStr = prefs.getString('notifications_last_read_time');
    _lastReadTime = lastReadTimeStr != null ? DateTime.parse(lastReadTimeStr) : null;

    // Load from scheduled notifications and filter those whose time has passed
    final scheduledJson = prefs.getString('scheduled_notifications');
    final List<ReceivedNotification> notifications = [];

    if (scheduledJson != null) {
      try {
        final List<dynamic> scheduledList = json.decode(scheduledJson);
        for (final item in scheduledList) {
          // Null safety checks for all fields
          if (item == null ||
              item['scheduledTime'] == null ||
              item['id'] == null ||
              item['title'] == null ||
              item['body'] == null ||
              item['type'] == null) {
            continue;
          }

          try {
            final scheduledTime = DateTime.parse(item['scheduledTime'].toString());
            // Only show notifications whose scheduled time has passed
            if (scheduledTime.isBefore(now)) {
              notifications.add(ReceivedNotification(
                id: item['id'] is int ? item['id'] : int.tryParse(item['id'].toString()) ?? 0,
                title: item['title'].toString(),
                body: item['body'].toString(),
                type: item['type'].toString(),
                receivedAt: scheduledTime,
              ));
            }
          } catch (parseError) {
            debugPrint('🔔 Error parsing notification item: $parseError');
          }
        }
      } catch (e) {
        debugPrint('🔔 Error loading scheduled notifications: $e');
      }
    }

    // Also load from received_notifications (tapped notifications)
    final receivedJson = prefs.getString('received_notifications');
    if (receivedJson != null) {
      try {
        final List<dynamic> receivedList = json.decode(receivedJson);
        for (final item in receivedList) {
          if (item == null) continue;
          try {
            final notification = ReceivedNotification.fromJson(item);
            notifications.add(notification);
          } catch (parseError) {
            debugPrint('🔔 Error parsing received notification: $parseError');
          }
        }
      } catch (e) {
        debugPrint('🔔 Error loading received notifications: $e');
      }
    }

    // Sort by receivedAt descending (newest first)
    notifications.sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

    // Remove duplicates by keeping only the latest entry for each id
    final seen = <int>{};
    _receivedNotifications = notifications.where((n) {
      if (seen.contains(n.id)) return false;
      seen.add(n.id);
      return true;
    }).toList();

    // Calculate unread count (notifications received after last read time)
    if (_lastReadTime != null) {
      _unreadCount = _receivedNotifications
          .where((n) => n.receivedAt.isAfter(_lastReadTime!))
          .length;
    } else {
      // If never read before, all notifications are unread
      _unreadCount = _receivedNotifications.length;
    }

    debugPrint('🔔 AdhanProvider: Unread notification count: $_unreadCount');
    notifyListeners();
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    final prefs = await SharedPreferences.getInstance();
    _lastReadTime = DateTime.now();
    await prefs.setString('notifications_last_read_time', _lastReadTime!.toIso8601String());
    _unreadCount = 0;
    debugPrint('🔔 AdhanProvider: All notifications marked as read');
    notifyListeners();
  }

  /// Save received notifications to storage
  Future<void> _saveReceivedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _receivedNotifications.map((n) => n.toJson()).toList();
    await prefs.setString('received_notifications', json.encode(jsonList));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Model for received notification
class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String type;
  final DateTime receivedAt;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.receivedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'receivedAt': receivedAt.toIso8601String(),
      };

  factory ReceivedNotification.fromJson(Map<String, dynamic> json) {
    return ReceivedNotification(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'reminder',
      receivedAt: json['receivedAt'] != null
          ? DateTime.tryParse(json['receivedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
