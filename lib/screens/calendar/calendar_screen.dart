import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

enum CalendarLanguage { english, urdu }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late HijriCalendar _selectedHijriDate;
  late DateTime _selectedGregorianDate;
  int _currentHijriMonth = HijriCalendar.now().hMonth;
  int _currentHijriYear = HijriCalendar.now().hYear;

  // Language selection
  CalendarLanguage _selectedLanguage = CalendarLanguage.english;

  static const Map<CalendarLanguage, String> languageNames = {
    CalendarLanguage.english: 'English',
    CalendarLanguage.urdu: 'Urdu',
  };

  @override
  void initState() {
    super.initState();
    _selectedHijriDate = HijriCalendar.now();
    _selectedGregorianDate = DateTime.now();
  }

  String _getMonthName(int monthIndex) {
    return _selectedLanguage == CalendarLanguage.urdu
        ? AppStrings.islamicMonthsUrdu[monthIndex]
        : AppStrings.islamicMonths[monthIndex];
  }

  List<String> _getWeekdayHeaders() {
    return _selectedLanguage == CalendarLanguage.urdu
        ? AppStrings.daysOfWeekShortUrdu
        : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  String _getDayName(HijriCalendar date) {
    final gregorian = date.hijriToGregorian(date.hYear, date.hMonth, date.hDay);
    final weekdayIndex = gregorian.weekday % 7;
    return _selectedLanguage == CalendarLanguage.urdu
        ? AppStrings.daysOfWeekUrdu[weekdayIndex]
        : AppStrings.daysOfWeek[weekdayIndex];
  }

  @override
  Widget build(BuildContext context) {
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(isUrdu ? 'اسلامی کیلنڈر' : 'Islamic Calendar'),
        actions: [
          PopupMenuButton<CalendarLanguage>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                languageNames[_selectedLanguage]!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
            onSelected: (CalendarLanguage language) {
              setState(() {
                _selectedLanguage = language;
              });
            },
            itemBuilder: (context) => CalendarLanguage.values.map((language) {
              return PopupMenuItem<CalendarLanguage>(
                value: language,
                child: Row(
                  children: [
                    if (_selectedLanguage == language)
                      const Icon(
                        Icons.check,
                        color: AppColors.primary,
                        size: 18,
                      )
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(languageNames[language]!),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Today's Date Card
            _buildTodayCard(),

            // Month Navigation
            _buildMonthNavigation(),

            // Calendar Grid
            _buildCalendarGrid(),

            // Important Dates
            _buildImportantDates(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayCard() {
    final today = HijriCalendar.now();
    final gregorianToday = DateTime.now();
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            isUrdu ? 'آج' : 'Today',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            isUrdu
                ? '${AppStrings.toUrduNumerals(today.hDay)} ${_getMonthName(today.hMonth - 1)} ${AppStrings.toUrduNumerals(today.hYear)} ہجری'
                : '${today.hDay} ${today.longMonthName} ${today.hYear} AH',
            style: TextStyle(
              color: Colors.white,
              fontSize: isUrdu ? 26 : 28,
              fontWeight: FontWeight.bold,
            ),
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 4),
          Text(
            isUrdu
                ? '${AppStrings.daysOfWeekUrdu[gregorianToday.weekday % 7]}، ${AppStrings.toUrduNumerals(gregorianToday.day)} ${AppStrings.gregorianMonthsUrdu[gregorianToday.month - 1]} ${AppStrings.toUrduNumerals(gregorianToday.year)}'
                : DateFormat('EEEE, MMMM d, yyyy').format(gregorianToday),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: Icon(
                isUrdu ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  _getMonthName(_currentHijriMonth - 1),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
                SizedBox(width: 10),
                Text(
                  isUrdu
                      ? '${AppStrings.toUrduNumerals(_currentHijriYear)} ہجری'
                      : '$_currentHijriYear AH',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: Icon(
                isUrdu ? Icons.chevron_left : Icons.chevron_right,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenBorder = Color(0xFF8AAF9A);

    final daysInMonth = HijriCalendar().getDaysInMonth(
      _currentHijriYear,
      _currentHijriMonth,
    );
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;
    final weekdayHeaders = _getWeekdayHeaders();

    // Get the first day of the month
    final firstDay = HijriCalendar()
      ..hYear = _currentHijriYear
      ..hMonth = _currentHijriMonth
      ..hDay = 1;

    // Convert to Gregorian to get the weekday
    final gregorianFirst = firstDay.hijriToGregorian(
      _currentHijriYear,
      _currentHijriMonth,
      1,
    );
    final startWeekday = gregorianFirst.weekday % 7; // Sunday = 0

    final today = HijriCalendar.now();
    final isCurrentMonth =
        today.hMonth == _currentHijriMonth && today.hYear == _currentHijriYear;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final isFriday = index == 5;
              return SizedBox(
                width: 40,
                child: Text(
                  weekdayHeaders[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isFriday
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: isUrdu ? 12 : 14,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Calendar days
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 rows * 7 days
            itemBuilder: (context, index) {
              final dayNumber = index - startWeekday + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return const SizedBox();
              }

              final isToday = isCurrentMonth && dayNumber == today.hDay;
              final isSelected =
                  dayNumber == _selectedHijriDate.hDay &&
                  _currentHijriMonth == _selectedHijriDate.hMonth &&
                  _currentHijriYear == _selectedHijriDate.hYear;
              final isFriday = (index % 7) == 5;

              return GestureDetector(
                onTap: () => _selectDate(dayNumber),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isToday
                        ? AppColors.primary
                        : isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      isUrdu
                          ? AppStrings.toUrduNumerals(dayNumber)
                          : '$dayNumber',
                      style: TextStyle(
                        color: isToday
                            ? Colors.white
                            : isFriday
                            ? AppColors.primary
                            : null,
                        fontWeight: isToday || isSelected
                            ? FontWeight.bold
                            : null,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImportantDates() {
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;

    // Important dates with month number (1-12) for filtering
    final allImportantDates = [
      _ImportantDateWithMonth(
        1,
        1,
        'Islamic New Year',
        'اسلامی نیا سال',
        Icons.celebration,
      ),
      _ImportantDateWithMonth(1, 10, 'Ashura', 'یوم عاشورہ', Icons.star),
      _ImportantDateWithMonth(
        3,
        12,
        'Mawlid an-Nabi',
        'عید میلاد النبی ﷺ',
        Icons.mosque,
      ),
      _ImportantDateWithMonth(
        7,
        27,
        "Isra' and Mi'raj",
        'شب معراج',
        Icons.nights_stay,
      ),
      _ImportantDateWithMonth(
        8,
        15,
        "Shab-e-Bara'at",
        'شب برات',
        Icons.auto_awesome,
      ),
      _ImportantDateWithMonth(
        9,
        1,
        'Start of Ramadan',
        'رمضان کی شروعات',
        Icons.brightness_2,
      ),
      _ImportantDateWithMonth(9, 27, 'Laylat al-Qadr', 'شب قدر', Icons.star),
      _ImportantDateWithMonth(
        10,
        1,
        'Eid ul-Fitr',
        'عید الفطر',
        Icons.celebration,
      ),
      _ImportantDateWithMonth(
        12,
        9,
        'Day of Arafah',
        'یوم عرفہ',
        Icons.terrain,
      ),
      _ImportantDateWithMonth(
        12,
        10,
        'Eid ul-Adha',
        'عید الاضحیٰ',
        Icons.celebration,
      ),
    ];

    // Filter dates for current month
    final currentMonthDates = allImportantDates
        .where((date) => date.month == _currentHijriMonth)
        .toList();

    // If no important dates this month, show message
    if (currentMonthDates.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: isUrdu
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              isUrdu
                  ? '${_getMonthName(_currentHijriMonth - 1)} کی اہم تاریخیں'
                  : 'Important Dates in ${_getMonthName(_currentHijriMonth - 1)}',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                isUrdu
                    ? 'اس مہینے میں کوئی خاص تاریخ نہیں ہے'
                    : 'No important dates this month',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: isUrdu
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            isUrdu
                ? '${_getMonthName(_currentHijriMonth - 1)} کی اہم تاریخیں'
                : 'Important Dates in ${_getMonthName(_currentHijriMonth - 1)}',
            style: Theme.of(context).textTheme.headlineSmall,
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          ...currentMonthDates.map((date) {
            const darkGreen = Color(0xFF0A5C36);
            const emeraldGreen = Color(0xFF1E8F5A);
            const lightGreenBorder = Color(0xFF8AAF9A);
            const lightGreenChip = Color(0xFFE8F3ED);

            final dateText = isUrdu
                ? '${AppStrings.toUrduNumerals(date.day)} ${_getMonthName(_currentHijriMonth - 1)}'
                : '${date.day} ${_getMonthName(_currentHijriMonth - 1)}';
            final nameText = isUrdu ? date.nameUrdu : date.nameEnglish;

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    if (!isUrdu) ...[
                      Container(
                        width: 48,
                        height: 48,
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
                        child: Icon(date.icon, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isUrdu
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                            textDirection: isUrdu
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreenChip,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              dateText,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                              ),
                              textDirection: isUrdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isUrdu) ...[
                      const SizedBox(width: 14),
                      Container(
                        width: 48,
                        height: 48,
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
                        child: Icon(date.icon, color: Colors.white, size: 22),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      if (_currentHijriMonth == 1) {
        _currentHijriMonth = 12;
        _currentHijriYear--;
      } else {
        _currentHijriMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentHijriMonth == 12) {
        _currentHijriMonth = 1;
        _currentHijriYear++;
      } else {
        _currentHijriMonth++;
      }
    });
  }

  void _selectDate(int day) {
    final isUrdu = _selectedLanguage == CalendarLanguage.urdu;

    setState(() {
      _selectedHijriDate = HijriCalendar()
        ..hYear = _currentHijriYear
        ..hMonth = _currentHijriMonth
        ..hDay = day;

      _selectedGregorianDate = _selectedHijriDate.hijriToGregorian(
        _currentHijriYear,
        _currentHijriMonth,
        day,
      );
    });

    // Show selected date info
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isUrdu
                  ? '${AppStrings.toUrduNumerals(day)} ${_getMonthName(_currentHijriMonth - 1)} ${AppStrings.toUrduNumerals(_currentHijriYear)} ہجری'
                  : '$day ${AppStrings.islamicMonths[_currentHijriMonth - 1]} $_currentHijriYear AH',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 8),
            Text(
              isUrdu
                  ? '${AppStrings.daysOfWeekUrdu[_selectedGregorianDate.weekday % 7]}، ${AppStrings.toUrduNumerals(_selectedGregorianDate.day)} ${AppStrings.gregorianMonthsUrdu[_selectedGregorianDate.month - 1]} ${AppStrings.toUrduNumerals(_selectedGregorianDate.year)}'
                  : DateFormat(
                      'EEEE, MMMM d, yyyy',
                    ).format(_selectedGregorianDate),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysDiff = date.difference(firstDayOfYear).inDays;
    return ((daysDiff + firstDayOfYear.weekday) / 7).ceil();
  }
}

class _ImportantDateWithMonth {
  final int month;
  final int day;
  final String nameEnglish;
  final String nameUrdu;
  final IconData icon;

  _ImportantDateWithMonth(
    this.month,
    this.day,
    this.nameEnglish,
    this.nameUrdu,
    this.icon,
  );
}
