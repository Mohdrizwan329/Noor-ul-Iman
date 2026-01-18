import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

enum GreetingLanguage { english, urdu, hindi }

class GreetingCardsScreen extends StatefulWidget {
  const GreetingCardsScreen({super.key});

  @override
  State<GreetingCardsScreen> createState() => _GreetingCardsScreenState();
}

class _GreetingCardsScreenState extends State<GreetingCardsScreen> {
  GreetingLanguage _selectedLanguage = GreetingLanguage.english;

  String _getLanguageLabel() {
    switch (_selectedLanguage) {
      case GreetingLanguage.english:
        return 'EN';
      case GreetingLanguage.urdu:
        return 'UR';
      case GreetingLanguage.hindi:
        return 'HI';
    }
  }

  void _showLanguageSelector() {
    const darkGreen = Color(0xFF0A5C36);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkGreen,
              ),
            ),
            const SizedBox(height: 20),
            _buildLanguageOption(GreetingLanguage.english, 'English', 'EN'),
            _buildLanguageOption(GreetingLanguage.urdu, 'اردو', 'UR'),
            _buildLanguageOption(GreetingLanguage.hindi, 'हिंदी', 'HI'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    GreetingLanguage language,
    String name,
    String code,
  ) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const veryLightGreen = Color(0xFFF2F7F4);

    final isSelected = _selectedLanguage == language;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? darkGreen : veryLightGreen,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            code,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFFFFF) : darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? darkGreen : const Color(0xFF2F3E36),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: emeraldGreen)
          : null,
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: _showLanguageSelector,
              icon: const Icon(Icons.translate, size: 18),
              label: Text(_getLanguageLabel()),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFFFFFFF),
              ), // White
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF6F8F6), // Soft Off-White background
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _islamicMonths.length,
          itemBuilder: (context, index) {
            final month = _islamicMonths[index];
            return _MonthCard(month: month, language: _selectedLanguage);
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
              border: Border.all(
                color: lightGreenBorder,
                width: 1.5,
              ),
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
                        child: const Text(
                          'Tap to view',
                          style: TextStyle(
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

// Full Screen Craft Style Card Design
class StatusCardScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const softGold = Color(0xFFC9A24D);
    const softOffWhite = Color(0xFFF6F8F6);
    const normalText = Color(0xFF2F3E36);

    return Scaffold(
      backgroundColor: softOffWhite,
      appBar: AppBar(
        title: Text(
          card.getTitle(language),
          style: const TextStyle(color: Color(0xFFFFFFFF)),
        ),
        backgroundColor: darkGreen,
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: softOffWhite,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Craft Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: lightGreenBorder, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      children: [
                        // Top Header with Pattern
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: const BoxDecoration(color: darkGreen),
                          child: Stack(
                            children: [
                              // Background Islamic Pattern
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: IslamicPatternPainter(
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                ),
                              ),
                              // Content
                              Column(
                                children: [
                                  // Decorative top border
                                  _buildIslamicBorder(
                                    softGold.withValues(alpha: 0.6),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Card Content
                        Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              // Title with decorative elements
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildCornerDecor(softGold),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Text(
                                      card.getTitle(language),
                                      style: const TextStyle(
                                        color: darkGreen,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildCornerDecor(softGold),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Message in elegant frame
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F3ED), // Light Green Chip
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: lightGreenBorder,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    // Quote marks
                                    Icon(
                                      Icons.format_quote,
                                      color: softGold.withValues(alpha: 0.6),
                                      size: 30,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      card.getMessage(language),
                                      style: const TextStyle(
                                        color: normalText,
                                        fontSize: 16,
                                        height: 1.7,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    RotatedBox(
                                      quarterTurns: 2,
                                      child: Icon(
                                        Icons.format_quote,
                                        color: softGold.withValues(alpha: 0.6),
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Month Tag - Elegant Style
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: darkGreen,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkGreen.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      month.arabicName,
                                      style: const TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 18,
                                        fontFamily: 'Amiri',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      width: 1,
                                      height: 20,
                                      color: Colors.white54,
                                    ),
                                    Text(
                                      month.getName(language),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
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
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: const BoxDecoration(
                            color: emeraldGreen, // Emerald Green footer
                          ),
                          child: Column(
                            children: [
                              _buildIslamicBorder(
                                softGold.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '✦ Jiyan Islamic Academy ✦',
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildIslamicBorder(
                                softGold.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Share Button
                ElevatedButton.icon(
                  onPressed: () => _shareCard(context),
                  icon: const Icon(Icons.share),
                  label: Text(
                    language == GreetingLanguage.urdu
                        ? 'اسٹیٹس پر شیئر کریں'
                        : language == GreetingLanguage.hindi
                        ? 'स्टेटस पर शेयर करें'
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIslamicBorder(Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(width: 30, height: 1, color: color),
        const SizedBox(width: 6),
        Icon(Icons.star, color: color, size: 8),
        const SizedBox(width: 6),
        Container(width: 20, height: 1, color: color),
        const SizedBox(width: 6),
        Icon(Icons.star, color: color, size: 10),
        const SizedBox(width: 6),
        Container(width: 20, height: 1, color: color),
        const SizedBox(width: 6),
        Icon(Icons.star, color: color, size: 8),
        const SizedBox(width: 6),
        Container(width: 30, height: 1, color: color),
      ],
    );
  }

  Widget _buildCornerDecor(Color color) {
    return Column(
      children: [
        Icon(Icons.star, color: color.withValues(alpha: 0.5), size: 10),
        const SizedBox(height: 4),
        Icon(Icons.star, color: color, size: 14),
        const SizedBox(height: 4),
        Icon(Icons.star, color: color.withValues(alpha: 0.5), size: 10),
      ],
    );
  }

  void _shareCard(BuildContext context) {
    final hijri = HijriCalendar.now();
    final hijriDate =
        '${hijri.hDay} ${_getHijriMonthName(hijri.hMonth)} ${hijri.hYear} AH';
    final gregorianDate = DateFormat('d MMMM yyyy').format(DateTime.now());

    Share.share(
      '✦ ${card.getTitle(language)} ✦\n\n'
      '${card.getMessage(language)}\n\n'
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
    }
  }
}

class GreetingCard {
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String message;
  final String messageUrdu;
  final String messageHindi;
  final IconData icon;
  final List<Color>? gradient;

  GreetingCard({
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.message,
    required this.messageUrdu,
    required this.messageHindi,
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
    gradient: [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
    cards: [
      GreetingCard(
        title: 'Islamic New Year',
        titleUrdu: 'اسلامی نیا سال مبارک',
        titleHindi: 'इस्लामी नया साल मुबारक',
        message:
            'May this new Islamic year bring you closer to Allah and fill your life with His blessings. Happy Islamic New Year!',
        messageUrdu:
            'یہ نیا اسلامی سال آپ کو اللہ کے قریب لائے اور آپ کی زندگی اس کی برکتوں سے بھر دے۔ اسلامی نیا سال مبارک!',
        messageHindi:
            'यह नया इस्लामी साल आपको अल्लाह के करीब लाए और आपकी जिंदगी को उनकी बरकतों से भर दे। इस्लामी नया साल मुबारक!',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Muharram Mubarak',
        titleUrdu: 'محرم مبارک',
        titleHindi: 'मुहर्रम मुबारक',
        message:
            'As the new Islamic year begins, may Allah guide you towards the right path and shower His blessings upon you.',
        messageUrdu:
            'جیسے ہی نیا اسلامی سال شروع ہو، اللہ آپ کو صراط مستقیم کی طرف رہنمائی فرمائے اور اپنی رحمتیں نازل فرمائے۔',
        messageHindi:
            'जैसे ही नया इस्लामी साल शुरू हो, अल्लाह आपको सही राह की ओर मार्गदर्शन करें और अपनी रहमतें नाज़िल फरमाएं।',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Day of Ashura',
        titleUrdu: 'یوم عاشورہ',
        titleHindi: 'आशूरा का दिन',
        message:
            'On this blessed day of Ashura, may Allah accept our fasting and forgive our sins. May peace be upon the Ummah.',
        messageUrdu:
            'عاشورہ کے اس مبارک دن پر، اللہ ہمارے روزے قبول فرمائے اور ہمارے گناہ معاف فرمائے۔ امت پر سلامتی ہو۔',
        messageHindi:
            'आशूरा के इस मुबारक दिन पर, अल्लाह हमारे रोज़े कबूल फरमाए और हमारे गुनाह माफ करे। उम्मत पर सलामती हो।',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'New Year Blessings',
        titleUrdu: 'نئے سال کی مبارکباد',
        titleHindi: 'नए साल की मुबारकबाद',
        message:
            'May the new Hijri year bring peace, prosperity, and spiritual growth. Wishing you a blessed year ahead!',
        messageUrdu:
            'نیا ہجری سال امن، خوشحالی اور روحانی ترقی لائے۔ آپ کو آنے والے سال کی مبارکباد!',
        messageHindi:
            'नया हिजरी साल शांति, खुशहाली और आध्यात्मिक तरक्की लाए। आने वाले साल की मुबारकबाद!',
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
        message:
            'May Allah protect you and your family throughout this month and always. Trust in Allah\'s plan.',
        messageUrdu:
            'اللہ اس مہینے اور ہمیشہ آپ کی اور آپ کے خاندان کی حفاظت فرمائے۔ اللہ کی منصوبہ بندی پر بھروسہ رکھیں۔',
        messageHindi:
            'अल्लाह इस महीने और हमेशा आपकी और आपके परिवार की हिफाज़त फरमाए। अल्लाह की योजना पर भरोसा रखें।',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Prayer for Safety',
        titleUrdu: 'سلامتی کی دعا',
        titleHindi: 'सलामती की दुआ',
        message:
            'O Allah, protect us from all harm and guide us to the straight path. May this month bring peace and safety.',
        messageUrdu:
            'اے اللہ، ہمیں ہر نقصان سے بچا اور ہمیں صراط مستقیم کی طرف رہنمائی فرما۔ یہ مہینہ امن اور سلامتی لائے۔',
        messageHindi:
            'ऐ अल्लाह, हमें हर नुकसान से बचा और हमें सीधे रास्ते की ओर मार्गदर्शन कर। यह महीना शांति और सलामती लाए।',
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
    gradient: [const Color(0xFF66BB6A), const Color(0xFF81C784)],
    cards: [
      GreetingCard(
        title: 'Eid Milad-un-Nabi',
        titleUrdu: 'عید میلاد النبی',
        titleHindi: 'ईद मीलाद-उन-नबी',
        message:
            'On this blessed occasion of the Prophet\'s birth, may we be inspired to follow his teachings of peace, love, and compassion.',
        messageUrdu:
            'نبی کریم ﷺ کی ولادت کے اس مبارک موقع پر، ہم ان کی امن، محبت اور رحمت کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'नबी करीम ﷺ की विलादत के इस मुबारक मौके पर, हम उनकी अमन, मोहब्बत और रहमत की तालीमात पर अमल करें।',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Prophet\'s Birthday',
        titleUrdu: 'یوم ولادت نبی',
        titleHindi: 'नबी का जन्मदिन',
        message:
            'Peace and blessings upon the Prophet Muhammad ﷺ. May his life continue to be a guiding light for all humanity.',
        messageUrdu:
            'نبی کریم ﷺ پر درود و سلام۔ ان کی زندگی ہمیشہ پوری انسانیت کے لیے رہنما روشنی بنی رہے۔',
        messageHindi:
            'नबी करीम ﷺ पर दरूद व सलाम। उनकी ज़िंदगी हमेशा पूरी इंसानियत के लिए मार्गदर्शक रोशनी बनी रहे।',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Rabi al-Awwal Mubarak',
        titleUrdu: 'ربیع الاول مبارک',
        titleHindi: 'रबीउल अव्वल मुबारक',
        message:
            'In this blessed month, let us remember the beautiful example of our beloved Prophet ﷺ and strive to embody his teachings.',
        messageUrdu:
            'اس مبارک مہینے میں، آئیے ہم اپنے پیارے نبی ﷺ کی خوبصورت مثال یاد کریں اور ان کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'इस मुबारक महीने में, आइए हम अपने प्यारे नबी ﷺ की खूबसूरत मिसाल याद करें और उनकी तालीमात पर अमल करें।',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Seerah Reminder',
        titleUrdu: 'سیرت کی یاد',
        titleHindi: 'सीरत की याद',
        message:
            'The Prophet ﷺ said: "None of you truly believes until I am more beloved to him than his father, his child, and all of mankind."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "تم میں سے کوئی اس وقت تک مومن نہیں ہوتا جب تک میں اسے اس کے والد، اولاد اور تمام لوگوں سے زیادہ محبوب نہ ہوں۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "तुम में से कोई उस वक्त तक मोमिन नहीं होता जब तक मैं उसे उसके वालिद, औलाद और तमाम लोगों से ज़्यादा महबूब न होऊं।"',
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
        message:
            'May this month bring you peace, happiness, and countless blessings from Allah SWT.',
        messageUrdu:
            'یہ مہینہ آپ کو اللہ تعالیٰ کی طرف سے امن، خوشی او�� بے شمار برکتیں لائے۔',
        messageHindi:
            'यह महीना आपको अल्लाह तआला की तरफ से अमन, खुशी और बेशुमार बरकतें लाए।',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Dua for You',
        titleUrdu: 'آپ کے لیے دعا',
        titleHindi: 'आपके लिए दुआ',
        message:
            'May Allah fill your life with joy, protect you from harm, and grant you success in this life and the hereafter.',
        messageUrdu:
            'اللہ آپ کی زندگی خوشیوں سے بھر دے، آپ کو نقصان سے بچائے، اور دنیا و آخرت میں کامیابی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपकी ज़िंदगी खुशियों से भर दे, आपको नुकसान से बचाए, और दुनिया व आखिरत में कामयाबी अता फरमाए।',
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
        message:
            'May Allah bless you with good health, prosperity, and spiritual growth this month.',
        messageUrdu:
            'اللہ آپ کو اس مہینے اچھی صحت، خوشحالی اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपको इस महीने अच्छी सेहत, खुशहाली और रूहानी तरक्की अता फरमाए।',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Peace and Blessings',
        titleUrdu: 'امن اور برکات',
        titleHindi: 'अमन और बरकात',
        message:
            'Wishing you a month filled with peace, love, and the mercy of Allah SWT.',
        messageUrdu:
            'آپ کو امن، محبت اور اللہ تعالیٰ کی رحمت سے بھرا مہینہ مبارک ہو۔',
        messageHindi:
            'आपको अमन, मोहब्बत और अल्लाह तआला की रहमत से भरा महीना मुबारक हो।',
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
        message:
            'May this month be filled with blessings, forgiveness, and spiritual enlightenment.',
        messageUrdu: 'یہ مہینہ برکتوں، مغفرت اور روحانی روشنی سے بھرا ہو۔',
        messageHindi: 'यह महीना बरकतों, माफी और रूहानी रोशनी से भरा हो।',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Prayer for Guidance',
        titleUrdu: 'ہدایت کی دعا',
        titleHindi: 'हिदायत की दुआ',
        message:
            'O Allah, guide us to what is good, protect us from evil, and keep us on the straight path.',
        messageUrdu:
            'اے اللہ، ہمیں نیکی کی طرف رہنمائی فرما، برائی سے بچا، اور صراط مستقیم پر رکھ۔',
        messageHindi:
            'ऐ अल्लाह, हमें नेकी की तरफ मार्गदर्शन कर, बुराई से बचा, और सीधे रास्ते पर रख।',
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
    gradient: [const Color(0xFF7C4DFF), const Color(0xFFB388FF)],
    cards: [
      GreetingCard(
        title: 'Rajab Mubarak',
        titleUrdu: 'رجب مبارک',
        titleHindi: 'रजब मुबारक',
        message:
            'Welcome to the sacred month of Rajab. May Allah bless you and prepare your heart for the upcoming Ramadan.',
        messageUrdu:
            'رجب کے مقدس مہینے میں خوش آمدید۔ اللہ آپ کو برکت دے اور آپ کا دل آنے والے رمضان کے لیے تیار فرمائے۔',
        messageHindi:
            'रजब के मुकद्दस महीने में खुश आमदीद। अल्लाह आपको बरकत दे और आपका दिल आने वाले रमज़ान के लिए तैयार फरमाए।',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Isra and Mi\'raj',
        titleUrdu: 'اسراء و معراج',
        titleHindi: 'इसरा और मेराज',
        message:
            'On this blessed night, the Prophet ﷺ was taken on a miraculous journey. May we be inspired by this divine event.',
        messageUrdu:
            'اس مبارک رات نبی کریم ﷺ کو معجزاتی سفر پر لے جایا گیا۔ ہم اس الہی واقعے سے متاثر ہوں۔',
        messageHindi:
            'इस मुबारक रात नबी करीम ﷺ को मोजिज़ाती सफर पर ले जाया गया। हम इस इलाही वाक़िए से प्रेरित हों।',
        icon: Icons.flight,
      ),
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        message:
            'Rajab is one of the sacred months. Increase your worship and good deeds. May Allah accept from us.',
        messageUrdu:
            'رجب حرمت والے مہینوں میں سے ایک ہے۔ عبادت اور نیک اعمال بڑھائیں۔ اللہ ہم سے قبول فرمائے۔',
        messageHindi:
            'रजब हुरमत वाले महीनों में से एक है। इबादत और नेक आमाल बढ़ाएं। अल्लाह हम से कबूल फरमाए।',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Preparation for Ramadan',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        message:
            'As Rajab arrives, let us begin preparing our hearts for the blessed month of Ramadan.',
        messageUrdu:
            'جیسے ہی رجب آئے، آئیے ہم اپنے دلوں کو رمضان المبارک کے لیے تیار کریں۔',
        messageHindi:
            'जैसे ही रजब आए, आइए हम अपने दिलों को रमज़ान उल-मुबारक के लिए तैयार करें।',
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
    gradient: [const Color(0xFF4DB6AC), const Color(0xFF80CBC4)],
    cards: [
      GreetingCard(
        title: 'Sha\'ban Mubarak',
        titleUrdu: 'شعبان مبارک',
        titleHindi: 'शाबान मुबारक',
        message:
            'May this blessed month prepare you spiritually for Ramadan. Increase your fasting and prayers.',
        messageUrdu:
            'یہ مبارک مہینہ آپ کو روحانی طور پر رمضان کے لیے تیار کرے۔ روزے اور نماز بڑھائیں۔',
        messageHindi:
            'यह मुबारक महीना आपको रूहानी तौर पर रमज़ान के लिए तैयार करे। रोज़े और नमाज़ बढ़ाएं।',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Shab-e-Barat',
        titleUrdu: 'شب برات مبارک',
        titleHindi: 'शब-ए-बारात मुबारक',
        message:
            'On this night of forgiveness, may Allah forgive our sins and write our destiny with goodness.',
        messageUrdu:
            'مغفرت کی اس رات، اللہ ہمارے گناہ معاف فرمائے اور ہماری تقدیر بھلائی سے لکھے۔',
        messageHindi:
            'माफी की इस रात, अल्लाह हमारे गुनाह माफ फरमाए और हमारी तकदीर भलाई से लिखे।',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Night of Records',
        titleUrdu: 'تقدیر کی رات',
        titleHindi: 'तक़दीर की रात',
        message:
            'May Allah write for you a year full of blessings, health, and success. Seek forgiveness on this blessed night.',
        messageUrdu:
            'اللہ آپ کے لیے برکتوں، صحت اور کامیابی سے بھرا سال لکھے۔ اس مبارک رات مغفرت مانگیں۔',
        messageHindi:
            'अल्लाह आपके लिए बरकतों, सेहत और कामयाबी से भरा साल लिखे। इस मुबारक रात माफी मांगें।',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Ramadan Preparation',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        message:
            'The Prophet ﷺ used to fast more in Sha\'ban. Let us follow his sunnah and prepare for Ramadan.',
        messageUrdu:
            'نبی کریم ﷺ شعبان میں زیادہ روزے رکھتے تھے۔ آئیے ان کی سنت پر عمل کریں اور رمضان کی تیاری کریں۔',
        messageHindi:
            'नबी करीम ﷺ शाबान में ज़्यादा रोज़े रखते थे। आइए उनकी सुन्नत पर अमल करें और रमज़ान की तैयारी करें।',
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
    gradient: [const Color(0xFFBA68C8), const Color(0xFFCE93D8)],
    cards: [
      GreetingCard(
        title: 'Ramadan Mubarak',
        titleUrdu: 'رمضان مبارک',
        titleHindi: 'रमज़ान मुबारक',
        message:
            'May this Ramadan bring you peace, prosperity, and happiness. May Allah accept your prayers and fasts.',
        messageUrdu:
            'یہ رمضان آپ کو امن، خوشحالی اور خوشی لائے۔ اللہ آپ کی نمازیں اور روزے قبول فرمائے۔',
        messageHindi:
            'यह रमज़ान आपको अमन, खुशहाली और खुशी लाए। अल्लाह आपकी नमाज़ें और रोज़े कबूल फरमाए।',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Ramadan Kareem',
        titleUrdu: 'رمضان کریم',
        titleHindi: 'रमज़ान करीम',
        message:
            'May the holy month of Ramadan light up your heart and home. Wishing you a blessed Ramadan!',
        messageUrdu:
            'رمضان کا مقدس مہینہ آپ کے دل اور گھر کو روشن کرے۔ آپ کو مبارک رمضان کی دعا!',
        messageHindi:
            'रमज़ान का मुकद्दस महीना आपके दिल और घर को रोशन करे। आपको मुबारक रमज़ान की दुआ!',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Blessed Month',
        titleUrdu: 'مبارک مہینہ',
        titleHindi: 'मुबारक महीना',
        message:
            'As the crescent moon is sighted, may Allah bless you with happiness and grace your home with peace.',
        messageUrdu:
            'جیسے ہی چاند نظر آئے، اللہ آپ کو خوشی سے نوازے اور آپ کے گھر کو امن سے مالا مال کرے۔',
        messageHindi:
            'जैसे ही चाँद नज़र आए, अल्लाह आपको खुशी से नवाज़े और आपके घर को अमन से माला माल करे।',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Laylatul Qadr',
        titleUrdu: 'لیلۃ القدر',
        titleHindi: 'लैलतुल क़द्र',
        message:
            'Seek Laylatul Qadr in the last ten nights. It is better than a thousand months. May Allah grant us its blessings.',
        messageUrdu:
            'آخری دس راتوں میں لیلۃ القدر تلاش کریں۔ یہ ہزار مہینوں سے بہتر ہے۔ اللہ ہمیں اس کی برکتیں عطا فرمائے۔',
        messageHindi:
            'आखिरी दस रातों में लैलतुल क़द्र तलाश करें। यह हज़ार महीनों से बेहतर है। अल्लाह हमें इसकी बरकतें अता फरमाए।',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Iftar Blessings',
        titleUrdu: 'افطار مبارک',
        titleHindi: 'इफ्तार मुबारक',
        message:
            'May every iftar be a source of blessings and every suhoor give you strength. Ramadan Mubarak!',
        messageUrdu:
            'ہر افطار برکت کا ذریعہ ہو اور ہر سحری آپ کو طاقت دے۔ رمضان مبارک!',
        messageHindi:
            'हर इफ्तार बरकत का ज़रिया हो और हर सहरी आपको ताकत दे। रमज़ान मुबारक!',
        icon: Icons.restaurant,
      ),
      GreetingCard(
        title: 'Taraweeh Greetings',
        titleUrdu: 'تراویح مبارک',
        titleHindi: 'तरावीह मुबारक',
        message:
            'May your Taraweeh prayers be accepted and your recitation of Quran bring light to your heart.',
        messageUrdu:
            'آپ کی تراویح قبول ہوں اور قرآن کی تلاوت آپ کے دل کو روشن کرے۔',
        messageHindi:
            'आपकी तरावीह कबूल हों और कुरआन की तिलावत आपके दिल को रोशन करे।',
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
    gradient: [const Color(0xFFFFB74D), const Color(0xFFFFE082)],
    cards: [
      GreetingCard(
        title: 'Eid Mubarak',
        titleUrdu: 'عید مبارک',
        titleHindi: 'ईद मुबारक',
        message:
            'May Allah accept your good deeds, forgive your transgressions and ease the suffering of all peoples. Eid Mubarak!',
        messageUrdu:
            'اللہ آپ کے نیک اعمال قبول فرمائے، گناہ معاف فرمائے اور سب کی تکالیف دور کرے۔ عید مبارک!',
        messageHindi:
            'अल्लाह आपके नेक आमाल कबूल फरमाए, गुनाह माफ करे और सबकी तकलीफें दूर करे। ईद मुबारक!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Eid',
        titleUrdu: 'مبارک عید',
        titleHindi: 'मुबारक ईद',
        message:
            'On this blessed day of Eid, may your heart be filled with joy and your home with happiness. Eid Mubarak!',
        messageUrdu:
            'عید کے اس مبارک دن، آپ کا دل خوشی سے بھرا ہو اور آپ کا گھر خوشیوں سے۔ عید مبارک!',
        messageHindi:
            'ईद के इस मुबारक दिन, आपका दिल खुशी से भरा हो और आपका घर खुशियों से। ईद मुबारक!',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Eid Greetings',
        titleUrdu: 'عید کی مبارکباد',
        titleHindi: 'ईद की मुबारकबाद',
        message:
            'May the magic of this Eid bring lots of happiness in your life. Celebrate it with all your loved ones!',
        messageUrdu:
            'اس عید کا جادو آپ کی زندگی میں بہت ساری خوشیاں لائے۔ اپنے پیاروں کے ساتھ منائیں!',
        messageHindi:
            'इस ईद का जादू आपकी ज़िंदगी में बहुत सारी खुशियां लाए। अपने प्यारों के साथ मनाएं!',
        icon: Icons.card_giftcard,
      ),
      GreetingCard(
        title: 'Eid ul-Fitr',
        titleUrdu: 'عید الفطر مبارک',
        titleHindi: 'ईद-उल-फ़ित्र मुबारक',
        message:
            'After a month of fasting and prayers, may this Eid bring you endless blessings. Taqabbal Allahu minna wa minkum!',
        messageUrdu:
            'روزوں اور نمازوں کے مہینے کے بعد، یہ عید آپ کو بے شمار برکتیں لائے۔ تقبل اللہ منا و منکم!',
        messageHindi:
            'रोज़ों और नमाज़ों के महीने के बाद, यह ईद आपको बेशुमार बरकतें लाए। तक़ब्बल अल्लाहु मिन्ना व मिनकुम!',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Six Fasts of Shawwal',
        titleUrdu: 'شوال کے چھ روزے',
        titleHindi: 'शव्वाल के छह रोज़े',
        message:
            'The Prophet ﷺ said: "Whoever fasts Ramadan and follows it with six days of Shawwal, it is as if he fasted the entire year."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "جس نے رمضان کے روزے رکھے اور شوال کے چھ روزے رکھے، گویا اس نے سال بھر روزے رکھے۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "जिसने रमज़ान के रोज़े रखे और शव्वाल के छह रोज़े रखे, गोया उसने साल भर रोज़े रखे।"',
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
    gradient: [const Color(0xFF78909C), const Color(0xFFB0BEC5)],
    cards: [
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        message:
            'Dhul Qa\'dah is one of the sacred months. May Allah bless you with peace and spiritual growth.',
        messageUrdu:
            'ذوالقعدہ حرمت والے مہینوں میں سے ایک ہے۔ اللہ آپ کو امن اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'ज़ुल-क़ादा हुरमत वाले महीनों में से एक है। अल्लाह आपको अमन और रूहानी तरक्की अता फरमाए।',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Hajj Preparation',
        titleUrdu: 'حج کی تیاری',
        titleHindi: 'हज की तैयारी',
        message:
            'For those preparing for Hajj, may Allah accept your pilgrimage and grant you a journey of a lifetime.',
        messageUrdu:
            'حج کی تیاری کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور زندگی کا بہترین سفر عطا فرمائے۔',
        messageHindi:
            'हज की तैयारी करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और ज़िंदगी का बेहतरीन सफर अता फरमाए।',
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
    gradient: [const Color(0xFFFF8A65), const Color(0xFFFFAB91)],
    cards: [
      GreetingCard(
        title: 'Eid ul-Adha Mubarak',
        titleUrdu: 'عید الاضحی مبارک',
        titleHindi: 'ईद-उल-अज़हा मुबारक',
        message:
            'May Allah flood your life with happiness on this occasion. Wishing you a very happy Eid ul-Adha!',
        messageUrdu:
            'اس موقع پر اللہ آپ کی زندگی خوشیوں سے بھر دے۔ آپ کو عید الاضحی بہت مبارک!',
        messageHindi:
            'इस मौके पर अल्लाह आपकी ज़िंदगी खुशियों से भर दे। आपको ईद-उल-अज़हा बहुत मुबारक!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Sacrifice',
        titleUrdu: 'مبارک قربانی',
        titleHindi: 'मुबारक कुर्बानी',
        message:
            'On this Eid ul-Adha, may your sacrifices be appreciated and your prayers be answered. Eid Mubarak!',
        messageUrdu:
            'اس عید الاضحی پر، آپ کی قربانیاں قبول ہوں اور دعائیں مقبول ہوں۔ عید مبارک!',
        messageHindi:
            'इस ईद-उल-अज़हा पर, आपकी कुर्बानियां कबूल हों और दुआएं मकबूल हों। ईद मुबारक!',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Day of Arafah',
        titleUrdu: 'یوم عرفہ',
        titleHindi: 'यौम-ए-अरफा',
        message:
            'The best dua is the dua on the Day of Arafah. May Allah accept all your prayers on this blessed day.',
        messageUrdu:
            'سب سے بہترین دعا یوم عرفہ کی دعا ہے۔ اللہ اس مبارک دن آپ کی تمام دعائیں قبول فرمائے۔',
        messageHindi:
            'सबसे बेहतरीन दुआ यौम-ए-अरफा की दुआ है। अल्लाह इस मुबारक दिन आपकी तमाम दुआएं कबूल फरमाए।',
        icon: Icons.terrain,
      ),
      GreetingCard(
        title: 'Hajj Mubarak',
        titleUrdu: 'حج مبارک',
        titleHindi: 'हज मुबारक',
        message:
            'For those performing Hajj, may Allah accept your pilgrimage and grant you Hajj Mabroor.',
        messageUrdu:
            'حج کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور حج مبرور عطا فرمائے۔',
        messageHindi:
            'हज करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और हज मबरूर अता फरमाए।',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'First Ten Days',
        titleUrdu: 'پہلے دس دن',
        titleHindi: 'पहले दस दिन',
        message:
            'The first ten days of Dhul Hijjah are the best days of the year. Increase your good deeds and worship.',
        messageUrdu:
            'ذوالحجہ کے پہلے دس دن سال کے بہترین دن ہیں۔ نیک اعمال اور عبادت بڑھائیں۔',
        messageHindi:
            'ज़ुल-हिज्जा के पहले दस दिन साल के बेहतरीन दिन हैं। नेक आमाल और इबादत बढ़ाएं।',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Qurbani Blessings',
        titleUrdu: 'قربانی مبارک',
        titleHindi: 'कुर्बानी मुबारक',
        message:
            'May your Qurbani be accepted and may Allah reward you for your sacrifice. Eid ul-Adha Mubarak!',
        messageUrdu:
            'آپ کی قربانی قبول ہو اور اللہ آپ کو اجر عطا فرمائے۔ عید الاضحی مبارک!',
        messageHindi:
            'आपकी कुर्बानी कबूल हो और अल्लाह आपको अज्र अता फरमाए। ईद-उल-अज़हा मुबारक!',
        icon: Icons.card_giftcard,
      ),
    ],
  ),
];
