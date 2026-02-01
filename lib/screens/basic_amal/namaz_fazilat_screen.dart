import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class NamazFazilatScreen extends StatefulWidget {
  const NamazFazilatScreen({super.key});

  @override
  State<NamazFazilatScreen> createState() => _NamazFazilatScreenState();
}

class _NamazFazilatScreenState extends State<NamazFazilatScreen> {
  final List<Map<String, dynamic>> _namazTopics = [
    {
      'number': 1,
      'titleKey': 'namaz_fazilat_1_importance_of_salah',
      'title': 'Importance of Salah',
      'titleUrdu': 'نماز کی اہمیت',
      'titleHindi': 'नमाज़ की अहमियत',
      'titleArabic': 'أهمية الصلاة',
      'icon': Icons.mosque,
      'color': Colors.green,
      'details': {
        'english': '''The Importance of Salah (Prayer)

Salah is the second pillar of Islam and the most important act of worship after the declaration of faith.

Status in Islam:
• First act to be questioned about on Day of Judgment
• The Prophet ﷺ said: "The first thing for which a person will be brought to account on the Day of Resurrection is his Salah." (Sunan an-Nasa'i)
• Distinguishes believers from disbelievers
• The Prophet ﷺ said: "Between a man and shirk and kufr is abandoning prayer." (Sahih Muslim)

Direct Command from Allah:
• Commanded 50 times, reduced to 5 with the reward of 50
• Only pillar directly commanded in the heavens during Mi'raj
• "Indeed, prayer has been decreed upon the believers at specified times." (Quran 4:103)

The Prophet's Emphasis:
• Last words of the Prophet ﷺ: "The prayer, the prayer! And fear Allah regarding those whom your right hands possess."
• He never missed a prayer, even during illness
• Prayed even while sitting when unable to stand

Signs of True Faith:
• Regular prayer is a sign of true Iman
• Those who neglect prayer have weak faith
• Prayer is the connection between servant and Lord

Consequences of Abandoning:
• Major sin in Islam
• Some scholars say it takes one out of Islam
• Will be raised with Pharaoh, Qarun, and Haman''',
        'urdu': '''نماز کی اہمیت

نماز اسلام کا دوسرا ستون اور کلمہ شہادت کے بعد سب سے اہم عبادت ہے۔

اسلام میں مقام:
• قیامت کے دن سب سے پہلے نماز کا حساب ہوگا
• نبی کریم ﷺ نے فرمایا: "قیامت کے دن سب سے پہلے جس چیز کا حساب لیا جائے گا وہ نماز ہے۔" (سنن نسائی)
• مومن اور کافر میں فرق کرتی ہے
• نبی کریم ﷺ نے فرمایا: "بندے اور شرک و کفر کے درمیان نماز چھوڑنا ہے۔" (صحیح مسلم)

اللہ کا براہ راست حکم:
• 50 بار فرض ہوئی، 5 پر کم کی گئی 50 کے ثواب کے ساتھ
• صرف یہی رکن ہے جو معراج میں آسمانوں پر براہ راست فرض ہوا
• "بیشک نماز مومنوں پر مقررہ اوقات میں فرض کی گئی ہے۔" (قرآن 4:103)

نبی کریم ﷺ کا زور:
• نبی کریم ﷺ کے آخری الفاظ: "نماز، نماز! اور اللہ سے ڈرو اپنے غلاموں کے بارے میں۔"
• آپ ﷺ نے بیماری میں بھی کبھی نماز نہیں چھوڑی
• کھڑے ہونے سے قاصر ہونے پر بیٹھ کر بھی نماز پڑھی

سچے ایمان کی علامات:
• باقاعدہ نماز سچے ایمان کی علامت ہے
• نماز میں کوتاہی کرنے والوں کا ایمان کمزور ہے
• نماز بندے اور رب کے درمیان تعلق ہے

چھوڑنے کے نتائج:
• اسلام میں بڑا گناہ
• بعض علماء کہتے ہیں یہ اسلام سے نکال دیتا ہے
• فرعون، قارون اور ہامان کے ساتھ اٹھایا جائے گا''',
        'hindi': '''नमाज़ की अहमियत

नमाज़ इस्लाम का दूसरा सुतून और कलिमा शहादत के बाद सबसे अहम इबादत है।

इस्लाम में मक़ाम:
• क़यामत के दिन सबसे पहले नमाज़ का हिसाब होगा
• नबी करीम ﷺ ने फ़रमाया: "क़यामत के दिन सबसे पहले जिस चीज़ का हिसाब लिया जाएगा वो नमाज़ है।" (सुनन नसाई)
• मोमिन और काफ़िर में फ़र्क़ करती है
• नबी करीम ﷺ ने फ़रमाया: "बंदे और शिर्क व कुफ़्र के दरमियान नमाज़ छोड़ना है।" (सहीह मुस्लिम)

अल्लाह का बराहेरास्त हुक्म:
• 50 बार फ़र्ज़ हुई, 5 पर कम की गई 50 के सवाब के साथ
• सिर्फ़ यही रुक्न है जो मेराज में आसमानों पर बराहेरास्त फ़र्ज़ हुआ
• "बेशक नमाज़ मोमिनों पर मुक़र्रर औक़ात में फ़र्ज़ की गई है।" (क़ुरआन 4:103)

नबी करीम ﷺ का ज़ोर:
• नबी करीम ﷺ के आख़िरी अल्फ़ाज़: "नमाज़, नमाज़! और अल्लाह से डरो अपने ग़ुलामों के बारे में।"
• आप ﷺ ने बीमारी में भी कभी नमाज़ नहीं छोड़ी
• खड़े होने से क़ासिर होने पर बैठकर भी नमाज़ पढ़ी

सच्चे ईमान की अलामात:
• बाक़ायदा नमाज़ सच्चे ईमान की अलामत है
• नमाज़ में कोताही करने वालों का ईमान कमज़ोर है
• नमाज़ बंदे और रब के दरमियान ताल्लुक़ है

छोड़ने के नताइज:
• इस्लाम में बड़ा गुनाह
• बाज़ उलमा कहते हैं यह इस्लाम से निकाल देता है
• फ़िरऔन, क़ारून और हामान के साथ उठाया जाएगा''',
        'arabic': '''أهمية الصلاة

الصلاة عماد الدين وأعظم أركان الإسلام بعد الشهادتين.

مكانة الصلاة:
• "إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا" (سورة النساء: 103)
• عماد الدين الذي لا يقوم إلا به
• أول ما يحاسب عليه العبد يوم القيامة
• قال النبي ﷺ: "العهد الذي بيننا وبينهم الصلاة فمن تركها فقد كفر" (الترمذي)

فرضية الصلاة:
• فرضت في ليلة الإسراء والمعراج
• فرضت خمسين صلاة فخففت إلى خمس
• أجرها كخمسين صلاة
• "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ" (سورة البقرة: 43)

الصلاة نور:
• قال النبي ﷺ: "الصلاة نور" (مسلم)
• تنور القلب والوجه
• تنور الطريق يوم القيامة
• تفتح أبواب الرحمة

الصلاة تنهى عن الفحشاء:
• "إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ" (سورة العنكبوت: 45)
• تحجز عن المعاصي
• تزكي النفس وتطهرها
• تقوي الإيمان

أول ما يحاسب عليه العبد:
• قال النبي ﷺ: "أول ما يحاسب به العبد يوم القيامة الصلاة" (النسائي)
• إذا صلحت صلح سائر عمله
• وإذا فسدت فسد سائر عمله'''
      },
    },
    {
      'number': 2,
      'titleKey': 'namaz_fazilat_2_five_daily_prayers',
      'title': 'Five Daily Prayers',
      'titleUrdu': 'پانچ وقت کی نمازیں',
      'titleHindi': 'पांच वक़्त की नमाज़ें',
      'titleArabic': 'الصلوات الخمس',
      'icon': Icons.access_time,
      'color': Colors.blue,
      'details': {
        'english': '''The Five Daily Prayers

Allah has prescribed five daily prayers at specific times.

1. Fajr (Dawn Prayer):
• Time: From true dawn until sunrise
• Rakats: 2 Sunnah + 2 Fard
• Virtue: "Whoever prays Fajr is under Allah's protection." (Sahih Muslim)
• The two Sunnah of Fajr are better than the world and all it contains

2. Dhuhr (Noon Prayer):
• Time: From sun's decline until Asr time
• Rakats: 4 Sunnah + 4 Fard + 2 Sunnah
• First prayer prayed after Qiblah changed to Kaaba
• Prayed when sun is at its hottest

3. Asr (Afternoon Prayer):
• Time: Until sunset
• Rakats: 4 Fard
• "This is the middle prayer" according to many scholars
• Missing it deliberately is like losing family and wealth

4. Maghrib (Evening Prayer):
• Time: From sunset until twilight disappears
• Rakats: 3 Fard + 2 Sunnah
• Shortest time window
• Should not be delayed

5. Isha (Night Prayer):
• Time: From twilight until midnight (can extend to Fajr in necessity)
• Rakats: 4 Fard + 2 Sunnah + 3 Witr
• Praying Isha in congregation equals half the night in prayer
• Witr is highly emphasized

Total Daily: 17 Fard Rakats + Various Sunnah''',
        'urdu': '''پانچ وقت کی نمازیں

اللہ نے مخصوص اوقات میں پانچ نمازیں فرض کی ہیں۔

1. فجر (صبح کی نماز):
• وقت: صبح صادق سے طلوع آفتاب تک
• رکعات: 2 سنت + 2 فرض
• فضیلت: "جو فجر پڑھے وہ اللہ کی حفاظت میں ہے۔" (صحیح مسلم)
• فجر کی دو سنتیں دنیا اور اس کی ہر چیز سے بہتر ہیں

2. ظہر (دوپہر کی نماز):
• وقت: سورج ڈھلنے سے عصر تک
• رکعات: 4 سنت + 4 فرض + 2 سنت
• قبلہ کعبہ کی طرف ہونے کے بعد پہلی نماز
• سورج کی شدید گرمی میں پڑھی جاتی ہے

3. عصر (دوپہر کے بعد کی نماز):
• وقت: غروب آفتاب تک
• رکعات: 4 فرض
• بہت سے علماء کے نزدیک "یہی درمیانی نماز ہے"
• جان بوجھ کر چھوڑنا گھر والوں اور مال کھونے جیسا ہے

4. مغرب (شام کی نماز):
• وقت: غروب آفتاب سے شفق غائب ہونے تک
• رکعات: 3 فرض + 2 سنت
• سب سے چھوٹا وقت
• تاخیر نہیں کرنی چاہیے

5. عشاء (رات کی نماز):
• وقت: شفق سے آدھی رات تک (ضرورت میں فجر تک)
• رکعات: 4 فرض + 2 سنت + 3 وتر
• جماعت سے عشاء پڑھنا آدھی رات کی عبادت کے برابر ہے
• وتر پر بہت زور دیا گیا ہے

روزانہ کل: 17 فرض رکعات + مختلف سنتیں''',
        'hindi': '''पांच वक़्त की नमाज़ें

अल्लाह ने मख़सूस औक़ात में पांच नमाज़ें फ़र्ज़ की हैं।

1. फ़ज्र (सुबह की नमाज़):
• वक़्त: सुबह सादिक़ से तुलू आफ़ताब तक
• रकअत: 2 सुन्नत + 2 फ़र्ज़
• फ़ज़ीलत: "जो फ़ज्र पढ़े वो अल्लाह की हिफ़ाज़त में है।" (सहीह मुस्लिम)
• फ़ज्र की दो सुन्नतें दुनिया और उसकी हर चीज़ से बेहतर हैं

2. ज़ुहर (दोपहर की नमाज़):
• वक़्त: सूरज ढलने से अस्र तक
• रकअत: 4 सुन्नत + 4 फ़र्ज़ + 2 सुन्नत
• क़िबला काबा की तरफ़ होने के बाद पहली नमाज़
• सूरज की शदीद गर्मी में पढ़ी जाती है

3. अस्र (दोपहर के बाद की नमाज़):
• वक़्त: ग़ुरूब आफ़ताब तक
• रकअत: 4 फ़र्ज़
• बहुत से उलमा के नज़दीक "यही दरमियानी नमाज़ है"
• जानबूझकर छोड़ना घरवालों और माल खोने जैसा है

4. मग़रिब (शाम की नमाज़):
• वक़्त: ग़ुरूब आफ़ताब से शफ़क़ ग़ायब होने तक
• रकअत: 3 फ़र्ज़ + 2 सुन्नत
• सबसे छोटा वक़्त
• ताख़ीर नहीं करनी चाहिए

5. इशा (रात की नमाज़):
• वक़्त: शफ़क़ से आधी रात तक (ज़रूरत में फ़ज्र तक)
• रकअत: 4 फ़र्ज़ + 2 सुन्नत + 3 वित्र
• जमाअत से इशा पढ़ना आधी रात की इबादत के बराबर है
• वित्र पर बहुत ज़ोर दिया गया है

रोज़ाना कुल: 17 फ़र्ज़ रकअत + मुख़्तलिफ़ सुन्नतें''',
        'arabic': '''الصلوات الخمس

فضائل الصلوات الخمس المفروضة.

صلاة الفجر:
• "أَقِمِ الصَّلَاةَ لِدُلُوكِ الشَّمْسِ إِلَىٰ غَسَقِ اللَّيْلِ وَقُرْآنَ الْفَجْرِ" (سورة الإسراء: 78)
• ركعتا الفجر خير من الدنيا وما فيها
• من صلى الفجر في جماعة فهو في ذمة الله
• "إِنَّ قُرْآنَ الْفَجْرِ كَانَ مَشْهُودًا" تشهده ملائكة الليل والنهار

صلاة الظهر:
• أول صلاة صلاها جبريل بالنبي ﷺ
• فيها تفتح أبواب السماء
• يستحب فيها إطالة القراءة
• أول صلاة أظهرها المسلمون بمكة

صلاة العصر:
• "حَافِظُوا عَلَى الصَّلَوَاتِ وَالصَّلَاةِ الْوُسْطَىٰ" (سورة البقرة: 238)
• الصلاة الوسطى على الأرجح
• قال النبي ﷺ: "من ترك صلاة العصر فقد حبط عمله" (البخاري)
• صلاة الملائكة

صلاة المغرب:
• وتر النهار
• ثلاث ركعات
• من صلاها في جماعة كأنما قام نصف الليل
• يستحب تعجيلها

صلاة العشاء:
• آخر الصلوات الخمس
• من صلاها في جماعة فكأنما قام نصف الليل
• من صلى العشاء والفجر في جماعة فكأنما قام الليل كله
• يجوز تأخيرها إلى نصف الليل'''
      },
    },
    {
      'number': 3,
      'titleKey': 'namaz_fazilat_3_rewards_of_prayer',
      'title': 'Rewards of Prayer',
      'titleUrdu': 'نماز کا ثواب',
      'titleHindi': 'नमाज़ का सवाब',
      'titleArabic': 'ثواب الصلاة',
      'icon': Icons.star,
      'color': Colors.amber,
      'details': {
        'english': '''Rewards and Benefits of Prayer

Prayer brings immense rewards in this life and the Hereafter.

Forgiveness of Sins:
• "The five daily prayers and Jumu'ah to Jumu'ah are expiation for what is between them, as long as major sins are avoided." (Sahih Muslim)
• Like bathing in a river five times daily - removes sins
• The Prophet ﷺ said: "If there was a river at your door and you bathed in it five times a day, would any dirt remain on you?"

Light on Day of Judgment:
• "Give glad tidings to those who walk to the mosques in darkness of complete light on the Day of Resurrection." (Abu Dawud)
• Prayer will be light in the grave
• Protection from darkness of the grave

Elevation of Ranks:
• Each prostration raises rank and removes sin
• The Prophet ﷺ said: "Make many prostrations, for you do not make any prostration without Allah raising you a degree and removing a sin from you."

Paradise Guaranteed:
• "Whoever prays twelve rak'ahs during the day and night, a house will be built for him in Paradise." (Tirmidhi)
• Regular prayer is a path to Paradise

Closeness to Allah:
• "The closest a servant is to his Lord is when he is prostrating." (Sahih Muslim)
• Direct communication with Allah
• Dua in prostration is especially accepted

Protection from Hellfire:
• Regular prayer protects from Hell
• Face that prostrates won't be touched by fire (according to scholars)''',
        'urdu': '''نماز کے ثواب اور فوائد

نماز اس دنیا اور آخرت میں بے شمار اجر لاتی ہے۔

گناہوں کی معافی:
• "پانچ وقت کی نمازیں اور جمعہ سے جمعہ تک درمیان کے گناہوں کا کفارہ ہیں، جب تک کبیرہ گناہوں سے بچا جائے۔" (صحیح مسلم)
• دن میں پانچ بار نہر میں نہانے کی طرح - گناہ دور کرتی ہے
• نبی کریم ﷺ نے فرمایا: "اگر تمہارے دروازے پر نہر ہو اور تم اس میں دن میں پانچ بار نہاؤ، کیا کوئی میل باقی رہے گی؟"

قیامت کے دن نور:
• "جو لوگ اندھیرے میں مسجدوں کی طرف چلتے ہیں انہیں قیامت کے دن مکمل نور کی خوشخبری دو۔" (ابو داؤد)
• نماز قبر میں نور ہوگی
• قبر کی تاریکی سے حفاظت

درجات کی بلندی:
• ہر سجدہ درجہ بلند کرتا اور گناہ مٹاتا ہے
• نبی کریم ﷺ نے فرمایا: "بہت سجدے کرو، کوئی سجدہ نہیں کرتے مگر اللہ تمہارا درجہ بلند کرتا اور گناہ مٹاتا ہے۔"

جنت کی ضمانت:
• "جو دن رات میں بارہ رکعت نماز پڑھے، اس کے لیے جنت میں گھر بنایا جائے گا۔" (ترمذی)
• باقاعدہ نماز جنت کا راستہ ہے

اللہ سے قربت:
• "بندہ اپنے رب سے سب سے قریب سجدے میں ہوتا ہے۔" (صحیح مسلم)
• اللہ سے براہ راست بات
• سجدے میں دعا خاص طور پر قبول ہوتی ہے

جہنم سے حفاظت:
• باقاعدہ نماز جہنم سے بچاتی ہے
• سجدہ کرنے والے چہرے کو آگ نہیں چھوئے گی (علماء کے مطابق)''',
        'hindi': '''नमाज़ के सवाब और फ़वाइद

नमाज़ इस दुनिया और आख़िरत में बेशुमार अज्र लाती है।

गुनाहों की माफ़ी:
• "पांच वक़्त की नमाज़ें और जुमा से जुमा तक दरमियान के गुनाहों का कफ़्फ़ारा हैं, जब तक कबीरा गुनाहों से बचा जाए।" (सहीह मुस्लिम)
• दिन में पांच बार नहर में नहाने की तरह - गुनाह दूर करती है
• नबी करीम ﷺ ने फ़रमाया: "अगर तुम्हारे दरवाज़े पर नहर हो और तुम उसमें दिन में पांच बार नहाओ, क्या कोई मैल बाक़ी रहेगी?"

क़यामत के दिन नूर:
• "जो लोग अंधेरे में मस्जिदों की तरफ़ चलते हैं उन्हें क़यामत के दिन मुकम्मल नूर की ख़ुशख़बरी दो।" (अबू दाऊद)
• नमाज़ क़ब्र में नूर होगी
• क़ब्र की तारीकी से हिफ़ाज़त

दर्जात की बुलंदी:
• हर सज्दा दर्जा बुलंद करता और गुनाह मिटाता है
• नबी करीम ﷺ ने फ़रमाया: "बहुत सज्दे करो, कोई सज्दा नहीं करते मगर अल्लाह तुम्हारा दर्जा बुलंद करता और गुनाह मिटाता है।"

जन्नत की ज़मानत:
• "जो दिन रात में बारह रकअत नमाज़ पढ़े, उसके लिए जन्नत में घर बनाया जाएगा।" (तिर्मिज़ी)
• बाक़ायदा नमाज़ जन्नत का रास्ता है

अल्लाह से क़ुर्बत:
• "बंदा अपने रब से सबसे क़रीब सज्दे में होता है।" (सहीह मुस्लिम)
• अल्लाह से बराहेरास्त बात
• सज्दे में दुआ ख़ास तौर पर क़बूल होती है

जहन्नम से हिफ़ाज़त:
• बाक़ायदा नमाज़ जहन्नम से बचाती है
• सज्दा करने वाले चेहरे को आग नहीं छुएगी (उलमा के मुताबिक़)''',
        'arabic': '''ثواب الصلاة

الأجر العظيم للصلاة.

تكفير الذنوب:
• قال النبي ﷺ: "الصلوات الخمس والجمعة إلى الجمعة كفارات لما بينهن ما لم تغش الكبائر" (مسلم)
• كل صلاة تكفر ما قبلها من الذنوب
• الوضوء يكفر الخطايا
• السجود يحط الذنوب

رفع الدرجات:
• بكل خطوة إلى المسجد درجة ومحو سيئة
• "يَرْفَعِ اللَّهُ الَّذِينَ آمَنُوا مِنكُمْ وَالَّذِينَ أُوتُوا الْعِلْمَ دَرَجَاتٍ" (سورة المجادلة: 11)
• الصلاة في الصف الأول أفضل
• المحافظة على الصلاة سبب لدخول الجنة

دخول الجنة:
• قال النبي ﷺ: "من صلى البردين دخل الجنة" (البخاري)
• من صلى اثنتي عشرة ركعة بنى الله له بيتاً في الجنة
• الصلاة طريق إلى الفردوس الأعلى

مضاعفة الأجر:
• الصلاة في المسجد بسبع وعشرين درجة
• الصلاة في المسجد الحرام بمائة ألف صلاة
• الصلاة في المسجد النبوي بألف صلاة
• الصلاة في المسجد الأقصى بخمسمائة صلاة

القرب من الله:
• "وَاسْجُدْ وَاقْتَرِب" (سورة العلق: 19)
• أقرب ما يكون العبد من ربه وهو ساجد
• الصلاة مناجاة مع الله
• سبب لمحبة الله ورضاه'''
      },
    },
    {
      'number': 4,
      'titleKey': 'namaz_fazilat_4_congregation_prayer',
      'title': 'Congregation Prayer',
      'titleUrdu': 'نماز باجماعت',
      'titleHindi': 'नमाज़ बा-जमाअत',
      'titleArabic': 'صلاة الجماعة',
      'icon': Icons.groups,
      'color': Colors.purple,
      'details': {
        'english': '''Virtues of Praying in Congregation

Praying in congregation has immense rewards and is strongly encouraged.

27 Times More Reward:
• "Prayer in congregation is twenty-seven times better than prayer offered individually." (Sahih Bukhari)
• Some narrations mention 25 times
• This multiplied reward is for those who pray in the mosque

Walking to the Mosque:
• Every step is rewarded and sins are forgiven
• "When he goes out of his house to the mosque, one foot raises his rank and the other erases a sin." (Sahih Muslim)
• Even returning home is rewarded

Waiting for Prayer:
• Angels seek forgiveness for one waiting
• "The angels keep on asking Allah's forgiveness for anyone of you, as long as he is in his prayer place."
• One is considered in prayer while waiting for prayer

Protection from Hypocrisy:
• Regular congregation attendance protects from nifaq
• The Prophet ﷺ considered burning the houses of those who don't attend Fajr and Isha in congregation

First Row Rewards:
• "If people knew what is in the call to prayer and the first row, and they could not get it except by drawing lots, they would draw lots." (Bukhari)
• Angels send blessings on first row
• Great competition for the front

Jumu'ah (Friday) Prayer:
• Obligatory for men
• "Whoever misses three Jumu'ah prayers out of negligence, Allah will seal his heart." (Tirmidhi)
• Best day of the week
• Special hour when dua is accepted''',
        'urdu': '''نماز باجماعت کے فضائل

جماعت سے نماز پڑھنے کا بے حد ثواب ہے اور بہت زور دیا گیا ہے۔

27 گنا زیادہ ثواب:
• "جماعت سے نماز اکیلے نماز سے 27 گنا بہتر ہے۔" (صحیح بخاری)
• بعض روایات میں 25 گنا ہے
• یہ بڑھا ہوا ثواب مسجد میں نماز پڑھنے والوں کے لیے ہے

مسجد کی طرف چلنا:
• ہر قدم پر ثواب ملتا اور گناہ معاف ہوتے ہیں
• "جب وہ گھر سے مسجد جاتا ہے، ایک قدم درجہ بلند کرتا اور دوسرا گناہ مٹاتا ہے۔" (صحیح مسلم)
• واپس گھر آنے پر بھی ثواب ملتا ہے

نماز کا انتظار:
• فرشتے انتظار کرنے والے کے لیے مغفرت مانگتے ہیں
• "فرشتے اللہ سے مغفرت مانگتے رہتے ہیں جب تک تم نماز کی جگہ ہو۔"
• نماز کا انتظار کرنے والا نماز میں شمار ہوتا ہے

منافقت سے حفاظت:
• باقاعدہ جماعت میں حاضری نفاق سے بچاتی ہے
• نبی کریم ﷺ نے فجر اور عشاء میں جماعت میں نہ آنے والوں کے گھر جلانے کا ارادہ کیا

پہلی صف کا ثواب:
• "اگر لوگ جانیں کہ اذان اور پہلی صف میں کیا ہے، اور قرعہ ڈال کر ہی مل سکے، تو قرعہ ڈالیں۔" (بخاری)
• فرشتے پہلی صف پر رحمت بھیجتے ہیں
• آگے کے لیے بڑا مقابلہ

جمعہ کی نماز:
• مردوں پر فرض
• "جو تین جمعے غفلت سے چھوڑے، اللہ اس کے دل پر مہر لگا دے گا۔" (ترمذی)
• ہفتے کا بہترین دن
• خاص گھڑی جب دعا قبول ہوتی ہے''',
        'hindi': '''नमाज़ बा-जमाअत की फ़ज़ीलत

जमाअत से नमाज़ पढ़ने का बेहद सवाब है और बहुत ज़ोर दिया गया है।

27 गुना ज़्यादा सवाब:
• "जमाअत से नमाज़ अकेले नमाज़ से 27 गुना बेहतर है।" (सहीह बुख़ारी)
• बाज़ रिवायात में 25 गुना है
• यह बढ़ा हुआ सवाब मस्जिद में नमाज़ पढ़ने वालों के लिए है

मस्जिद की तरफ़ चलना:
• ��र क़दम पर सवाब मिलता और गुनाह माफ़ होते हैं
• "जब वो घर से मस्जिद जाता है, एक क़दम दर्जा बुलंद करता और दूसरा गुनाह मिटाता है।" (सहीह मुस्लिम)
• वापस घर आने पर भी सवाब मिलता है

नमाज़ का इंतिज़ार:
• फ़रिश्ते इंतिज़ार करने वाले के लिए मग़फ़िरत मांगते हैं
• "फ़रिश्ते अल्लाह से मग़फ़िरत मांगते रहते हैं जब तक तुम नमाज़ की जगह हो।"
• नमाज़ का इंतिज़ार करने वाला नमाज़ में शुमार होता है

निफ़ाक़ से हिफ़ाज़त:
• बाक़ायदा जमाअत में हाज़िरी निफ़ाक़ से बचाती है
• नबी करीम ﷺ ने फ़ज्र और इशा में जमाअत में न आने वालों के घर जलाने का इरादा किया

पहली सफ़ का सवाब:
• "अगर लोग जानें कि अज़ान और पहली सफ़ में क्या है, और क़ुरआ डालकर ही मिल सके, तो क़ुरआ डालें।" (बुख़ारी)
• फ़रिश्ते पहली सफ़ पर रहमत भेजते हैं
• आगे के लिए बड़ा मुक़ाबला

जुमा की नमाज़:
• मर्दों पर फ़र्ज़
• "जो तीन जुमे ग़फ़लत से छोड़े, अल्लाह उसके दिल पर मुहर लगा देगा।" (तिर्मिज़ी)
• हफ़्ते का बेहतरीन दिन
• ख़ास घड़ी जब दुआ क़बूल होती है''',
        'arabic': '''صلاة الجماعة

فضل الصلاة جماعة في المسجد.

فضل صلاة الجماعة:
• قال النبي ﷺ: "صلاة الجماعة تفضل صلاة الفذ بسبع وعشرين درجة" (البخاري)
• واجبة على الرجال
• سنة مؤكدة للنساء في بيوتهن
• من أعظم شعائر الإسلام

الأجر العظيم:
• من توضأ فأحسن الوضوء ثم مشى إلى المسجد غفر له ما تقدم من ذنبه
• بكل خطوة درجة ومحو سيئة
• "فِي بُيُوتٍ أَذِنَ اللَّهُ أَن تُرْفَعَ" (سورة النور: 36)
• انتظار الصلاة في المسجد عبادة

الصف الأول:
• قال النبي ﷺ: "لو يعلم الناس ما في النداء والصف الأول ثم لم يجدوا إلا أن يستهموا عليه لاستهموا" (البخاري)
• أفضل الصفوف
• التبكير إليه من السنن
• القرب من الإمام أفضل

حكم ترك الجماعة:
• هم النبي ﷺ بتحريق بيوت من تخلف عن الجماعة
• إثم عظيم لمن تركها بلا عذر
• علامة من علامات النفاق
• استحقاق العقوبة في الدنيا والآخرة

آداب صلاة الجماعة:
• التبكير إلى المسجد
• الطهارة والنظافة
• المشي بسكينة ووقار
• سد الفرج واعتدال الصفوف
• متابعة الإمام وعدم مسابقته'''
      },
    },
    {
      'number': 5,
      'titleKey': 'namaz_fazilat_5_sunnah_nafl_prayers',
      'title': 'Sunnah & Nafl Prayers',
      'titleUrdu': 'سنت اور نفل نمازیں',
      'titleHindi': 'सुन्नत और नफ़्ल नमाज़ें',
      'titleArabic': 'صلاة السنة والنافلة',
      'icon': Icons.volunteer_activism,
      'color': Colors.teal,
      'details': {
        'english': '''Sunnah and Voluntary Prayers

In addition to obligatory prayers, voluntary prayers bring immense rewards.

Sunnah Muakkadah (Emphasized Sunnah):
• 2 before Fajr - better than the world
• 4 before Dhuhr, 2 after
• 2 after Maghrib
• 2 after Isha
• Total: 12 rak'ahs guarantee a house in Paradise

Tahajjud (Night Prayer):
• "The best prayer after the obligatory prayers is the night prayer." (Sahih Muslim)
• Best time: last third of the night
• "Our Lord descends to the lowest heaven in the last third of the night and says: 'Who will call upon Me that I may answer?'"

Duha (Forenoon Prayer):
• Time: After sunrise until before Dhuhr
• Minimum: 2 rak'ahs
• "In the morning, charity is due on every joint. Saying Subhanallah is charity... and two rak'ahs of Duha is sufficient for all that." (Sahih Muslim)

Ishraq Prayer:
• After sunrise, waiting 15-20 minutes
• Reward of Hajj and Umrah if one stays in place after Fajr until Ishraq

Tahiyyatul Masjid:
• 2 rak'ahs upon entering mosque
• "When one of you enters the mosque, do not sit until you pray two rak'ahs." (Bukhari)

Salat at-Tawbah:
• Prayer of repentance
• 2 rak'ahs seeking forgiveness

Benefits of Voluntary Prayers:
• Compensate for deficiencies in obligatory prayers
• Bring one closer to Allah
• Extra protection and blessings''',
        'urdu': '''سنت اور نفل نمازیں

فرض نمازوں کے علاوہ، نفل نمازیں بے شمار ثواب لاتی ہیں۔

سنت مؤکدہ:
• فجر سے پہلے 2 - دنیا سے بہتر
• ظہر سے پہلے 4، بعد میں 2
• مغرب کے بعد 2
• عشاء کے بعد 2
• کل: 12 رکعتیں جنت میں گھر کی ضمانت

تہجد (رات کی نماز):
• "فرض نمازوں کے بعد بہترین نماز رات کی نماز ہے۔" (صحیح مسلم)
• بہترین وقت: رات کا آخری تہائی
• "ہمارا رب رات کے آخری تہائی میں آسمان دنیا پر اترتا ہے اور فرماتا ہے: 'کون مجھے پکارے گا کہ میں جواب دوں؟'"

چاشت کی نماز:
• وقت: طلوع آفتاب کے بعد ظہر سے پہلے تک
• کم از کم: 2 رکعت
• "صبح ہر جوڑ پر صدقہ ہے۔ سبحان اللہ کہنا صدقہ ہے... اور چاشت کی دو رکعت یہ سب کافی ہیں۔" (صحیح مسلم)

اشراق کی نماز:
• طلوع آفتاب کے بعد، 15-20 منٹ انتظار
• فجر کے بعد اشراق تک جگہ پر رہنے سے حج اور عمرہ کا ثواب

تحیۃ المسجد:
• مسجد میں داخل ہونے پر 2 رکعت
• "جب تم میں سے کوئی مسجد میں داخل ہو، دو رکعت پڑھے بغیر نہ بیٹھے۔" (بخاری)

صلاۃ التوبہ:
• توبہ کی نماز
• مغفرت مانگتے ہوئے 2 رکعت

نفل نمازوں کے فوائد:
• فرض نمازوں کی کمیوں کی تلافی
• اللہ سے قربت
• اضافی حفاظت اور برکات''',
        'hindi': '''सुन्नत और नफ़्ल नमाज़ें

फ़र्ज़ नमाज़ों के अलावा, नफ़्ल नमाज़ें बेशुमार सवाब लाती हैं।

सुन्नत मुअक्कदा:
• फ़ज्र से पहले 2 - दुनिया से बेहतर
• ज़ुहर से पहले 4, बाद में 2
• मग़रिब के बाद 2
• इशा के बाद 2
• कुल: 12 रकअतें जन्नत में घर की ज़मानत

तहज्जुद (रात की नमाज़):
• "फ़र्ज़ नमाज़ों के बाद बेहतरीन नमाज़ रात की नमाज़ है।" (सहीह मुस्लिम)
• बेहतरीन वक़्त: रात का आख़िरी तिहाई
• "हमारा रब रात के आख़िरी तिहाई में आसमान दुनिया पर उतरता है और फ़रमाता है: 'कौन मुझे पुकारेगा कि मैं जवाब दूं?'"

चाश्त की नमाज़:
• वक़्त: तुलू आफ़ताब के बाद ज़ुहर से पहले तक
• कम से कम: 2 रकअत
• "सुबह हर जोड़ पर सदक़ा है। सुब्हानल्लाह कहना सदक़ा है... और चाश्त की दो रकअत यह सब काफ़ी हैं।" (सहीह मुस्लिम)

इशराक़ की नमाज़:
• तुलू आफ़ताब के बाद, 15-20 मिनट इंतिज़ार
• फ़ज्र के बाद इशराक़ तक जगह पर रहने से हज और उमरा का सवाब

तहिय्यतुल मस्जिद:
• मस्जिद में दाख़िल होने पर 2 रकअत
• "जब तुम में से कोई मस्जिद में दाख़िल हो, दो रकअत पढ़े बग़ैर न बैठे।" (बुख़ारी)

स��ातुत तौबा:
• तौबा की नमाज़
• मग़फ़िरत मांगते हुए 2 रकअत

नफ़्ल नमाज़ों के फ़वाइद:
• फ़र्ज़ नमाज़ों की कमियों की तलाफ़ी
• अल्लाह से क़ुर्बत
• इज़ाफ़ी हिफ़ाज़त और बरकात''',
        'arabic': '''صلاة السنة والنافلة

فضل صلاة النوافل والرواتب.

السنن الرواتب:
• قال النبي ﷺ: "من صلى في يوم وليلة اثنتي عشرة ركعة بنى الله له بيتاً في الجنة" (مسلم)
• ركعتان قبل الفجر
• أربع قبل الظهر وركعتان بعدها
• ركعتان بعد المغرب
• ركعتان بعد العشاء

صلاة الضحى:
• "يُصْبِحُ عَلَىٰ كُلِّ سُلَامَىٰ مِنْ أَحَدِكُمْ صَدَقَةٌ" (البخاري)
• من 2 إلى 12 ركعة
• تجزئ عن صدقة عن كل مفصل
• وقتها من ارتفاع الشمس إلى قبل الزوال

قيام الليل:
• "وَمِنَ اللَّيْلِ فَتَهَجَّدْ بِهِ نَافِلَةً لَّكَ" (سورة الإسراء: 79)
• أفضل الصلاة بعد الفريضة
• قال النبي ﷺ: "أفضل الصلاة بعد الفريضة صلاة الليل" (مسلم)
• الثلث الأخير من الليل أفضل

صلاة الوتر:
• آكد النوافل
• "أَوْتِرُوا يَا أَهْلَ الْقُرْآنِ" (أبو داود)
• من ركعة إلى إحدى عشرة ركعة
• آخر صلاة الليل

تحية المسجد:
• ركعتان عند دخول المسجد
• لا تجلس حتى تصلي ركعتين
• حتى في أوقات النهي
• سنة مؤكدة'''
      },
    },
    {
      'number': 6,
      'titleKey': 'namaz_fazilat_6_prayer_character',
      'title': 'Prayer & Character',
      'titleUrdu': 'نماز اور اخلاق',
      'titleHindi': 'नमाज़ और अख़्लाक़',
      'titleArabic': 'الصلاة والأخلاق',
      'icon': Icons.favorite,
      'color': Colors.red,
      'details': {
        'english': '''Prayer's Effect on Character

True prayer transforms a person's character and behavior.

Prayer Prevents Sin:
• "Indeed, prayer prohibits immorality and wrongdoing." (Quran 29:45)
• Regular prayer should make one avoid sin
• If prayer doesn't stop sin, it's not being prayed properly

Humility and Submission:
• Prayer teaches submission to Allah
• Bowing and prostrating humble the ego
• "Successful indeed are the believers who are humble in their prayers." (Quran 23:1-2)

Patience and Perseverance:
• Five times daily requires discipline
• Fajr especially tests patience
• "Seek help through patience and prayer." (Quran 2:45)

Gratitude:
• Prayer is a form of thanking Allah
• Teaches appreciation for blessings
• The Prophet ﷺ prayed until his feet swelled out of gratitude

Time Management:
• Prayers structure the day
• Teaches punctuality and discipline
• Prevents procrastination

Community Bonds:
• Praying together builds brotherhood
• Standing shoulder to shoulder removes pride
• Shared worship creates unity

Mindfulness:
• Requires presence and focus
• Khushu (humility in prayer) is its soul
• Removes distractions from worldly matters

Signs of Proper Prayer:
• Improved character
• Less sinning
• More patience
• Better relationships
• Increased God-consciousness''',
        'urdu': '''نماز کا اخلاق پر اثر

حقیقی نماز انسان کے اخلاق اور رویے کو بدل دیتی ہے۔

نماز گناہ سے روکتی ہے:
• "بیشک نماز بے حیائی اور برائی سے روکتی ہے۔" (قرآن 29:45)
• باقاعدہ نماز گناہ سے بچنے پر مجبور کرے
• اگر نماز گناہ نہیں روکتی تو صحیح نہیں پڑھی جا رہی

عاجزی اور تسلیم:
• نماز اللہ کے سامنے جھکنا سکھاتی ہے
• رکوع اور سجدہ نفس کو عاجز کرتے ہیں
• "کامیاب ہو گئے مومن جو اپنی نمازوں میں عاجزی کرتے ہیں۔" (قرآن 23:1-2)

صبر اور استقامت:
• روزانہ پانچ بار ضبط چاہیے
• خاص طور پر فجر صبر کا امتحان لیتی ہے
• "صبر اور نماز سے مدد مانگو۔" (قرآن 2:45)

شکر گزاری:
• نماز اللہ کا شکر ادا کرنے کی صورت ہے
• نعمتوں کی قدر سکھاتی ہے
• نبی کریم ﷺ شکر کی وجہ سے اتنی نماز پڑھتے کہ پاؤں سوج جاتے

وقت کا انتظام:
• نمازیں دن کو منظم کرتی ہیں
• وقت کی پابندی اور ضبط سکھاتی ہیں
• سستی روکتی ہیں

معاشرتی رشتے:
• مل کر نماز پڑھنا بھائی چارہ بناتا ہے
• کندھے سے کندھا ملانا تکبر دور کرتا ہے
• مشترکہ عبادت اتحاد پیدا کرتی ہے

حاضر دماغی:
• توجہ اور حضوری چاہیے
• خشوع (نماز میں عاجزی) اس کی روح ہے
• دنیاوی پریشانیوں سے دور کرتی ہے

صحیح نماز کی علامات:
• بہتر اخلاق
• کم گناہ
• زیادہ صبر
• بہتر رشتے
• بڑھا ہوا تقویٰ''',
        'hindi': '''नमाज़ का अख़्लाक़ पर असर

हक़ीक़ी नमाज़ इंसान के अख़्लाक़ और रवय्ये को बदल देती है।

नमाज़ गुनाह से रोकती है:
• "बेशक नमाज़ बेहयाई और बुराई से रोकती है।" (क़ुरआन 29:45)
• बाक़ायदा नमाज़ गुनाह से बचने पर मजबूर करे
• अगर नमाज़ गुनाह नहीं रोकती तो सही नहीं पढ़ी जा रही

आजिज़ी और तस्लीम:
• नमाज़ अल्लाह के सामने झुकना सिखाती है
• रुकू और सज्दा नफ़्स को आजिज़ करते हैं
• "कामयाब हो गए मोमिन जो अपनी नमाज़ों में आजिज़ी करते हैं।" (क़ुरआन 23:1-2)

सब्र और इस्तिक़ामत:
• रोज़ाना पांच बार ज़ब्त चाहिए
• ख़ास तौर पर फ़ज्र सब्र का इम्तिहान लेती है
• "सब्र और नमाज़ से मदद मांगो।" (क़ुरआन 2:45)

शुक्रगुज़ारी:
• नमाज़ अल्लाह का शुक्र अदा करने की सूरत है
• नेमतों की क़द्र सिखाती है
• नबी करीम ﷺ शुक्र की वजह से इतनी नमाज़ पढ़ते कि पांव सूज जाते

वक़्त का इंतिज़ाम:
• नमाज़ें दिन को मुनज़्ज़म करती हैं
• वक़्त की पाबंदी और ज़ब्त सिखाती हैं
• सुस्ती रोकती हैं

मुआशरती रिश्ते:
• मिलकर नमाज़ पढ़ना भाईचारा बनाता है
• कंधे से कंधा मिलाना तकब्बुर दूर करता है
• मुश्तरका इबादत इत्तेहाद पैदा करती है

हाज़िर दिमाग़ी:
• तवज्जोह और हुज़ूरी चाहिए
• ख़ुशू (नमाज़ में आजिज़ी) इसकी रूह है
• दुनियावी परेशानियों से दूर करती है

सही नमाज़ की अलामात:
• बेहतर अख़्लाक़
• कम गुनाह
• ज़्यादा सब्र
• बेहतर रिश्ते
• बढ़ा हुआ तक़वा''',
        'arabic': '''الصلاة والأخلاق

أثر الصلاة على الأخلاق والسلوك.

الخشوع في الصلاة:
• "قَدْ أَفْلَحَ الْمُؤْمِنُونَ * الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ" (سورة المؤمنون: 1-2)
• حضور القلب
• الخوف والرجاء
• تدبر القراءة والأذكار

الصلاة تربي على الصدق:
• "إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ" (سورة العنكبوت: 45)
• تعلم الأمانة والاستقامة
• الوقوف بين يدي الله بصدق
• الإخلاص في العبادة

النظام والانضباط:
• المحافظة على أوقات الصلاة
• الالتزام بشروط الصلاة وأركانها
• الانتظام في صفوف الجماعة
• "وَأَقِمِ الصَّلَاةَ طَرَفَيِ النَّهَارِ" (سورة هود: 114)

التواضع والخضوع:
• السجود أعلى مراتب التواضع
• الخضوع لله في القيام والركوع
• ترك الكبر والعجب
• الشعور بالعبودية الكاملة لله

الرحمة والإحسان:
• المصلي يتعلم الرحمة
• الصلاة تزكي النفس
• تعلم الإحسان إلى الخلق
• "وَأَقِمِ الصَّلَاةَ لِذِكْرِي" (سورة طه: 14)

الصبر والثبات:
• "وَاسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ" (سورة البقرة: 45)
• الصلاة تعين على الشدائد
• تقوي العزيمة
• تثبت القلب'''
      },
    },
    {
      'number': 7,
      'titleKey': 'namaz_fazilat_7_fajr_prayer_virtues',
      'title': 'Virtues of Fajr Prayer',
      'titleUrdu': 'فجر کی نماز کے فضائل',
      'titleHindi': 'फ़ज्र की नमाज़ की फ़ज़ीलत',
      'titleArabic': 'فضائل صلاة الفجر',
      'icon': Icons.wb_twilight,
      'color': Colors.orange,
      'details': {
        'english': '''Virtues of Fajr Prayer

Fajr is the most blessed and virtuous of the five daily prayers with unique rewards.

Under Allah's Protection:
• The Prophet ﷺ said: "Whoever prays Fajr will be under the protection of Allah." (Muslim)
• This protection lasts the entire day
• Angels testify about those who pray Fajr

Two Sunnah Better Than the World:
• The Prophet ﷺ said: "The two rak'ahs before Fajr are better than this world and all it contains." (Muslim)
• He never missed these two rak'ahs, even while traveling
• They should be prayed at home if possible

Witnessed by Angels:
• "Indeed, the recitation of Fajr is witnessed." (Quran 17:78)
• Night and day angels gather during Fajr
• They report to Allah that they left His servants while praying

Reward of Hajj and Umrah:
• "Whoever prays Fajr in congregation, then sits remembering Allah until the sun rises, then prays two rak'ahs (Ishraq), will have a reward like that of Hajj and Umrah - complete, complete, complete." (Tirmidhi)

Light on the Day of Judgment:
• "Give glad tidings to those who walk to the mosques in darkness of complete light on the Day of Resurrection." (Abu Dawud)

Satan's Defeat:
• The Prophet ﷺ said: "Satan ties three knots at the back of your head when you sleep. When you wake and remember Allah, a knot is untied. When you make wudu, a knot is untied. When you pray, all knots are untied." (Bukhari)

Guaranteed Paradise:
• "Whoever prays the two cold prayers (Fajr and Asr) will enter Paradise." (Bukhari)''',
        'urdu': '''فجر کی نماز کے فضائل

فجر پانچ وقت کی نمازوں میں سب سے زیادہ برکت والی ہے۔

اللہ کی حفاظت میں:
• نبی کریم ﷺ نے فرمایا: "جو فجر پڑھے وہ اللہ کی حفاظت میں ہے۔" (مسلم)
• یہ حفاظت پورے دن رہتی ہے

دو سنتیں دنیا سے بہتر:
• نبی کریم ﷺ نے فرمایا: "فجر سے پہلے کی دو رکعتیں اس دنیا اور جو کچھ اس میں ہے سب سے بہتر ہیں۔" (مسلم)

فرشتوں کی گواہی:
• "بیشک فجر کی قراءت میں فرشتے حاضر ہوتے ہیں۔" (قرآن 17:78)
• رات اور دن کے فرشتے فجر میں جمع ہوتے ہیں

حج اور عمرہ کا ثواب:
• "جو فجر جماعت سے پڑھے، پھر طلوع آفتاب تک اللہ کا ذکر کرتا رہے، پھر دو رکعت پڑھے، اسے مکمل حج اور عمرہ کا ثواب ملے گا۔" (ترمذی)

قیامت کے دن نور:
• "جو لوگ اندھیرے میں مسجدوں کی طرف چلتے ہیں انہیں قیامت کے دن مکمل نور کی خوشخبری دو۔" (ابو داؤد)

شیطان کی شکست:
• نبی کریم ﷺ نے فرمایا: "شیطان سونے پر تین گرہیں لگاتا ہے۔ جاگو تو ایک، وضو کرو تو ایک، نماز پڑھو تو سب کھل جاتی ہیں۔" (بخاری)

جنت کی ضمانت:
• "جو دو ٹھنڈی نمازیں (فجر اور عصر) پڑھے وہ جنت میں داخل ہوگا۔" (بخاری)''',
        'hindi': '''फ़ज्र की नमाज़ की फ़ज़ीलत

फ़ज्र पांच वक़्त की नमाज़ों में सबसे ज़्यादा बरकत वाली है।

अल्लाह की हिफ़ाज़त में:
• नबी करीम ﷺ ने फ़रमाया: "जो फ़ज्र पढ़े वो अल्लाह की हिफ़ाज़त में है।" (मुस्लिम)
• यह हिफ़ाज़त पूरे दिन रहती है

दो सुन्नतें दुनिया से बेहतर:
• नबी करीम ﷺ ने फ़रमाया: "फ़ज्र से पहले की दो रकअतें इस दुनिया और जो कुछ उसमें है सबसे बेहतर हैं।" (मुस्लिम)

फ़रिश्तों की गवाही:
• "बेशक फ़ज्र की क़िराअत में फ़रिश्ते हाज़िर होते हैं।" (क़ुरआन 17:78)
• रात और दिन के फ़रिश्ते फ़ज्र में जमा होते हैं

हज और उमरा का सवाब:
• "जो फ़ज्र जमाअत से पढ़े, फिर तुलू आफ़ताब तक अल्लाह का ज़िक्र करता रहे, फिर दो रकअत पढ़े, उसे मुकम्मल हज और उमरा का सवाब मिलेगा।" (तिर्मिज़ी)

क़यामत के दिन नूर:
• "जो लोग अंधेरे में मस्जिदों की तरफ़ चलते हैं उन्हें क़यामत के दिन मुकम्मल नूर की ख़ुशख़बरी दो।" (अबू दाऊद)

शैतान की शिकस्त:
• नबी करीम ﷺ ने फ़रमाया: "शैतान सोने पर तीन गांठें लगाता है। जागो तो एक, वुज़ू करो तो एक, नमाज़ पढ़ो तो सब खुल जाती हैं।" (बुख़ारी)

जन्नत की ज़मानत:
• "जो दो ठंडी नमाज़ें (फ़ज्र और अस्र) पढ़े वो जन्नत में दाख़िल होगा।" (बुख़ारी)''',
        'arabic': '''فضائل صلاة الفجر

صلاة الفجر من أعظم الصلوات وأكثرها بركة.

في ذمة الله:
• قال النبي ﷺ: "من صلى الفجر فهو في ذمة الله." (مسلم)
• هذه الحماية تستمر طوال اليوم

ركعتا الفجر خير من الدنيا:
• قال النبي ﷺ: "ركعتا الفجر خير من الدنيا وما فيها." (مسلم)

صلاة مشهودة:
• "وَقُرْآنَ الْفَجْرِ إِنَّ قُرْآنَ الْفَجْرِ كَانَ مَشْهُودًا" (الإسراء: 78)
• تجتمع ملائكة الليل والنهار في صلاة الفجر

ثواب حجة وعمرة:
• "من صلى الفجر في جماعة ثم قعد يذكر الله حتى تطلع الشمس ثم صلى ركعتين كان له أجر حجة وعمرة تامة." (الترمذي)

نور يوم القيامة:
• "بشر المشائين في الظلم إلى المساجد بالنور التام يوم القيامة." (أبو داود)

هزيمة الشيطان:
• قال النبي ﷺ: "يعقد الشيطان ثلاث عقد، فإذا استيقظ وذكر الله انحلت عقدة، وإذا توضأ انحلت عقدة، وإذا صلى انحلت عقده كلها." (البخا��ي)

ضمان الجنة:
• "من صلى البردين دخل الجنة." (البخاري)'''
      },
    },
    {
      'number': 8,
      'titleKey': 'namaz_fazilat_8_tahajjud_virtues',
      'title': 'Virtues of Tahajjud',
      'titleUrdu': 'تہجد کے فضائل',
      'titleHindi': 'तहज्जुद की फ़ज़ीलत',
      'titleArabic': 'فضائل صلاة التهجد',
      'icon': Icons.nightlight_round,
      'color': Colors.indigo,
      'details': {
        'english': '''Virtues of Tahajjud (Night Prayer)

Tahajjud is the most beloved voluntary prayer to Allah.

Best Prayer After Fard:
• The Prophet ﷺ said: "The best prayer after the obligatory prayers is prayer at night." (Muslim)

Allah Descends to the Lowest Heaven:
• The Prophet ﷺ said: "Our Lord descends every night to the lowest heaven in the last third of the night and says: 'Who will call upon Me that I may answer? Who will ask of Me that I may give?'" (Bukhari)

Custom of the Righteous:
• The Prophet ﷺ said: "You should pray Qiyam al-Layl, for it is the custom of the righteous who came before you. It brings you closer to your Lord and expiates sins." (Tirmidhi)

Expiation of Sins:
• Night prayer wipes away sins
• The Prophet ﷺ said: "It expiates sins and expels disease from the body."

Degrees Based on Recitation:
• "Whoever prays Qiyam reciting ten verses will not be recorded among the negligent."
• "Whoever recites one hundred verses will be recorded among the devout." (Abu Dawud)

Path to Paradise:
• Night prayer is one of the paths to Jannah
• Those who pray at night will be called from a special gate

Praise from Allah:
• "They arise from their beds to call upon their Lord in fear and hope." (Quran 32:16)''',
        'urdu': '''تہجد کے فضائل

تہجد اللہ کو سب سے محبوب نفل نماز ہے۔

فرض کے بعد بہترین نماز:
• نبی کریم ﷺ نے فرمایا: "فرض نمازوں کے بعد سب سے بہترین نماز رات کی نماز ہے۔" (مسلم)

اللہ آسمان دنیا پر اترتا ہے:
• نبی کریم ﷺ نے فرمایا: "ہمارا رب ہر رات کے آخری تہائی میں آسمان دنیا پر اترتا ہے اور فرماتا ہے: 'کون مجھے پکارے؟ کون مجھ سے مانگے؟'" (بخاری)

صالحین کی عادت:
• نبی کریم ﷺ نے فرمایا: "قیام اللیل کرو، یہ تم سے پہلے صالحین کی عادت ہے، اللہ سے قریب کرتی اور گناہ مٹاتی ہے۔" (ترمذی)

گناہوں کا کفارہ:
• رات کی نماز گناہ مٹا دیتی ہے
• نبی کریم ﷺ نے فرمایا: "یہ گناہ مٹاتی اور جسم سے بیماری نکالتی ہے۔"

قراءت پر درجات:
• "جو دس آیات پڑھ کر قیام کرے، غافلوں میں نہیں لکھا جائے گا۔"
• "جو سو آیات پڑھے، عابدین میں لکھا جائے گا۔" (ابو داؤد)

جنت کا راستہ:
• رات کی نماز جنت کے راستوں میں سے ایک ہے
• خاص دروازے سے بلایا جائے گا

اللہ کی تعریف:
• "ان کے پہلو بستروں سے اٹھتے ہیں اپنے رب کو خوف اور امید سے پکارتے ہیں۔" (قرآن 32:16)''',
        'hindi': '''तहज्जुद की फ़ज़ीलत

तहज्जुद अल्लाह को सबसे महबूब नफ़्ल नमाज़ है।

फ़र्ज़ के बाद बेहतरीन नमाज़:
• नबी करीम ﷺ ने फ़रमाया: "फ़र्ज़ नमाज़ों के बाद सबसे बेहतरीन नमाज़ रात की नमाज़ है।" (मुस्लिम)

अल्लाह आसमान दुनिया पर उतरता है:
• नबी करीम ﷺ ने फ़रमाया: "हमारा रब हर रात के आख़िरी तिहाई में आसमान दुनिया पर उतरता है और फ़रमाता है: 'कौन मुझे पुकारे? कौन मुझसे मांगे?'" (बुख़ारी)

सालिहीन की आदत:
• नबी करीम ﷺ ने फ़रमाया: "क़ियामुल लैल करो, यह तुमसे पहले सालिहीन की आदत है, अल्लाह से क़रीब करती और गुनाह मिटाती है।" (तिर्मिज़ी)

गुनाहों का कफ़्फ़ारा:
• रात की नमाज़ गुनाह मिटा देती है
• नबी करीम ﷺ ने फ़रमाया: "यह गुनाह मिटाती और जिस्म से बीमारी निकालती है।"

क़िराअत पर दर्जात:
• "जो दस आयात पढ़कर क़ियाम करे, ग़ाफ़िलों में नहीं लिखा जाएगा।"
• "जो सौ आयात पढ़े, आबिदीन में लिखा जाएगा।" (अबू दाऊद)

जन्नत का रास्ता:
• रात की नमाज़ जन्नत के रास्तों में से एक है
• ख़ास दरवाज़े से बुलाया जाएगा

अल्लाह की तारीफ़:
• "उनके पहलू बिस्तरों से उठते हैं अपने रब को ख़ौफ़ और उम्मीद से पुकारते हैं।" (क़ुरआन 32:16)''',
        'arabic': '''فضائل صلاة التهجد

التهجد أحب صلاة نافلة إلى الله.

أفضل الصلاة بعد الفريضة:
• قال النبي ﷺ: "أفضل الصلاة بعد الفريضة صلاة الليل." (مسلم)

نزول الله إلى السماء الدنيا:
• قال النبي ﷺ: "ينزل ربنا كل ليلة إلى السماء الدنيا حين يبقى ثلث الليل الآخر فيقول: من يدعوني؟ من يسألني؟" (البخاري)

عادة الصالحين:
• قال النبي ﷺ: "عليكم بقيام الليل فإنه دأب الصالحين قبلكم، وقربة إلى الله تعالى، ومنهاة عن الإثم." (الترمذي)

تكفير الذنوب:
• صلاة الليل تمحو الذنوب
• قال النبي ﷺ: "فإنه مطردة للداء عن الجسد."

الدرجات حسب القراءة:
• "من قام بعشر آيات لم يكتب من الغافلين."
• "ومن قام بمائة آية كتب من القانتين." (أبو داود)

طريق الجنة:
• قيام الليل من طرق الجنة
• المصلون بالليل يُدعون من باب خاص

ثناء الله عليهم:
• "تَتَجَافَىٰ جُنُوبُهُمْ عَنِ الْمَضَاجِعِ يَدْعُونَ رَبَّهُمْ خَوْفًا وَطَمَعًا" (السجدة: 16)'''
      },
    },
    {
      'number': 9,
      'titleKey': 'namaz_fazilat_9_jumuah_virtues',
      'title': 'Virtues of Jumu\'ah',
      'titleUrdu': 'جمعہ کے فضائل',
      'titleHindi': 'जुमा की फ़ज़ीलत',
      'titleArabic': 'فضائل الجمعة',
      'icon': Icons.calendar_today,
      'color': Colors.cyan,
      'details': {
        'english': '''Virtues of Jumu'ah (Friday Prayer)

Jumu'ah is the master of all days with unique blessings.

Best Day of the Week:
• The Prophet ﷺ said: "The best day on which the sun has risen is Friday. On it Adam was created, on it he entered Paradise, and the Hour will not be established except on Friday." (Muslim)

Weekly Expiation of Sins:
• "The five daily prayers and Jumu'ah to Jumu'ah are an expiation for what is between them." (Muslim)

Reward of Fasting and Praying a Year:
• "Whoever does ghusl on Friday, sets out early, walks and does not ride, comes close to the imam, listens and does not talk - for every step he will have the reward of fasting and praying for one year." (Tirmidhi)

Hour of Accepted Dua:
• The Prophet ﷺ said: "There is an hour on Friday during which a Muslim does not ask Allah for anything but He will give it to him." (Bukhari)

Reward Based on Arrival Time:
• "Angels stand at the door of the mosque. Whoever comes first gets the reward of sacrificing a camel, then a cow, then a ram." (Bukhari)

Reciting Surah Al-Kahf:
• "Whoever reads Surah Al-Kahf on Friday will have light between the two Fridays." (Nasai)

Warning Against Missing:
• "Whoever misses three Jumu'ahs out of negligence, Allah will seal his heart." (Tirmidhi)''',
        'urdu': '''جمعہ کے فضائل

جمعہ تمام دنوں کا سردار ہے۔

ہفتے کا بہترین دن:
• نبی کریم ﷺ نے فرمایا: "سورج جس دن نکلا ہے اس میں بہترین جمعہ ہے۔ اس دن آدم پیدا ہوئے، جنت میں داخل ہوئے، اور قیامت جمعہ کے دن ہوگی۔" (مسلم)

ہفتہ وار گناہوں کا کفارہ:
• "پانچ نمازیں اور جمعہ سے جمعہ تک درمیان کے گناہوں کا کفارہ ہیں۔" (مسلم)

سال کے روزے اور نماز کا ثواب:
• "جو جمعہ کو غسل کرے، جلدی نکلے، پیدل چلے، امام کے قریب بیٹھے، سنے اور بات نہ کرے - ہر قدم پر سال کے روزے اور نماز کا ثواب۔" (ترمذی)

قبولیت دعا کی گھڑی:
• نبی کریم ﷺ نے فرمایا: "جمعہ میں ایک گھڑی ہے جس میں مسلمان مانگے تو ضرور ملتا ہے۔" (بخاری)

آنے کے وقت پر ثواب:
• "فرشتے مسجد کے دروازے پر لکھتے ہیں۔ پہلے آنے والے کو اونٹ، پھر گائے، پھر مینڈھے کا ثواب۔" (بخاری)

سورہ الکہف پڑھنا:
• "جو جمعہ کو سورہ الکہف پڑھے اسے دو جمعوں کے درمیان نور ملے گا۔" (نسائی)

چھوڑنے پر وعید:
• "جو تین جمعے غفلت سے چھوڑے، اللہ دل پر مہر لگا دے گا۔" (ترمذی)''',
        'hindi': '''जुमा की फ़ज़ीलत

जुमा तमाम दिनों का सरदार है।

हफ़्ते का बेहतरीन दिन:
• नबी करीम ﷺ ने फ़रमाया: "सूरज जिस दिन निकला है उसमें बेहतरीन जुमा है। इस दिन आदम पैदा हुए, जन्नत में दाख़िल हुए, और क़यामत जुमा के दिन होगी।" (मुस्लिम)

हफ़्तावार गुनाहों का कफ़्फ़ारा:
• "पांच नमाज़ें और जुमा से जुमा तक दरमियान के गुनाहों का कफ़्फ़ारा हैं।" (मुस्लिम)

साल के रोज़े और नमाज़ का सवाब:
• "जो जुमा को ग़ुस्ल करे, जल्दी निकले, पैदल चले, इमाम के क़रीब बैठे, सुने और बात न करे - हर क़दम पर साल के रोज़े और नमाज़ का सवाब।" (तिर्मिज़ी)

क़बूलियत दुआ की घड़ी:
• नबी करीम ﷺ ने फ़रमाया: "जुमा में एक घड़ी है जिसमें मुसलमान मांगे तो ज़रूर मिलता है।" (बुख़ारी)

आने के वक़्त पर सवाब:
• "फ़रिश्ते मस्जिद के दरवाज़े पर लिखते हैं। पहले आने वाले को ऊंट, फिर गाय, फिर मेंढ़े का सवाब।" (बुख़ारी)

सूरा अल-कह्फ़ पढ़ना:
• "जो जुमा को सूरा अल-कह्फ़ पढ़े उसे दो जुमों के दरमियान नूर मिलेगा।" (नसाई)

छोड़ने पर वईद:
• "जो तीन जुमे ग़फ़लत से छोड़े, अल्लाह दिल पर मुहर लगा देगा।" (तिर्मिज़ी)''',
        'arabic': '''فضائل الجمعة

الجمعة سيد الأيام.

خير يوم في الأسبوع:
• قال النبي ﷺ: "خير يوم طلعت عليه الشمس يوم الجمعة، فيه خُلق آدم، وفيه أُدخل الجنة، ولا تقوم الساعة إلا في يوم الجمعة." (مسلم)

تكفير الذنوب الأسبوعية:
• "الصلوات الخمس والجمعة إلى الجمعة كفارة لما بينهن." (مسلم)

ثواب صيام وصلاة سنة:
• "من اغتسل يوم الجمعة ثم بكر وابتكر، ومشى ولم يركب، ودنا من الإمام فاستمع ولم يلغ، كان له بكل خطوة أجر سنة صيامها وقيامها." (الترمذي)

ساعة الإجابة:
• قال النبي ﷺ: "إن في الجمعة لساعة لا يوافقها عبد مسلم يسأل الله شيئاً إلا أعطاه إياه." (البخاري)

الثواب حسب وقت الحضور:
• "إذا كان يوم الجمعة وقفت الملائكة على باب المسجد يكتبون الأول فالأول." (البخاري)

قراءة سورة الكهف:
• "من قرأ سورة الكهف يوم الجمعة أضاء له من النور ما بين الجمعتين." (النسائي)

التحذير من الترك:
• "من ترك ثلاث جمع تهاوناً طبع الله على قلبه." (الترمذي)'''
      },
    },
    {
      'number': 10,
      'titleKey': 'namaz_fazilat_10_sujood_virtues',
      'title': 'Virtues of Prostration',
      'titleUrdu': 'سجدے کے فضائل',
      'titleHindi': 'सज्दे की फ़ज़ीलत',
      'titleArabic': 'فضائل السجود',
      'icon': Icons.south,
      'color': Colors.brown,
      'details': {
        'english': '''Virtues of Prostration (Sujood)

Sujood is the greatest pillar of prayer and the moment of closest proximity to Allah.

Closest to Allah:
• The Prophet ﷺ said: "The closest a servant is to his Lord is when he is prostrating, so increase your supplications therein." (Muslim)

Command to Prostrate and Draw Near:
• "Rather, prostrate and draw near [to Allah]." (Quran 96:19)

Elevation and Forgiveness:
• The Prophet ﷺ said: "Prostrate much, for there is no Muslim who prostrates to Allah except that Allah raises him one degree in Paradise and removes one sin from him." (Muslim)

Satan Weeps:
• The Prophet ﷺ said: "When the son of Adam prostrates, Satan withdraws weeping and says: 'Woe to me! He was commanded to prostrate and he prostrated, so Paradise is for him. I was commanded to prostrate and I refused, so Hellfire is for me.'" (Muslim)

The Mark of Believers:
• "Their mark will be on their faces from the traces of prostration." (Quran 48:29)
• Light on the forehead on Day of Judgment

Ultimate Humility:
• Prostration is the ultimate expression of submission
• The forehead on the ground, the heart raised to the heavens

Best Position for Dua:
• Make abundant dua in prostration
• Dua in sujood is more likely to be answered''',
        'urdu': '''سجدے کے فضائل

سجدہ نماز کا سب سے بڑا رکن ہے اور اللہ سے سب سے زیادہ قربت کا لمحہ ہے۔

اللہ سے سب سے قریب:
• نبی کریم ﷺ نے فرمایا: "بندہ رب سے سب سے قریب سجدے میں ہوتا ہے، اس میں کثرت سے دعا کرو۔" (مسلم)

سجدہ کرو اور قریب ہو جاؤ:
• "سجدہ کرو اور [اللہ سے] قریب ہو جاؤ۔" (قرآن 96:19)

درجات اور مغفرت:
• نبی کریم ﷺ نے فرمایا: "بہت سجدے کرو، کوئی مسلمان سجدہ نہیں کرتا مگر اللہ ایک درجہ بلند اور ایک گناہ مٹاتا ہے۔" (مسلم)

شیطان روتا ہے:
• نبی کریم ﷺ نے فرمایا: "جب ابن آدم سجدہ کرتا ہے، شیطان روتا ہوا کہتا ہے: 'اسے سجدہ کا حکم ہوا تو کیا، اس کے لیے جنت۔ مجھے حکم ہوا تو انکار کیا، میرے لیے جہنم۔'" (مسلم)

مومنوں کی نشانی:
• "ان کی نشانی چہروں پر سجدوں کے نشان سے ہے۔" (قرآن 48:29)
• قیامت کے دن پیشانی پر نور

انتہائی عاجزی:
• سجدہ تسلیم کا سب سے بڑا اظہار ہے
• پیشانی زمین پر، دل آسمانوں کی طرف بلند

دعا کے لیے بہترین حالت:
• سجدے میں کثرت سے دعا کرو
• سجدے میں دعا قبول ہونے کا زیادہ امکان ہے''',
        'hindi': '''सज्दे की फ़ज़ीलत

सज्दा नमाज़ का सबसे बड़ा रुक्न है और अल्लाह से सबसे ज़्यादा क़ुर्बत का लम्हा है।

अल्लाह से सबसे क़रीब:
• नबी करीम ﷺ ने फ़रमाया: "बंदा रब से सबसे क़रीब सज्दे में होता है, उसमें कसरत से दुआ करो।" (मुस्लिम)

सज्दा करो और क़रीब हो जाओ:
• "सज्दा करो और [अल्लाह से] क़रीब हो जाओ।" (क़ुरआन 96:19)

दर्जात और मग़फ़िरत:
• नबी करीम ﷺ ने फ़रमाया: "बहुत सज्दे करो, कोई मुसलमान सज्दा नहीं करता मगर अल्लाह एक दर्जा बुलंद और एक गुनाह मिटाता है।" (मुस्लिम)

शैतान रोता है:
• नबी करीम ﷺ ने फ़रमाया: "जब इब्ने आदम सज्दा करता है, शैतान रोता हुआ कहता है: 'उसे सज्दे का हुक्म हुआ तो किया, उसके लिए जन्नत। मुझे हुक्म हुआ तो इंकार किया, मेरे लिए जहन्नम।'" (मुस्लिम)

मोमिनों की निशानी:
• "उनकी निशानी चेहरों पर सज्दों के निशान से है।" (क़ुरआन 48:29)
• क़यामत के दिन पेशानी पर नूर

इंतिहाई आजिज़ी:
• सज्दा तस्लीम का सबसे बड़ा इज़हार है
• पेशानी ज़मीन पर, दिल आसमानों की तरफ़ बुलंद

दुआ के लिए बेहतरीन हालत:
• सज्दे में कसरत से दुआ करो
• सज्दे में दुआ क़बूल होने का ज़्यादा इमकान है''',
        'arabic': '''فضائل السجود

السجود أعظم أركان الصلاة وأقرب ما يكون العبد من ربه.

أقرب ما يكون العبد من ربه:
• قال النبي ﷺ: "أقرب ما يكون العبد من ربه وهو ساجد، فأكثروا الدعاء." (مسلم)

الأمر بالسجود والاقتراب:
• "كَلَّا لَا تُطِعْهُ وَاسْجُدْ وَاقْتَرِب" (العلق: 19)

الرفعة والمغفرة:
• قال النبي ﷺ: "أكثروا السجود فإنه ليس من عبد يسجد لله سجدة إلا رفعه الله بها درجة، وحط عنه بها خطيئة." (مسلم)

بكاء الشيطان:
• قال النبي ﷺ: "إذا سجد ابن آدم اعتزل الشيطان يبكي يقول: أمر ابن آدم بالسجود فسجد فله الجنة، وأمرت بالسجود فأبيت فلي النار." (مسلم)

سيماء المؤمنين:
• "سِيمَاهُمْ فِي وُجُوهِهِم مِّنْ أَثَرِ السُّجُودِ" (الفتح: 29)
• نور في الجبهة يوم القيامة

غاية التواضع:
• السجود أعلى مراتب الخضوع لله
• الجبهة على الأرض والقلب معلق بالسماء

أفضل حال للدعاء:
• أكثروا من الدعاء في السجود
• الدعاء في السجود أحرى بالإجابة'''
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<SettingsProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr('namaz_fazilat'),
          style: TextStyle(
            color: Colors.white,
            fontSize: context.responsive.textLarge,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        padding: context.responsive.paddingRegular,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _namazTopics.length,
          itemBuilder: (context, index) {
            final topic = _namazTopics[index];
            return _buildTopicCard(topic, isDark);
          },
        ),
      ),
    );
  }


  Widget _buildTopicCard(Map<String, dynamic> topic, bool isDark) {
    final langCode = context.languageProvider.languageCode;
    final title = context.tr(topic['titleKey'] ?? 'namaz_fazilat');
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
return Container(
      margin: responsive.paddingOnly(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isDark ? Colors.grey.shade700 : lightGreenBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showTopicDetails(topic),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingAll(14),
          child: Row(
            children: [
              // Number Badge
              Container(
                width: responsive.iconLarge * 1.5,
                height: responsive.iconLarge * 1.5,
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2.0),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${topic['number']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.textLarge,
                    ),
                  ),
                ),
              ),
              responsive.hSpaceSmall,

              // Title and Icon chip
              Expanded(
                child: Column(
                  crossAxisAlignment: (langCode == 'ur' || langCode == 'ar')
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: responsive.textLarge,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextPrimary : darkGreen,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textDirection: (langCode == 'ur' || langCode == 'ar')
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                    responsive.vSpaceXSmall,
                    // Icon chip
                    Container(
                      padding: responsive.paddingSymmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3ED),
                        borderRadius: BorderRadius.circular(responsive.radiusSmall),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            topic['icon'] as IconData,
                            size: responsive.textXSmall + 2,
                            color: emeraldGreen,
                          ),
                          responsive.hSpaceXSmall,
                          Flexible(
                            child: Text(
                              context.tr('namaz_fazilat'),
                              style: TextStyle(
                                fontSize: responsive.textXSmall,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Container(
                padding: responsive.paddingAll(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8F5A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: responsive.textXSmall + 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTopicDetails(Map<String, dynamic> topic) {
    final details = topic['details'] as Map<String, String>;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BasicAmalDetailScreen(
          title: topic['title'] ?? '',
          titleUrdu: topic['titleUrdu'] ?? '',
          titleHindi: topic['titleHindi'] ?? '',
          titleArabic: topic['titleArabic'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          contentArabic: details['arabic'] ?? '',
          color: topic['color'] as Color,
          icon: topic['icon'] as IconData,
          categoryKey: 'category_namaz_fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
