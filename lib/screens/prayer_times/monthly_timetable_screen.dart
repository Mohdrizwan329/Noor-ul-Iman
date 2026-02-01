import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/prayer_provider.dart';
import '../../data/models/prayer_time_model.dart';

class MonthlyTimetableScreen extends StatefulWidget {
  const MonthlyTimetableScreen({super.key});

  @override
  State<MonthlyTimetableScreen> createState() => _MonthlyTimetableScreenState();
}

class _MonthlyTimetableScreenState extends State<MonthlyTimetableScreen> {
  late int _selectedMonth;
  late int _selectedYear;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
    _loadMonthlyData();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('monthly_timetable'),
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
                _buildHeaderCell(context, context.tr('date'), flex: 2),
                _buildHeaderCell(context, context.tr('fajr')),
                _buildHeaderCell(context, context.tr('sunrise')),
                _buildHeaderCell(context, context.tr('dhuhr')),
                _buildHeaderCell(context, context.tr('asr')),
                _buildHeaderCell(context, context.tr('maghrib')),
                _buildHeaderCell(context, context.tr('isha')),
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
                                context.tr('no_prayer_times'),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: responsive.textRegular,
                                ),
                              ),
                              SizedBox(height: responsive.spaceRegular),
                              ElevatedButton(
                                onPressed: _loadMonthlyData,
                                child: Text(
                                  context.tr('retry'),
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
