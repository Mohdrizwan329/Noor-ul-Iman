import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

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
  final ContentService _contentService = ContentService();
  bool _isContentLoading = true;
  CalendarScreenContentFirestore? _calendarContent;

  @override
  void initState() {
    super.initState();
    _selectedHijriDate = HijriCalendar.now();
    _selectedGregorianDate = DateTime.now();
    _loadCalendarContent();
  }

  /// Load all calendar screen content from Firebase - no static fallback
  Future<void> _loadCalendarContent() async {
    try {
      final content = await _contentService.getCalendarScreenContent();
      if (mounted) {
        setState(() {
          _calendarContent = content;
          _isContentLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading calendar content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
      }
    }
  }

  /// Get translated string from Firebase only - no static fallback
  String _t(String key) {
    if (_calendarContent == null) return '';
    final langCode =
        Provider.of<LanguageProvider>(context, listen: false).languageCode;
    return _calendarContent!.getString(key, langCode);
  }

  String _getMonthName(int monthIndex, String langCode) {
    if (_calendarContent == null) return '';
    return _calendarContent!.getIslamicMonths(langCode)[monthIndex];
  }

  String _getUrduArabicNumerals(dynamic number, String langCode) {
    if ((langCode == 'ur' || langCode == 'ar') && _calendarContent != null) {
      return _calendarContent!.toUrduNumerals(number);
    }
    return number.toString();
  }

  String _getGregorianDateString(DateTime date, String langCode) {
    if (_calendarContent == null) return '';
    final weekdayIndex = date.weekday % 7;
    switch (langCode) {
      case 'ur':
        return '${_calendarContent!.getDaysOfWeek('ur')[weekdayIndex]}، ${_calendarContent!.toUrduNumerals(date.day)} ${_calendarContent!.getGregorianMonths('ur')[date.month - 1]} ${_calendarContent!.toUrduNumerals(date.year)}';
      case 'ar':
        return '${_calendarContent!.getDaysOfWeek('ar')[weekdayIndex]}، ${_calendarContent!.toUrduNumerals(date.day)} ${_calendarContent!.getGregorianMonths('ar')[date.month - 1]} ${_calendarContent!.toUrduNumerals(date.year)}';
      case 'hi':
        return '${_calendarContent!.getDaysOfWeek('hi')[weekdayIndex]}, ${date.day} ${_calendarContent!.getGregorianMonths('hi')[date.month - 1]} ${date.year}';
      default:
        return '${_calendarContent!.getDaysOfWeek('en')[weekdayIndex]}, ${_calendarContent!.getGregorianMonths('en')[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  List<String> _getWeekdayHeaders(String langCode) {
    if (_calendarContent == null) return List.filled(7, '');
    return _calendarContent!.getIslamicDaysOfWeek(langCode);
  }

  @override
  Widget build(BuildContext context) {
    if (_isContentLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: AppColors.primary),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_t('islamic_calendar')),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTodayCard(),
                  _buildMonthNavigation(),
                  _buildCalendarGrid(),
                  _buildImportantDates(),
                ],
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildTodayCard() {
    final responsive = ResponsiveUtils(context);
    final langCode = context.watch<LanguageProvider>().languageCode;
    final today = HijriCalendar.now();
    final gregorianToday = DateTime.now();

    return Container(
      margin: responsive.paddingAll(16),
      padding: responsive.paddingAll(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
      ),
      child: Column(
        children: [
          Text(
            _t('today'),
            style: TextStyle(color: Colors.white70, fontSize: responsive.fontSize(16)),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            (langCode == 'ar' || langCode == 'ur')
                ? '${_getUrduArabicNumerals(today.hDay, langCode)} ${_getMonthName(today.hMonth - 1, langCode)} ${_getUrduArabicNumerals(today.hYear, langCode)} ${_t('ah')}'
                : langCode == 'hi'
                ? '${today.hDay} ${_getMonthName(today.hMonth - 1, langCode)} ${today.hYear} ${_t('ah')}'
                : '${today.hDay} ${_getMonthName(today.hMonth - 1, langCode)} ${today.hYear} ${_t('ah')}',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize((langCode == 'ar' || langCode == 'ur') ? 26 : 28),
              fontWeight: FontWeight.bold,
            ),
            textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: responsive.spacing(4)),
          Text(
            _getGregorianDateString(gregorianToday, langCode),
            style: TextStyle(color: Colors.white70, fontSize: responsive.fontSize(16)),
            textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    final responsive = ResponsiveUtils(context);
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isRTL = langCode == 'ur' || langCode == 'ar';
    return Padding(
      padding: responsive.paddingSymmetric(horizontal: 16, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      _getMonthName(_currentHijriMonth - 1, langCode),
                      style: TextStyle(color: Colors.white, fontSize: responsive.fontSize(16)),
                      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: responsive.spacing(10)),
                  Text(
                    (langCode == 'ar' || langCode == 'ur')
                        ? '${_getUrduArabicNumerals(_currentHijriYear, langCode)} ${_t('ah')}'
                        : '$_currentHijriYear ${_t('ah')}',
                    style: TextStyle(color: Colors.white, fontSize: responsive.fontSize(16)),
                    textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ],
              ),
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
    final responsive = ResponsiveUtils(context);
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
      margin: responsive.paddingAll(16),
      padding: responsive.paddingAll(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
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
                width: responsive.spacing(40),
                child: Text(
                  weekdayHeaders[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isFriday
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontSize: responsive.fontSize(isUrdu ? 12 : 14),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: responsive.spacing(12)),

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
                        fontSize: responsive.fontSize(16),
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
    final responsive = ResponsiveUtils(context);
    final langCode = context.watch<LanguageProvider>().languageCode;
    final isUrdu = langCode == 'ur';

    // Important dates from Firebase - filter for current month
    final allImportantDates = _calendarContent?.importantDates ?? [];
    final currentMonthDates = allImportantDates
        .where((date) => date.month == _currentHijriMonth)
        .toList();

    // If no important dates this month, show message
    if (currentMonthDates.isEmpty) {
      return Container(
        margin: responsive.paddingAll(16),
        child: Column(
          crossAxisAlignment: isUrdu
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              isUrdu
                  ? '${_getMonthName(_currentHijriMonth - 1, langCode)} ${_t('important_dates_in')}'
                  : '${_t('important_dates_in')} ${_getMonthName(_currentHijriMonth - 1, langCode)}',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            SizedBox(height: responsive.spacing(16)),
            Center(
              child: Text(
                _t('no_important_dates_this_month'),
                style: TextStyle(color: AppColors.textSecondary, fontSize: responsive.fontSize(16)),
                textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: responsive.paddingAll(16),
      child: Column(
        crossAxisAlignment: isUrdu
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            isUrdu
                ? '${_getMonthName(_currentHijriMonth - 1, langCode)} ${_t('important_dates_in')}'
                : '${_t('important_dates_in')} ${_getMonthName(_currentHijriMonth - 1, langCode)}',
            style: Theme.of(context).textTheme.headlineSmall,
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          SizedBox(height: responsive.spacing(12)),
          ...currentMonthDates.map((date) {
            const darkGreen = Color(0xFF0A5C36);
            const emeraldGreen = Color(0xFF1E8F5A);
            const lightGreenBorder = Color(0xFF8AAF9A);
            const lightGreenChip = Color(0xFFE8F3ED);

            final dateText = (langCode == 'ar' || langCode == 'ur')
                ? '${_getUrduArabicNumerals(date.day, langCode)} ${_getMonthName(_currentHijriMonth - 1, langCode)}'
                : '${date.day} ${_getMonthName(_currentHijriMonth - 1, langCode)}';
            final nameText = _t(date.titleKey);
            final descText = date.descKey.isNotEmpty ? _t(date.descKey) : '';

            return Container(
              margin: EdgeInsets.only(bottom: responsive.spacing(10)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
                border: Border.all(color: lightGreenBorder, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: darkGreen.withValues(alpha: 0.08),
                    blurRadius: responsive.spacing(10),
                    offset: Offset(0, responsive.spacing(2)),
                  ),
                ],
              ),
              child: Padding(
                padding: responsive.paddingAll(14),
                child: Row(
                  children: [
                    if (!isUrdu) ...[
                      Container(
                        width: responsive.spacing(48),
                        height: responsive.spacing(48),
                        decoration: BoxDecoration(
                          color: darkGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: darkGreen.withValues(alpha: 0.3),
                              blurRadius: responsive.spacing(8),
                              offset: Offset(0, responsive.spacing(2)),
                            ),
                          ],
                        ),
                        child: Icon(_getIconData(date.icon), color: Colors.white, size: responsive.iconSize(22)),
                      ),
                      SizedBox(width: responsive.spacing(14)),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: isUrdu
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameText,
                            style: TextStyle(
                              fontSize: responsive.fontSize(16),
                              fontWeight: FontWeight.bold,
                              color: darkGreen,
                            ),
                            textDirection: isUrdu
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: responsive.spacing(4)),
                          Container(
                            padding: responsive.paddingSymmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: lightGreenChip,
                              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                            ),
                            child: Text(
                              dateText,
                              style: TextStyle(
                                fontSize: responsive.fontSize(11),
                                fontWeight: FontWeight.w600,
                                color: emeraldGreen,
                              ),
                              textDirection: isUrdu
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                          if (descText.isNotEmpty) ...[
                            SizedBox(height: responsive.spacing(6)),
                            Text(
                              descText,
                              style: TextStyle(
                                fontSize: responsive.fontSize(12),
                                color: Colors.grey[600],
                              ),
                              textDirection: (langCode == 'ar' || langCode == 'ur')
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isUrdu) ...[
                      SizedBox(width: responsive.spacing(14)),
                      Container(
                        width: responsive.spacing(48),
                        height: responsive.spacing(48),
                        decoration: BoxDecoration(
                          color: darkGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: darkGreen.withValues(alpha: 0.3),
                              blurRadius: responsive.spacing(8),
                              offset: Offset(0, responsive.spacing(2)),
                            ),
                          ],
                        ),
                        child: Icon(_getIconData(date.icon), color: Colors.white, size: responsive.iconSize(22)),
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

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'celebration': return Icons.celebration;
      case 'star': return Icons.star;
      case 'mosque': return Icons.mosque;
      case 'nights_stay': return Icons.nights_stay;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'brightness_2': return Icons.brightness_2;
      case 'flight_takeoff': return Icons.flight_takeoff;
      case 'terrain': return Icons.terrain;
      default: return Icons.star;
    }
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveUtils(context).borderRadius(20))),
      ),
      builder: (context) => Container(
        padding: ResponsiveUtils(context).paddingAll(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (langCode == 'ar' || langCode == 'ur')
                  ? '${_getUrduArabicNumerals(day, langCode)} ${_getMonthName(_currentHijriMonth - 1, langCode)} ${_getUrduArabicNumerals(_currentHijriYear, langCode)} ${_t('ah')}'
                  : langCode == 'hi'
                  ? '$day ${_getMonthName(_currentHijriMonth - 1, langCode)} $_currentHijriYear ${_t('ah')}'
                  : '$day ${_getMonthName(_currentHijriMonth - 1, langCode)} $_currentHijriYear ${_t('ah')}',
              style: Theme.of(context).textTheme.headlineSmall,
              textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            ),
            SizedBox(height: ResponsiveUtils(context).spacing(8)),
            Text(
              _getGregorianDateString(_selectedGregorianDate, langCode),
              style: TextStyle(color: AppColors.textSecondary, fontSize: ResponsiveUtils(context).fontSize(16)),
              textDirection: (langCode == 'ar' || langCode == 'ur') ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}
