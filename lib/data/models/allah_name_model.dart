enum AllahNameLanguage { english, urdu, hindi }

class AllahNameModel {
  final int number;
  final String name;
  final String transliteration;
  final String meaning;
  final String meaningUrdu;
  final String meaningHindi;
  final String description;
  final String descriptionUrdu;
  final String descriptionHindi;
  final String? audioUrl;

  AllahNameModel({
    required this.number,
    required this.name,
    required this.transliteration,
    required this.meaning,
    this.meaningUrdu = '',
    this.meaningHindi = '',
    required this.description,
    this.descriptionUrdu = '',
    this.descriptionHindi = '',
    this.audioUrl,
  });

  // Get meaning based on language
  String getMeaning(AllahNameLanguage language) {
    switch (language) {
      case AllahNameLanguage.urdu:
        final urdu = meaningUrdu;
        return urdu.isNotEmpty ? urdu : meaning;
      case AllahNameLanguage.hindi:
        final hindi = meaningHindi;
        return hindi.isNotEmpty ? hindi : meaning;
      case AllahNameLanguage.english:
        return meaning;
    }
  }

  // Get description based on language
  String getDescription(AllahNameLanguage language) {
    switch (language) {
      case AllahNameLanguage.urdu:
        final urdu = descriptionUrdu;
        return urdu.isNotEmpty ? urdu : description;
      case AllahNameLanguage.hindi:
        final hindi = descriptionHindi;
        return hindi.isNotEmpty ? hindi : description;
      case AllahNameLanguage.english:
        return description;
    }
  }

  factory AllahNameModel.fromJson(Map<String, dynamic> json) {
    return AllahNameModel(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      transliteration: json['transliteration'] ?? '',
      meaning: json['meaning'] ?? '',
      meaningUrdu: json['meaningUrdu'] ?? '',
      meaningHindi: json['meaningHindi'] ?? '',
      description: json['description'] ?? '',
      descriptionUrdu: json['descriptionUrdu'] ?? '',
      descriptionHindi: json['descriptionHindi'] ?? '',
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'transliteration': transliteration,
      'meaning': meaning,
      'meaningUrdu': meaningUrdu,
      'meaningHindi': meaningHindi,
      'description': description,
      'descriptionUrdu': descriptionUrdu,
      'descriptionHindi': descriptionHindi,
      'audioUrl': audioUrl,
    };
  }
}

// Pre-defined 99 Names of Allah with translations
class AllahNames {
  static List<AllahNameModel> get names => [
    AllahNameModel(number: 1, name: 'الله', transliteration: 'Allah', meaning: 'The God', meaningUrdu: 'اللہ', meaningHindi: 'अल्लाह', description: 'The greatest name of Allah, encompassing all divine attributes.', descriptionUrdu: 'اللہ کا سب سے بڑا نام جو تمام الہی صفات کو شامل ہے۔', descriptionHindi: 'अल्लाह का सबसे बड़ा नाम जो सभी दिव्य गुणों को समाहित करता है।'),
    AllahNameModel(number: 2, name: 'الرَّحْمَنُ', transliteration: 'Ar-Rahman', meaning: 'The Most Gracious', meaningUrdu: 'بہت مہربان', meaningHindi: 'सबसे दयालु', description: 'The one who has plenty of mercy for believers and non-believers in this world.', descriptionUrdu: 'جو اس دنیا میں مومنوں اور غیر مومنوں پر بے پناہ رحمت رکھتا ہے۔', descriptionHindi: 'जो इस दुनिया में विश्वासियों और गैर-विश्वासियों पर अपार दया रखते हैं।'),
    AllahNameModel(number: 3, name: 'الرَّحِيمُ', transliteration: 'Ar-Raheem', meaning: 'The Most Merciful', meaningUrdu: 'نہایت رحم کرنے والا', meaningHindi: 'अत्यंत दयावान', description: 'The one who has plenty of mercy for the believers.', descriptionUrdu: 'جو مومنوں پر بے پناہ رحمت رکھتا ہے۔', descriptionHindi: 'जो विश्वासियों पर अपार दया रखते हैं।'),
    AllahNameModel(number: 4, name: 'الْمَلِكُ', transliteration: 'Al-Malik', meaning: 'The King', meaningUrdu: 'بادشاہ', meaningHindi: 'राजा', description: 'The one with complete dominion, the one whose dominion is clear from imperfection.', descriptionUrdu: 'جو مکمل حاکمیت رکھتا ہے، جس کی حاکمیت ہر نقص سے پاک ہے۔', descriptionHindi: 'जिनका संपूर्ण प्रभुत्व है, जिनका राज्य हर दोष से मुक्त है।'),
    AllahNameModel(number: 5, name: 'الْقُدُّوسُ', transliteration: 'Al-Quddus', meaning: 'The Most Holy', meaningUrdu: 'پاک ذات', meaningHindi: 'पवित्र', description: 'The one who is pure from any imperfection and clear from children and adversaries.', descriptionUrdu: 'جو ہر نقص سے پاک ہے اور اولاد اور دشمنوں سے بری ہے۔', descriptionHindi: 'जो हर दोष से पवित्र हैं और संतान और शत्रुओं से मुक्त हैं।'),
    AllahNameModel(number: 6, name: 'السَّلاَمُ', transliteration: 'As-Salam', meaning: 'The Source of Peace', meaningUrdu: 'سلامتی دینے والا', meaningHindi: 'शांति का स्रोत', description: 'The one who is free from every imperfection.', descriptionUrdu: 'جو ہر نقص سے پاک ہے۔', descriptionHindi: 'जो हर दोष से मुक्त हैं।'),
    AllahNameModel(number: 7, name: 'الْمُؤْمِنُ', transliteration: 'Al-Mumin', meaning: 'The Guardian of Faith', meaningUrdu: 'امن دینے والا', meaningHindi: 'विश्वास का रक्षक', description: 'The one who witnessed for himself that no one is God but Him.', descriptionUrdu: 'جس نے خود گواہی دی کہ اس کے سوا کوئی معبود نہیں۔', descriptionHindi: 'जिसने स्वयं गवाही दी कि उनके सिवा कोई पूज्य नहीं।'),
    AllahNameModel(number: 8, name: 'الْمُهَيْمِنُ', transliteration: 'Al-Muhaymin', meaning: 'The Protector', meaningUrdu: 'نگہبان', meaningHindi: 'रक्षक', description: 'The one who witnesses the saying and deeds of His creatures.', descriptionUrdu: 'جو اپنی مخلوق کے قول و فعل کا گواہ ہے۔', descriptionHindi: 'जो अपनी सृष्टि के कथनों और कर्मों के साक्षी हैं।'),
    AllahNameModel(number: 9, name: 'الْعَزِيزُ', transliteration: 'Al-Aziz', meaning: 'The Almighty', meaningUrdu: 'غالب', meaningHindi: 'सर्वशक्तिमान', description: 'The defeater who is never defeated.', descriptionUrdu: 'جو ہمیشہ غالب رہتا ہے اور کبھی مغلوب نہیں ہوتا۔', descriptionHindi: 'जो हमेशा विजयी रहते हैं और कभी पराजित नहीं होते।'),
    AllahNameModel(number: 10, name: 'الْجَبَّارُ', transliteration: 'Al-Jabbar', meaning: 'The Compeller', meaningUrdu: 'زبردست', meaningHindi: 'प्रबल', description: 'The one that nothing happens in His dominion except that which He willed.', descriptionUrdu: 'جس کی سلطنت میں کچھ نہیں ہوتا سوائے اس کے جو وہ چاہے۔', descriptionHindi: 'जिनके राज्य में कुछ नहीं होता सिवाय उसके जो वे चाहें।'),
    AllahNameModel(number: 11, name: 'الْمُتَكَبِّرُ', transliteration: 'Al-Mutakabbir', meaning: 'The Greatest', meaningUrdu: 'بڑائی والا', meaningHindi: 'महान', description: 'The one who is clear from the attributes of the creatures.', descriptionUrdu: 'جو مخلوق کی صفات سے پاک ہے۔', descriptionHindi: 'जो सृष्टि के गुणों से परे हैं।'),
    AllahNameModel(number: 12, name: 'الْخَالِقُ', transliteration: 'Al-Khaliq', meaning: 'The Creator', meaningUrdu: 'پیدا کرنے والا', meaningHindi: 'सृष्टिकर्ता', description: 'The one who brings everything from non-existence to existence.', descriptionUrdu: 'جو ہر چیز کو عدم سے وجود میں لاتا ہے۔', descriptionHindi: 'जो हर चीज़ को अस्तित्व में लाते हैं।'),
    AllahNameModel(number: 13, name: 'الْبَارِئُ', transliteration: 'Al-Bari', meaning: 'The Maker', meaningUrdu: 'بنانے والا', meaningHindi: 'निर्माता', description: 'The creator who has the power to turn the entities.', descriptionUrdu: 'خالق جو مخلوقات کو بدلنے کی طاقت رکھتا ہے۔', descriptionHindi: 'सृष्टिकर्ता जो प्राणियों को बदलने की शक्ति रखते हैं।'),
    AllahNameModel(number: 14, name: 'الْمُصَوِّرُ', transliteration: 'Al-Musawwir', meaning: 'The Fashioner', meaningUrdu: 'صورت بنانے والا', meaningHindi: 'आकार देने वाला', description: 'The one who forms His creatures in different pictures.', descriptionUrdu: 'جو اپنی مخلوق کو مختلف صورتوں میں بناتا ہے۔', descriptionHindi: 'जो अपनी सृष्टि को विभिन्न रूपों में बनाते हैं।'),
    AllahNameModel(number: 15, name: 'الْغَفَّارُ', transliteration: 'Al-Ghaffar', meaning: 'The Forgiver', meaningUrdu: 'بخشنے والا', meaningHindi: 'क्षमा करने वाला', description: 'The one who forgives sins of His slaves time and time again.', descriptionUrdu: 'جو اپنے بندوں کے گناہ بار بار معاف کرتا ہے۔', descriptionHindi: 'जो अपने बंदों के गुनाहों को बार-बार माफ करते हैं।'),
    AllahNameModel(number: 16, name: 'الْقَهَّارُ', transliteration: 'Al-Qahhar', meaning: 'The Subduer', meaningUrdu: 'سب پر غالب', meaningHindi: 'दमन करने वाला', description: 'The one who has the perfect power and is not incapable of anything.', descriptionUrdu: 'جو مکمل طاقت رکھتا ہے اور کسی چیز سے عاجز نہیں۔', descriptionHindi: 'जिनके पास पूर्ण शक्ति है और जो किसी चीज़ से असमर्थ नहीं।'),
    AllahNameModel(number: 17, name: 'الْوَهَّابُ', transliteration: 'Al-Wahhab', meaning: 'The Giver of All', meaningUrdu: 'بہت عطا کرنے والا', meaningHindi: 'सब कुछ देने वाला', description: 'The one who is generous in giving plenty without any return.', descriptionUrdu: 'جو بغیر کسی بدلے کے بہت کچھ دیتا ہے۔', descriptionHindi: 'जो बिना किसी बदले के बहुत कुछ देते हैं।'),
    AllahNameModel(number: 18, name: 'الرَّزَّاقُ', transliteration: 'Ar-Razzaq', meaning: 'The Sustainer', meaningUrdu: 'رزق دینے والا', meaningHindi: 'जीविका देने वाला', description: 'The one who gives everything that benefits whether sustenance or knowledge.', descriptionUrdu: 'جو ہر فائدہ مند چیز دیتا ہے خواہ رزق ہو یا علم۔', descriptionHindi: 'जो हर लाभदायक चीज़ देते हैं चाहे जीविका हो या ज्ञान।'),
    AllahNameModel(number: 19, name: 'الْفَتَّاحُ', transliteration: 'Al-Fattah', meaning: 'The Opener', meaningUrdu: 'کھولنے والا', meaningHindi: 'खोलने वाला', description: 'The one who opens for His slaves the closed worldly and religious matters.', descriptionUrdu: 'جو اپنے بندوں کے لیے دنیاوی اور دینی بند معاملات کھولتا ہے۔', descriptionHindi: 'जो अपने बंदों के लिए बंद दुनियावी और धार्मिक मामले खोलते हैं।'),
    AllahNameModel(number: 20, name: 'اَلْعَلِيْمُ', transliteration: 'Al-Alim', meaning: 'The All-Knowing', meaningUrdu: 'سب کچھ جاننے والا', meaningHindi: 'सर्वज्ञ', description: 'The one nothing is absent from His knowledge.', descriptionUrdu: 'جس کے علم سے کوئی چیز پوشیدہ نہیں۔', descriptionHindi: 'जिनके ज्ञान से कुछ भी छुपा नहीं।'),
    AllahNameModel(number: 21, name: 'الْقَابِضُ', transliteration: 'Al-Qabid', meaning: 'The Constrictor', meaningUrdu: 'تنگ کرنے والا', meaningHindi: 'रोकने वाला', description: 'The one who constricts the sustenance by His wisdom.', descriptionUrdu: 'جو اپنی حکمت سے رزق تنگ کرتا ہے۔', descriptionHindi: 'जो अपनी बुद्धि से जीविका रोकते हैं।'),
    AllahNameModel(number: 22, name: 'الْبَاسِطُ', transliteration: 'Al-Basit', meaning: 'The Reliever', meaningUrdu: 'کشادگی دینے والا', meaningHindi: 'विस्तार देने वाला', description: 'The one who constricts and opens sustenance to whomever He wills.', descriptionUrdu: 'جو جسے چاہے رزق تنگ یا کشادہ کرتا ہے۔', descriptionHindi: 'जो जिसे चाहें जीविका रोकते या देते हैं।'),
    AllahNameModel(number: 23, name: 'الْخَافِضُ', transliteration: 'Al-Khafid', meaning: 'The Abaser', meaningUrdu: 'پست کرنے والا', meaningHindi: 'नीचा करने वाला', description: 'The one who lowers whoever He willed by His destruction.', descriptionUrdu: 'جو جسے چاہے اپنی تباہی سے نیچا کرتا ہے۔', descriptionHindi: 'जो जिसे चाहें अपने विनाश से नीचा करते हैं।'),
    AllahNameModel(number: 24, name: 'الرَّافِعُ', transliteration: 'Ar-Rafi', meaning: 'The Exalter', meaningUrdu: 'بلند کرنے والا', meaningHindi: 'ऊंचा करने वाला', description: 'The one who raises whoever He willed by His endowment.', descriptionUrdu: 'جو جسے چاہے اپنی عطا سے بلند کرتا ہے۔', descriptionHindi: 'जो जिसे चाहें अपनी कृपा से ऊंचा करते हैं।'),
    AllahNameModel(number: 25, name: 'الْمُعِزُّ', transliteration: 'Al-Muizz', meaning: 'The Bestower of Honors', meaningUrdu: 'عزت دینے والا', meaningHindi: 'सम्मान देने वाला', description: 'He gives esteem to whoever He willed.', descriptionUrdu: 'جسے چاہے عزت دیتا ہے۔', descriptionHindi: 'जिसे चाहें सम्मान देते हैं।'),
    AllahNameModel(number: 26, name: 'المُذِلُّ', transliteration: 'Al-Mudhill', meaning: 'The Humiliator', meaningUrdu: 'ذلیل کرنے والا', meaningHindi: 'अपमानित करने वाला', description: 'He degrades whoever He willed.', descriptionUrdu: 'جسے چاہے ذلیل کرتا ہے۔', descriptionHindi: 'जिसे चाहें अपमानित करते हैं।'),
    AllahNameModel(number: 27, name: 'السَّمِيعُ', transliteration: 'As-Sami', meaning: 'The All-Hearing', meaningUrdu: 'سب کچھ سننے والا', meaningHindi: 'सब कुछ सुनने वाला', description: 'The one who hears all things that are heard.', descriptionUrdu: 'جو ہر سنی جانے والی چیز سنتا ہے۔', descriptionHindi: 'जो हर सुनी जाने वाली चीज़ सुनते हैं।'),
    AllahNameModel(number: 28, name: 'الْبَصِيرُ', transliteration: 'Al-Basir', meaning: 'The All-Seeing', meaningUrdu: 'سب ک��ھ دیکھنے والا', meaningHindi: 'सब कुछ देखने वाला', description: 'The one who sees all things that are seen.', descriptionUrdu: 'جو ہر دکھائی دینے والی چیز دیکھتا ہے۔', descriptionHindi: 'जो हर दिखाई देने वाली चीज़ देखते हैं।'),
    AllahNameModel(number: 29, name: 'الْحَكَمُ', transliteration: 'Al-Hakam', meaning: 'The Judge', meaningUrdu: 'فیصلہ کرنے والا', meaningHindi: 'न्यायाधीश', description: 'He is the ruler and His judgment is His word.', descriptionUrdu: 'وہ حاکم ہے اور اس کا فیصلہ اس کا کلام ہے۔', descriptionHindi: 'वह शासक हैं और उनका फैसला उनका वचन है।'),
    AllahNameModel(number: 30, name: 'الْعَدْلُ', transliteration: 'Al-Adl', meaning: 'The Just', meaningUrdu: 'انصاف کرنے والا', meaningHindi: 'न्यायी', description: 'The one who is entitled to do what He does.', descriptionUrdu: 'جو کچھ کرتا ہے اس کا حق ہے۔', descriptionHindi: 'जो कुछ करते हैं उसका अधिकार है।'),
    AllahNameModel(number: 31, name: 'اللَّطِيفُ', transliteration: 'Al-Latif', meaning: 'The Subtle One', meaningUrdu: 'باریک بین', meaningHindi: 'सूक्ष्मदर्शी', description: 'The one who is kind to His slaves and endows upon them.', descriptionUrdu: 'جو اپنے بندوں پر مہربان ہے اور انہیں نوازتا ہے۔', descriptionHindi: 'जो अपने बंदों पर दयालु हैं और उन्हें नवाज़ते हैं।'),
    AllahNameModel(number: 32, name: 'الْخَبِيرُ', transliteration: 'Al-Khabir', meaning: 'The All-Aware', meaningUrdu: 'باخبر', meaningHindi: 'सब कुछ जानने वाला', description: 'The one who knows the truth of things.', descriptionUrdu: 'جو چیزوں کی حقیقت جانتا ہے۔', descriptionHindi: 'जो चीज़ों की हकीकत जानते हैं।'),
    AllahNameModel(number: 33, name: 'الْحَلِيمُ', transliteration: 'Al-Halim', meaning: 'The Forbearing', meaningUrdu: 'بردبار', meaningHindi: 'सहनशील', description: 'The one who delays the punishment for those who deserve it.', descriptionUrdu: 'جو مستحقین کی سزا میں تاخیر کرتا ہے۔', descriptionHindi: 'जो हकदारों की सज़ा में देरी करते हैं।'),
    AllahNameModel(number: 34, name: 'الْعَظِيمُ', transliteration: 'Al-Azim', meaning: 'The Magnificent', meaningUrdu: 'عظیم', meaningHindi: 'महान', description: 'The one deserving the attributes of exaltment, glory, extolment.', descriptionUrdu: 'جو بلندی، شان اور تعریف کی صفات کا مستحق ہے۔', descriptionHindi: 'जो उच्चता, महिमा और प्रशंसा के गुणों के योग्य हैं।'),
    AllahNameModel(number: 35, name: 'الْغَفُورُ', transliteration: 'Al-Ghafur', meaning: 'The Forgiving', meaningUrdu: 'بخشنے والا', meaningHindi: 'क्षमा करने वाला', description: 'The one who forgives a lot.', descriptionUrdu: 'جو بہت زیادہ معاف کرتا ہے۔', descriptionHindi: 'जो बहुत ज़्यादा माफ करते हैं।'),
    AllahNameModel(number: 36, name: 'الشَّكُورُ', transliteration: 'Ash-Shakur', meaning: 'The Grateful', meaningUrdu: 'قدردان', meaningHindi: 'कृतज्ञ', description: 'The one who gives a lot of reward for a little obedience.', descriptionUrdu: 'جو تھوڑی فرمانبرداری پر بہت زیادہ اجر دیتا ہے۔', descriptionHindi: 'जो थोड़ी आज्ञाकारिता पर बहुत इनाम देते हैं।'),
    AllahNameModel(number: 37, name: 'الْعَلِيُّ', transliteration: 'Al-Ali', meaning: 'The Most High', meaningUrdu: 'بلند', meaningHindi: 'सर्वोच्च', description: 'The one who is clear from the attributes of the creation.', descriptionUrdu: 'جو مخلوق کی صفات سے پاک ہے۔', descriptionHindi: 'जो सृष्टि के गुणों से परे हैं।'),
    AllahNameModel(number: 38, name: 'الْكَبِيرُ', transliteration: 'Al-Kabir', meaning: 'The Most Great', meaningUrdu: 'بڑا', meaningHindi: 'सबसे बड़ा', description: 'The one who is greater than everything in status.', descriptionUrdu: 'جو مرتبے میں سب سے بڑا ہے۔', descriptionHindi: 'जो हर चीज़ से बड़े हैं।'),
    AllahNameModel(number: 39, name: 'الْحَفِيظُ', transliteration: 'Al-Hafiz', meaning: 'The Preserver', meaningUrdu: 'حفاظت کرنے والا', meaningHindi: 'रक्षक', description: 'The one who protects whatever and whoever He willed.', descriptionUrdu: 'جو جسے اور جو چاہے اس کی حفاظت کرتا ہے۔', descriptionHindi: 'जो जिसे चाहें उसकी रक्षा करते हैं।'),
    AllahNameModel(number: 40, name: 'المُقيِت', transliteration: 'Al-Muqit', meaning: 'The Nourisher', meaningUrdu: 'قوت دینے والا', meaningHindi: 'पोषण करने वाला', description: 'The one who has the power.', descriptionUrdu: 'جو طاقت رکھتا ہے۔', descriptionHindi: 'जो शक्ति रखते हैं।'),
    AllahNameModel(number: 41, name: 'الْحسِيبُ', transliteration: 'Al-Hasib', meaning: 'The Reckoner', meaningUrdu: 'حساب لینے والا', meaningHindi: 'हिसाब लेने वाला', description: 'The one who gives satisfaction.', descriptionUrdu: 'جو تسلی دیتا ہے۔', descriptionHindi: 'जो संतोष देते हैं।'),
    AllahNameModel(number: 42, name: 'الْجَلِيلُ', transliteration: 'Al-Jalil', meaning: 'The Majestic', meaningUrdu: 'جلیل', meaningHindi: 'भव्य', description: 'The one who is attributed with greatness of power.', descriptionUrdu: 'جو طاقت کی عظمت سے متصف ہے۔', descriptionHindi: 'जो शक्ति की महानता से विशेषित हैं।'),
    AllahNameModel(number: 43, name: 'الْكَرِيمُ', transliteration: 'Al-Karim', meaning: 'The Generous', meaningUrdu: 'کریم', meaningHindi: 'उदार', description: 'The one who is clear from abjectness.', descriptionUrdu: 'جو ذلت سے پاک ہے۔', descriptionHindi: 'जो अधमता से मुक्त हैं।'),
    AllahNameModel(number: 44, name: 'الرَّقِيبُ', transliteration: 'Ar-Raqib', meaning: 'The Watchful', meaningUrdu: 'نگران', meaningHindi: 'निगरानी करने वाला', description: 'The one that nothing is absent from Him.', descriptionUrdu: 'جس سے کوئی چیز پوشیدہ نہیں۔', descriptionHindi: 'जिनसे कुछ भी छुपा नहीं।'),
    AllahNameModel(number: 45, name: 'الْمُجِيبُ', transliteration: 'Al-Mujib', meaning: 'The Responsive', meaningUrdu: 'دعا قبول کرنے والا', meaningHindi: 'दुआ कबूल करने वाला', description: 'The one who answers the one in need if he asks Him.', descriptionUrdu: 'جو ضرورت مند کی دعا قبول کرتا ہے اگر وہ مانگے۔', descriptionHindi: 'जो ज़रूरतमंद की दुआ कबूल करते हैं अगर वह मांगे।'),
    AllahNameModel(number: 46, name: 'الْوَاسِعُ', transliteration: 'Al-Wasi', meaning: 'The All-Encompassing', meaningUrdu: 'وسعت والا', meaningHindi: 'सर्वव्यापी', description: 'The knowledgeable.', descriptionUrdu: 'جو علم والا ہے۔', descriptionHindi: 'जो ज्ञानी हैं।'),
    AllahNameModel(number: 47, name: 'الْحَكِيمُ', transliteration: 'Al-Hakim', meaning: 'The All-Wise', meaningUrdu: 'حکمت والا', meaningHindi: 'बुद्धिमान', description: 'The one who is correct in His doings.', descriptionUrdu: 'جو اپنے کاموں میں درست ہے۔', descriptionHindi: 'जो अपने कामों में सही हैं।'),
    AllahNameModel(number: 48, name: 'الْوَدُودُ', transliteration: 'Al-Wadud', meaning: 'The Most Loving', meaningUrdu: 'محبت کرنے والا', meaningHindi: 'प्रेम करने वाला', description: 'The one who loves His believing slaves and His believing slaves love Him.', descriptionUrdu: 'جو اپنے مومن بندوں سے محبت کرتا ہے اور مومن بندے اس سے محبت کرتے ہیں۔', descriptionHindi: 'जो अपने मोमिन बंदों से प्रेम करते हैं और मोमिन बंदे उनसे प्रेम करते हैं।'),
    AllahNameModel(number: 49, name: 'الْمَجِيدُ', transliteration: 'Al-Majid', meaning: 'The Most Glorious', meaningUrdu: 'بزرگی والا', meaningHindi: 'महिमावान', description: 'The one who is with perfect power, high status, compassion, generosity.', descriptionUrdu: 'جو کامل طاقت، بلند مرتبہ، رحم اور سخاوت والا ہے۔', descriptionHindi: 'जो पूर्ण शक्ति, उच्च स्थान, करुणा और उदारता वाले हैं।'),
    AllahNameModel(number: 50, name: 'الْبَاعِثُ', transliteration: 'Al-Baith', meaning: 'The Resurrector', meaningUrdu: 'اٹھانے والا', meaningHindi: 'पुनर्जीवित करने वाला', description: 'The one who resurrects His slaves after death.', descriptionUrdu: 'جو اپنے بندوں کو موت کے بعد اٹھاتا ہے۔', descriptionHindi: 'जो अपने बंदों को मृत्यु के बाद उठाते हैं।'),
    AllahNameModel(number: 51, name: 'الشَّهِيدُ', transliteration: 'Ash-Shahid', meaning: 'The Witness', meaningUrdu: 'گواہ', meaningHindi: 'गवाह', description: 'The one who nothing is absent from Him.', descriptionUrdu: 'جس سے کوئی چیز پوشیدہ نہیں۔', descriptionHindi: 'जिनसे कुछ भी छुपा नहीं।'),
    AllahNameModel(number: 52, name: 'الْحَقُّ', transliteration: 'Al-Haqq', meaning: 'The Truth', meaningUrdu: 'سچا', meaningHindi: 'सत्य', description: 'The one who truly exists.', descriptionUrdu: 'جو حقیقی طور پر موجود ہے۔', descriptionHindi: 'जो वास्तव में मौजूद हैं।'),
    AllahNameModel(number: 53, name: 'الْوَكِيلُ', transliteration: 'Al-Wakil', meaning: 'The Trustee', meaningUrdu: 'کارساز', meaningHindi: 'कार्यवाहक', description: 'The one who gives the satisfaction and is relied upon.', descriptionUrdu: 'جو تسلی دیتا ہے اور جس پر بھروسہ کیا جاتا ہے۔', descriptionHindi: 'जो संतोष देते हैं और जिन पर भरोसा किया जाता है।'),
    AllahNameModel(number: 54, name: 'الْقَوِيُّ', transliteration: 'Al-Qawiyy', meaning: 'The Most Strong', meaningUrdu: 'طاقتور', meaningHindi: 'शक्तिशाली', description: 'The one with the complete power.', descriptionUrdu: 'جو مکمل طاقت رکھتا ہے۔', descriptionHindi: 'जो पूर्ण शक्ति रखते हैं।'),
    AllahNameModel(number: 55, name: 'الْمَتِينُ', transliteration: 'Al-Matin', meaning: 'The Firm', meaningUrdu: 'مضبوط', meaningHindi: 'दृढ़', description: 'The one with extreme power which is un-interrupted.', descriptionUrdu: 'جو انتہائی طاقت رکھتا ہے جو کبھی ختم نہیں ہوتی۔', descriptionHindi: 'जो अत्यधिक शक्ति रखते हैं जो कभी समाप्त नहीं होती।'),
    AllahNameModel(number: 56, name: 'الْوَلِيُّ', transliteration: 'Al-Waliyy', meaning: 'The Protecting Friend', meaningUrdu: 'دوست', meaningHindi: 'मित्र', description: 'The supporter.', descriptionUrdu: 'جو مددگار ہے۔', descriptionHindi: 'जो सहायक हैं।'),
    AllahNameModel(number: 57, name: 'الْحَمِيدُ', transliteration: 'Al-Hamid', meaning: 'The Praiseworthy', meaningUrdu: 'قابل تعریف', meaningHindi: 'प्रशंसनीय', description: 'The praised one who deserves to be praised.', descriptionUrdu: 'جو تعریف کا مستحق ہے۔', descriptionHindi: 'जो प्रशंसा के योग्य हैं।'),
    AllahNameModel(number: 58, name: 'الْمُحْصِي', transliteration: 'Al-Muhsi', meaning: 'The Accounter', meaningUrdu: 'شمار کرنے والا', meaningHindi: 'गिनने वाला', description: 'The one who the count of things are known to Him.', descriptionUrdu: 'جسے ہر چیز کا شمار معلوم ہے۔', descriptionHindi: 'जिन्हें हर चीज़ की गिनती मालूम है।'),
    AllahNameModel(number: 59, name: 'الْمُبْدِئُ', transliteration: 'Al-Mubdi', meaning: 'The Originator', meaningUrdu: 'پہلی بار پیدا کرنے والا', meaningHindi: 'उत्पत्तिकर्ता', description: 'The one who started the human being.', descriptionUrdu: 'جس نے انسان کو پہلی بار پیدا کیا۔', descriptionHindi: 'जिसने इंसान को पहली बार पैदा किया।'),
    AllahNameModel(number: 60, name: 'الْمُعِيدُ', transliteration: 'Al-Muid', meaning: 'The Restorer', meaningUrdu: 'دوبارہ پیدا کرنے والا', meaningHindi: 'पुनर्स्थापक', description: 'The one who brings back the creatures after death.', descriptionUrdu: 'جو مخلوق کو موت کے بعد واپس لاتا ہے۔', descriptionHindi: 'जो सृष्टि को मृत्यु के बाद वापस लाते हैं।'),
    AllahNameModel(number: 61, name: 'الْمُحْيِي', transliteration: 'Al-Muhyi', meaning: 'The Giver of Life', meaningUrdu: 'زندگی دینے والا', meaningHindi: 'जीवन देने वाला', description: 'The one who took out a living human from semen that does not have a soul.', descriptionUrdu: 'جس نے بے جان نطفے سے زندہ انسان نکالا۔', descriptionHindi: 'जिसने बेजान बीज से जीवित इंसान निकाला।'),
    AllahNameModel(number: 62, name: 'اَلْمُمِيتُ', transliteration: 'Al-Mumit', meaning: 'The Taker of Life', meaningUrdu: 'موت دینے والا', meaningHindi: 'मृत्यु देने वाला', description: 'The one who renders the living dead.', descriptionUrdu: 'جو زندوں کو مردہ کرتا ہے۔', descriptionHindi: 'जो जीवितों को मृत करते हैं।'),
    AllahNameModel(number: 63, name: 'الْحَيُّ', transliteration: 'Al-Hayy', meaning: 'The Ever Living', meaningUrdu: 'ہمیشہ زندہ', meaningHindi: 'सदा जीवित', description: 'The one attributed with a life that is unlike our life.', descriptionUrdu: 'جو ایسی زندگی سے متصف ہے جو ہماری زندگی جیسی نہیں۔', descriptionHindi: 'जो ऐसी जिंदगी से विशेषित हैं जो हमारी जिंदगी जैसी नहीं।'),
    AllahNameModel(number: 64, name: 'الْقَيُّومُ', transliteration: 'Al-Qayyum', meaning: 'The Self-Existing', meaningUrdu: 'قائم رہنے وال��', meaningHindi: 'स्वयंभू', description: 'The one who remains and does not end.', descriptionUrdu: 'جو باقی رہتا ہے اور ختم نہیں ہوتا۔', descriptionHindi: 'जो बाकी रहते हैं और खत्म नहीं होते।'),
    AllahNameModel(number: 65, name: 'الْوَاجِدُ', transliteration: 'Al-Wajid', meaning: 'The Finder', meaningUrdu: 'پانے والا', meaningHindi: 'पाने वाला', description: 'The rich who is never poor.', descriptionUrdu: 'جو غنی ہے اور کبھی فقیر نہیں۔', descriptionHindi: 'जो धनी हैं और कभी गरीब नहीं।'),
    AllahNameModel(number: 66, name: 'الْمَاجِدُ', transliteration: 'Al-Majid', meaning: 'The Glorious', meaningUrdu: 'بزرگ', meaningHindi: 'गौरवशाली', description: 'The one who is majid.', descriptionUrdu: 'جو مجید ہے۔', descriptionHindi: 'जो गौरवशाली हैं।'),
    AllahNameModel(number: 67, name: 'الْواحِدُ', transliteration: 'Al-Wahid', meaning: 'The One', meaningUrdu: 'ایک', meaningHindi: 'एक', description: 'The one without a partner.', descriptionUrdu: 'جس کا کوئی شریک نہیں۔', descriptionHindi: 'जिनका कोई साझीदार नहीं।'),
    AllahNameModel(number: 68, name: 'اَلاَحَدُ', transliteration: 'Al-Ahad', meaning: 'The Unique', meaningUrdu: 'یکتا', meaningHindi: 'अद्वितीय', description: 'The one without equal.', descriptionUrdu: 'جس کا کوئی مثل نہیں۔', descriptionHindi: 'जिनका कोई बराबर नहीं।'),
    AllahNameModel(number: 69, name: 'الصَّمَدُ', transliteration: 'As-Samad', meaning: 'The Eternal', meaningUrdu: 'بے نیاز', meaningHindi: 'अनन्त', description: 'The master who is relied upon in matters.', descriptionUrdu: 'جس پر معاملات میں بھروسہ کیا جاتا ہے۔', descriptionHindi: 'जिन पर मामलों में भरोसा किया जाता है।'),
    AllahNameModel(number: 70, name: 'الْقَادِرُ', transliteration: 'Al-Qadir', meaning: 'The Able', meaningUrdu: 'قادر', meaningHindi: 'समर्थ', description: 'The one attributed with power.', descriptionUrdu: 'جو طاقت سے متصف ہے۔', descriptionHindi: 'जो शक्ति से विशेषित हैं।'),
    AllahNameModel(number: 71, name: 'الْمُقْتَدِرُ', transliteration: 'Al-Muqtadir', meaning: 'The Powerful', meaningUrdu: 'اختیار والا', meaningHindi: 'शक्तिशाली', description: 'The one with the perfect power that nothing is withheld from Him.', descriptionUrdu: 'جو مکمل طاقت رکھتا ہے جس سے کوئی چیز روکی نہیں جاتی۔', descriptionHindi: 'जो पूर्ण शक्ति रखते हैं जिनसे कुछ भी रोका नहीं जा सकता।'),
    AllahNameModel(number: 72, name: 'الْمُقَدِّمُ', transliteration: 'Al-Muqaddim', meaning: 'The Expediter', meaningUrdu: 'آگے کرنے والا', meaningHindi: 'आगे करने वाला', description: 'The one who puts things in their right places.', descriptionUrdu: 'جو چیزوں کو ان کی صحیح جگہ رکھتا ہے۔', descriptionHindi: 'जो चीज़ों को उनकी सही जगह रखते हैं।'),
    AllahNameModel(number: 73, name: 'الْمُؤَخِّرُ', transliteration: 'Al-Muakhkhir', meaning: 'The Delayer', meaningUrdu: 'پیچھے کرنے والا', meaningHindi: 'पीछे करने वाला', description: 'The one who delays what He wills.', descriptionUrdu: 'جو جسے چاہے موخر کرتا ہے۔', descriptionHindi: 'जो जिसे चाहें देरी करते हैं।'),
    AllahNameModel(number: 74, name: 'الأوَّلُ', transliteration: 'Al-Awwal', meaning: 'The First', meaningUrdu: 'پہلا', meaningHindi: 'पहला', description: 'The one whose existence is without a beginning.', descriptionUrdu: 'جس کے وجود کی کوئی ابتدا نہیں۔', descriptionHindi: 'जिनके अस्तित्व की कोई शुरुआत नहीं।'),
    AllahNameModel(number: 75, name: 'الآخِرُ', transliteration: 'Al-Akhir', meaning: 'The Last', meaningUrdu: 'آخری', meaningHindi: 'आखिरी', description: 'The one whose existence is without an end.', descriptionUrdu: 'جس کے وجود کا کوئی انت نہیں۔', descriptionHindi: 'जिनके अस्तित्व का कोई अंत नहीं।'),
    AllahNameModel(number: 76, name: 'الظَّاهِرُ', transliteration: 'Az-Zahir', meaning: 'The Manifest', meaningUrdu: 'ظاہر', meaningHindi: 'प्रकट', description: 'The one that nothing is above Him and nothing is beneath Him.', descriptionUrdu: 'جس سے اوپر کچھ نہیں اور جس سے نیچے کچھ نہیں۔', descriptionHindi: 'जिनसे ऊपर कुछ नहीं और जिनसे नीचे कुछ नहीं।'),
    AllahNameModel(number: 77, name: 'الْبَاطِنُ', transliteration: 'Al-Batin', meaning: 'The Hidden', meaningUrdu: 'پوشیدہ', meaningHindi: 'छुपा हुआ', description: 'The one that nothing is beneath Him.', descriptionUrdu: 'جس سے نیچے کچھ نہیں۔', descriptionHindi: 'जिनसे नीचे कुछ नहीं।'),
    AllahNameModel(number: 78, name: 'الْوَالِي', transliteration: 'Al-Wali', meaning: 'The Protecting Friend', meaningUrdu: 'مالک', meaningHindi: 'स्वामी', description: 'The one who owns things and manages them.', descriptionUrdu: 'جو چیزوں کا مالک ہے اور انہیں سنبھالتا ہے۔', descriptionHindi: 'जो चीज़ों के मालिक हैं और उन्हें संभालते हैं।'),
    AllahNameModel(number: 79, name: 'الْمُتَعَالِي', transliteration: 'Al-Mutaali', meaning: 'The Most Exalted', meaningUrdu: 'بلند تر', meaningHindi: 'सर्वोच्च', description: 'The one who is clear from the attributes of the creation.', descriptionUrdu: 'جو مخلوق کی صفات سے پاک ہے۔', descriptionHindi: 'जो सृष्टि के गुणों से परे हैं।'),
    AllahNameModel(number: 80, name: 'الْبَرُّ', transliteration: 'Al-Barr', meaning: 'The Source of Goodness', meaningUrdu: 'نیکی کرنے والا', meaningHindi: 'भलाई का स्रोत', description: 'The one who is kind to His creatures.', descriptionUrdu: 'جو اپنی مخلوق پر مہربان ہے۔', descriptionHindi: 'जो अपनी सृष्टि पर दयालु हैं।'),
    AllahNameModel(number: 81, name: 'التَّوَّابُ', transliteration: 'At-Tawwab', meaning: 'The Acceptor of Repentance', meaningUrdu: 'توبہ قبول کرنے والا', meaningHindi: 'तौबा कबूल करने वाला', description: 'The one who grants repentance.', descriptionUrdu: 'جو توبہ قبول کرتا ہے۔', descriptionHindi: 'जो तौबा कबूल करते हैं।'),
    AllahNameModel(number: 82, name: 'الْمُنْتَقِمُ', transliteration: 'Al-Muntaqim', meaning: 'The Avenger', meaningUrdu: 'بدلہ لینے والا', meaningHindi: 'बदला लेने वाला', description: 'The one who victoriously prevails over His enemies.', descriptionUrdu: 'جو اپنے دشمنوں پر فتح مند ہوتا ہے۔', descriptionHindi: 'जो अपने दुश्मनों पर विजयी होते हैं।'),
    AllahNameModel(number: 83, name: 'العَفُوُّ', transliteration: 'Al-Afuww', meaning: 'The Pardoner', meaningUrdu: 'معاف کرنے والا', meaningHindi: 'माफ करने वाला', description: 'The one with wide forgiveness.', descriptionUrdu: 'جو وسیع مغفرت والا ہے۔', descriptionHindi: 'जो विस्तृत क्षमा वाले हैं।'),
    AllahNameModel(number: 84, name: 'الرَّؤُوفُ', transliteration: 'Ar-Rauf', meaning: 'The Compassionate', meaningUrdu: 'شفقت والا', meaningHindi: 'करुणामय', description: 'The one with extreme mercy.', descriptionUrdu: 'جو انتہائی رحم والا ہے۔', descriptionHindi: 'जो अत्यधिक दया वाले हैं।'),
    AllahNameModel(number: 85, name: 'مَالِكُ الْمُلْكِ', transliteration: 'Malik-ul-Mulk', meaning: 'Owner of Sovereignty', meaningUrdu: 'بادشاہت کا مالک', meaningHindi: 'संप्रभुता के मालिक', description: 'The one who controls the dominion.', descriptionUrdu: 'جو سلطنت کو قابو میں رکھتا ہے۔', descriptionHindi: 'जो राज्य को नियंत्रित करते हैं।'),
    AllahNameModel(number: 86, name: 'ذُوالْجَلاَلِ وَالإكْرَامِ', transliteration: 'Dhul-Jalal-wal-Ikram', meaning: 'Lord of Majesty and Bounty', meaningUrdu: 'عظمت اور کرم والا', meaningHindi: 'महिमा और उदारता के स्वामी', description: 'The one who deserves to be exalted.', descriptionUrdu: 'جو بلندی کا مستحق ہے۔', descriptionHindi: 'जो उच्चता के योग्य हैं।'),
    AllahNameModel(number: 87, name: 'الْمُقْسِطُ', transliteration: 'Al-Muqsit', meaning: 'The Equitable', meaningUrdu: 'انصاف کرنے والا', meaningHindi: 'न्यायी', description: 'The one who is just in His judgment.', descriptionUrdu: 'جو اپنے فیصلے میں عادل ہے۔', descriptionHindi: 'जो अपने फैसले में न्यायी हैं।'),
    AllahNameModel(number: 88, name: 'الْجَامِعُ', transliteration: 'Al-Jami', meaning: 'The Gatherer', meaningUrdu: 'جمع کرنے والا', meaningHindi: 'इकट्ठा करने वाला', description: 'The one who gathers the creatures on a day.', descriptionUrdu: 'جو مخلوق کو ایک دن جمع کرتا ہے۔', descriptionHindi: 'जो सृष्टि को एक दिन इकट्ठा करते हैं।'),
    AllahNameModel(number: 89, name: 'الْغَنِيُّ', transliteration: 'Al-Ghani', meaning: 'The Self-Sufficient', meaningUrdu: 'بے نیاز', meaningHindi: 'निस्पृह', description: 'The one who does not need the creation.', descriptionUrdu: 'جسے مخلوق کی ضرورت نہیں۔', descriptionHindi: 'जिन्हें सृष्टि की ज़रूरत नहीं।'),
    AllahNameModel(number: 90, name: 'الْمُغْنِي', transliteration: 'Al-Mughni', meaning: 'The Enricher', meaningUrdu: 'غنی کرنے والا', meaningHindi: 'समृद्ध करने वाला', description: 'The one who satisfies the necessities of the creatures.', descriptionUrdu: 'جو مخلوق کی ضروریات پوری کرتا ہے۔', descriptionHindi: 'जो सृष्टि की ज़रूरतें पूरी करते हैं।'),
    AllahNameModel(number: 91, name: 'اَلْمَانِعُ', transliteration: 'Al-Mani', meaning: 'The Preventer of Harm', meaningUrdu: 'روکنے والا', meaningHindi: 'रोकने वाला', description: 'The supporter who protects.', descriptionUrdu: 'مددگار جو حفاظت کرتا ہے۔', descriptionHindi: 'सहायक जो रक्षा करते हैं।'),
    AllahNameModel(number: 92, name: 'الضَّارَّ', transliteration: 'Ad-Darr', meaning: 'The Creator of Harm', meaningUrdu: 'نقصان پہنچانے والا', meaningHindi: 'नुकसान पहुंचाने वाला', description: 'The one who makes harm reach to whoever He willed.', descriptionUrdu: 'جو جسے چاہے نقصان پہنچاتا ہے۔', descriptionHindi: 'जो जिसे चाहें नुकसान पहुंचाते हैं।'),
    AllahNameModel(number: 93, name: 'النَّافِعُ', transliteration: 'An-Nafi', meaning: 'The Creator of Good', meaningUrdu: 'فائدہ پہنچانے والا', meaningHindi: 'फायदा पहुंचाने वाला', description: 'The one who makes benefit reach to whoever He willed.', descriptionUrdu: 'جو جسے چاہے فائدہ پہنچاتا ہے۔', descriptionHindi: 'जो जिसे चाहें फायदा पहुंचाते हैं।'),
    AllahNameModel(number: 94, name: 'النُّورُ', transliteration: 'An-Nur', meaning: 'The Light', meaningUrdu: 'روشنی', meaningHindi: 'प्रकाश', description: 'The one who guides.', descriptionUrdu: 'جو رہنمائی کرتا ہے۔', descriptionHindi: 'जो मार्गदर्शन करते हैं।'),
    AllahNameModel(number: 95, name: 'الْهَادِي', transliteration: 'Al-Hadi', meaning: 'The Guide', meaningUrdu: 'ہدایت دینے والا', meaningHindi: 'मार्गदर्शक', description: 'The one whom with His guidance His believers were guided.', descriptionUrdu: 'جس کی ہدایت سے مومن ہدایت پاتے ہیں۔', descriptionHindi: 'जिनकी हिदायत से मोमिन हिदायत पाते हैं।'),
    AllahNameModel(number: 96, name: 'الْبَدِيعُ', transliteration: 'Al-Badi', meaning: 'The Originator', meaningUrdu: 'نئی چیز بنانے والا', meaningHindi: 'नई चीज़ बनाने वाला', description: 'The one who created the creation and formed it without any preceding example.', descriptionUrdu: 'جس نے بغیر کسی سابقہ مثال کے مخلوق کو بنایا۔', descriptionHindi: 'जिसने बिना किसी पूर्व उदाहरण के सृष्टि बनाई।'),
    AllahNameModel(number: 97, name: 'اَلْبَاقِي', transliteration: 'Al-Baqi', meaning: 'The Everlasting', meaningUrdu: 'باقی رہنے والا', meaningHindi: 'शाश्वत', description: 'The one that the state of non-existence is impossible for Him.', descriptionUrdu: 'جس کے لیے عدم کی حالت ناممکن ہے۔', descriptionHindi: 'जिनके लिए अस्तित्वहीनता असंभव है।'),
    AllahNameModel(number: 98, name: 'الْوَارِثُ', transliteration: 'Al-Warith', meaning: 'The Inheritor', meaningUrdu: 'وارث', meaningHindi: 'उत्तराधिकारी', description: 'The one whose existence remains.', descriptionUrdu: 'جس کا وجود باقی رہتا ہے۔', descriptionHindi: 'जिनका अस्तित्व बाकी रहता है।'),
    AllahNameModel(number: 99, name: 'الرَّشِيدُ', transliteration: 'Ar-Rashid', meaning: 'The Guide to the Right Path', meaningUrdu: 'سیدھے راستے کی رہنمائی کرنے والا', meaningHindi: 'सीधे रास्ते का मार्गदर्शक', description: 'The one who guides.', descriptionUrdu: 'جو رہنمائی کرتا ہے۔', descriptionHindi: 'जो मार्गदर्शन करते हैं।'),
  ];
}
