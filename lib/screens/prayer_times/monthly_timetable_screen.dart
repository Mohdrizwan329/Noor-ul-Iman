import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/prayer_time_model.dart';
import '../../widgets/common/banner_ad_widget.dart';

class MonthlyTimetableScreen extends StatefulWidget {
  const MonthlyTimetableScreen({super.key});

  @override
  State<MonthlyTimetableScreen> createState() => _MonthlyTimetableScreenState();
}

class _MonthlyTimetableScreenState extends State<MonthlyTimetableScreen> {
  late int _selectedMonth;
  late int _selectedYear;
  bool _isLoading = false;
  final ContentService _contentService = ContentService();
  PrayerTimesScreenContentFirestore? _content;
  bool _isContentLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = await _contentService.getPrayerTimesScreenContent();
      if (mounted) {
        setState(() {
          _content = content;
          _isContentLoading = false;
        });
        _loadMonthlyData();
      }
    } catch (e) {
      debugPrint('Error loading prayer times content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
        _loadMonthlyData();
      }
    }
  }

  String get _langCode =>
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  /// Get translated string from Firebase only
  String _t(String key) {
    if (_content == null) return '';
    return _content!.getString(key, _langCode);
  }

  Future<void> _loadMonthlyData() async {
    setState(() => _isLoading = true);

    final provider = context.read<PrayerProvider>();
    await provider.fetchMonthlyPrayerTimes(_selectedMonth, _selectedYear);

    setState(() => _isLoading = false);
  }

  void _previousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
    _loadMonthlyData();
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
    _loadMonthlyData();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    if (_isContentLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('monthly_timetable'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Column(
        children: [
          // Month Navigation Header
          Container(
            padding: responsive.paddingRegular,
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: responsive.iconLarge,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth)),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.textXXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_selectedYear',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: responsive.textRegular,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: responsive.iconLarge,
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            color: AppColors.primary.withValues(alpha: 0.1),
            padding: responsive.paddingSymmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                _buildHeaderCell(context, _t('date'), flex: 2),
                _buildHeaderCell(context, _t('fajr')),
                _buildHeaderCell(context, _t('sunrise')),
                _buildHeaderCell(context, _t('dhuhr')),
                _buildHeaderCell(context, _t('asr')),
                _buildHeaderCell(context, _t('maghrib')),
                _buildHeaderCell(context, _t('isha')),
              ],
            ),
          ),

          // Table Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Consumer<PrayerProvider>(
                    builder: (context, provider, child) {
                      final prayerTimes = provider.monthlyPrayerTimes;

                      if (prayerTimes.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: responsive.iconXXLarge,
                                color: Colors.grey,
                              ),
                              SizedBox(height: responsive.spaceRegular),
                              Text(
                                _t('no_prayer_times'),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: responsive.textRegular,
                                ),
                              ),
                              SizedBox(height: responsive.spaceRegular),
                              ElevatedButton(
                                onPressed: _loadMonthlyData,
                                child: Text(
                                  _t('retry'),
                                  style: TextStyle(fontSize: responsive.textMedium),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: prayerTimes.length,
                        itemBuilder: (context, index) {
                          return _buildDayRow(context, prayerTimes[index], index);
                        },
                      );
                    },
                  ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(BuildContext context, String text, {int flex = 1}) {
    final responsive = ResponsiveUtils(context);

    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: responsive.textSmall,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDayRow(BuildContext context, PrayerTimeModel prayerTime, int index) {
    final responsive = ResponsiveUtils(context);
    final today = DateTime.now();
    final dayNumber = index + 1;
    final isToday = today.day == dayNumber &&
        today.month == _selectedMonth &&
        today.year == _selectedYear;

    // Parse date to get day name
    final date = DateTime(_selectedYear, _selectedMonth, dayNumber);
    final dayName = DateFormat('EEE').format(date);
    final isFriday = date.weekday == DateTime.friday;

    return Container(
      padding: responsive.paddingSymmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.primary.withValues(alpha: 0.15)
            : (index % 2 == 0 ? Colors.white : Colors.grey.withValues(alpha: 0.05)),
        border: isToday
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                    fontSize: responsive.textMedium,
                    color: isToday ? AppColors.primary : null,
                  ),
                ),
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: responsive.textXSmall,
                    color: isFriday
                        ? AppColors.primary
                        : (isToday ? AppColors.primary : Colors.grey),
                    fontWeight: isFriday ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
          _buildTimeCell(prayerTime.fajr, isToday, responsive),
          _buildTimeCell(prayerTime.sunrise, isToday, responsive),
          _buildTimeCell(prayerTime.dhuhr, isToday, responsive),
          _buildTimeCell(prayerTime.asr, isToday, responsive),
          _buildTimeCell(prayerTime.maghrib, isToday, responsive),
          _buildTimeCell(prayerTime.isha, isToday, responsive),
        ],
      ),
    );
  }

  Widget _buildTimeCell(String time, bool isToday, ResponsiveUtils responsive) {
    return Expanded(
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: responsive.textSmall,
          fontWeight: isToday ? FontWeight.w600 : null,
          color: isToday ? AppColors.primary : null,
        ),
      ),
    );
  }
}
