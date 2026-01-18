import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Timetable'),
      ),
      body: Column(
        children: [
          // Month Navigation Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Column(
                  children: [
                    Text(
                      DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$_selectedYear',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            color: AppColors.primary.withValues(alpha: 0.1),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                _buildHeaderCell('Date', flex: 2),
                _buildHeaderCell('Fajr'),
                _buildHeaderCell('Sunrise'),
                _buildHeaderCell('Dhuhr'),
                _buildHeaderCell('Asr'),
                _buildHeaderCell('Maghrib'),
                _buildHeaderCell('Isha'),
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
                              const Icon(
                                Icons.calendar_today,
                                size: 64,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No prayer times available',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadMonthlyData,
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: prayerTimes.length,
                        itemBuilder: (context, index) {
                          return _buildDayRow(prayerTimes[index], index);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 11,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDayRow(PrayerTimeModel prayerTime, int index) {
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
                    fontSize: 14,
                    color: isToday ? AppColors.primary : null,
                  ),
                ),
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 10,
                    color: isFriday
                        ? AppColors.primary
                        : (isToday ? AppColors.primary : Colors.grey),
                    fontWeight: isFriday ? FontWeight.bold : null,
                  ),
                ),
              ],
            ),
          ),
          _buildTimeCell(prayerTime.fajr, isToday),
          _buildTimeCell(prayerTime.sunrise, isToday),
          _buildTimeCell(prayerTime.dhuhr, isToday),
          _buildTimeCell(prayerTime.asr, isToday),
          _buildTimeCell(prayerTime.maghrib, isToday),
          _buildTimeCell(prayerTime.isha, isToday),
        ],
      ),
    );
  }

  Widget _buildTimeCell(String time, bool isToday) {
    return Expanded(
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isToday ? FontWeight.w600 : null,
          color: isToday ? AppColors.primary : null,
        ),
      ),
    );
  }
}
