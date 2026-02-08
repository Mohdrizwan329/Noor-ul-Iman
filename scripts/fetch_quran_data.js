#!/usr/bin/env node
/**
 * Fetch ALL Quran data from AlQuran Cloud API and generate JSON files
 * for Firebase upload.
 *
 * This downloads:
 *   - All 114 surah metadata
 *   - Arabic text (quran-uthmani) for each surah
 *   - English translation (en.sahih)
 *   - Urdu translation (ur.jalandhry)
 *   - Hindi translation (hi.hindi)
 *   - Arabic tafsir (ar.jalalayn)
 *   - English transliteration (en.transliteration)
 *
 * Output:
 *   - assets/data/firebase/quran_surahs/surah_1.json ... surah_114.json
 *   - Updates quran_screen_content.json with full metadata
 *
 * Usage:
 *   node scripts/fetch_quran_data.js
 */

const https = require('https');
const fs = require('fs');
const path = require('path');

const BASE_URL = 'https://api.alquran.cloud/v1';

// Translations to fetch
const EDITIONS = {
  arabic: 'quran-uthmani',
  english: 'en.sahih',
  urdu: 'ur.jalandhry',
  hindi: 'hi.hindi',
  arabic_tafsir: 'ar.jalalayn',
  transliteration: 'en.transliteration',
};

// English name translations in 4 languages (meaning of surah name)
const SURAH_MEANING_TRANSLATIONS = {
  1: { en: 'The Opening', hi: 'प्रारंभ', ur: 'آغاز', ar: 'الفاتحة' },
  2: { en: 'The Cow', hi: 'गाय', ur: 'گائے', ar: 'البقرة' },
  3: { en: 'The Family of Imran', hi: 'इमरान का परिवार', ur: 'آل عمران', ar: 'آل عمران' },
  4: { en: 'The Women', hi: 'औरतें', ur: 'عورتیں', ar: 'النساء' },
  5: { en: 'The Table Spread', hi: 'खाने से सजा मेज़', ur: 'دسترخوان', ar: 'المائدة' },
  6: { en: 'The Cattle', hi: 'मवेशी', ur: 'چوپائے', ar: 'الأنعام' },
  7: { en: 'The Heights', hi: 'ऊँचाइयाँ', ur: 'اونچائیاں', ar: 'الأعراف' },
  8: { en: 'The Spoils of War', hi: 'जंग की लूट', ur: 'مالِ غنیمت', ar: 'الأنفال' },
  9: { en: 'The Repentance', hi: 'तौबा', ur: 'توبہ', ar: 'التوبة' },
  10: { en: 'Jonah', hi: 'यूनुस', ur: 'یونس', ar: 'يونس' },
  11: { en: 'Hud', hi: 'हूद', ur: 'ہود', ar: 'هود' },
  12: { en: 'Joseph', hi: 'यूसुफ़', ur: 'یوسف', ar: 'يوسف' },
  13: { en: 'The Thunder', hi: 'गरज', ur: 'بادل کی گرج', ar: 'الرعد' },
  14: { en: 'Abraham', hi: 'इब्राहीम', ur: 'ابراہیم', ar: 'إبراهيم' },
  15: { en: 'The Rocky Tract', hi: 'पथरीली ज़मीन', ur: 'پتھریلی زمین', ar: 'الحجر' },
  16: { en: 'The Bee', hi: 'मधुमक्खी', ur: 'شہد کی مکھی', ar: 'النحل' },
  17: { en: 'The Night Journey', hi: 'रात का सफ़र', ur: 'رات کا سفر', ar: 'الإسراء' },
  18: { en: 'The Cave', hi: 'गुफा', ur: 'غار', ar: 'الكهف' },
  19: { en: 'Mary', hi: 'मरयम', ur: 'مریم', ar: 'مريم' },
  20: { en: 'Ta-Ha', hi: 'ताहा', ur: 'طٰہٰ', ar: 'طه' },
  21: { en: 'The Prophets', hi: 'अंबिया', ur: 'انبیاء', ar: 'الأنبياء' },
  22: { en: 'The Pilgrimage', hi: 'हज', ur: 'حج', ar: 'الحج' },
  23: { en: 'The Believers', hi: 'मोमिन', ur: 'مومنین', ar: 'المؤمنون' },
  24: { en: 'The Light', hi: 'नूर', ur: 'نور', ar: 'النور' },
  25: { en: 'The Criterion', hi: 'कसौटी', ur: 'فرقان', ar: 'الفرقان' },
  26: { en: 'The Poets', hi: 'शायर', ur: 'شاعر', ar: 'الشعراء' },
  27: { en: 'The Ant', hi: 'चींटी', ur: 'چیونٹی', ar: 'النمل' },
  28: { en: 'The Stories', hi: 'क़िस्से', ur: 'قصے', ar: 'القصص' },
  29: { en: 'The Spider', hi: 'मकड़ी', ur: 'مکڑی', ar: 'العنكبوت' },
  30: { en: 'The Romans', hi: 'रूम', ur: 'رومی', ar: 'الروم' },
  31: { en: 'Luqman', hi: 'लुक़मान', ur: 'لقمان', ar: 'لقمان' },
  32: { en: 'The Prostration', hi: 'सज्दा', ur: 'سجدہ', ar: 'السجدة' },
  33: { en: 'The Combined Forces', hi: 'गिरोह', ur: 'گروہ', ar: 'الأحزاب' },
  34: { en: 'Sheba', hi: 'सबा', ur: 'سبا', ar: 'سبأ' },
  35: { en: 'The Originator', hi: 'पैदा करने वाला', ur: 'پیدا کرنے والا', ar: 'فاطر' },
  36: { en: 'Ya-Sin', hi: 'यासीन', ur: 'یٰسین', ar: 'يس' },
  37: { en: 'Those Ranged in Ranks', hi: 'सफ़ बाँधने वाले', ur: 'صف بندی کرنے والے', ar: 'الصافات' },
  38: { en: 'The Letter Sad', hi: 'साद', ur: 'ص', ar: 'ص' },
  39: { en: 'The Groups', hi: 'झुंड', ur: 'گروہ', ar: 'الزمر' },
  40: { en: 'The Forgiver', hi: 'माफ़ करने वाला', ur: 'معاف کرنے والا', ar: 'غافر' },
  41: { en: 'Explained in Detail', hi: 'विस्तार से', ur: 'تفصیل سے', ar: 'فصلت' },
  42: { en: 'The Consultation', hi: 'मशविरा', ur: 'مشاورت', ar: 'الشورى' },
  43: { en: 'The Gold Adornment', hi: 'सोने की सजावट', ur: 'سونے کی سجاوٹ', ar: 'الزخرف' },
  44: { en: 'The Smoke', hi: 'धुआँ', ur: 'دھواں', ar: 'الدخان' },
  45: { en: 'The Crouching', hi: 'घुटनों के बल', ur: 'گھٹنوں کے بل', ar: 'الجاثية' },
  46: { en: 'The Wind-Curved Sandhills', hi: 'रेत के टीले', ur: 'ریت کے ٹیلے', ar: 'الأحقاف' },
  47: { en: 'Muhammad', hi: 'मुहम्मद', ur: 'محمد', ar: 'محمد' },
  48: { en: 'The Victory', hi: 'फ़तह', ur: 'فتح', ar: 'الفتح' },
  49: { en: 'The Rooms', hi: 'कमरे', ur: 'کمرے', ar: 'الحجرات' },
  50: { en: 'The Letter Qaf', hi: 'क़ाफ़', ur: 'ق', ar: 'ق' },
  51: { en: 'The Winnowing Winds', hi: 'बिखेरने वाली हवाएँ', ur: 'بکھیرنے والی ہوائیں', ar: 'الذاريات' },
  52: { en: 'The Mount', hi: 'पहाड़', ur: 'پہاڑ', ar: 'الطور' },
  53: { en: 'The Star', hi: 'तारा', ur: 'ستارہ', ar: 'النجم' },
  54: { en: 'The Moon', hi: 'चाँद', ur: 'چاند', ar: 'القمر' },
  55: { en: 'The Beneficent', hi: 'रहमान', ur: 'رحمٰن', ar: 'الرحمن' },
  56: { en: 'The Inevitable', hi: 'वाक़िआ', ur: 'واقعہ', ar: 'الواقعة' },
  57: { en: 'The Iron', hi: 'लोहा', ur: 'لوہا', ar: 'الحديد' },
  58: { en: 'The Pleading Woman', hi: 'बहस करने वाली', ur: 'بحث کرنے والی', ar: 'المجادلة' },
  59: { en: 'The Exile', hi: 'इकट्ठा करना', ur: 'جلاوطنی', ar: 'الحشر' },
  60: { en: 'She that is to be examined', hi: 'परखी जाने वाली', ur: 'پرکھی جانے والی', ar: 'الممتحنة' },
  61: { en: 'The Ranks', hi: 'सफ़', ur: 'صف', ar: 'الصف' },
  62: { en: 'The Congregation', hi: 'जुमा', ur: 'جمعہ', ar: 'الجمعة' },
  63: { en: 'The Hypocrites', hi: 'मुनाफ़िक़', ur: 'منافقین', ar: 'المنافقون' },
  64: { en: 'The Mutual Disillusion', hi: 'धोखे का पता', ur: 'دھوکے کا پتہ', ar: 'التغابن' },
  65: { en: 'The Divorce', hi: 'तलाक़', ur: 'طلاق', ar: 'الطلاق' },
  66: { en: 'The Prohibition', hi: 'मनाही', ur: 'حرمت', ar: 'التحريم' },
  67: { en: 'The Sovereignty', hi: 'बादशाही', ur: 'بادشاہت', ar: 'الملك' },
  68: { en: 'The Pen', hi: 'क़लम', ur: 'قلم', ar: 'القلم' },
  69: { en: 'The Reality', hi: 'हक़ीक़त', ur: 'حقیقت', ar: 'الحاقة' },
  70: { en: 'The Ascending Stairways', hi: 'चढ़ने की सीढ़ियाँ', ur: 'چڑھنے کی سیڑھیاں', ar: 'المعارج' },
  71: { en: 'Noah', hi: 'नूह', ur: 'نوح', ar: 'نوح' },
  72: { en: 'The Jinn', hi: 'जिन्न', ur: 'جن', ar: 'الجن' },
  73: { en: 'The Enshrouded One', hi: 'चादर ओढ़ने वाला', ur: 'چادر لپیٹنے والا', ar: 'المزمل' },
  74: { en: 'The Cloaked One', hi: 'कपड़ा ओढ़ने वाला', ur: 'کپڑا اوڑھنے والا', ar: 'المدثر' },
  75: { en: 'The Resurrection', hi: 'क़ियामत', ur: 'قیامت', ar: 'القيامة' },
  76: { en: 'The Human', hi: 'इनसान', ur: 'انسان', ar: 'الإنسان' },
  77: { en: 'The Emissaries', hi: 'भेजी गईं', ur: 'بھیجی ہوئیں', ar: 'المرسلات' },
  78: { en: 'The Tidings', hi: 'ख़बर', ur: 'خبر', ar: 'النبأ' },
  79: { en: 'Those Who Drag Forth', hi: 'खींचने वाले', ur: 'کھینچنے والے', ar: 'النازعات' },
  80: { en: 'He Frowned', hi: 'त्योरी चढ़ाई', ur: 'تیوری چڑھائی', ar: 'عبس' },
  81: { en: 'The Overthrowing', hi: 'लपेट लेना', ur: 'لپیٹ لینا', ar: 'التكوير' },
  82: { en: 'The Cleaving', hi: 'फट जाना', ur: 'پھٹ جانا', ar: 'الانفطار' },
  83: { en: 'Defrauding', hi: 'कम तौलने वाले', ur: 'کم تولنے والے', ar: 'المطففين' },
  84: { en: 'The Sundering', hi: 'चिरना', ur: 'پھٹ جانا', ar: 'الانشقاق' },
  85: { en: 'The Mansions of the Stars', hi: 'बुर्ज', ur: 'برج', ar: 'البروج' },
  86: { en: 'The Morning Star', hi: 'रात का तारा', ur: 'رات کا تارا', ar: 'الطارق' },
  87: { en: 'The Most High', hi: 'सबसे ऊँचा', ur: 'سب سے اعلیٰ', ar: 'الأعلى' },
  88: { en: 'The Overwhelming', hi: 'ढक लेने वाली', ur: 'ڈھک لینے والی', ar: 'الغاشية' },
  89: { en: 'The Dawn', hi: 'सुबह', ur: 'صبح', ar: 'الفجر' },
  90: { en: 'The City', hi: 'शहर', ur: 'شہر', ar: 'البلد' },
  91: { en: 'The Sun', hi: 'सूरज', ur: 'سورج', ar: 'الشمس' },
  92: { en: 'The Night', hi: 'रात', ur: 'رات', ar: 'الليل' },
  93: { en: 'The Morning Hours', hi: 'चाश्त', ur: 'چاشت', ar: 'الضحى' },
  94: { en: 'The Relief', hi: 'सीना खोलना', ur: 'سینہ کشادگی', ar: 'الشرح' },
  95: { en: 'The Fig', hi: 'अंजीर', ur: 'انجیر', ar: 'التين' },
  96: { en: 'The Clot', hi: 'ख़ून का लोथड़ा', ur: 'خون کا لوتھڑا', ar: 'العلق' },
  97: { en: 'The Power', hi: 'शबे क़द्र', ur: 'شبِ قدر', ar: 'القدر' },
  98: { en: 'The Clear Proof', hi: 'स्पष्ट प्रमाण', ur: 'واضح دلیل', ar: 'البينة' },
  99: { en: 'The Earthquake', hi: 'ज़लज़ला', ur: 'زلزلہ', ar: 'الزلزلة' },
  100: { en: 'The Courser', hi: 'दौड़ने वाले', ur: 'دوڑنے والے', ar: 'العاديات' },
  101: { en: 'The Calamity', hi: 'आफ़त', ur: 'آفت', ar: 'القارعة' },
  102: { en: 'The Rivalry in World Increase', hi: 'ज़्यादा होने की होड़', ur: 'زیادتی کی ہوڑ', ar: 'التكاثر' },
  103: { en: 'The Declining Day', hi: 'ज़माना', ur: 'زمانہ', ar: 'العصر' },
  104: { en: 'The Traducer', hi: 'ताना मारने वाला', ur: 'طعنے دینے والا', ar: 'الهمزة' },
  105: { en: 'The Elephant', hi: 'हाथी', ur: 'ہاتھی', ar: 'الفيل' },
  106: { en: 'Quraysh', hi: 'क़ुरैश', ur: 'قریش', ar: 'قريش' },
  107: { en: 'The Small Kindnesses', hi: 'छोटी नेकियाँ', ur: 'چھوٹی نیکیاں', ar: 'الماعون' },
  108: { en: 'The Abundance', hi: 'बहुत ज़्यादा', ur: 'بہت زیادہ', ar: 'الكوثر' },
  109: { en: 'The Disbelievers', hi: 'काफ़िर', ur: 'کافر', ar: 'الكافرون' },
  110: { en: 'The Divine Support', hi: 'मदद', ur: 'مدد', ar: 'النصر' },
  111: { en: 'The Palm Fiber', hi: 'रस्सी', ur: 'رسی', ar: 'المسد' },
  112: { en: 'The Sincerity', hi: 'इख़लास', ur: 'اخلاص', ar: 'الإخلاص' },
  113: { en: 'The Daybreak', hi: 'सुबह की रोशनी', ur: 'صبح کی روشنی', ar: 'الفلق' },
  114: { en: 'Mankind', hi: 'इनसान', ur: 'انسان', ar: 'الناس' },
};

// Rate limiting - delay between API calls (ms)
const DELAY_MS = 500;

function delay(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function fetchJSON(url) {
  return new Promise((resolve, reject) => {
    https
      .get(url, (res) => {
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => {
          try {
            const json = JSON.parse(data);
            resolve(json);
          } catch (e) {
            reject(new Error(`Parse error for ${url}: ${e.message}`));
          }
        });
      })
      .on('error', reject);
  });
}

async function fetchWithRetry(url, retries = 3) {
  for (let i = 0; i < retries; i++) {
    try {
      const result = await fetchJSON(url);
      if (result.code === 200) return result;
      console.warn(`API returned code ${result.code} for ${url}, retry ${i + 1}/${retries}`);
    } catch (e) {
      console.warn(`Error fetching ${url}: ${e.message}, retry ${i + 1}/${retries}`);
    }
    await delay(2000);
  }
  throw new Error(`Failed to fetch ${url} after ${retries} retries`);
}

async function main() {
  const outputDir = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'quran_surahs');
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Step 1: Fetch surah list
  console.log('Fetching surah list...');
  const surahListResponse = await fetchWithRetry(`${BASE_URL}/surah`);
  const surahList = surahListResponse.data;
  console.log(`Found ${surahList.length} surahs`);

  // Step 2: Load existing quran_screen_content.json
  const contentPath = path.join(__dirname, '..', 'assets', 'data', 'firebase', 'quran_screen_content.json');
  const existingContent = JSON.parse(fs.readFileSync(contentPath, 'utf8'));

  // Step 3: Enhance surah_names with metadata
  console.log('Enhancing surah metadata...');
  const enhancedSurahNames = existingContent.surah_names.map((entry) => {
    const surahMeta = surahList.find((s) => s.number === entry.number);
    const meaningTranslation = SURAH_MEANING_TRANSLATIONS[entry.number] || {
      en: surahMeta?.englishNameTranslation || '',
      hi: '',
      ur: '',
      ar: '',
    };
    return {
      ...entry,
      number_of_ayahs: surahMeta?.numberOfAyahs || 0,
      revelation_type: surahMeta?.revelationType || 'Meccan',
      english_name_translation: meaningTranslation,
    };
  });

  existingContent.surah_names = enhancedSurahNames;
  fs.writeFileSync(contentPath, JSON.stringify(existingContent, null, 2), 'utf8');
  console.log('Updated quran_screen_content.json with enhanced metadata');

  // Step 4: Fetch each surah with all translations
  for (let i = 1; i <= 114; i++) {
    const surahMeta = surahList.find((s) => s.number === i);
    const surahNameEntry = existingContent.surah_names.find((s) => s.number === i);

    console.log(`\nFetching Surah ${i}/${114}: ${surahMeta.englishName}...`);

    try {
      // Fetch all editions for this surah
      const [arabicRes, englishRes, urduRes, hindiRes, tafsirRes, translitRes] = await Promise.all([
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.arabic}`),
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.english}`),
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.urdu}`),
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.hindi}`),
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.arabic_tafsir}`),
        fetchWithRetry(`${BASE_URL}/surah/${i}/${EDITIONS.transliteration}`),
      ]);

      const arabicAyahs = arabicRes.data.ayahs;
      const englishAyahs = englishRes.data.ayahs;
      const urduAyahs = urduRes.data.ayahs;
      const hindiAyahs = hindiRes.data.ayahs;
      const tafsirAyahs = tafsirRes.data.ayahs;
      const translitAyahs = translitRes.data.ayahs;

      // Build combined ayah data
      const ayahs = arabicAyahs.map((ayah, idx) => ({
        number: ayah.number,
        number_in_surah: ayah.numberInSurah,
        arabic_text: ayah.text,
        translation: {
          en: englishAyahs[idx]?.text || '',
          ur: urduAyahs[idx]?.text || '',
          hi: hindiAyahs[idx]?.text || '',
          ar: tafsirAyahs[idx]?.text || '',
        },
        transliteration: translitAyahs[idx]?.text || '',
        juz: ayah.juz,
        page: ayah.page,
        hizb_quarter: ayah.hizbQuarter,
        sajda: typeof ayah.sajda === 'boolean' ? ayah.sajda : false,
      }));

      // Build surah document
      const surahDoc = {
        number: i,
        name: surahNameEntry?.name || {
          en: surahMeta.englishName,
          hi: '',
          ur: '',
          ar: surahMeta.name,
        },
        number_of_ayahs: surahMeta.numberOfAyahs,
        revelation_type: surahMeta.revelationType,
        english_name_translation:
          SURAH_MEANING_TRANSLATIONS[i] || {
            en: surahMeta.englishNameTranslation,
            hi: '',
            ur: '',
            ar: '',
          },
        ayahs: ayahs,
      };

      // Save individual surah file
      const filePath = path.join(outputDir, `surah_${i}.json`);
      fs.writeFileSync(filePath, JSON.stringify(surahDoc, null, 2), 'utf8');
      console.log(`  Saved surah_${i}.json (${ayahs.length} ayahs)`);
    } catch (e) {
      console.error(`  ERROR fetching surah ${i}: ${e.message}`);
    }

    // Rate limit
    await delay(DELAY_MS);
  }

  console.log('\n=== All done! ===');
  console.log(`Surah files saved to: ${outputDir}`);
  console.log(`Updated: ${contentPath}`);
  console.log('\nNext step: Run push_quran_to_firebase.js to upload to Firebase');
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
