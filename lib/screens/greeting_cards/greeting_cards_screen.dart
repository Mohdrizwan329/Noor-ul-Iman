import 'package:flutter/material.dart';
import 'package:noorulhuda/core/constants/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../providers/language_provider.dart';

enum GreetingLanguage { english, urdu, hindi, arabic }

// Helper function to map global language code to GreetingLanguage
GreetingLanguage _getGreetingLanguage(String languageCode) {
  switch (languageCode) {
    case 'en':
      return GreetingLanguage.english;
    case 'ur':
      return GreetingLanguage.urdu;
    case 'hi':
      return GreetingLanguage.hindi;
    case 'ar':
      return GreetingLanguage.arabic;
    default:
      return GreetingLanguage.english;
  }
}

class GreetingCardsScreen extends StatelessWidget {
  const GreetingCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final language = _getGreetingLanguage(languageProvider.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Greeting Cards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF), // White
          ),
        ),
        backgroundColor: const Color(0xFF0A5C36), // Dark Islamic Green
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)), // White icons
      ),
      body: Container(
        color: const Color(0xFFF6F8F6), // Soft Off-White background
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _islamicMonths.length,
          itemBuilder: (context, index) {
            final month = _islamicMonths[index];
            return _MonthCard(month: month, language: language);
          },
        ),
      ),
    );
  }
}

class _MonthCard extends StatelessWidget {
  final IslamicMonth month;
  final GreetingLanguage language;

  const _MonthCard({required this.month, required this.language});

  @override
  Widget build(BuildContext context) {
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const arabicTextColor = Color(0xFF1F3D2B);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MonthCardsScreen(month: month, language: language),
              ),
            );
          },
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF), // White card background
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF8AAF9A), // Light Green border
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Month Number Circle - Dark Green background
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: darkGreen, // Dark Green circle
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${month.monthNumber}',
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF), // White text
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // English Name - Dark Green Bold
                      Text(
                        month.getName(language),
                        style: const TextStyle(
                          color: darkGreen, // Dark Green
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      // Arabic Name - Muted Green
                      Text(
                        month.arabicName,
                        style: const TextStyle(
                          color: arabicTextColor, // Arabic Text Color
                          fontSize: 15,
                          fontFamily: 'Amiri',
                        ),
                      ),
                      if (month.getSpecialOccasion(language) != null) ...[
                        const SizedBox(height: 6),
                        // Event Chip - Light Green bg, Emerald text
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          child: Text(
                            month.getSpecialOccasion(language)!,
                            style: const TextStyle(
                              color: emeraldGreen, // Emerald Green text
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                // Arrow button - Emerald Green circle
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: emeraldGreen, // Emerald Green circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFFFFFF), // White arrow
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MonthCardsScreen extends StatelessWidget {
  final IslamicMonth month;
  final GreetingLanguage language;

  const MonthCardsScreen({
    super.key,
    required this.month,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const softOffWhite = Color(0xFFF6F8F6);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          month.getName(language),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF), // White
          ),
        ),
        backgroundColor: darkGreen, // Dark Islamic Green
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)), // White icons
      ),
      body: Container(
        color: softOffWhite, // Soft Off-White background
        child: month.cards.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: darkGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        size: 64,
                        color: darkGreen,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      language == GreetingLanguage.urdu
                          ? 'اس مہینے کے لیے کوئی خاص کارڈ نہیں'
                          : language == GreetingLanguage.hindi
                          ? 'इस महीने के लिए कोई विशेष कार्ड नहीं'
                          : language == GreetingLanguage.arabic
                          ? 'لا توجد بطاقات خاصة لهذا الشهر'
                          : 'No special cards for this month',
                      style: const TextStyle(color: darkGreen, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: month.cards.length,
                itemBuilder: (context, index) {
                  return _GreetingCardTile(
                    card: month.cards[index],
                    month: month,
                    language: language,
                  );
                },
              ),
      ),
    );
  }
}

class _GreetingCardTile extends StatelessWidget {
  final GreetingCard card;
  final IslamicMonth month;
  final GreetingLanguage language;

  const _GreetingCardTile({
    required this.card,
    required this.month,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showCardPreview(context),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: lightGreenBorder, width: 1.5),
            ),
            child: Row(
              children: [
                // Icon with dark green circle
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: darkGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      card.icon,
                      color: const Color(0xFFFFFFFF),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Card title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.getTitle(language),
                        style: const TextStyle(
                          color: darkGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreenChip,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          language == GreetingLanguage.urdu
                              ? 'دیکھنے کے لیے ٹیپ کریں'
                              : language == GreetingLanguage.hindi
                              ? 'देखने के लिए टैप करें'
                              : language == GreetingLanguage.arabic
                              ? 'اضغط للعرض'
                              : 'Tap to view',
                          style: const TextStyle(
                            color: emeraldGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Arrow button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: emeraldGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFFFFFF),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCardPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            StatusCardScreen(card: card, month: month, language: language),
      ),
    );
  }
}

// Color Theme Data Class
class CardColorTheme {
  final String name;
  final String nameUrdu;
  final String nameHindi;
  final String nameArabic;
  final Color headerColor;
  final Color footerColor;
  final Color accentColor;

  const CardColorTheme({
    required this.name,
    required this.nameUrdu,
    required this.nameHindi,
    required this.nameArabic,
    required this.headerColor,
    required this.footerColor,
    required this.accentColor,
  });

  String getName(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return name;
      case GreetingLanguage.urdu:
        return nameUrdu;
      case GreetingLanguage.hindi:
        return nameHindi;
      case GreetingLanguage.arabic:
        return nameArabic;
    }
  }
}

// 8 Available Color Themes
final List<CardColorTheme> _colorThemes = [
  CardColorTheme(
    name: 'Islamic Green',
    nameUrdu: 'اسلامی سبز',
    nameHindi: 'इस्लामी हरा',
    nameArabic: 'الأخضر الإسلامي',
    headerColor: Color(0xFF0A5C36),
    footerColor: Color(0xFF1E8F5A),
    accentColor: Color(0xFFC9A24D),
  ),
  CardColorTheme(
    name: 'Royal Blue',
    nameUrdu: 'شاہی نیلا',
    nameHindi: 'रॉयल नीला',
    nameArabic: 'الأزرق الملكي',
    headerColor: Color(0xFF1565C0),
    footerColor: Color(0xFF1976D2),
    accentColor: Color(0xFFFFD700),
  ),
  CardColorTheme(
    name: 'Purple Elegance',
    nameUrdu: 'جامنی خوبصورتی',
    nameHindi: 'बैंगनी भव्यता',
    nameArabic: 'الأناقة الأرجوانية',
    headerColor: Color(0xFF6A1B9A),
    footerColor: Color(0xFF8E24AA),
    accentColor: Color(0xFFFFC107),
  ),
  CardColorTheme(
    name: 'Teal Ocean',
    nameUrdu: 'فیروزی سمندر',
    nameHindi: 'टील महासागर',
    nameArabic: 'المحيط الفيروزي',
    headerColor: Color(0xFF00695C),
    footerColor: Color(0xFF00897B),
    accentColor: Color(0xFFFFE082),
  ),
  CardColorTheme(
    name: 'Burgundy Wine',
    nameUrdu: 'برگنڈی شراب',
    nameHindi: 'बरगंडी वाइन',
    nameArabic: 'النبيذ البرغندي',
    headerColor: Color(0xFF880E4F),
    footerColor: Color(0xFFC2185B),
    accentColor: Color(0xFFFFEB3B),
  ),
  CardColorTheme(
    name: 'Indigo Night',
    nameUrdu: 'نیلی رات',
    nameHindi: 'इंडिगो रात',
    nameArabic: 'ليلة النيلي',
    headerColor: Color(0xFF283593),
    footerColor: Color(0xFF3949AB),
    accentColor: Color(0xFFFFCA28),
  ),
  CardColorTheme(
    name: 'Deep Orange',
    nameUrdu: 'گہرا نارنجی',
    nameHindi: 'गहरा नारंगी',
    nameArabic: 'البرتقالي العميق',
    headerColor: Color(0xFFD84315),
    footerColor: Color(0xFFE64A19),
    accentColor: Color(0xFFFFD54F),
  ),
  CardColorTheme(
    name: 'Brown Earth',
    nameUrdu: 'بھورا زمین',
    nameHindi: 'भूरा पृथ्वी',
    nameArabic: 'الأرض البنية',
    headerColor: Color(0xFF4E342E),
    footerColor: Color(0xFF6D4C41),
    accentColor: Color(0xFFFFB74D),
  ),
];

// Full Screen Craft Style Card Design
class StatusCardScreen extends StatefulWidget {
  final GreetingCard card;
  final IslamicMonth month;
  final GreetingLanguage language;

  const StatusCardScreen({
    super.key,
    required this.card,
    required this.month,
    required this.language,
  });

  @override
  State<StatusCardScreen> createState() => _StatusCardScreenState();
}

class _StatusCardScreenState extends State<StatusCardScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  int _selectedThemeIndex = 0;
  int _selectedTemplateIndex = 0; // Default to original premium Islamic card
  String _customTitle = '';
  String _customMessage = '';
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _customTitle = widget.card.getTitle(widget.language);
    _customMessage = widget.card.getMessage(widget.language);
  }

  @override
  Widget build(BuildContext context) {
    // Get current theme colors
    final currentTheme = _colorThemes[_selectedThemeIndex];
    final emeraldGreen = currentTheme.footerColor;

    // Premium Islamic Color Palette
    const darkTealBg = Color(0xFF0E2A2A); // Dark Teal / Navy Background
    const deepGreen = Color(0xFF123838); // Deep Green Shade (Card Inner Area)
    const goldenBorder = Color(0xFFD4AF37); // Golden Border / Frame
    const softGoldText = Color(0xFFE6C87A); // Soft Gold (Text – "HAPPY")
    const warmGold = Color(0xFFBFA24A); // Warm Gold (Main Title)
    const creamText = Color(0xFFF5F1E6); // Off-White / Light Cream Text
    const lanternGlow = Color(0xFFFFD36A); // Lantern Light Glow
    const lanternBody = Color(
      0xFF8A6A3E,
    ); // Muted Bronze / Brown (Lantern Body)
    const mandalaGold = Color(0xFF9C8355); // Decorative Mandala Outline
    const shadowGreen = Color(0xFF081C1C); // Shadow / Depth Dark Green

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_customTitle, style: const TextStyle(color: creamText)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: goldenBorder),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [darkTealBg, shadowGreen],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Card Display (wrapped with Screenshot) - Uses Selected Template
                Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    height: 600,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildCardVariation(_selectedTemplateIndex),
                  ),
                ), // Screenshot widget
                const SizedBox(height: 24),

                // 9 Different Card Design Templates
                Container(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTemplateIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTemplateIndex = index;
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD4AF37)
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FittedBox(
                              child: SizedBox(
                                width: 300,
                                height: 400,
                                child: _buildCardVariation(index),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Color Theme Selector
                Container(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _colorThemes.length,
                    itemBuilder: (context, index) {
                      final theme = _colorThemes[index];
                      final isSelected = _selectedThemeIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedThemeIndex = index;
                          });
                        },
                        child: Container(
                          width: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [theme.headerColor, theme.footerColor],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? theme.accentColor
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: theme.accentColor.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              theme.getName(widget.language),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Edit Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton.icon(
                          onPressed: _showEditDialog,
                          icon: const Icon(Icons.edit, size: 20),
                          label: Text(
                            widget.language == GreetingLanguage.urdu
                                ? 'ترمیم'
                                : widget.language == GreetingLanguage.hindi
                                ? 'संपादित करें'
                                : widget.language == GreetingLanguage.arabic
                                ? 'تعديل'
                                : 'Edit',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _colorThemes[_selectedThemeIndex].headerColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Download Button
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton.icon(
                          onPressed: _downloadCard,
                          icon: const Icon(Icons.download, size: 20),
                          label: Text(
                            widget.language == GreetingLanguage.urdu
                                ? 'ڈاؤن لوڈ'
                                : widget.language == GreetingLanguage.hindi
                                ? 'डाउनलोड करें'
                                : widget.language == GreetingLanguage.arabic
                                ? 'تحميل'
                                : 'Download',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _colorThemes[_selectedThemeIndex].footerColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Share Button
                ElevatedButton.icon(
                  onPressed: () => _shareCard(context),
                  icon: const Icon(Icons.share),
                  label: Text(
                    widget.language == GreetingLanguage.urdu
                        ? 'اسٹیٹس پر شیئر کریں'
                        : widget.language == GreetingLanguage.hindi
                        ? 'स्टेटस पर शेयर करें'
                        : widget.language == GreetingLanguage.arabic
                        ? 'مشاركة على الحالة'
                        : 'Share on Status',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldGreen, // Emerald Green button
                    foregroundColor: const Color(0xFFFFFFFF), // White text
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Premium Islamic Design Helper Methods
  Widget _buildLantern(Color bodyColor, Color glowColor, double scale) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hanging chain
          Container(
            width: 2,
            height: 15,
            color: bodyColor.withValues(alpha: 0.6),
          ),
          // Lantern top
          Container(
            width: 30,
            height: 8,
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ),
          // Lantern body with glow
          Container(
            width: 35,
            height: 40,
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [glowColor, bodyColor]),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.wb_incandescent, color: glowColor, size: 20),
            ),
          ),
          // Lantern bottom
          Container(
            width: 30,
            height: 8,
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenBorder(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, color, color],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Container(width: 30, height: 2, color: color),
        const SizedBox(width: 8),
        Icon(Icons.circle, color: color, size: 6),
        const SizedBox(width: 8),
        Container(width: 30, height: 2, color: color),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStar(Color color, double size) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(Icons.star, color: color, size: size),
    );
  }

  Widget _buildCornerOrnament(Color color) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: CornerOrnamentPainter(color: color),
    );
  }

  // Build 9 Different Card Design Variations
  Widget _buildCardVariation(int index) {
    // Remap indices: Original premium card (was index 8) is now at index 0
    const indexMap = [8, 0, 1, 2, 3, 4, 5, 6, 7];
    index = indexMap[index];

    const darkTealBg = Color(0xFF0E2A2A);
    const deepGreen = Color(0xFF123838);
    const goldenBorder = Color(0xFFD4AF37);
    const softGoldText = Color(0xFFE6C87A);
    const warmGold = Color(0xFFBFA24A);
    const creamText = Color(0xFFF5F1E6);
    const lanternGlow = Color(0xFFFFD36A);
    const shadowGreen = Color(0xFF081C1C);

    switch (index) {
      case 0:
        // Design 1: Classic Ornate with Diamond Pattern
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: goldenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Diamond pattern background
              Positioned.fill(
                child: CustomPaint(
                  painter: DiamondPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.1),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.brightness_2, color: goldenBorder, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    _customTitle,
                    style: const TextStyle(
                      color: warmGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _customMessage,
                      style: const TextStyle(
                        color: creamText,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 1:
        // Design 2: Eid Al-Adha Golden Frame Style
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF0B4F3C), darkTealBg],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: goldenBorder, width: 4),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.7),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Geometric Islamic Pattern Background
              Positioned.fill(
                child: CustomPaint(
                  painter: GeometricPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Top Golden Stars
              Positioned(
                top: 15,
                left: 30,
                child: _buildStar(goldenBorder, 10),
              ),
              Positioned(top: 20, left: 50, child: _buildStar(goldenBorder, 6)),
              Positioned(
                top: 15,
                right: 30,
                child: _buildStar(goldenBorder, 10),
              ),
              Positioned(
                top: 20,
                right: 50,
                child: _buildStar(goldenBorder, 6),
              ),
              // Main Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top ornament
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [goldenBorder, warmGold],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: goldenBorder.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.brightness_2,
                      color: Color(0xFF0A2A1A),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Golden decorative line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, goldenBorder],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: goldenBorder,
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [goldenBorder, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      _customTitle,
                      style: const TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      _customMessage,
                      style: const TextStyle(
                        color: creamText,
                        fontSize: 14,
                        height: 1.6,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom ornamental line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 40, height: 1.5, color: goldenBorder),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.auto_awesome,
                          color: goldenBorder,
                          size: 16,
                        ),
                      ),
                      Container(width: 40, height: 1.5, color: goldenBorder),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

      case 2:
        // Design 3: Ramadan Kareem with Arabic Calligraphy Style
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Left side with geometric Islamic pattern
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: 140,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1A5C78),
                          const Color(0xFF0E3A4A),
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: IslamicPatternPainter(
                        color: goldenBorder.withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                ),
                // Right side content area
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.transparent, Color(0xFFF5F5F0)],
                      stops: [0.0, 0.35],
                    ),
                  ),
                  child: Row(
                    children: [
                      // Left pattern section
                      const SizedBox(width: 140),
                      // Main content
                      Expanded(
                        child: Container(
                          color: const Color(0xFFF5F5F0),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Hanging lanterns decorations
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Transform.scale(
                                    scale: 0.4,
                                    child: _buildLantern(
                                      const Color(0xFF8B4513),
                                      goldenBorder,
                                      1.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.brightness_2,
                                    color: goldenBorder,
                                    size: 18,
                                  ),
                                  _buildStar(goldenBorder, 10),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Title
                              Text(
                                _customTitle,
                                style: const TextStyle(
                                  color: Color(0xFF1A3A4A),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Amiri',
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 12),
                              // Decorative line
                              Container(
                                height: 2,
                                width: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [goldenBorder, Colors.transparent],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Message
                              Text(
                                _customMessage,
                                style: const TextStyle(
                                  color: Color(0xFF4A5A5A),
                                  fontSize: 13,
                                  height: 1.6,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              // Bottom decoration
                              Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: goldenBorder,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 30,
                                    height: 1.5,
                                    color: goldenBorder,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Golden ornamental frame on left edge
                Positioned(
                  left: 135,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [goldenBorder, warmGold, goldenBorder],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      case 3:
        // Design 4: Islamic New Year Blue Elegance
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A4D7A), // Deep Royal Blue
                Color(0xFF2E6BA8), // Medium Blue
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: goldenBorder, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.4),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corner ornaments
              Positioned(
                top: 15,
                left: 15,
                child: CustomPaint(
                  size: const Size(30, 30),
                  painter: CornerOrnamentPainter(
                    color: goldenBorder.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Transform.rotate(
                  angle: 1.5708,
                  child: CustomPaint(
                    size: const Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Transform.rotate(
                  angle: -1.5708,
                  child: CustomPaint(
                    size: const Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: CustomPaint(
                    size: const Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top ornament
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [goldenBorder, warmGold],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goldenBorder.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Color(0xFF1A4D7A),
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    Text(
                      _customTitle,
                      style: const TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    // Decorative line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, goldenBorder],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.auto_awesome,
                            color: goldenBorder,
                            size: 16,
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [goldenBorder, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Message
                    Text(
                      _customMessage,
                      style: const TextStyle(
                        color: Color(0xFFE8E8E8),
                        fontSize: 13,
                        height: 1.6,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 4:
        // Design 5: Eid Al-Fitr with Hanging Lanterns
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0C5C4A), // Dark Teal
                Color(0xFF0A4438), // Darker Teal
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: goldenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background mandala pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Hanging lanterns at top
              Positioned(
                top: 10,
                left: 30,
                child: Transform.scale(
                  scale: 0.5,
                  child: _buildLantern(
                    const Color(0xFF8B4513),
                    lanternGlow,
                    1.0,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 30,
                child: Transform.scale(
                  scale: 0.5,
                  child: _buildLantern(
                    const Color(0xFF8B4513),
                    lanternGlow,
                    1.0,
                  ),
                ),
              ),
              // Palm leaves decoration
              Positioned(
                top: 0,
                left: 10,
                child: Icon(
                  Icons.eco,
                  color: const Color(0xFF2D5F3F).withValues(alpha: 0.5),
                  size: 50,
                ),
              ),
              Positioned(
                top: 0,
                right: 10,
                child: Transform.flip(
                  flipX: true,
                  child: Icon(
                    Icons.eco,
                    color: const Color(0xFF2D5F3F).withValues(alpha: 0.5),
                    size: 50,
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Happy text
                    const Text(
                      'HAPPY',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      _customTitle,
                      style: const TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Message
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A3A2E).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: goldenBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _customMessage,
                        style: const TextStyle(
                          color: creamText,
                          fontSize: 13,
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 5:
        // Design 6: Iftar Invitation Elegant Frame
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F4C3A), // Deep Green
                Color(0xFF1A6B52), // Medium Green
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.7),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: goldenBorder, width: 3),
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A3A2E),
                  Color(0xFF123838),
                ],
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: goldenBorder.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 1.5,
                        color: goldenBorder,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.mosque,
                          color: goldenBorder,
                          size: 22,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 1.5,
                        color: goldenBorder,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Invitation text
                  const Text(
                    'Invitation',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    _customTitle,
                    style: const TextStyle(
                      color: Color(0xFFFFE5A0),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Amiri',
                      letterSpacing: 0.8,
                      shadows: [
                        Shadow(
                          color: Color(0xFF000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14),
                  // Message
                  Text(
                    _customMessage,
                    style: const TextStyle(
                      color: Color(0xFFE8E8E8),
                      fontSize: 12,
                      height: 1.7,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  // Bottom decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStar(goldenBorder, 8),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 1.5,
                        color: goldenBorder,
                      ),
                      const SizedBox(width: 10),
                      _buildStar(goldenBorder, 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

      case 6:
        // Design 7: Premium Wedding/Celebration Invitation
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0C4C3C),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.8),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: goldenBorder.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top golden decorative border pattern
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [goldenBorder, warmGold, goldenBorder],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22),
                      topRight: Radius.circular(22),
                    ),
                  ),
                  child: CustomPaint(
                    painter: GeometricPatternPainter(
                      color: const Color(0xFF0C4C3C).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              // Bottom golden decorative border pattern
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [goldenBorder, warmGold, goldenBorder],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                  ),
                  child: CustomPaint(
                    painter: GeometricPatternPainter(
                      color: const Color(0xFF0C4C3C).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              // Main content area
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 50, left: 20, right: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0F5C48),
                        deepGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: goldenBorder, width: 2),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top ornament
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [warmGold, goldenBorder],
                          ),
                        ),
                        child: const Icon(
                          Icons.brightness_2,
                          color: Color(0xFF0F5C48),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        _customTitle,
                        style: const TextStyle(
                          color: Color(0xFFFFE5A0),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          shadows: [
                            Shadow(
                              color: Color(0xFF000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      // Decorative divider
                      Container(
                        width: 100,
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              goldenBorder,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Message
                      Text(
                        _customMessage,
                        style: const TextStyle(
                          color: creamText,
                          fontSize: 13,
                          height: 1.6,
                          letterSpacing: 0.4,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case 7:
        // Design 8: Turquoise Celebration Elegance
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0C8E8E), // Turquoise
                Color(0xFF1AABAD), // Light Turquoise
                Color(0xFF0C8E8E), // Turquoise
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: goldenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0C8E8E).withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top star decoration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStar(const Color(0xFFFFE5A0), 12),
                        const SizedBox(width: 15),
                        Icon(
                          Icons.brightness_2,
                          color: goldenBorder,
                          size: 28,
                        ),
                        const SizedBox(width: 15),
                        _buildStar(const Color(0xFFFFE5A0), 12),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Wishing you text
                    const Text(
                      'Wishing you all a very',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      _customTitle,
                      style: const TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Message in frame
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A6666).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: goldenBorder.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _customMessage,
                        style: const TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 12,
                          height: 1.7,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Bottom decoration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.4,
                          child: _buildLantern(
                            const Color(0xFF8B4513),
                            const Color(0xFFFFD700),
                            1.0,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Transform.scale(
                          scale: 0.4,
                          child: _buildLantern(
                            const Color(0xFF8B4513),
                            const Color(0xFFFFD700),
                            1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Corner mandalas
              Positioned(
                top: 10,
                left: 10,
                child: CustomPaint(
                  size: const Size(40, 40),
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CustomPaint(
                  size: const Size(40, 40),
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ],
          ),
        );

      case 8:
        // Design 9: Original Premium Islamic Card with Lanterns
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: shadowGreen,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: goldenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: goldenBorder.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              children: [
                // Top Header with Lanterns
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [deepGreen, deepGreen.withValues(alpha: 0.8)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background Mandala Pattern
                      Positioned.fill(
                        child: CustomPaint(
                          painter: MandalaPatternPainter(
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      // Hanging Lanterns
                      Positioned(
                        top: -10,
                        left: 20,
                        child: _buildLantern(
                          const Color(0xFF8B4513),
                          lanternGlow,
                          0.7,
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: 20,
                        child: _buildLantern(
                          const Color(0xFF8B4513),
                          lanternGlow,
                          0.7,
                        ),
                      ),
                      // Content
                      Column(
                        children: [
                          // HAPPY text
                          Text(
                            widget.language == GreetingLanguage.urdu
                                ? 'مبارک ہو'
                                : widget.language == GreetingLanguage.hindi
                                ? 'मुबारक हो'
                                : widget.language == GreetingLanguage.arabic
                                ? 'مبارك'
                                : 'HAPPY',
                            style: const TextStyle(
                              color: softGoldText,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Golden decorative border
                          _buildGoldenBorder(goldenBorder),
                          const SizedBox(height: 10),
                          // Moon and Stars decoration
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStar(lanternGlow, 8),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.brightness_2,
                                color: goldenBorder,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              _buildStar(lanternGlow, 8),
                            ],
                          ),
                          const SizedBox(height: 8),

                          _buildGoldenBorder(goldenBorder),
                        ],
                      ),
                    ],
                  ),
                ),

                // Card Content Area
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [deepGreen.withValues(alpha: 0.9), darkTealBg],
                    ),
                  ),
                  child: Column(
                    children: [
                      // Month Name with Same Style as Title Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: goldenBorder, width: 2),
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              deepGreen.withValues(alpha: 0.6),
                              shadowGreen.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Consumer<LanguageProvider>(
                          builder: (context, languageProvider, child) {
                            String monthName;
                            switch (languageProvider.languageCode) {
                              case 'en':
                                monthName = widget.month.name;
                                break;
                              case 'ur':
                                monthName = widget.month.nameUrdu;
                                break;
                              case 'hi':
                                monthName = widget.month.nameHindi;
                                break;
                              case 'ar':
                                monthName = widget.month.arabicName;
                                break;
                              default:
                                monthName = widget.month.name;
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildCornerOrnament(goldenBorder),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    monthName,
                                    style: TextStyle(
                                      color: warmGold,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontFamily:
                                          languageProvider.languageCode == 'ar'
                                          ? 'Amiri'
                                          : null,
                                      shadows: const [
                                        Shadow(
                                          color: shadowGreen,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                _buildCornerOrnament(goldenBorder),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Main Title with Golden Frame
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: goldenBorder, width: 2),
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              deepGreen.withValues(alpha: 0.6),
                              shadowGreen.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildCornerOrnament(goldenBorder),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                _customTitle,
                                style: const TextStyle(
                                  color: warmGold,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  shadows: [
                                    Shadow(
                                      color: shadowGreen,
                                      blurRadius: 4,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _buildCornerOrnament(goldenBorder),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Message with Decorative Frame
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              deepGreen.withValues(alpha: 0.4),
                              shadowGreen.withValues(alpha: 0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: goldenBorder, width: 2),

                          boxShadow: [
                            BoxShadow(
                              color: shadowGreen.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Top ornament
                            CustomPaint(
                              size: const Size(80, 18),
                              painter: OrnamentPainter(color: softGoldText),
                            ),
                            const SizedBox(height: 12),
                            // Message text
                            Text(
                              _customMessage,
                              style: const TextStyle(
                                color: creamText,
                                fontSize: 16,
                                height: 1.8,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: shadowGreen,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            // Bottom ornament
                            Transform.rotate(
                              angle: 3.14159,
                              child: CustomPaint(
                                size: const Size(80, 18),
                                painter: OrnamentPainter(color: softGoldText),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Decorative Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [deepGreen.withValues(alpha: 0.9), shadowGreen],
                    ),
                    border: Border(
                      top: BorderSide(color: goldenBorder, width: 2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildGoldenBorder(goldenBorder),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStar(lanternGlow, 6),
                          const SizedBox(width: 10),
                          const Text(
                            'Jiyan Islamic Academy',
                            style: TextStyle(
                              color: creamText,
                              fontSize: 12,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildStar(lanternGlow, 6),
                        ],
                      ),
                      const SizedBox(height: 8),

                      _buildGoldenBorder(goldenBorder),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Future<void> _downloadCard() async {
    try {
      // Capture the card as image
      final image = await _screenshotController.capture();

      if (image == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'تصویر بنانے میں خرابی'
                  : widget.language == GreetingLanguage.hindi
                  ? 'छवि बनाने में त्रुटि'
                  : widget.language == GreetingLanguage.arabic
                  ? 'خطأ في إنشاء الصورة'
                  : 'Error creating image',
            ),
          ),
        );
        return;
      }

      // Get directory to save the image
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/greeting_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      if (!mounted) return;

      // Show success message with share option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.language == GreetingLanguage.urdu
                ? 'کارڈ محفوظ ہو گیا: $imagePath'
                : widget.language == GreetingLanguage.hindi
                ? 'कार्ड सहेजा गया: $imagePath'
                : widget.language == GreetingLanguage.arabic
                ? 'تم حفظ البطاقة: $imagePath'
                : 'Card saved: $imagePath',
          ),
          action: SnackBarAction(
            label: widget.language == GreetingLanguage.urdu
                ? 'شیئر کریں'
                : widget.language == GreetingLanguage.hindi
                ? 'शेयर करें'
                : widget.language == GreetingLanguage.arabic
                ? 'مشاركة'
                : 'Share',
            onPressed: () {
              Share.shareXFiles([XFile(imagePath)]);
            },
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.language == GreetingLanguage.urdu
                ? 'خرابی: $e'
                : widget.language == GreetingLanguage.hindi
                ? 'त्रुटि: $e'
                : widget.language == GreetingLanguage.arabic
                ? 'خطأ: $e'
                : 'Error: $e',
          ),
        ),
      );
    }
  }

  void _showEditDialog() {
    final titleController = TextEditingController(text: _customTitle);
    final messageController = TextEditingController(text: _customMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.language == GreetingLanguage.urdu
              ? 'کارڈ میں ترمیم کریں'
              : widget.language == GreetingLanguage.hindi
              ? 'कार्ड संपादित करें'
              : widget.language == GreetingLanguage.arabic
              ? 'تعديل البطاقة'
              : 'Edit Card',
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'عنوان'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शीर्षक'
                      : widget.language == GreetingLanguage.arabic
                      ? 'العنوان'
                      : 'Title',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'پیغام'
                      : widget.language == GreetingLanguage.hindi
                      ? 'संदेश'
                      : widget.language == GreetingLanguage.arabic
                      ? 'الرسالة'
                      : 'Message',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Reset to original
              setState(() {
                _customTitle = widget.card.getTitle(widget.language);
                _customMessage = widget.card.getMessage(widget.language);
                _isEdited = false;
              });
              Navigator.pop(context);
            },
            child: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'دوبارہ ترتیب دیں'
                  : widget.language == GreetingLanguage.hindi
                  ? 'रीसेट करें'
                  : widget.language == GreetingLanguage.arabic
                  ? 'إعادة تعيين'
                  : 'Reset',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'منسوخ کریں'
                  : widget.language == GreetingLanguage.hindi
                  ? 'रद्द करें'
                  : widget.language == GreetingLanguage.arabic
                  ? 'إلغاء'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customTitle = titleController.text;
                _customMessage = messageController.text;
                _isEdited = true;
              });
              Navigator.pop(context);
            },
            child: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'محفوظ کریں'
                  : widget.language == GreetingLanguage.hindi
                  ? 'सहेजें'
                  : widget.language == GreetingLanguage.arabic
                  ? 'حفظ'
                  : 'Save',
            ),
          ),
        ],
      ),
    );
  }

  void _shareCard(BuildContext context) {
    final hijri = HijriCalendar.now();
    final hijriDate =
        '${hijri.hDay} ${_getHijriMonthName(hijri.hMonth)} ${hijri.hYear} AH';
    final gregorianDate = DateFormat('d MMMM yyyy').format(DateTime.now());

    Share.share(
      '✦ $_customTitle ✦\n\n'
      '$_customMessage\n\n'
      '🌙 $hijriDate\n'
      '📅 $gregorianDate\n\n'
      '~ Jiyan Islamic Academy ~',
    );
  }

  String _getHijriMonthName(int month) {
    const months = [
      'Muharram',
      'Safar',
      'Rabi al-Awwal',
      'Rabi al-Thani',
      'Jumada al-Awwal',
      'Jumada al-Thani',
      'Rajab',
      'Sha\'ban',
      'Ramadan',
      'Shawwal',
      'Dhul Qa\'dah',
      'Dhul Hijjah',
    ];
    return months[month - 1];
  }
}

// Islamic Pattern Painter for background decoration
class IslamicPatternPainter extends CustomPainter {
  final Color color;

  IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        // Draw small geometric shapes
        canvas.drawCircle(Offset(x, y), 3, paint);
        // Draw small star pattern
        final starPath = Path();
        for (var i = 0; i < 4; i++) {
          final angle = (i * 90) * 3.14159 / 180;
          if (i == 0) {
            starPath.moveTo(x + 8, y);
          }
          starPath.lineTo(
            x + 8 * cos(angle + 3.14159 / 4),
            y + 8 * sin(angle + 3.14159 / 4),
          );
        }
        starPath.close();
        canvas.drawPath(starPath, paint);
      }
    }
  }

  double cos(double radians) => radians.abs() < 0.01
      ? 1
      : (radians - 1.5708).abs() < 0.01
      ? 0
      : (radians - 3.14159).abs() < 0.01
      ? -1
      : 0;

  double sin(double radians) => radians.abs() < 0.01
      ? 0
      : (radians - 1.5708).abs() < 0.01
      ? 1
      : (radians - 3.14159).abs() < 0.01
      ? 0
      : -1;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Mandala Pattern Painter for Premium Islamic Design
class MandalaPatternPainter extends CustomPainter {
  final Color color;

  MandalaPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw mandala patterns
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles
    for (var r = 20.0; r < 100; r += 25) {
      canvas.drawCircle(Offset(centerX, centerY), r, paint);
    }

    // Draw radiating lines
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final x1 = centerX + 30 * _cos(angle);
      final y1 = centerY + 30 * _sin(angle);
      final x2 = centerX + 80 * _cos(angle);
      final y2 = centerY + 80 * _sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  double _cos(double radians) {
    // Simple approximation
    if (radians.abs() < 0.01) return 1;
    if ((radians - 1.5708).abs() < 0.01) return 0;
    if ((radians - 3.14159).abs() < 0.01) return -1;
    if ((radians - 4.71239).abs() < 0.01) return 0;
    // For 45-degree angles
    if ((radians - 0.7854).abs() < 0.01) return 0.707;
    if ((radians - 2.3562).abs() < 0.01) return -0.707;
    if ((radians - 3.9270).abs() < 0.01) return -0.707;
    if ((radians - 5.4978).abs() < 0.01) return 0.707;
    return 0;
  }

  double _sin(double radians) {
    // Simple approximation
    if (radians.abs() < 0.01) return 0;
    if ((radians - 1.5708).abs() < 0.01) return 1;
    if ((radians - 3.14159).abs() < 0.01) return 0;
    if ((radians - 4.71239).abs() < 0.01) return -1;
    // For 45-degree angles
    if ((radians - 0.7854).abs() < 0.01) return 0.707;
    if ((radians - 2.3562).abs() < 0.01) return 0.707;
    if ((radians - 3.9270).abs() < 0.01) return -0.707;
    if ((radians - 5.4978).abs() < 0.01) return -0.707;
    return 0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Ornament Painter for Message Decoration
class OrnamentPainter extends CustomPainter {
  final Color color;

  OrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw decorative curves
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(path, paint);

    // Draw center ornament
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner Ornament Painter
class CornerOrnamentPainter extends CustomPainter {
  final Color color;

  CornerOrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw small decorative pattern
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 6, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3, fillPaint);

    // Draw corner lines
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width / 2 - 8, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 8, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Diamond Pattern Painter for Card Variation 1
class DiamondPatternPainter extends CustomPainter {
  final Color color;

  DiamondPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        final path = Path();
        path.moveTo(x, y - 15);
        path.lineTo(x + 15, y);
        path.lineTo(x, y + 15);
        path.lineTo(x - 15, y);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Arch Pattern Painter for Card Variation 5
class ArchPatternPainter extends CustomPainter {
  final Color color;

  ArchPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw arches
    final archWidth = size.width / 5;
    for (var i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        i * archWidth,
        size.height * 0.3,
        archWidth,
        size.height * 0.4,
      );
      canvas.drawArc(rect, 3.14159, 3.14159, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Geometric Pattern Painter for Card Variation 6
class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        // Draw hexagons
        final path = Path();
        const hexRadius = 15.0;
        for (var i = 0; i < 6; i++) {
          final angle = (i * 60) * 3.14159 / 180;
          final xPos = x + hexRadius * _cos(angle);
          final yPos = y + hexRadius * _sin(angle);
          if (i == 0) {
            path.moveTo(xPos, yPos);
          } else {
            path.lineTo(xPos, yPos);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  double _cos(double radians) {
    if (radians.abs() < 0.01) return 1;
    if ((radians - 1.5708).abs() < 0.01) return 0;
    if ((radians - 3.14159).abs() < 0.01) return -1;
    if ((radians - 4.71239).abs() < 0.01) return 0;
    if ((radians - 1.0472).abs() < 0.01) return 0.5;
    if ((radians - 2.0944).abs() < 0.01) return -0.5;
    if ((radians - 4.1888).abs() < 0.01) return -0.5;
    if ((radians - 5.2360).abs() < 0.01) return 0.5;
    return 0;
  }

  double _sin(double radians) {
    if (radians.abs() < 0.01) return 0;
    if ((radians - 1.5708).abs() < 0.01) return 1;
    if ((radians - 3.14159).abs() < 0.01) return 0;
    if ((radians - 4.71239).abs() < 0.01) return -1;
    if ((radians - 1.0472).abs() < 0.01) return 0.866;
    if ((radians - 2.0944).abs() < 0.01) return 0.866;
    if ((radians - 4.1888).abs() < 0.01) return -0.866;
    if ((radians - 5.2360).abs() < 0.01) return -0.866;
    return 0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner Ornament Detail Painter for Card Variation 7
class CornerOrnamentDetailPainter extends CustomPainter {
  final Color color;

  CornerOrnamentDetailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    // Draw ornate corner design
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.3,
      0,
      size.width * 0.4,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.3,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.4,
      0,
      size.width * 0.4,
    );
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

    // Add decorative circles
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      3,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.08),
      2,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.25),
      2,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Data Models
class IslamicMonth {
  final int monthNumber;
  final String name;
  final String nameUrdu;
  final String nameHindi;
  final String arabicName;
  final String? specialOccasion;
  final String? specialOccasionUrdu;
  final String? specialOccasionHindi;
  final String? specialOccasionArabic;
  final List<Color> gradient;
  final List<GreetingCard> cards;

  IslamicMonth({
    required this.monthNumber,
    required this.name,
    required this.nameUrdu,
    required this.nameHindi,
    required this.arabicName,
    this.specialOccasion,
    this.specialOccasionUrdu,
    this.specialOccasionHindi,
    this.specialOccasionArabic,
    required this.gradient,
    required this.cards,
  });

  String getName(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return name;
      case GreetingLanguage.urdu:
        return nameUrdu;
      case GreetingLanguage.hindi:
        return nameHindi;
      case GreetingLanguage.arabic:
        return arabicName;
    }
  }

  String? getSpecialOccasion(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return specialOccasion;
      case GreetingLanguage.urdu:
        return specialOccasionUrdu;
      case GreetingLanguage.hindi:
        return specialOccasionHindi;
      case GreetingLanguage.arabic:
        return specialOccasionArabic;
    }
  }
}

class GreetingCard {
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final String message;
  final String messageUrdu;
  final String messageHindi;
  final String messageArabic;
  final IconData icon;
  final List<Color>? gradient;

  GreetingCard({
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.message,
    required this.messageUrdu,
    required this.messageHindi,
    required this.messageArabic,
    required this.icon,
    this.gradient,
  });

  String getTitle(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return title;
      case GreetingLanguage.urdu:
        return titleUrdu;
      case GreetingLanguage.hindi:
        return titleHindi;
      case GreetingLanguage.arabic:
        return titleArabic;
    }
  }

  String getMessage(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return message;
      case GreetingLanguage.urdu:
        return messageUrdu;
      case GreetingLanguage.hindi:
        return messageHindi;
      case GreetingLanguage.arabic:
        return messageArabic;
    }
  }
}

// Islamic Months Data with Cards
final List<IslamicMonth> _islamicMonths = [
  // 1. Muharram
  IslamicMonth(
    monthNumber: 1,
    name: 'Muharram',
    nameUrdu: 'محرم',
    nameHindi: 'मुहर्रम',
    arabicName: 'مُحَرَّم',
    specialOccasion: 'Islamic New Year, Ashura',
    specialOccasionUrdu: 'اسلامی نیا سال، عاشورہ',
    specialOccasionHindi: 'इस्लामी नया साल, आशूरा',
    specialOccasionArabic: 'السنة الهجرية الجديدة، عاشوراء',
    gradient: [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
    cards: [
      GreetingCard(
        title: 'Islamic New Year',
        titleUrdu: 'اسلامی نیا سال مبارک',
        titleHindi: 'इस्लामी नया साल मुबारक',
        titleArabic: 'سنة هجرية سعيدة',
        message:
            'May this new Islamic year bring you closer to Allah and fill your life with His blessings. Happy Islamic New Year!',
        messageUrdu:
            'یہ نیا اسلامی سال آپ کو اللہ کے قریب لائے اور آپ کی زندگی اس کی برکتوں سے بھر دے۔ اسلامی نیا سال مبارک!',
        messageHindi:
            'यह नया इस्लामी साल आपको अल्लाह के करीब लाए और आपकी जिंदगी को उनकी बरकतों से भर दे। इस्लामी नया साल मुबारक!',
        messageArabic:
            'نسأل الله أن تقربك هذه السنة الهجرية الجديدة إلى الله وتملأ حياتك ببركاته. كل عام وأنتم بخير!',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Muharram Mubarak',
        titleUrdu: 'محرم مبارک',
        titleHindi: 'मुहर्रम मुबारक',
        titleArabic: 'محرم مبارك',
        message:
            'As the new Islamic year begins, may Allah guide you towards the right path and shower His blessings upon you.',
        messageUrdu:
            'جیسے ہی نیا اسلامی سال شروع ہو، اللہ آپ کو صراط مستقیم کی طرف رہنمائی فرمائے اور اپنی رحمتیں نازل فرمائے۔',
        messageHindi:
            'जैसे ही नया इस्लामी साल शुरू हो, अल्लाह आपको सही राह की ओर मार्गदर्शन करें और अपनी रहमतें नाज़िल फरमाएं।',
        messageArabic:
            'مع بداية السنة الهجرية الجديدة، نسأل الله أن يهديك إلى الصراط المستقيم ويغدق عليك بركاته.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Day of Ashura',
        titleUrdu: 'یوم عاشورہ',
        titleHindi: 'आशूरा का दिन',
        titleArabic: 'يوم عاشوراء',
        message:
            'On this blessed day of Ashura, may Allah accept our fasting and forgive our sins. May peace be upon the Ummah.',
        messageUrdu:
            'عاشورہ کے اس مبارک دن پر، اللہ ہمارے روزے قبول فرمائے اور ہمارے گناہ معاف فرمائے۔ امت پر سلامتی ہو۔',
        messageHindi:
            'आशूरा के इस मुबारक दिन पर, अल्लाह हमारे रोज़े कबूल फरमाए और हमारे गुनाह माफ करे। उम्मत पर सलामती हो।',
        messageArabic:
            'في هذا اليوم المبارك من عاشوراء، نسأل الله أن يتقبل صيامنا ويغفر ذنوبنا. السلام على الأمة.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'New Year Blessings',
        titleUrdu: 'نئے سال کی مبارکباد',
        titleHindi: 'नए साल की मुबारकबाद',
        titleArabic: 'بركات السنة الجديدة',
        message:
            'May the new Hijri year bring peace, prosperity, and spiritual growth. Wishing you a blessed year ahead!',
        messageUrdu:
            'نیا ہجری سال امن، خوشحالی اور روحانی ترقی لائے۔ آپ کو آنے والے سال کی مبارکباد!',
        messageHindi:
            'नया हिजरी साल शांति, खुशहाली और आध्यात्मिक तरक्की लाए। आने वाले साल की मुबारकबाद!',
        messageArabic:
            'نسأل الله أن تجلب السنة الهجرية الجديدة السلام والازدهار والنمو الروحي. نتمنى لكم عاماً مباركاً قادماً!',
        icon: Icons.star,
      ),
    ],
  ),

  // 2. Safar
  IslamicMonth(
    monthNumber: 2,
    name: 'Safar',
    nameUrdu: 'صفر',
    nameHindi: 'सफर',
    arabicName: 'صَفَر',
    gradient: [const Color(0xFF8D6E63), const Color(0xFFBCAAA4)],
    cards: [
      GreetingCard(
        title: 'Safar Blessings',
        titleUrdu: 'صفر مبارک',
        titleHindi: 'सफर मुबारक',
        titleArabic: 'بركات شهر صفر',
        message:
            'May Allah protect you and your family throughout this month and always. Trust in Allah\'s plan.',
        messageUrdu:
            'اللہ اس مہینے اور ہمیشہ آپ کی اور آپ کے خاندان کی حفاظت فرمائے۔ اللہ کی منصوبہ بندی پر بھروسہ رکھیں۔',
        messageHindi:
            'अल्लाह इस महीने और हमेशा आपकी और आपके परिवार की हिफाज़त फरमाए। अल्लाह की योजना पर भरोसा रखें।',
        messageArabic:
            'نسأل الله أن يحميك ويحمي عائلتك طوال هذا الشهر ودائماً. توكل على تدبير الله.',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Prayer for Safety',
        titleUrdu: 'سلامتی کی دعا',
        titleHindi: 'सलामती की दुआ',
        titleArabic: 'دعاء السلامة',
        message:
            'O Allah, protect us from all harm and guide us to the straight path. May this month bring peace and safety.',
        messageUrdu:
            'اے اللہ، ہمیں ہر نقصان سے بچا اور ہمیں صراط مستقیم کی طرف رہنمائی فرما۔ یہ مہینہ امن اور سلامتی لائے۔',
        messageHindi:
            'ऐ अल्लाह, हमें हर नुकसान से बचा और हमें सीधे रास्ते की ओर मार्गदर्शन कर। यह महीना शांति और सलामती लाए।',
        messageArabic:
            'اللهم احفظنا من كل سوء واهدنا إلى الصراط المستقيم. نسأل الله أن يجلب هذا الشهر السلام والأمان.',
        icon: Icons.favorite,
      ),
    ],
  ),

  // 3. Rabi al-Awwal
  IslamicMonth(
    monthNumber: 3,
    name: 'Rabi al-Awwal',
    nameUrdu: 'ربیع الاول',
    nameHindi: 'रबीउल अव्वल',
    arabicName: 'رَبِيع الأَوَّل',
    specialOccasion: 'Birth of Prophet Muhammad ﷺ',
    specialOccasionUrdu: 'ولادت نبی کریم ﷺ',
    specialOccasionHindi: 'नबी करीम ﷺ का जन्म',
    specialOccasionArabic: 'مولد النبي محمد ﷺ',
    gradient: [const Color(0xFF66BB6A), const Color(0xFF81C784)],
    cards: [
      GreetingCard(
        title: 'Eid Milad-un-Nabi',
        titleUrdu: 'عید میلاد النبی',
        titleHindi: 'ईद मीलाद-उन-नबी',
        titleArabic: 'عيد المولد النبوي',
        message:
            'On this blessed occasion of the Prophet\'s birth, may we be inspired to follow his teachings of peace, love, and compassion.',
        messageUrdu:
            'نبی کریم ﷺ کی ولادت کے اس مبارک موقع پر، ہم ان کی امن، محبت اور رحمت کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'नबी करीम ﷺ की विलादत के इस मुबारक मौके पर, हम उनकी अमन, मोहब्बत और रहमत की तालीमात पर अमल करें।',
        messageArabic:
            'في هذه المناسبة المباركة لمولد النبي، نسأل الله أن نُلهم لاتباع تعاليمه في السلام والمحبة والرحمة.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Prophet\'s Birthday',
        titleUrdu: 'یوم ولادت نبی',
        titleHindi: 'नबी का जन्मदिन',
        titleArabic: 'يوم ميلاد النبي',
        message:
            'Peace and blessings upon the Prophet Muhammad ﷺ. May his life continue to be a guiding light for all humanity.',
        messageUrdu:
            'نبی کریم ﷺ پر درود و سلام۔ ان کی زندگی ہمیشہ پوری انسانیت کے لیے رہنما روشنی بنی رہے۔',
        messageHindi:
            'नबी करीम ﷺ पर दरूद व सलाम। उनकी ज़िंदगी हमेशा पूरी इंसानियत के लिए मार्गदर्शक रोशनी बनी रहे।',
        messageArabic:
            'الصلاة والسلام على النبي محمد ﷺ. نسأل الله أن تستمر حياته نوراً هادياً للبشرية جمعاء.',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Rabi al-Awwal Mubarak',
        titleUrdu: 'ربیع الاول مبارک',
        titleHindi: 'रबीउल अव्वल मुबारक',
        titleArabic: 'ربيع الأول مبارك',
        message:
            'In this blessed month, let us remember the beautiful example of our beloved Prophet ﷺ and strive to embody his teachings.',
        messageUrdu:
            'اس مبارک مہینے میں، آئیے ہم اپنے پیارے نبی ﷺ کی خوبصورت مثال یاد کریں اور ان کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'इस मुबारक महीने में, आइए हम अपने प्यारे नबी ﷺ की खूबसूरत मिसाल याद करें और उनकी तालीमात पर अमल करें।',
        messageArabic:
            'في هذا الشهر المبارك، لنتذكر المثال الجميل لنبينا الحبيب ﷺ ونسعى لتجسيد تعاليمه.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Seerah Reminder',
        titleUrdu: 'سیرت کی یاد',
        titleHindi: 'सीरत की याद',
        titleArabic: 'تذكير بالسيرة',
        message:
            'The Prophet ﷺ said: "None of you truly believes until I am more beloved to him than his father, his child, and all of mankind."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "تم میں سے کوئی اس وقت تک مومن نہیں ہوتا جب تک میں اسے اس کے والد، اولاد اور تمام لوگوں سے زیادہ محبوب نہ ہوں۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "तुम में से कोई उस वक्त तक मोमिन नहीं होता जब तक मैं उसे उसके वालिद, औलाद और तमाम लोगों से ज़्यादा महबूब न होऊं।"',
        messageArabic:
            'قال النبي ﷺ: "لا يؤمن أحدكم حتى أكون أحب إليه من والده وولده والناس أجمعين."',
        icon: Icons.menu_book,
      ),
    ],
  ),

  // 4. Rabi al-Thani
  IslamicMonth(
    monthNumber: 4,
    name: 'Rabi al-Thani',
    nameUrdu: 'ربیع الثانی',
    nameHindi: 'रबीउस सानी',
    arabicName: 'رَبِيع الثَّانِي',
    gradient: [const Color(0xFF4DB6AC), const Color(0xFF80CBC4)],
    cards: [
      GreetingCard(
        title: 'Month of Blessings',
        titleUrdu: 'برکتوں کا مہینہ',
        titleHindi: 'बरकतों का महीना',
        titleArabic: 'شهر البركات',
        message:
            'May this month bring you peace, happiness, and countless blessings from Allah SWT.',
        messageUrdu:
            'یہ مہینہ آپ کو اللہ تعالیٰ کی طرف سے امن، خوشی او�� بے شمار برکتیں لائے۔',
        messageHindi:
            'यह महीना आपको अल्लाह तआला की तरफ से अमन, खुशी और बेशुमार बरकतें लाए।',
        messageArabic:
            'نسأل الله أن يجلب لك هذا الشهر السلام والسعادة والبركات الوفيرة من الله سبحانه وتعالى.',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Dua for You',
        titleUrdu: 'آپ کے لیے دعا',
        titleHindi: 'आपके लिए दुआ',
        titleArabic: 'دعاء لك',
        message:
            'May Allah fill your life with joy, protect you from harm, and grant you success in this life and the hereafter.',
        messageUrdu:
            'اللہ آپ کی زندگی خوشیوں سے بھر دے، آپ کو نقصان سے بچائے، اور دنیا و آخرت میں کامیابی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपकी ज़िंदगी खुशियों से भर दे, आपको नुकसान से बचाए, और दुनिया व आखिरत में कामयाबी अता फरमाए।',
        messageArabic:
            'نسأل الله أن يملأ حياتك بالفرح ويحميك من الأذى ويمنحك النجاح في الدنيا والآخرة.',
        icon: Icons.volunteer_activism,
      ),
    ],
  ),

  // 5. Jumada al-Awwal
  IslamicMonth(
    monthNumber: 5,
    name: 'Jumada al-Awwal',
    nameUrdu: 'جمادی الاول',
    nameHindi: 'जमादिउल अव्वल',
    arabicName: 'جُمَادَى الأُولَى',
    gradient: [const Color(0xFF64B5F6), const Color(0xFF90CAF9)],
    cards: [
      GreetingCard(
        title: 'Monthly Blessings',
        titleUrdu: 'ماہانہ برکات',
        titleHindi: 'मासिक बरकात',
        titleArabic: 'البركات الشهرية',
        message:
            'May Allah bless you with good health, prosperity, and spiritual growth this month.',
        messageUrdu:
            'اللہ آپ کو اس مہینے اچھی صحت، خوشحالی اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपको इस महीने अच्छी सेहत, खुशहाली और रूहानी तरक्की अता फरमाए।',
        messageArabic:
            'نسأل الله أن يرزقك هذا الشهر الصحة الجيدة والازدهار والنمو الروحي.',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Peace and Blessings',
        titleUrdu: 'امن اور برکات',
        titleHindi: 'अमन और बरकात',
        titleArabic: 'السلام والبركات',
        message:
            'Wishing you a month filled with peace, love, and the mercy of Allah SWT.',
        messageUrdu:
            'آپ کو امن، محبت اور اللہ تعالیٰ کی رحمت سے بھرا مہینہ مبارک ہو۔',
        messageHindi:
            'आपको अमन, मोहब्बत और अल्लाह तआला की रहमत से भरा महीना मुबारक हो।',
        messageArabic:
            'نتمنى لك شهراً مليئاً بالسلام والمحبة ورحمة الله سبحانه وتعالى.',
        icon: Icons.spa,
      ),
    ],
  ),

  // 6. Jumada al-Thani
  IslamicMonth(
    monthNumber: 6,
    name: 'Jumada al-Thani',
    nameUrdu: 'جمادی الثانی',
    nameHindi: 'जमादिउस सानी',
    arabicName: 'جُمَادَى الثَّانِيَة',
    gradient: [const Color(0xFF9575CD), const Color(0xFFB39DDB)],
    cards: [
      GreetingCard(
        title: 'Blessed Month',
        titleUrdu: 'مبارک مہینہ',
        titleHindi: 'मुबारक महीना',
        titleArabic: 'شهر مبارك',
        message:
            'May this month be filled with blessings, forgiveness, and spiritual enlightenment.',
        messageUrdu: 'یہ مہینہ برکتوں، مغفرت اور روحانی روشنی سے بھرا ہو۔',
        messageHindi: 'यह महीना बरकतों, माफी और रूहानी रोशनी से भरा हो।',
        messageArabic:
            'نسأل الله أن يكون هذا الشهر مليئاً بالبركات والمغفرة والاستنارة الروحية.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Prayer for Guidance',
        titleUrdu: 'ہدایت کی دعا',
        titleHindi: 'हिदायत की दुआ',
        titleArabic: 'دعاء للهداية',
        message:
            'O Allah, guide us to what is good, protect us from evil, and keep us on the straight path.',
        messageUrdu:
            'اے اللہ، ہمیں نیکی کی طرف رہنمائی فرما، برائی سے بچا، اور صراط مستقیم پر رکھ۔',
        messageHindi:
            'ऐ अल्लाह, हमें नेकी की तरफ मार्गदर्शन कर, बुराई से बचा, और सीधे रास्ते पर रख।',
        messageArabic:
            'اللهم اهدنا إلى ما هو خير واحمنا من الشر وأبقنا على الصراط المستقيم.',
        icon: Icons.lightbulb,
      ),
    ],
  ),

  // 7. Rajab
  IslamicMonth(
    monthNumber: 7,
    name: 'Rajab',
    nameUrdu: 'رجب',
    nameHindi: 'रजब',
    arabicName: 'رَجَب',
    specialOccasion: 'Isra and Mi\'raj',
    specialOccasionUrdu: 'اسراء و معراج',
    specialOccasionHindi: 'इसरा और मेराज',
    specialOccasionArabic: 'الإسراء والمعراج',
    gradient: [const Color(0xFF7C4DFF), const Color(0xFFB388FF)],
    cards: [
      GreetingCard(
        title: 'Rajab Mubarak',
        titleUrdu: 'رجب مبارک',
        titleHindi: 'रजब मुबारक',
        titleArabic: 'رجب مبارك',
        message:
            'Welcome to the sacred month of Rajab. May Allah bless you and prepare your heart for the upcoming Ramadan.',
        messageUrdu:
            'رجب کے مقدس مہینے میں خوش آمدید۔ اللہ آپ کو برکت دے اور آپ کا دل آنے والے رمضان کے لیے تیار فرمائے۔',
        messageHindi:
            'रजब के मुकद्दस महीने में खुश आमदीद। अल्लाह आपको बरकत दे और आपका दिल आने वाले रमज़ान के लिए तैयार फरमाए।',
        messageArabic:
            'مرحباً بك في شهر رجب المقدس. نسأل الله أن يباركك ويعد قلبك لشهر رمضان القادم.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Isra and Mi\'raj',
        titleUrdu: 'اسراء و معراج',
        titleHindi: 'इसरा और मेराज',
        titleArabic: 'الإسراء والمعراج',
        message:
            'On this blessed night, the Prophet ﷺ was taken on a miraculous journey. May we be inspired by this divine event.',
        messageUrdu:
            'اس مبارک رات نبی کریم ﷺ کو معجزاتی سفر پر لے جایا گیا۔ ہم اس الہی واقعے سے متاثر ہوں۔',
        messageHindi:
            'इस मुबारक रात नबी करीम ﷺ को मोजिज़ाती सफर पर ले जाया गया। हम इस इलाही वाक़िए से प्रेरित हों।',
        messageArabic:
            'في هذه الليلة المباركة، أُسري بالنبي ﷺ في رحلة معجزة. نسأل الله أن نُلهم بهذا الحدث الإلهي.',
        icon: Icons.flight,
      ),
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        titleArabic: 'شهر مقدس',
        message:
            'Rajab is one of the sacred months. Increase your worship and good deeds. May Allah accept from us.',
        messageUrdu:
            'رجب حرمت والے مہینوں میں سے ایک ہے۔ عبادت اور نیک اعمال بڑھائیں۔ اللہ ہم سے قبول فرمائے۔',
        messageHindi:
            'रजब हुरमत वाले महीनों में से एक है। इबादत और नेक आमाल बढ़ाएं। अल्लाह हम से कबूल फरमाए।',
        messageArabic:
            'رجب من الأشهر الحرم. أكثروا من العبادة والأعمال الصالحة. نسأل الله أن يتقبل منا.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Preparation for Ramadan',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        titleArabic: 'التحضير لرمضان',
        message:
            'As Rajab arrives, let us begin preparing our hearts for the blessed month of Ramadan.',
        messageUrdu:
            'جیسے ہی رجب آئے، آئیے ہم اپنے دلوں کو رمضان المبارک کے لیے تیار کریں۔',
        messageHindi:
            'जैसे ही रजब आए, आइए हम अपने दिलों को रमज़ान उल-मुबारक के लिए तैयार करें।',
        messageArabic: 'مع قدوم رجب، لنبدأ في إعداد قلوبنا لشهر رمضان المبارك.',
        icon: Icons.calendar_today,
      ),
    ],
  ),

  // 8. Sha'ban
  IslamicMonth(
    monthNumber: 8,
    name: 'Sha\'ban',
    nameUrdu: 'شعبان',
    nameHindi: 'शाबान',
    arabicName: 'شَعْبَان',
    specialOccasion: 'Shab-e-Barat',
    specialOccasionUrdu: 'شب برات',
    specialOccasionHindi: 'शब-ए-बारात',
    specialOccasionArabic: 'ليلة البراءة',
    gradient: [const Color(0xFF4DB6AC), const Color(0xFF80CBC4)],
    cards: [
      GreetingCard(
        title: 'Sha\'ban Mubarak',
        titleUrdu: 'شعبان مبارک',
        titleHindi: 'शाबान मुबारक',
        titleArabic: 'شعبان مبارك',
        message:
            'May this blessed month prepare you spiritually for Ramadan. Increase your fasting and prayers.',
        messageUrdu:
            'یہ مبارک مہینہ آپ کو روحانی طور پر رمضان کے لیے تیار کرے۔ روزے اور نماز بڑھائیں۔',
        messageHindi:
            'यह मुबारक महीना आपको रूहानी तौर पर रमज़ान के लिए तैयार करे। रोज़े और नमाज़ बढ़ाएं।',
        messageArabic:
            'نسأل الله أن يعدك هذا الشهر المبارك روحياً لشهر رمضان. أكثر من الصيام والصلاة.',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Shab-e-Barat',
        titleUrdu: 'شب برات مبارک',
        titleHindi: 'शब-ए-बारात मुबारक',
        titleArabic: 'شب برات مبارك',
        message:
            'On this night of forgiveness, may Allah forgive our sins and write our destiny with goodness.',
        messageUrdu:
            'مغفرت کی اس رات، اللہ ہمارے گناہ معاف فرمائے اور ہماری تقدیر بھلائی سے لکھے۔',
        messageHindi:
            'माफी की इस रात, अल्लाह हमारे गुनाह माफ फरमाए और हमारी तकदीर भलाई से लिखे।',
        messageArabic:
            'في ليلة المغفرة هذه، نسأل الله أن يغفر ذنوبنا ويكتب قدرنا بالخير.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Night of Records',
        titleUrdu: 'تقدیر کی رات',
        titleHindi: 'तक़दीर की रात',
        titleArabic: 'ليلة القدر',
        message:
            'May Allah write for you a year full of blessings, health, and success. Seek forgiveness on this blessed night.',
        messageUrdu:
            'اللہ آپ کے لیے برکتوں، صحت اور کامیابی سے بھرا سال لکھے۔ اس مبارک رات مغفرت مانگیں۔',
        messageHindi:
            'अल्लाह आपके लिए बरकतों, सेहत और कामयाबी से भरा साल लिखे। इस मुबारक रात माफी मांगें।',
        messageArabic:
            'نسأل الله أن يكتب لك عاماً مليئاً بالبركات والصحة والنجاح. اطلب المغفرة في هذه الليلة المباركة.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Ramadan Preparation',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        titleArabic: 'التحضير لرمضان',
        message:
            'The Prophet ﷺ used to fast more in Sha\'ban. Let us follow his sunnah and prepare for Ramadan.',
        messageUrdu:
            'نبی کریم ﷺ شعبان میں زیادہ روزے رکھتے تھے۔ آئیے ان کی سنت پر عمل کریں اور رمضان کی تیاری کریں۔',
        messageHindi:
            'नबी करीम ﷺ शाबान में ज़्यादा रोज़े रखते थे। आइए उनकी सुन्नत पर अमल करें और रमज़ान की तैयारी करें।',
        messageArabic:
            'كان النبي ﷺ يكثر من الصيام في شعبان. لنتبع سنته ونستعد لرمضان.',
        icon: Icons.calendar_today,
      ),
    ],
  ),

  // 9. Ramadan
  IslamicMonth(
    monthNumber: 9,
    name: 'Ramadan',
    nameUrdu: 'رمضان',
    nameHindi: 'रमज़ान',
    arabicName: 'رَمَضَان',
    specialOccasion: 'Month of Fasting, Laylatul Qadr',
    specialOccasionUrdu: 'روزوں کا مہینہ، لیلۃ القدر',
    specialOccasionHindi: 'रोज़ों का महीना, लैलतुल क़द्र',
    specialOccasionArabic: 'شهر الصيام، ليلة القدر',
    gradient: [const Color(0xFFBA68C8), const Color(0xFFCE93D8)],
    cards: [
      GreetingCard(
        title: 'Ramadan Mubarak',
        titleUrdu: 'رمضان مبارک',
        titleHindi: 'रमज़ान मुबारक',
        titleArabic: 'رمضان مبارك',
        message:
            'May this Ramadan bring you peace, prosperity, and happiness. May Allah accept your prayers and fasts.',
        messageUrdu:
            'یہ رمضان آپ کو امن، خوشحالی اور خوشی لائے۔ اللہ آپ کی نمازیں اور روزے قبول فرمائے۔',
        messageHindi:
            'यह रमज़ान आपको अमन, खुशहाली और खुशी लाए। अल्लाह आपकी नमाज़ें और रोज़े कबूल फरमाए।',
        messageArabic:
            'نسأل الله أن يجلب لك هذا الشهر الكريم السلام والازدهار والسعادة. نسأل الله أن يتقبل صلواتك وصيامك.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Ramadan Kareem',
        titleUrdu: 'رمضان کریم',
        titleHindi: 'रमज़ान करीम',
        titleArabic: 'رمضان كريم',
        message:
            'May the holy month of Ramadan light up your heart and home. Wishing you a blessed Ramadan!',
        messageUrdu:
            'رمضان کا مقدس مہینہ آپ کے دل اور گھر کو روشن کرے۔ آپ کو مبارک رمضان کی دعا!',
        messageHindi:
            'रमज़ान का मुकद्दस महीना आपके दिल और घर को रोशन करे। आपको मुबारक रमज़ान की दुआ!',
        messageArabic:
            'نسأل الله أن ينير شهر رمضان المقدس قلبك وبيتك. نتمنى لك رمضان مباركاً!',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Blessed Month',
        titleUrdu: 'مبارک مہینہ',
        titleHindi: 'मुबारक महीना',
        titleArabic: 'شهر مبارك',
        message:
            'As the crescent moon is sighted, may Allah bless you with happiness and grace your home with peace.',
        messageUrdu:
            'جیسے ہی چاند نظر آئے، اللہ آپ کو خوشی سے نوازے اور آپ کے گھر کو امن سے مالا مال کرے۔',
        messageHindi:
            'जैसे ही चाँद नज़र आए, अल्लाह आपको खुशी से नवाज़े और आपके घर को अमन से माला माल करे।',
        messageArabic:
            'نسأل الله أن يكون هذا الشهر مليئاً بالبركات والمغفرة والاستنارة الروحية.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Laylatul Qadr',
        titleUrdu: 'لیلۃ القدر',
        titleHindi: 'लैलतुल क़द्र',
        titleArabic: 'ليلة القدر',
        message:
            'Seek Laylatul Qadr in the last ten nights. It is better than a thousand months. May Allah grant us its blessings.',
        messageUrdu:
            'آخری دس راتوں میں لیلۃ القدر تلاش کریں۔ یہ ہزار مہینوں سے بہتر ہے۔ اللہ ہمیں اس کی برکتیں عطا فرمائے۔',
        messageHindi:
            'आखिरी दस रातों में लैलतुल क़द्र तलाश करें। यह हज़ार महीनों से बेहतर है। अल्लाह हमें इसकी बरकतें अता फरमाए।',
        messageArabic:
            'اطلبوا ليلة القدر في العشر الأواخر. إنها خير من ألف شهر. نسأل الله أن يرزقنا بركاتها.',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Iftar Blessings',
        titleUrdu: 'افطار مبارک',
        titleHindi: 'इफ्तार मुबारक',
        titleArabic: 'بركات الإفطار',
        message:
            'May every iftar be a source of blessings and every suhoor give you strength. Ramadan Mubarak!',
        messageUrdu:
            'ہر افطار برکت کا ذریعہ ہو اور ہر سحری آپ کو طاقت دے۔ رمضان مبارک!',
        messageHindi:
            'हर इफ्तार बरकत का ज़रिया हो और हर सहरी आपको ताकत दे। रमज़ान मुबारक!',
        messageArabic:
            'نسأل الله أن يكون كل إفطار مصدر بركة وكل سحور يمنحك القوة. رمضان مبارك!',
        icon: Icons.restaurant,
      ),
      GreetingCard(
        title: 'Taraweeh Greetings',
        titleUrdu: 'تراویح مبارک',
        titleHindi: 'तरावीह मुबारक',
        titleArabic: 'تحية التراويح',
        message:
            'May your Taraweeh prayers be accepted and your recitation of Quran bring light to your heart.',
        messageUrdu:
            'آپ کی تراویح قبول ہوں اور قرآن کی تلاوت آپ کے دل کو روشن کرے۔',
        messageHindi:
            'आपकी तरावीह कबूल हों और कुरआन की तिलावत आपके दिल को रोशन करे।',
        messageArabic:
            'نسأل الله أن تُقبل صلاة التراويح وأن يجلب تلاوة القرآن النور لقلبك.',
        icon: Icons.menu_book,
      ),
    ],
  ),

  // 10. Shawwal
  IslamicMonth(
    monthNumber: 10,
    name: 'Shawwal',
    nameUrdu: 'شوال',
    nameHindi: 'शव्वाल',
    arabicName: 'شَوَّال',
    specialOccasion: 'Eid ul-Fitr',
    specialOccasionUrdu: 'عید الفطر',
    specialOccasionHindi: 'ईद-उल-फ़ित्र',
    specialOccasionArabic: 'عيد الفطر',
    gradient: [const Color(0xFFFFB74D), const Color(0xFFFFE082)],
    cards: [
      GreetingCard(
        title: 'Eid Mubarak',
        titleUrdu: 'عید مبارک',
        titleHindi: 'ईद मुबारक',
        titleArabic: 'عيد مبارك',
        message:
            'May Allah accept your good deeds, forgive your transgressions and ease the suffering of all peoples. Eid Mubarak!',
        messageUrdu:
            'اللہ آپ کے نیک اعمال قبول فرمائے، گناہ معاف فرمائے اور سب کی تکالیف دور کرے۔ عید مبارک!',
        messageHindi:
            'अल्लाह आपके नेक आमाल कबूल फरमाए, गुनाह माफ करे और सबकी तकलीफें दूर करे। ईद मुबारक!',
        messageArabic:
            'نسأل الله أن يتقبل أعمالك الصالحة ويغفر ذنوبك ويخفف معاناة جميع الناس. عيد مبارك!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Eid',
        titleUrdu: 'مبارک عید',
        titleHindi: 'मुबारक ईद',
        titleArabic: 'عيد مبارك',
        message:
            'On this blessed day of Eid, may your heart be filled with joy and your home with happiness. Eid Mubarak!',
        messageUrdu:
            'عید کے اس مبارک دن، آپ کا دل خوشی سے بھرا ہو اور آپ کا گھر خوشیوں سے۔ عید مبارک!',
        messageHindi:
            'ईद के इस मुबारक दिन, आपका दिल खुशी से भरा हो और आपका घर खुशियों से। ईद मुबारक!',
        messageArabic:
            'في هذا اليوم المبارك من العيد، نسأل الله أن يملأ قلبك بالفرح وبيتك بالسعادة. عيد مبارك!',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Eid Greetings',
        titleUrdu: 'عید کی مبارکباد',
        titleHindi: 'ईद की मुबारकबाद',
        titleArabic: 'تحية العيد',
        message:
            'May the magic of this Eid bring lots of happiness in your life. Celebrate it with all your loved ones!',
        messageUrdu:
            'اس عید کا جادو آپ کی زندگی میں بہت ساری خوشیاں لائے۔ اپنے پیاروں کے ساتھ منائیں!',
        messageHindi:
            'इस ईद का जादू आपकी ज़िंदगी में बहुत सारी खुशियां लाए। अपने प्यारों के साथ मनाएं!',
        messageArabic:
            'نسأل الله أن يجلب لك سحر هذا العيد الكثير من السعادة في حياتك. احتفل به مع جميع أحبائك!',
        icon: Icons.card_giftcard,
      ),
      GreetingCard(
        title: 'Eid ul-Fitr',
        titleUrdu: 'عید الفطر مبارک',
        titleHindi: 'ईद-उल-फ़ित्र मुबारक',
        titleArabic: 'عيد الفطر مبارك',
        message:
            'After a month of fasting and prayers, may this Eid bring you endless blessings. Taqabbal Allahu minna wa minkum!',
        messageUrdu:
            'روزوں اور نمازوں کے مہینے کے بعد، یہ عید آپ کو بے شمار برکتیں لائے۔ تقبل اللہ منا و منکم!',
        messageHindi:
            'रोज़ों और नमाज़ों के महीने के बाद, यह ईद आपको बेशुमार बरकतें लाए। तक़ब्बल अल्लाहु मिन्ना व मिनकुम!',
        messageArabic:
            'بعد شهر من الصيام والصلاة، نسأل الله أن يجلب لك هذا العيد بركات لا نهاية لها. تقبل الله منا ومنكم!',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Six Fasts of Shawwal',
        titleUrdu: 'شوال کے چھ روزے',
        titleHindi: 'शव्वाल के छह रोज़े',
        titleArabic: 'صيام الست من شوال',
        message:
            'The Prophet ﷺ said: "Whoever fasts Ramadan and follows it with six days of Shawwal, it is as if he fasted the entire year."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "جس نے رمضان کے روزے رکھے اور شوال کے چھ روزے رکھے، گویا اس نے سال بھر روزے رکھے۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "जिसने रमज़ान के रोज़े रखे और शव्वाल के छह रोज़े रखे, गोया उसने साल भर रोज़े रखे।"',
        messageArabic:
            'قال النبي ﷺ: "من صام رمضان ثم أتبعه ستاً من شوال، كان كصيام الدهر."',
        icon: Icons.calendar_today,
      ),
    ],
  ),

  // 11. Dhul Qa'dah
  IslamicMonth(
    monthNumber: 11,
    name: 'Dhul Qa\'dah',
    nameUrdu: 'ذوالقعدہ',
    nameHindi: 'ज़ुल-क़ादा',
    arabicName: 'ذُو القَعْدَة',
    specialOccasion: 'Sacred Month',
    specialOccasionUrdu: 'حرمت والا مہینہ',
    specialOccasionHindi: 'हुरमत वाला महीना',
    specialOccasionArabic: 'شهر حرام',
    gradient: [const Color(0xFF78909C), const Color(0xFFB0BEC5)],
    cards: [
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        titleArabic: 'شهر مقدس',
        message:
            'Dhul Qa\'dah is one of the sacred months. May Allah bless you with peace and spiritual growth.',
        messageUrdu:
            'ذوالقعدہ حرمت والے مہینوں میں سے ایک ہے۔ اللہ آپ کو امن اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'ज़ुल-क़ादा हुरमत वाले महीनों में से एक है। अल्लाह आपको अमन और रूहानी तरक्की अता फरमाए।',
        messageArabic:
            'رجب من الأشهر الحرم. أكثروا من العبادة والأعمال الصالحة. نسأل الله أن يتقبل منا.',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Hajj Preparation',
        titleUrdu: 'حج کی تیاری',
        titleHindi: 'हज की तैयारी',
        titleArabic: 'التحضير للحج',
        message:
            'For those preparing for Hajj, may Allah accept your pilgrimage and grant you a journey of a lifetime.',
        messageUrdu:
            'حج کی تیاری کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور زندگی کا بہترین سفر عطا فرمائے۔',
        messageHindi:
            'हज की तैयारी करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और ज़िंदगी का बेहतरीन सफर अता फरमाए।',
        messageArabic:
            'للذين يستعدون للحج، نسأل الله أن يتقبل حجكم ويمنحكم رحلة العمر.',
        icon: Icons.flight,
      ),
    ],
  ),

  // 12. Dhul Hijjah
  IslamicMonth(
    monthNumber: 12,
    name: 'Dhul Hijjah',
    nameUrdu: 'ذوالحجہ',
    nameHindi: 'ज़ुल-हिज्जा',
    arabicName: 'ذُو الحِجَّة',
    specialOccasion: 'Hajj, Eid ul-Adha, Day of Arafah',
    specialOccasionUrdu: 'حج، عید الاضحی، یوم عرفہ',
    specialOccasionHindi: 'हज, ईद-उल-अज़हा, यौम-ए-अरफा',
    specialOccasionArabic: 'الحج، عيد الأضحى، يوم عرفة',
    gradient: [const Color(0xFFFF8A65), const Color(0xFFFFAB91)],
    cards: [
      GreetingCard(
        title: 'Eid ul-Adha Mubarak',
        titleUrdu: 'عید الاضحی مبارک',
        titleHindi: 'ईद-उल-अज़हा मुबारक',
        titleArabic: 'عيد الأضحى مبارك',
        message:
            'May Allah flood your life with happiness on this occasion. Wishing you a very happy Eid ul-Adha!',
        messageUrdu:
            'اس موقع پر اللہ آپ کی زندگی خوشیوں سے بھر دے۔ آپ کو عید الاضحی بہت مبارک!',
        messageHindi:
            'इस मौके पर अल्लाह आपकी ज़िंदगी खुशियों से भर दे। आपको ईद-उल-अज़हा बहुत मुबारक!',
        messageArabic:
            'نسأل الله أن يغمر حياتك بالسعادة في هذه المناسبة. نتمنى لك عيد أضحى سعيد جداً!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Sacrifice',
        titleUrdu: 'مبارک قربانی',
        titleHindi: 'मुबारक कुर्बानी',
        titleArabic: 'قربان مبارك',
        message:
            'On this Eid ul-Adha, may your sacrifices be appreciated and your prayers be answered. Eid Mubarak!',
        messageUrdu:
            'اس عید الاضحی پر، آپ کی قربانیاں قبول ہوں اور دعائیں مقبول ہوں۔ عید مبارک!',
        messageHindi:
            'इस ईद-उल-अज़हा पर, आपकी कुर्बानियां कबूल हों और दुआएं मकबूल हों। ईद मुबारक!',
        messageArabic:
            'في هذا العيد الأضحى، نسأل الله أن تُقدر تضحياتك وتُجاب صلواتك. عيد مبارك!',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Day of Arafah',
        titleUrdu: 'یوم عرفہ',
        titleHindi: 'यौम-ए-अरफा',
        titleArabic: 'يوم عرفة',
        message:
            'The best dua is the dua on the Day of Arafah. May Allah accept all your prayers on this blessed day.',
        messageUrdu:
            'سب سے بہترین دعا یوم عرفہ کی دعا ہے۔ اللہ اس مبارک دن آپ کی تمام دعائیں قبول فرمائے۔',
        messageHindi:
            'सबसे बेहतरीन दुआ यौम-ए-अरफा की दुआ है। अल्लाह इस मुबारक दिन आपकी तमाम दुआएं कबूल फरमाए।',
        messageArabic:
            'أفضل الدعاء دعاء يوم عرفة. نسأل الله أن يستجيب جميع دعواتك في هذا اليوم المبارك.',
        icon: Icons.terrain,
      ),
      GreetingCard(
        title: 'Hajj Mubarak',
        titleUrdu: 'حج مبارک',
        titleHindi: 'हज मुबारक',
        titleArabic: 'حج مبارك',
        message:
            'For those performing Hajj, may Allah accept your pilgrimage and grant you Hajj Mabroor.',
        messageUrdu:
            'حج کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور حج مبرور عطا فرمائے۔',
        messageHindi:
            'हज करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और हज मबरूर अता फरमाए।',
        messageArabic:
            'للذين يؤدون فريضة الحج، نسأل الله أن يتقبل حجكم ويمنحكم حجاً مبروراً.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'First Ten Days',
        titleUrdu: 'پہلے دس دن',
        titleHindi: 'पहले दस दिन',
        titleArabic: 'الأيام العشر الأولى',
        message:
            'The first ten days of Dhul Hijjah are the best days of the year. Increase your good deeds and worship.',
        messageUrdu:
            'ذوالحجہ کے پہلے دس دن سال کے بہترین دن ہیں۔ نیک اعمال اور عبادت بڑھائیں۔',
        messageHindi:
            'ज़ुल-हिज्जा के पहले दस दिन साल के बेहतरीन दिन हैं। नेक आमाल और इबादत बढ़ाएं।',
        messageArabic:
            'الأيام العشر الأولى من ذي الحجة هي أفضل أيام السنة. أكثروا من الأعمال الصالحة والعبادة.',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Qurbani Blessings',
        titleUrdu: 'قربانی مبارک',
        titleHindi: 'कुर्बानी मुबारक',
        titleArabic: 'بركات القربان',
        message:
            'May your Qurbani be accepted and may Allah reward you for your sacrifice. Eid ul-Adha Mubarak!',
        messageUrdu:
            'آپ کی قربانی قبول ہو اور اللہ آپ کو اجر عطا فرمائے۔ عید الاضحی مبارک!',
        messageHindi:
            'आपकी कुर्बानी कबूल हो और अल्लाह आपको अज्र अता फरमाए। ईद-उल-अज़हा मुबारक!',
        messageArabic:
            'نسأل الله أن يُقبل قربانك ويجزيك على تضحيتك. عيد الأضحى مبارك!',
        icon: Icons.card_giftcard,
      ),
    ],
  ),
];
