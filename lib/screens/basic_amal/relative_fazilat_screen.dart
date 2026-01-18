import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/settings_provider.dart';
import 'basic_amal_detail_screen.dart';

class RelativeFazilatScreen extends StatefulWidget {
  const RelativeFazilatScreen({super.key});

  @override
  State<RelativeFazilatScreen> createState() => _RelativeFazilatScreenState();
}

class _RelativeFazilatScreenState extends State<RelativeFazilatScreen> {
  String _selectedLanguage = 'english';

  final Map<String, String> _titles = {
    'english': 'Relatives - Maintaining Family Ties',
    'urdu': 'رشتہ دار - صلہ رحمی',
    'hindi': 'रिश्तेदार - सिला रहमी',
  };

  final List<Map<String, dynamic>> _relativeTopics = [
    {
      'number': 1,
      'title': 'Importance of Silat ar-Rahm',
      'titleUrdu': 'صلہ رحمی کی اہمیت',
      'titleHindi': 'सिला रहमी की अहमियत',
      'icon': Icons.connect_without_contact,
      'color': Colors.green,
      'details': {
        'english': '''Importance of Silat ar-Rahm (Maintaining Family Ties)

Maintaining family ties is one of the most emphasized acts in Islam.

What is Silat ar-Rahm:
• Literally means "connecting the womb" - maintaining blood relations
• Includes kindness, visiting, helping, and showing love to relatives
• Encompasses all family members - near and distant
• Not limited to those who are kind to you

Great Rewards:
• "And fear Allah through whom you ask one another, and the wombs. Indeed Allah is ever, over you, an Observer." (Quran 4:1)
• Increases lifespan and sustenance
• The Prophet ﷺ said: "Whoever would like his provision to be increased and his lifespan to be extended should maintain family ties." (Bukhari & Muslim)
• Causes blessings in wealth and children
• Protects from sudden death

Entry to Paradise:
• Maintaining family ties is a pathway to Paradise
• The Prophet ﷺ said: "You will not enter Paradise until you believe, and you will not believe until you love one another." (Muslim)
• The merciful are shown mercy by the Most Merciful
• Family ties are a means of intercession

Punishment for Breaking Ties:
• One of the quickest sins to be punished
• "Would you perhaps, if you turned away, cause corruption on earth and sever your ties of relationship?" (Quran 47:22)
• Prevents prayers from being accepted
• The Prophet ﷺ said: "The one who severs family ties will not enter Paradise." (Bukhari & Muslim)
• Deprived of Allah's mercy

Who Are Your Relatives:
• Parents and grandparents
• Children and grandchildren
• Siblings and their children
• Uncles, aunts, and their children
• All those related by blood
• Extended family members

How to Maintain Ties:
• Visit them regularly
• Call or message to check on them
• Give gifts on special occasions
• Help in times of need
• Invite them for meals
• Attend family gatherings
• Make dua for them
• Forgive their mistakes''',
        'urdu': '''صلہ رحمی کی اہمیت

صلہ رحمی اسلام میں سب سے زیادہ زور دیے گئے اعمال میں سے ایک ہے۔

صلہ رحمی کیا ہے:
• لفظی معنی "رحم کو جوڑنا" - خونی رشتوں کو برقرار رکھنا
• رشتہ داروں سے مہربانی، ملاقات، مدد اور محبت شامل ہے
• تمام خاندانی اراکین - قریبی اور دور کے
• صرف ان تک محدود نہیں جو آپ کے ساتھ اچھے ہیں

بڑے ثواب:
• "اور اللہ سے ڈرو جس کے نام پر تم ایک دوسرے سے مانگتے ہو، اور رحموں سے۔ بیشک اللہ تم پر نگران ہے۔" (قرآن 4:1)
• عمر اور رزق میں اضافہ
• نبی کریم ﷺ نے فرمایا: "جو چاہے کہ اس کا رزق بڑھے اور عمر دراز ہو، وہ صلہ رحمی کرے۔" (بخاری و مسلم)
• مال اور اولاد میں برکت
• اچانک موت سے حفاظت

جنت میں داخلہ:
• صلہ رحمی جنت کا راستہ ہے
• نبی کریم ﷺ نے فرمایا: "تم جنت میں داخل نہیں ہو سکتے جب تک ایمان نہ لاؤ، اور ایمان نہیں لا سکتے جب تک ایک دوسرے سے محبت نہ کرو۔" (مسلم)
• رحم کرنے والوں پر رحمان رحم کرتا ہے
• صلہ رحمی شفاعت کا ذریعہ ہے

رشتے توڑنے کی سزا:
• سب سے جلد سزا دیے جانے والے گناہوں میں سے
• "کیا تم نے اگر منہ پھیر لیا تو زمین میں فساد کرو گے اور اپنے رشتے توڑو گے؟" (قرآن 47:22)
• دعائیں قبول نہیں ہوتیں
• نبی کریم ﷺ نے فرمایا: "رشتے توڑنے والا جنت میں داخل نہیں ہوگا۔" (بخاری و مسلم)
• اللہ کی رحمت سے محروم

آپ کے رشتہ دار کون ہیں:
• والدین اور دادا دادی، نانا نانی
• بچے اور پوتے پوتیاں
• بہن بھائی اور ان کے بچے
• چچا، خالہ، پھوپھی، ماموں اور ان کے بچے
• تمام خونی رشتہ دار
• وسیع خاندانی اراکین

رشتے کیسے برقرار رکھیں:
• باقاعدگی سے ملاقات کریں
• فون یا پیغام سے خبر گیری کریں
• خاص مواقع پر تحائف دیں
• ضرورت کے وقت مدد کریں
• کھانے پر بلائیں
• خاندانی اجتماعات میں شرکت کریں
• ان کے لیے دعا کریں
• ان کی غلطیوں کو معاف کریں''',
        'hindi': '''सिला रहमी की अहमियत

सिला रहमी इस्लाम में सबसे ज़्यादा ज़ोर दिए गए आमाल में से एक है।

सिला रहमी क्या है:
• लफ़्ज़ी मअना "रहम को जोड़ना" - ख़ूनी रिश्तों को बरक़रार रखना
• रिश्तेदारों से मेहरबानी, मुलाक़ात, मदद और मोहब्बत शामिल है
• तमाम ख़ानदानी अराकीन - क़रीबी और दूर के
• सिर्फ़ उन तक महदूद नहीं जो आपके साथ अच्छे हैं

बड़े सवाब:
• "और अल्लाह से डरो जिसके नाम पर तुम एक दूसरे से मांगते हो, और रहमों से। बेशक अल्लाह तुम पर निगरान है।" (क़ुरआन 4:1)
• उम्र और रिज़्क़ में इज़ाफ़ा
• नबी करीम ﷺ ने फ़रमाया: "जो चाहे कि उसका रिज़्क़ बढ़े और उम्र दराज़ हो, वो सिला रहमी करे।" (बुख़ारी व मुस्लिम)
• माल और औलाद में बरकत
• अचानक मौत से हिफ़ाज़त

जन्नत में दाख़िला:
• सिला रहमी जन्नत का रास्ता है
• नबी करीम ﷺ ने फ़रमाया: "तुम जन्नत में दाख़िल नहीं हो सकते जब तक ईमान न लाओ, और ईमान नहीं ला सकते जब तक एक दूसरे से मोहब्बत न करो।" (मुस्लिम)
• रहम करने वालों पर रहमान रहम करता है
• सिला रहमी शफ़ाअत का ज़रीआ है

रिश्ते तोड़ने की सज़ा:
• सबसे जल्द सज़ा दिए जाने वाले गुनाहों में से
• "क्या तुमने अगर मुंह फेर लिया तो ज़मीन में फ़साद करोगे और अपने रिश्ते तोड़ोगे?" (क़ुरआन 47:22)
• दुआएं क़बूल नहीं होतीं
• नबी करीम ﷺ ने फ़रमाया: "रिश्ते तोड़ने वाला जन्नत में दाख़िल नहीं होगा।" (बुख़ारी व मुस्लिम)
• अल्लाह की रहमत से महरूम

आपके रिश्तेदार कौन हैं:
• वालिदैन और दादा दादी, नाना नानी
• बच्चे और पोते पोतियां
• बहन भाई और उनके बच्चे
• चाचा, ख़ाला, फूफी, मामूं और उनके बच्चे
• तमाम ख़ूनी रिश्तेदार
• वसी ख़ानदानी अराकीन

रिश्ते कैसे बरक़रार रखें:
• बाक़ायदगी से मुलाक़ात करें
• फ़ोन या पैग़ाम से ख़बरगीरी करें
• ख़ास मवाक़े पर तोहफ़े दें
• ज़रूरत के वक़्त मदद करें
• खाने पर बुलाएं
• ख़ानदानी इजतिमाआत में शिरकत करें
• उनके लिए दुआ करें
• उनकी ग़लतियों को माफ़ करें''',
      },
    },
    {
      'number': 2,
      'title': 'Dealing with Difficult Relatives',
      'titleUrdu': 'مشکل رشتہ داروں سے نمٹنا',
      'titleHindi': 'मुश्किल रिश्तेदारों से निपटना',
      'icon': Icons.handshake,
      'color': Colors.orange,
      'details': {
        'english': '''Dealing with Difficult Relatives

True test of maintaining ties is when relatives are difficult.

The Prophet's Teaching:
• A man came to the Prophet ﷺ and said: "I have relatives with whom I try to keep ties, but they cut me off. I treat them well, but they treat me badly. I am gentle with them, but they are harsh towards me."
• The Prophet ﷺ said: "If you are as you say, it is as if you are putting hot ashes in their mouths. Allah will continue to support you as long as you continue to do that." (Muslim)

Patience is Key:
• Don't respond to evil with evil
• "Repel evil with that which is better." (Quran 41:34)
• Continue kindness despite mistreatment
• Remember the reward is with Allah
• Your good character will eventually win hearts

When They Wrong You:
• Forgive their mistakes
• Don't seek revenge
• Pray for their guidance
• Keep communication open
• Set boundaries if needed
• Don't gossip about them to others

When They Cut You Off:
• Don't cut them off in return
• Keep reaching out periodically
• Send greetings through others
• Make dua for them
• Give gifts if appropriate
• Be the first to reconcile

Financial Issues:
• If they owe you money, be patient
• Don't demand harshly
• Consider forgiving the debt if they're struggling
• Don't let money destroy relationships
• "And if someone is in hardship, then let there be postponement until a time of ease." (Quran 2:280)

Protecting Your Rights:
• You can maintain ties while protecting yourself
• Set healthy boundaries
• Don't enable bad behavior
• Seek advice from wise people
• Involve elders for mediation if needed
• Distance yourself if they're harmful to your faith

Remember:
• Your reward is for your effort, not their response
• Allah sees your sincerity
• Don't expect perfection from imperfect humans
• Focus on pleasing Allah, not them
• The harder it is, the greater the reward''',
        'urdu': '''مشکل رشتہ داروں سے نمٹنا

رشتے برقرار رکھنے کا اصل امتحان اس وقت ہوتا ہے جب رشتہ دار مشکل ہوں۔

نبی کریم ﷺ کی تعلیم:
• ایک آدمی نبی کریم ﷺ کے پاس آیا اور کہا: "میرے رشتہ دار ہیں جن سے میں رشتہ برقرار رکھنے کی کوشش کرتا ہوں، لیکن وہ مجھے کاٹ دیتے ہیں۔ میں ان کے ساتھ اچھا سلوک کرتا ہوں، لیکن وہ میرے ساتھ برا سلوک کرتے ہیں۔ میں ان کے ساتھ نرم ہوں، لیکن وہ مجھ پر سخت ہیں۔"
• نبی کریم ﷺ نے فرمایا: "اگر تم جیسا کہتے ہو ویسے ہو، تو یہ ایسے ہے جیسے تم ان کے منہ میں گرم راکھ ڈال رہے ہو۔ اللہ تمہاری مدد جاری رکھے گا جب تک تم یہ کرتے رہو۔" (مسلم)

صبر کلیدی ہے:
• برائی کا جواب برائی سے نہ دیں
• "برائی کو اس چیز سے دور کرو جو بہتر ہے۔" (قرآن 41:34)
• بدسلوکی کے باوجود مہربانی جاری رکھیں
• یاد رکھیں ثواب اللہ کے پاس ہے
• آپ کا اچھا کردار آخرکار دل جیت لے گا

جب وہ آپ پر ظلم کریں:
• ان کی غلطیوں کو معاف کریں
• بدلہ نہ لیں
• ان کی ہدایت کے لیے دعا کریں
• رابطہ کھلا رکھیں
• ضرورت ہو تو حدود مقرر کریں
• دوسروں سے ان کی غیبت نہ کریں

جب وہ آپ کو کاٹ دیں:
• بدلے میں انہیں نہ کاٹیں
• وقتاً فوقتاً رابطہ کرتے رہیں
• دوسروں کے ذریعے سلام بھیجیں
• ان کے لیے دعا کریں
• مناسب ہو تو تحائف دیں
• صلح کے لیے پہل کریں

مالی مسائل:
• اگر وہ آپ کے مقروض ہیں تو صبر کریں
• سختی سے مطالبہ نہ کریں
• اگر وہ مشکل میں ہیں تو قرض معاف کرنے پر غور کریں
• پیسے کو رشتوں کو تباہ نہ کرنے دیں
• "اور اگر کوئی تنگ دست ہے تو آسانی تک مہلت دی جائے۔" (قرآن 2:280)

اپنے حقوق کی حفاظت:
• رشتے برقرار رکھتے ہوئے اپنی حفاظت کر سکتے ہیں
• صحت مند حدود مقرر کریں
• بری عادتوں کو فروغ نہ دیں
• دانشمند لوگوں سے مشورہ لیں
• ضرورت ہو تو بزرگوں کو بیچ میں لائیں
• اگر وہ آپ کے ایمان کے لیے نقصان دہ ہیں تو فاصلہ بنائیں

یاد رکھیں:
• آپ کا ثواب آپ کی کوشش کے لیے ہے، ان کے جواب کے لیے نہیں
• اللہ آپ کی خلوص دیکھتا ہے
• ناقص انسانوں سے کمال کی توقع نہ رکھیں
• اللہ کو خوش کرنے پر توجہ دیں، انہیں نہیں
• جتنا مشکل ہوگا، ثواب اتنا زیادہ ہوگا''',
        'hindi': '''मुश्किल रिश्तेदारों से निपटना

रिश्ते बरक़रार रखने का असल इम्तिहान उस वक़्त होता है ���ब रिश्तेदार मुश्किल हों।

नबी करीम ﷺ की तालीम:
• एक आदमी नबी करीम ﷺ के पास आया और कहा: "मेरे रिश्तेदार हैं जिनसे मैं रिश्ता बरक़रार रखने की कोशिश करता हूं, लेकिन वो मुझे काट देते हैं। मैं उनके साथ अच्छा सुलूक करता हूं, लेकिन वो मेरे साथ बुरा सुलूक करते हैं। मैं उनके साथ नरम हूं, लेकिन वो मुझ पर सख़्त हैं।"
• नबी करीम ﷺ ने फ़रमाया: "अगर तुम जैसा कहते हो वैसे हो, तो यह ऐसे है जैसे तुम उनके मुंह में गरम राख डाल रहे हो। अल्लाह तुम्हारी मदद जारी रखेगा जब तक तुम यह करते रहो।" (मुस्लिम)

सब्र कुंजी है:
• बुराई का जवाब बुराई से न दें
• "बुराई को उस चीज़ से दूर करो जो बेहतर है।" (क़ुरआन 41:34)
• बदसुलूकी के बावजूद मेहरबानी जारी रखें
• याद रखें सवाब अल्लाह के पास है
• आपका अच्छा किरदार आख़िरकार दिल जीत लेगा

जब वो आप पर ज़ुल्म करें:
• उनकी ग़लतियों को माफ़ करें
• बदला न लें
• उनकी हिदायत के लिए दुआ करें
• राबिता खुला रखें
• ज़रूरत हो तो हुदूद मुक़र्रर करें
• दूसरों से उनकी ग़ीबत न करें

जब वो आपको काट दें:
• बदले में उन्हें न काटें
• वक़्तन फ़ौक़्तन राबिता करते रहें
• दूसरों के ज़रीए सलाम भेजें
• उनके लिए दुआ करें
• मुनासिब हो तो तोहफ़े दें
• सुलह के लिए पहल करें

माली मसाइल:
• अगर वो आपके मक़रूज़ हैं तो सब्र करें
• सख़्ती से मुतालबा न करें
• अगर वो मुश्किल में हैं तो क़र्ज़ माफ़ करने पर ग़ौर करें
• पैसे को रिश्तों को तबाह न करने दें
• "और अगर कोई तंगदस्त है तो आसानी तक मोहलत दी जाए।" (क़ुरआन 2:280)

अपने हुक़ूक़ की हिफ़ाज़त:
• रिश्ते बरक़रार रखते हुए अपनी हिफ़ाज़त कर सकते हैं
• सेहतमंद हुदूद मुक़र्रर करें
• बुरी आदतों को फ़रोग़ न दें
• दानिशमंद लोगों से मशवरा लें
• ज़रूरत हो तो बुज़ुर्गों को बीच में लाएं
• अगर वो आपके ईमान के लिए नुक़सानदेह हैं तो फ़ासला बनाएं

याद रखें:
• आपका सवाब आपकी कोशिश के लिए है, उनके जवाब के लिए नहीं
• अल्लाह आपकी ख़ुलूस देखता है
• नाक़िस इंसानों से कमाल की तवक़्क़ो न रखें
• अल्लाह को ख़ुश करने पर तवज्जोह दें, उन्हें नहीं
• जितना मुश्किल होगा, सवाब उतना ज़्यादा होगा''',
      },
    },
    {
      'number': 3,
      'title': 'Neighbors as Extended Family',
      'titleUrdu': 'پڑوسی - وسیع خاندان کی طرح',
      'titleHindi': 'पड़ोसी - वसी ख़ानदान की तरह',
      'icon': Icons.home_work,
      'color': Colors.blue,
      'details': {
        'english': '''Neighbors as Extended Family

Islam places great emphasis on the rights of neighbors.

Status of Neighbors:
• "Worship Allah and associate nothing with Him, and to parents do good, and to relatives and orphans and the needy and the near neighbor and the neighbor farther away." (Quran 4:36)
• The Prophet ﷺ said: "Jibreel kept advising me about the neighbor until I thought he would make him an heir." (Bukhari & Muslim)
• Neighbors have rights similar to relatives

Three Categories:
1. Muslim neighbor who is a relative - has three rights: right of Islam, right of kinship, and right of being a neighbor
2. Muslim neighbor - has two rights: right of Islam and right of being a neighbor
3. Non-Muslim neighbor - has the right of being a neighbor

Rights of Neighbors:
• Do not harm them in any way
• Be patient with their harm
• Share food with them
• The Prophet ﷺ said: "He is not a believer who eats his fill while his neighbor beside him is hungry." (Bayhaqi)
• Help them in times of need
• Visit when they are sick
• Congratulate in times of joy
• Offer condolences in times of grief

Good Neighbor Qualities:
• Greeting with Salam
• Lowering gaze and respecting privacy
• Not peeking into their homes
• Keeping noise levels down
• Not blocking their access
• Sharing fruits and good things
• Lending items when needed

Bad Neighbor Warning:
• A woman asked: "O Messenger of Allah, so-and-so prays at night, fasts during the day, does good deeds and gives charity, but she harms her neighbors with her tongue." He said: "She is in the Fire." (Ahmad)
• Good worship doesn't excuse bad behavior to neighbors
• How you treat neighbors reflects your faith

Practical Steps:
• Introduce yourself to new neighbors
• Exchange phone numbers
• Offer help proactively
• Invite them for meals
• Share your blessings
• Be there in emergencies
• Create community bonds

Building Community:
• Organize neighborhood gatherings
• Establish watch programs
• Help elderly neighbors
• Create play areas for children
• Collaborate on neighborhood improvements
• Resolve conflicts peacefully''',
        'urdu': '''پڑوسی - وسیع خاندان کی طرح

اسلام نے پڑوسیوں کے حقوق پر بہت زور دیا ہے۔

پڑوسیوں کا مقام:
• "اللہ کی عبادت کرو اور اس کے ساتھ کسی کو شریک نہ ٹھہراؤ، اور والدین کے ساتھ اچھا سلوک کرو اور رشتہ داروں، یتیموں، محتاجوں اور قریبی پڑوسی اور دور کے پڑوسی کے ساتھ۔" (قرآن 4:36)
• نبی کریم ﷺ نے فرمایا: "جبریل مجھے پڑوسی کے بارے میں نصیحت کرتے رہے یہاں تک کہ میں نے سوچا کہ وہ اسے وارث بنا دیں گے۔" (بخاری و مسلم)
• پڑوسیوں کے رشتہ داروں جیسے حقوق ہیں

تین قسمیں:
1. مسلمان پڑوسی جو رشتہ دار بھی ہے - تین حقوق: اسلام کا حق، رشتہ داری کا حق، اور پڑ��سی ہونے کا حق
2. مسلمان پڑوسی - دو حقوق: اسلام کا حق اور پڑوسی ہونے کا حق
3. غیر مسلم پڑوسی - پڑوسی ہونے کا حق

پڑوسیوں کے حقوق:
• کسی بھی طرح سے انہیں نقصان نہ پہنچائیں
• ان کے نقصان پر صبر کریں
• ان کے ساتھ کھانا بانٹیں
• نبی کریم ﷺ نے فرمایا: "وہ مومن نہیں جو پیٹ بھر کر کھائے جبکہ اس کا پڑوسی بھوکا ہو۔" (بیہقی)
• ضرورت کے وقت مدد کریں
• بیماری میں ملاقات کریں
• خوشی کے موقع پر مبارکباد دیں
• غم کے وقت تعزیت کریں

اچھے پڑوسی کی خصوصیات:
• سلام کے ساتھ ملاقات
• نگاہ جھکانا اور رازداری کا احترام
• ان کے گھروں میں جھانکنا نہیں
• شور کی سطح کم رکھنا
• ان کے راستے میں رکاوٹ نہ ڈالنا
• پھل اور اچھی چیزیں بانٹنا
• ضرورت پڑنے پر چیزیں ادھار دینا

برے پڑوسی کی تنبیہ:
• ایک عورت نے پوچھا: "اے اللہ کے رسول، فلاں عورت رات کو نماز پڑھتی ہے، دن میں روزہ رکھتی ہے، نیک کام کرتی ہے اور صدقہ دیتی ہے، لیکن وہ اپنی زبان سے اپنے پڑوسیوں کو تکلیف دیتی ہے۔" آپ نے فرمایا: "وہ جہنم میں ہے۔" (احمد)
• اچھی عبادت پڑوسیوں کے ساتھ برے سلوک کا بہانہ نہیں بنتی
• پڑوسیوں کے ساتھ آپ کا سلوک آپ کے ایمان کی عکاسی کرتا ہے

عملی قدم:
• نئے پڑوسیوں سے اپنا تعارف کرائیں
• فون نمبر تبدیل کریں
• فعال طور پر مدد کی پیشکش کریں
• انہیں کھانے پر بلائیں
• اپنی برکتیں بانٹیں
• ہنگامی حالات میں موجود رہیں
• کمیونٹی کے بندھن بنائیں

کمیونٹی بنانا:
• محلے کے اجتماعات کا اہتمام کریں
• نگرانی کے پروگرام قائم کریں
• بوڑھے پڑوسیوں کی مدد کریں
• بچوں کے لیے کھیل کے علاقے بنائیں
• محلے کی بہتری پر تعاون کریں
• تنازعات کو امن سے حل کریں''',
        'hindi': '''पड़ोसी - वसी ख़ानदान की तरह

इस्लाम ने पड़ोसियों के हुक़ूक़ पर बहुत ज़ोर दिया है।

पड़ोसियों का मक़ाम:
• "अल्लाह की इबादत करो और उसके साथ किसी को शरीक न ठहराओ, और वालिदैन के साथ अच्छा सुलूक करो और रिश्तेदारों, यतीमों, मोहताजों और क़रीबी पड़ोसी और दूर के पड़ोसी के साथ।" (क़ुरआन 4:36)
• नबी करीम ﷺ ने फ़रमाया: "जिबरील मुझे पड़ोसी के बारे में नसीहत करते रहे यहां तक कि मैंने सोचा कि वो उसे वारिस बना देंगे।" (बुख़ारी व मुस्लिम)
• पड़ोसियों के रिश्तेदारों जैसे हुक़ूक़ हैं

तीन क़िस्में:
1. मुसलमान पड़ोसी जो रिश्तेदार भी है - तीन हुक़ूक़: इस्लाम का हक़, रिश्तेदारी का हक़, और पड़ोसी होने का हक़
2. मुसलमान पड़ोसी - दो हुक़ूक़: इस्लाम का हक़ और पड़ोसी होने का हक़
3. ग़ैर मुस्लिम पड़ोसी - पड़ोसी होने का हक़

पड़ोसियों के हुक़ूक़:
• किसी भी तरह से उन्हें नुक़सान न पहुंचाएं
• उनके नुक़सान पर सब्र करें
• उनके साथ खाना बांटें
• नबी करीम ﷺ ने फ़रमाया: "वो मोमिन नहीं जो पेट भरकर खाए जबकि उसका पड़ोसी भूखा हो।" (बैहक़ी)
• ज़रूरत के वक़्त मदद करें
• बीमारी में मुलाक़ात करें
• ख़ुशी के मौक़े पर मुबारकबाद दें
• ग़म के वक़्त ताज़ियत करें

अच्छे पड़ोसी की ख़ुसूसियात:
• सलाम के साथ मुलाक़ात
• निगाह झुकाना और राज़दारी का एहतराम
• उनके घरों में झांकना नहीं
• शोर की सतह कम रखना
• उनके रास्ते में रुकावट न डालना
• फल और अच्छी चीज़ें बांटना
• ज़रूरत पड़ने पर चीज़ें उधार देना

बुरे पड़ोसी की तंबीह:
• एक औरत ने पूछा: "ऐ अल्लाह के रसूल, फ़लां औरत रात को नमाज़ पढ़ती है, दिन में रोज़ा रखती है, नेक काम करती है और सदक़ा देती है, लेकिन वो अपनी ज़बान से अपने पड़ोसियों को तकलीफ़ देती है।" आपने फ़रमाया: "वो जहन्नम में है।" (अहमद)
• अच्छी इबादत पड़ोसियों के साथ बुरे सुलूक का बहाना नहीं बनती
• पड़ोसियों के साथ आपका सुलूक आपके ईमान की अक्कासी करता है

अमली क़दम:
• नए पड़ोसियों से अपना तआरुफ़ कराएं
• फ़ोन नंबर तबदील करें
• फ़ेअल तौर पर मदद की पेशकश करें
• उन्हें खाने पर बुलाएं
• अपनी बरकतें बांटें
• हंगामी हालात में मौजूद रहें
• कम्युनिटी के बंधन बनाएं

कम्युनिटी बनाना:
• मोहल्ले के इजतिमाआत का एहतमाम करें
• निगरानी के प्रोग्राम क़ायम करें
• बूढ़े पड़ोसियों की मदद करें
• बच्चों के लिए खेल के इलाक़े बनाएं
• मोहल्ले की बेहतरी पर तआवुन करें
• तनाज़ुआत को अमन से हल करें''',
      },
    },
    {
      'number': 4,
      'title': 'Muslim Brotherhood',
      'titleUrdu': 'مسلم بھائی چارہ',
      'titleHindi': 'मुस्लिम भाईचारा',
      'icon': Icons.groups_2,
      'color': Colors.purple,
      'details': {
        'english': '''Muslim Brotherhood (Ukhuwwah)

All Muslims are brothers and sisters in faith.

The Bond of Islam:
• "The believers are but brothers, so make settlement between your brothers." (Quran 49:10)
• Islamic brotherhood transcends race, nationality, and tribe
• Stronger than blood relations
• The Prophet ﷺ established brotherhood between Muhajireen and Ansar

Rights of Muslim Brothers:
• Help when they need assistance
• Visit when they are sick
• Attend their funerals
• Accept their invitations
• Give sincere advice
• Love them for Allah's sake
• Pray for them in their absence

The Prophet's Description:
• "The example of the believers in their affection, mercy, and compassion for each other is that of a body. When any limb aches, the whole body reacts with sleeplessness and fever." (Bukhari & Muslim)
• "A Muslim is a brother of another Muslim. He does not wrong him, nor does he forsake him when he is in need." (Muslim)

What to Avoid:
• Don't envy them
• Don't spy on them
• Don't backbite about them
• Don't hate them
• Don't compete in worldly matters
• Don't break promises to them
• Don't rejoice at their misfortune

Loving for Allah's Sake:
• The Prophet ﷺ said: "Allah will say on the Day of Resurrection: 'Where are those who loved each other for My glory? Today I will shade them with My shade on the day when there is no shade but Mine.'" (Muslim)
• Purest form of love
• Continues in the Hereafter
• Based on righteousness and faith

Building Brotherhood:
• Regular gatherings for remembrance of Allah
• Sharing meals together
• Helping in times of need
• Celebrating joys together
• Consoling in sorrows
• Making dua for each other
• Gift-giving increases love

Unity of Ummah:
• Don't create divisions
• Don't follow different sects blindly
• Return to Quran and Sunnah
• Respect differences of opinion
• Work together for common good
• "And hold firmly to the rope of Allah all together and do not become divided." (Quran 3:103)''',
        'urdu': '''مسلم بھائی چارہ (اخوت)

تمام مسلمان ایمان میں بھائی بہن ہیں۔

اسلام کا رشتہ:
• "مومن آپس میں بھائی ہیں، تو اپنے بھائیوں میں صلح کراؤ۔" (قرآن 49:10)
• اسلامی بھائی چارہ نسل، قومیت اور قبیلے سے بالاتر ہے
• خونی رشتوں سے مضبوط
• نبی کریم ﷺ نے مہاجرین اور انصار کے درمیان بھائی چارہ قائم کیا

مسلمان بھائیوں کے حقوق:
• ضرورت کے وقت مدد کریں
• بیماری میں ملاقات کریں
• ان کے جنازے میں شرکت کریں
• ان کی دعوتیں قبول کریں
• مخلصانہ نصیحت کریں
• اللہ کی خاطر ان سے محبت کریں
• ان کی غیر موجودگی میں ان کے لیے دعا کریں

نبی کریم ﷺ کی تشبیہ:
• "مومنوں کی مثال ان کی محبت، رحمت اور شفقت میں جسم کی طرح ہے۔ جب کوئی عضو درد کرتا ہے تو پورا جسم بے خوابی اور بخار سے متاثر ہوتا ہے۔" (بخاری و مسلم)
• "مسلمان دوسرے مسلمان کا بھائی ہے۔ وہ اس پر ظلم نہیں کرتا، نہ ضرورت کے وقت اسے چھوڑتا ہے۔" (مسلم)

کیا نہ کریں:
• ان سے حسد نہ کریں
• ان کی جاسوسی نہ کریں
• ان کی غیبت نہ کریں
• ان سے نفرت نہ کریں
• دنیاوی معاملات میں مقابلہ نہ کریں
• ان سے وعدے نہ توڑیں
• ان کی مصیبت پر خوش نہ ہوں

اللہ کی خاطر محبت:
• نبی کریم ﷺ نے فرمایا: "اللہ قیامت کے دن فرمائے گا: 'کہاں ہیں وہ جو میری خاطر ایک دوسرے سے محبت کرتے تھے؟ آج میں انہیں اپنے سائے میں جگہ دوں گا جس دن میرے سائے کے سوا کوئی سایہ نہیں۔'" (مسلم)
• محبت کی سب سے پاک صورت
• آخرت میں بھی جاری رہتی ہے
• نیکی اور ایمان پر مبنی

بھائی چارہ بنانا:
• اللہ کی یاد کے لیے باقاعدہ اجتماعات
• ساتھ کھانا کھانا
• ضرورت کے وقت مدد کرنا
• خوشیاں ساتھ منانا
• غموں میں تسلی دینا
• ایک دوسرے کے لیے دعا کرنا
• تحائف دینا محبت بڑھاتا ہے

امت کی وحدت:
• تقسیم نہ کریں
• اندھا دھند مختلف فرقوں کی پیروی نہ کریں
• قرآن اور سنت کی طرف لوٹیں
• اختلاف رائے کا احترام کریں
• مشترکہ بھلائی کے لیے مل کر کام کریں
• "اور اللہ کی رسی کو مضبوطی سے تھامو اور تفرقہ نہ ڈالو۔" (قرآن 3:103)''',
        'hindi': '''मुस्लिम भाईचारा (उख़ुव्वत)

तमाम मुसलमान ईमान में भाई बहन हैं।

इस्लाम का रिश्ता:
• "मोमिन आपस में भाई हैं, तो अपने भाइयों में सुलह कराओ।" (क़ुरआन 49:10)
• इस्लामी भाईचारा नस्ल, क़ौमियत और क़बीले से बालातर है
• ख़ूनी रिश्तों से मज़बूत
• नबी करीम ﷺ ने मुहाजिरीन और अंसार के दरमियान भाईचारा क़ायम किया

मुसलमान भाइयों के हुक़ूक़:
• ज़रूरत के वक़्त मदद करें
• बीमारी में मुलाक़ात करें
• उनके जनाज़े में शिरकत करें
• उनकी दावतें क़बूल करें
• मुख़्लिसाना नसीहत करें
• अल्लाह की ख़ातिर उनसे मोहब्बत करें
• उनकी ग़ैर मौजूदगी में उनके लिए दुआ करें

नबी करीम ﷺ की तशबीह:
• "मोमिनों की मिसाल उनकी मोहब्बत, रहमत और शफ़क़त में जिस्म की तरह है। जब कोई उज़्व दर्द करता है तो पूरा जिस्म बेख़्वाबी और बुख़ार से मुतास्सिर होता है।" (बुख़ारी व मुस्लिम)
• "मुसलमान दूसरे मुसलमान का भाई है। वो उस पर ज़ुल्म नहीं करता, न ज़रूरत के वक़्त उसे छोड़ता है।" (मुस्लिम)

क्या न करें:
• उनसे हसद न करें
• उनकी जासूसी न करें
• उनकी ग़ीबत न करें
• उनसे नफ़रत न करें
• दुनियावी मुआमलात में मुक़ाबला न करें
• उनसे वादे न तोड़ें
• उनकी मुसीबत पर ख़ुश न हों

अल्लाह की ख़ातिर मोहब्बत:
• नबी करीम ﷺ ने फ़रमाया: "अल्लाह क़यामत के दिन फ़रमाएगा: 'कहां हैं वो जो मेरी ख़ातिर एक दूसरे से मोहब्बत करते थे? आज मै�� उन्हें अपने साए में जगह दूंगा जिस दिन मेरे साए के सिवा कोई साया नहीं।'" (मुस्लिम)
• मोहब्बत की सबसे पाक सूरत
• आख़िरत में भी जारी रहती है
• नेकी और ईमान पर मबनी

भाईचारा बनाना:
• अल्लाह की याद के लिए बाक़ायदा इजतिमाआत
• साथ खाना खाना
• ज़रूरत के वक़्त मदद करना
• ख़ुशियां साथ मनाना
• ग़मों में तसल्ली देना
• एक दूसरे के लिए दुआ करना
• तोहफ़े देना मोहब्बत बढ़ाता है

उम्मत की वहदत:
• तक़सीम न करें
• अंधा धुंध मुख़्तलिफ़ फ़िर्क़ों की पैरवी न करें
• क़ुरआन और सुन्नत की तरफ़ लौटें
• इख़्तिलाफ़ राय का एहतराम करें
• मुश्तरका भलाई के लिए मिलकर काम करें
• "और अल्लाह की रस्सी को मज़बूती से थामो और तफ़र्क़ा न डालो।" (क़ुरआन 3:103)''',
      },
    },
    {
      'number': 5,
      'title': 'Inheritance & Family Wealth',
      'titleUrdu': 'وراثت اور خاندانی دولت',
      'titleHindi': 'विरासत और ख़ानदानी दौलत',
      'icon': Icons.account_balance,
      'color': Colors.amber,
      'details': {
        'english': '''Inheritance & Family Wealth

Islamic inheritance laws preserve family bonds and ensure justice.

Divine Distribution:
• "For men is a share of what the parents and close relatives leave, and for women is a share of what the parents and close relatives leave." (Quran 4:7)
• Inheritance laws are fixed by Allah
• Not optional or changeable by anyone
• Violating them is among major sins

Importance of Following Islamic Law:
• The Prophet ﷺ said: "Give the shares to those who are entitled to them, and what remains goes to the nearest male heir." (Bukhari & Muslim)
• Protects rights of all family members
• Prevents disputes and injustice
• Women's rights are guaranteed

Common Violations to Avoid:
• Depriving daughters of their share
• Giving preference to one child over another
• Using cultural traditions instead of Islamic law
• Delaying distribution of inheritance
• Hiding assets from rightful heirs

The Sin of Injustice:
• "Indeed, those who devour the property of orphans unjustly are only consuming into their bellies fire." (Quran 4:10)
• Taking someone's rightful share is severe oppression
• Will be held accountable on Day of Judgment
• Can destroy family relationships

Preparing Your Will:
• Write a will according to Islamic law
• Cannot will more than 1/3 of your estate
• Cannot give inheritance to an heir (they already have fixed shares)
• The 1/3 is for non-heirs (charity, distant relatives, etc.)
• The Prophet ﷺ said: "It is not permissible for any Muslim who has something to will to stay for two nights without having his will written down." (Bukhari & Muslim)

Maintaining Unity:
• Distribute inheritance promptly
• Be content with your share
• Don't compete or argue over wealth
• Remember: "You will leave it behind for others"
• Reconcile before disputes arise
• Seek help from Islamic scholars if unclear

Family Wealth Guidelines:
• Spend on poor relatives first before others
• Don't cut ties due to wealth differences
• Rich should help poor family members
• Avoid showing off wealth
• Teach children about proper wealth management
• Make lawful income only''',
        'urdu': '''وراثت اور خاندانی دولت

اسلامی وراثت کے قوانین خاندانی بندھن کو محفوظ رکھتے اور انصاف کو یقینی بناتے ہیں۔

الٰہی تقسیم:
• "مردوں کے لیے حصہ ہے جو والدین اور قریبی رشتہ دار چھوڑیں، اور عورتوں کے لیے بھی حصہ ہے جو والدین اور قریبی رشتہ دار چھوڑیں۔" (قرآن 4:7)
• وراثت کے قوانین اللہ نے مقرر کیے ہیں
• اختیاری یا کسی کے ذریعہ تبدیل نہیں کیے جا سکتے
• ان کی خلاف ورزی کبیرہ گناہوں میں سے ہے

اسلامی قانون کی پیروی کی اہمیت:
• نبی کریم ﷺ نے فرمایا: "حصے حقداروں کو دو، اور جو بچے وہ قریب ترین مرد وارث کو جائے۔" (بخاری و مسلم)
• تمام خاندانی اراکین کے حقوق کی حفاظت
• جھگڑوں اور ناانصافی سے بچاتا ہے
• عورتوں کے حقوق کی ضمانت

عام خلاف ورزیاں جن سے بچنا چاہیے:
• بیٹیوں کو ان کے حصے سے محروم کرنا
• ایک بچے کو دوسرے پر ترجیح دینا
• اسلامی قانون کی بجائے ثقافتی روایات استعمال کرنا
• وراثت کی تقسیم میں تاخیر
• حقدار وارثوں سے اثاثے چھپانا

ناانصافی کا گناہ:
• "بیشک جو یتیموں کا مال ناحق کھاتے ہیں وہ اپنے پیٹ میں صرف آگ بھرتے ہیں۔" (قرآن 4:10)
• کسی کا حق لینا شدید ظلم ہے
• قیامت کے دن جوابدہ ہوں گے
• خاندانی رشتوں کو تباہ کر سکتا ہے

اپنی وصیت تیار کرنا:
• اسلامی قانون کے مطابق وصیت لکھیں
• اپنی جائیداد کے 1/3 سے زیادہ کی وصیت نہیں کر سکتے
• وارث کو وراثت نہیں دے سکتے (ان کے پہلے سے مقررہ حصے ہیں)
• 1/3 غیر وارثوں کے لیے ہے (صدقہ، دور کے رشتہ دار وغیرہ)
• نبی کریم ﷺ نے فرمایا: "کسی بھی مسلمان کے لیے جس کے پاس وصیت کرنے کی کوئی چیز ہو، دو راتیں گزارنا جائز نہیں کہ اس کی وصیت لکھی ہوئی نہ ہو۔" (بخاری و مسلم)

اتحاد برقرار رکھنا:
• وراثت فوری طور پر تقسیم کریں
• اپنے حصے پر مطمئن رہیں
• دولت پر مقابلہ یا جھگڑا نہ کریں
• یاد رکھیں: "تم اسے دوسروں کے لیے چھوڑ جاؤ گے"
• جھگڑے پیدا ہونے سے پہلے صلح کریں
• واضح نہ ہو تو اسلامی علماء سے مدد لیں

خاندانی دولت کی رہنمائی:
• پہلے غریب رشتہ داروں پر خرچ کریں
• دولت کے فرق کی وجہ سے رشتے نہ توڑیں
• امیر غریب خاندانی اراکین کی مدد کریں
• دولت کا دکھاوا کرنے سے بچیں
• بچوں کو دولت کے صحیح انتظام کے بارے میں سکھائیں
• صرف حلال آمدنی کمائیں''',
        'hindi': '''विरासत और ख़ानदानी दौलत

इस्लामी विरासत के क़वानीन ख़ानदानी बंधन को महफ़ूज़ रखते और इंसाफ़ को यक़ीनी बनाते हैं।

इलाही तक़सीम:
• "मर्दों के लिए हिस्सा है जो वालिदैन और क़रीबी रिश्तेदार छोड़ें, और औरतों ��े लिए भी हिस्सा है जो वालिदैन और क़रीबी रिश्तेदार छोड़ें।" (क़ुरआन 4:7)
• विरासत के क़वानीन अल्लाह ने मुक़र्रर किए हैं
• इख़्तियारी या किसी के ज़रीआ तबदील नहीं किए जा सकते
• उनकी ख़िलाफ़वर्ज़ी कबीरा गुनाहों में से है

इस्लामी क़ानून की पैरवी की अहमियत:
• नबी करीम ﷺ ने फ़रमाया: "हिस्से हक़दारों को दो, और जो बचे वो क़रीबतरीन मर्द वारिस को जाए।" (बुख़ारी व मुस्लिम)
• तमाम ख़ानदानी अराकीन के हुक़ूक़ की हिफ़ाज़त
• झगड़ों और नाइंसाफ़ी से बचाता है
• औरतों के हुक़ूक़ की ज़मानत

आम ख़िलाफ़वर्ज़ियां जिनसे बचना चाहिए:
• बेटियों को उनके हिस्से से महरूम करना
• एक बच्चे को दूसरे पर तरजीह देना
• इस्लामी क़ानून की बजाए सक़ाफ़ती रिवायतें इस्तेमाल करना
• विरासत की तक़सीम में तअख़ीर
• हक़दार वारिसों से असासे छुपाना

नाइंसाफ़ी का गुनाह:
• "बेशक जो यतीमों का माल नाहक़ खाते हैं वो अपने पेट में सिर्फ़ आग भरते हैं।" (क़ुरआन 4:10)
• किसी का हक़ लेना शदीद ज़ुल्म है
• क़यामत के दिन जवाबदेह होंगे
• ख़ानदानी रिश्तों को तबाह कर सकता है

अपनी वसीयत तैयार करना:
• इस्लामी क़ानून के मुताबिक़ वसीयत लिखें
• अपनी जायदाद के 1/3 से ज़्यादा की वसीयत नहीं कर सकते
• वारिस को विरासत नहीं दे सकते (उनके पहले से मुक़र्ररा हिस्से हैं)
• 1/3 ग़ैर वारिसों के लिए है (सदक़ा, दूर के रिश्तेदार वग़ैरह)
• नबी करीम ﷺ ने फ़रमाया: "किसी भी मुसलमान के लिए जिसके पास वसीयत करने की कोई चीज़ हो, दो रातें गुज़ारना जाइज़ नहीं कि उसकी वसीयत लिखी हुई न हो।" (बुख़ारी व मुस्लिम)

इत्तेहाद बरक़रार रखना:
• विरासत फ़ौरन तक़सीम करें
• अपने हिस्से पर मुतमइन रहें
• दौलत पर मुक़ाबला या झगड़ा न करें
• याद रखें: "तुम इसे दूसरों के लिए छोड़ जाओगे"
• झगड़े पैदा होने से पहले सुलह करें
• वाज़ेह न हो तो इस्लामी उलमा से मदद लें

ख़ानदानी दौलत की रहनुमाई:
• पहले ग़रीब रिश्तेदारों पर ख़र्च करें
• दौलत के फ़र्क़ की वजह से रिश्ते न तोड़ें
• अमीर ग़रीब ख़ानदानी अराकीन की मदद करें
• दौलत का दिखावा करने से बचें
• बच्चों को दौलत के सही इंतिज़ाम के बारे में सिखाएं
• सिर्फ़ हलाल आमदनी कमाएं''',
      },
    },
    {
      'number': 6,
      'title': 'Breaking Family Ties',
      'titleUrdu': 'خاندانی تعلقات توڑنا',
      'titleHindi': 'ख़ानदानी तअल्लुक़ात तोड़ना',
      'icon': Icons.link_off,
      'color': Colors.red,
      'details': {
        'english': '''Breaking Family Ties (Qat ar-Rahm)

Severing family ties is among the gravest sins in Islam.

The Severe Warning:
• "Would you perhaps, if you turned away, cause corruption on earth and sever your ties of relationship? Those are the ones that Allah has cursed." (Quran 47:22-23)
• One of the quickest sins to be punished
• Causes curse from Allah
• Prevents entry to Paradise

The Prophet's Statement:
• "The one who severs family ties will not enter Paradise." (Bukhari & Muslim)
• This is a severe warning
• Shows the gravity of this sin
• Emphasizes importance of maintaining ties

What Breaks Family Ties:
• Completely cutting off communication
• Refusing to visit or be visited
• Harboring hatred and enmity
• Not helping in times of need
• Ignoring their rights
• Speaking badly about them
• Rejoicing at their misfortune

Common Excuses (Not Valid):
• "They did wrong to me first"
• "They are difficult to deal with"
• "I'm too busy"
• "They don't respect me"
• "We had a small argument"
• None of these excuses justify breaking ties

How Long is Too Long:
• The Prophet ﷺ said: "It is not permissible for a Muslim to forsake his brother for more than three days." (Bukhari & Muslim)
• Some scholars say for relatives it's even less
• Don't let sun set on your anger
• Reconcile as soon as possible

How to Reconcile:
• Make the first move
• Don't wait for them to apologize
• Send greetings through others
• Give a gift
• Visit them personally
• Make dua for strength to reconcile
• Remember Allah's reward for maintaining ties

If They Refuse:
• Keep trying periodically
• Don't give up completely
• Make dua for them
• Send gifts and greetings
• Your reward is with Allah
• The sin is on the one who refuses

Prevention is Better:
• Don't let small issues become big
• Forgive quickly
• Communicate openly
• Address problems early
• Remember blood is thicker than pride
• Think of Allah's pleasure, not ego

The Reconnection:
• "Whoever is pleased that his provision be increased and his lifespan extended should maintain family ties." (Bukhari)
• Immediate blessings in this life
• Reward in the Hereafter
• Peace of mind and heart
• Allah's pleasure''',
        'urdu': '''خاندانی تعلقات توڑنا (قطع رحم)

خاندانی تعلقات توڑنا اسلام میں سب سے بڑے گناہوں میں سے ہے۔

سخت تنبیہ:
• "کیا تم نے اگر منہ پھیر لیا تو زمین میں فساد کرو گے اور اپنے رشتے توڑو گے؟ یہ وہ لوگ ہیں جن پر اللہ نے لعنت کی ہے۔" (قرآن 47:22-23)
• سب سے جلد سزا دیے جانے والے گناہوں میں سے
• اللہ کی لعنت کا سبب
• جنت میں داخلے سے روکتا ہے

نبی کریم ﷺ کا بیان:
• "رشتے توڑنے والا جنت میں داخل نہیں ہوگا۔" (بخاری و مسلم)
• یہ سخت ��نبیہ ہے
• اس گناہ کی سنگینی ظاہر کرتا ہے
• رشتے برقرار رکھنے کی اہمیت پر زور دیتا ہے

کیا رشتے توڑتا ہے:
• مکمل طور پر رابطہ کاٹنا
• ملاقات کرنے یا ملنے سے انکار
• نفرت اور دشمنی رکھنا
• ضرورت کے وقت مدد نہ کرنا
• ان کے حقوق کو نظرانداز کرنا
• ان کے بارے میں برا بولنا
• ان کی مصیبت پر خوش ہونا

عام بہانے (درست نہیں):
• "انہوں نے پہلے میرے ساتھ غلط کیا"
• "ان سے نمٹنا مشکل ہے"
• "میں بہت مصروف ہوں"
• "وہ میرا احترام نہیں کرتے"
• "ہماری چھوٹی سی بحث ہوئی"
• ان میں سے کوئی بھی بہانہ رشتے توڑنے کو جائز نہیں بناتا

کتنا لمبا بہت زیادہ ہے:
• نبی کریم ﷺ نے فرمایا: "کسی مسلمان کے لیے جائز نہیں کہ وہ اپنے بھائی سے تین دن سے زیادہ ناراض رہے۔" (بخاری و مسلم)
• کچھ علماء کہتے ہیں کہ رشتہ داروں کے لیے یہ اور بھی کم ہے
• اپنے غصے پر سورج غروب نہ ہونے دیں
• جتنی جلدی ممکن ہو صلح کریں

کیسے صلح کریں:
• پہل کریں
• ان کی معذرت کا انتظار نہ کریں
• دوسروں کے ذریعے سلام بھیجیں
• تحفہ دیں
• خود جا کر ملیں
• صلح کی طاقت کے لیے دعا کریں
• اللہ کے ثواب کو یاد رکھیں

اگر وہ انکار کریں:
• وقتاً فوقتاً کوشش جاری رکھیں
• مکمل طور پر ہار نہ مانیں
• ان کے لیے دعا کریں
• تحائف اور سلام بھیجیں
• آپ کا ثواب اللہ کے پاس ہے
• گناہ انکار کرنے والے پر ہے

روک تھام بہتر ہے:
• چھوٹے مسائل کو بڑا نہ ہونے دیں
• جلدی معاف کریں
• کھل کر بات کریں
• مسائل کو جلدی حل کریں
• یاد رکھیں خون تکبر سے گاڑھا ہے
• اللہ کی خوشی سوچیں، انا نہیں

دوبارہ جڑنا:
• "جو چاہے کہ اس کا رزق بڑھے اور عمر دراز ہو، وہ صلہ رحمی کرے۔" (بخاری)
• اس زندگی میں فوری برکتیں
• آخرت میں ثواب
• دل و دماغ کا سکون
• اللہ کی خوشی''',
        'hindi': '''ख़ानदानी तअल्लुक़ात तोड़ना (क़त अर-रहम)

ख़ानदानी तअल्लुक़ात तोड़ना इस्लाम में सबसे बड़े गुनाहों में से है।

सख़्त तंबीह:
• "क्या तुमने अगर मुंह फेर लिया तो ज़मीन में फ़साद करोगे और अपने रिश्ते तोड़ोगे? यह वो लोग हैं जिन पर अल्लाह ने लानत की है।" (क़ुरआन 47:22-23)
• सबसे जल्द सज़ा दिए जाने वाले गुनाहों में से
• अल्लाह की लानत का सबब
• जन्नत में दाख़िले से रोकता है

नबी करीम ﷺ का बयान:
• "रिश्ते तोड़ने वाला जन्नत में दाख़िल नहीं होगा।" (बुख़ारी व मुस्लिम)
• यह सख़्त तंबीह है
• इस गुनाह की संगीनी ज़ाहिर करता है
• रिश्ते बरक़रार रखने की अहमियत पर ज़ोर देता है

क्या रिश्ते तोड़ता है:
• मुकम्मल तौर पर राबिता काटना
• मुलाक़ात करने या मिलने से इंकार
• नफ़रत और दुश्मनी रखना
• ज़रूरत के वक़्त मदद न करना
• उनके हुक़ूक़ को नज़रअंदाज़ करना
• उनके बारे में बुरा बोलना
• उनकी मुसीबत पर ख़ुश होना

आम बहाने (दुरुस्त नहीं):
• "उन्होंने पहले मेरे साथ ग़लत किया"
• "उनसे निपटना मुश्किल है"
• "मैं बहुत मसरूफ़ हूं"
• "वो मेरा एहतराम नहीं करते"
• "हमारी छोटी सी बहस हुई"
• इनमें से कोई भी बहाना रिश्ते तोड़ने को जाइज़ नहीं बनाता

कितना लंबा बहुत ज़्यादा है:
• नबी करीम ﷺ ने फ़रमाया: "किसी मुसलमान के लिए जाइज़ नहीं कि वो अपने भाई से तीन दिन से ज़्यादा नाराज़ रहे।" (बुख़ारी व मुस्लिम)
• कुछ उलमा कहते हैं कि रिश्तेदारों के लिए यह और भी कम है
• अपने ग़ुस्से पर सूरज ग़ुरूब न होने दें
• जितनी जल्दी मुमकिन हो सुलह करें

कैसे सुलह करें:
• पहल करें
• उनकी माफ़ी का इंतिज़ार न करें
• दूसरों के ज़रीए सलाम भेजें
• तोहफ़ा दें
• ख़ुद जाकर मिलें
• सुलह की ताक़त के लिए दुआ करें
• अल्लाह के सवाब को याद रखें

अगर वो इंकार करें:
• वक़्तन फ़ौक़्तन कोशिश जारी रखें
• मुकम्मल तौर पर हार न मानें
• उनके लिए दुआ करें
• तोहफ़े और सलाम भेजें
• आपका सवाब अल्लाह के पास है
• गुनाह इंकार करने वाले पर है

रोकथाम बेहतर है:
• छोटे मसाइल को बड़ा न होने दें
• जल्दी माफ़ करें
• खुलकर बात करें
• मसाइल को जल्दी हल करें
• याद रखें ख़ून तकब्बुर से गाढ़ा है
• अल्लाह की ख़ुशी सोचें, अना नहीं

दोबारा जुड़ना:
• "जो चाहे कि उसका रिज़्क़ बढ़े और उम्र दराज़ हो, वो सिला रहमी करे।" (बुख़ारी)
• इस ज़िंदगी में फ़ौरी बरकतें
• आख़िरत में सवाब
• दिल व दिमाग़ का सुकून
• अल्लाह की ख़ुशी''',
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
          _titles[_selectedLanguage]!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedLanguage == 'urdu'
                    ? 'اردو'
                    : _selectedLanguage == 'hindi'
                    ? 'हिंदी'
                    : 'EN',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (value) => setState(() => _selectedLanguage = value),
            itemBuilder: (context) => [
              _buildLanguageMenuItem('english', 'English'),
              _buildLanguageMenuItem('urdu', 'اردو'),
              _buildLanguageMenuItem('hindi', 'हिंदी'),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _relativeTopics.length,
              itemBuilder: (context, index) {
                final topic = _relativeTopics[index];
                return _buildTopicCard(topic, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildLanguageMenuItem(String value, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          if (_selectedLanguage == value)
            Icon(Icons.check, color: AppColors.primary, size: 18)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: _selectedLanguage == value
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: _selectedLanguage == value ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(Map<String, dynamic> topic, bool isDark) {
    final title = _selectedLanguage == 'english'
        ? topic['title']
        : _selectedLanguage == 'urdu'
        ? topic['titleUrdu']
        : topic['titleHindi'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTopicDetails(topic),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.lightGreenBorder.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${topic['number']}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (topic['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    topic['icon'] as IconData,
                    color: topic['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: _selectedLanguage == 'urdu'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E8F5A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ],
            ),
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
          title: topic['title'],
          titleUrdu: topic['titleUrdu'] ?? '',
          titleHindi: topic['titleHindi'] ?? '',
          contentEnglish: details['english'] ?? '',
          contentUrdu: details['urdu'] ?? '',
          contentHindi: details['hindi'] ?? '',
          color: topic['color'] as Color,
          icon: topic['icon'] as IconData,
          category: 'Relative - Fazilat',
          number: topic['number'] as int?,
        ),
      ),
    );
  }
}
