import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/language_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedHijriDate = HijriCalendar.now();
    _selectedGregorianDate = DateTime.now();
  }

  String _getMonthName(int monthIndex, String langCode) {
    switch (langCode) {
      case 'ur':
        return AppStrings.islamicMonthsUrdu[monthIndex];
      case 'ar':
        return AppStrings.islamicMonthsArabic[monthIndex];
      case 'hi':
        return AppStrings.islamicMonthsHindi[monthIndex];
      default:
        return AppStrings.islamicMonths[monthIndex];
    }
  }

  String _getUrduArabicNumerals(dynamic number, String langCode) {
    if (langCode == 'ur' || langCode == 'ar') {
      return AppStrings.toUrduNumerals(number);
    }
    return number.toString();
  }

  String _getGregorianDateString(DateTime date, String langCode) {
    final weekdayIndex = date.weekday % 7;
    switch (langCode) {
      case 'ur':
        return '${AppStrings.daysOfWeekUrdu[weekdayIndex]}، ${AppStrings.toUrduNumerals(date.day)} ${AppStrings.gregorianMonthsUrdu[date.month - 1]} ${AppStrings.toUrduNumerals(date.year)}';
      case 'ar':
        return '${AppStrings.daysOfWeekArabic[weekdayIndex]}، ${AppStrings.toUrduNumerals(date.day)} ${AppStrings.gregorianMonthsArabic[date.month - 1]} ${AppStrings.toUrduNumerals(date.year)}';
      case 'hi':
        return '${AppStrings.daysOfWeekHindi[weekdayIndex]}, ${date.day} ${AppStrings.gregorianMonthsHindi[date.month - 1]} ${date.year}';
      default:
        return DateFormat('EEEE, MMMM d, yyyy').format(date);
    }
  }

  List<String> _getWeekdayHeaders(String langCode) {
    switch (langCode) {
      case 'ur':
        return AppStrings.daysOfWeekShortUrdu;
      case 'ar':
        return AppStrings.daysOfWeekShortArabic;
      case 'hi':
        return AppStrings.daysOfWeekShortHindi;
      default:
        return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr('islamic_calendar')),
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
    final langCode = context.watch<LanguageProvider>().languageCode;
    final today = HijriCalendar.now();
    final gregorianToday = DateTime.now();

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
            context.tr('today'),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            (langCode == 'ar' || langCode == 'ur')
                ? '${_getUrduArabicNumerals(today.hDay, langCode)} ${_getMonthName(today.hMonth - 1, langCode)} ${_getUrduArabicNumerals(today.hYear, langCode)} ${context.tr('ah')}'
                : langCode == 'hi'
                ? '${today.hDay} ${_getMonthName(today.hMonth - 1, langCode)} ${today.hYear} ${context.tr('ah')}'
                : '${today.hDay} ${today.longMonthName} ${today.hYear} ${context.tr('ah')}',
            style: TextStyle(
              color: Colors.white,
              fontSize: (langCode == 'ar' || langCode == 'ur') ? 26 : 28,
              fontWeight: FontWeight.bold,
            ),
            textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 4),
          Text(
            _getGregorianDateString(gregorianToday, langCode),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isRTL = langCode == 'ur' || langCode == 'ar';
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
                isRTL ? Icons.chevron_right : Icons.chevron_left,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  _getMonthName(_currentHijriMonth - 1, langCode),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
                SizedBox(width: 10),
                Text(
                  (langCode == 'ar' || langCode == 'ur')
                      ? '${_getUrduArabicNumerals(_currentHijriYear, langCode)} ${context.tr('ah')}'
                      : '$_currentHijriYear ${context.tr('ah')}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: Icon(
                isRTL ? Icons.chevron_left : Icons.chevron_right,
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
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isUrdu = langCode == 'ur';
    final weekdayHeaders = _getWeekdayHeaders(langCode);

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
                      _getUrduArabicNumerals(dayNumber, langCode),
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
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isUrdu = langCode == 'ur';

    // Important dates with month number (1-12) for filtering
    final allImportantDates = [
      _ImportantDateWithMonth(
        1,
        1,
        'islamic_new_year',
        Icons.celebration,
      ),
      _ImportantDateWithMonth(1, 10, 'ashura_event', Icons.star),
      _ImportantDateWithMonth(
        3,
        12,
        'mawlid_an_nabi',
        Icons.mosque,
      ),
      _ImportantDateWithMonth(
        7,
        27,
        'isra_miraj',
        Icons.nights_stay,
      ),
      _ImportantDateWithMonth(
        8,
        15,
        'shab_e_barat',
        Icons.auto_awesome,
      ),
      _ImportantDateWithMonth(
        9,
        1,
        'start_of_ramadan',
        Icons.brightness_2,
      ),
      _ImportantDateWithMonth(9, 27, 'laylat_al_qadr', Icons.star),
      _ImportantDateWithMonth(
        10,
        1,
        'eid_ul_fitr_event',
        Icons.celebration,
      ),
      _ImportantDateWithMonth(
        12,
        9,
        'day_of_arafah',
        Icons.terrain,
      ),
      _ImportantDateWithMonth(
        12,
        10,
        'eid_ul_adha_event',
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
                  ? '${_getMonthName(_currentHijriMonth - 1, langCode)} ${context.tr('important_dates_in')}'
                  : '${context.tr('important_dates_in')} ${_getMonthName(_currentHijriMonth - 1, langCode)}',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                context.tr('no_important_dates_this_month'),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
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
                ? '${_getMonthName(_currentHijriMonth - 1, langCode)} ${context.tr('important_dates_in')}'
                : '${context.tr('important_dates_in')} ${_getMonthName(_currentHijriMonth - 1, langCode)}',
            style: Theme.of(context).textTheme.headlineSmall,
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          const SizedBox(height: 12),
          ...currentMonthDates.map((date) {
            const darkGreen = Color(0xFF0A5C36);
            const emeraldGreen = Color(0xFF1E8F5A);
            const lightGreenBorder = Color(0xFF8AAF9A);
            const lightGreenChip = Color(0xFFE8F3ED);

            final dateText = (langCode == 'ar' || langCode == 'ur')
                ? '${_getUrduArabicNumerals(date.day, langCode)} ${_getMonthName(_currentHijriMonth - 1, langCode)}'
                : '${date.day} ${_getMonthName(_currentHijriMonth - 1, langCode)}';
            final nameText = context.tr(date.translationKey);

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
    final langCode = context.read<LanguageProvider>().languageCode;

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
              (langCode == 'ar' || langCode == 'ur')
                  ? '${_getUrduArabicNumerals(day, langCode)} ${_getMonthName(_currentHijriMonth - 1, langCode)} ${_getUrduArabicNumerals(_currentHijriYear, langCode)} ${context.tr('ah')}'
                  : langCode == 'hi'
                  ? '$day ${_getMonthName(_currentHijriMonth - 1, langCode)} $_currentHijriYear ${context.tr('ah')}'
                  : '$day ${AppStrings.islamicMonths[_currentHijriMonth - 1]} $_currentHijriYear ${context.tr('ah')}',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 8),
            Text(
              _getGregorianDateString(_selectedGregorianDate, langCode),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
              textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportantDateWithMonth {
  final int month;
  final int day;
  final String translationKey;
  final IconData icon;

  _ImportantDateWithMonth(
    this.month,
    this.day,
    this.translationKey,
    this.icon,
  );
}
