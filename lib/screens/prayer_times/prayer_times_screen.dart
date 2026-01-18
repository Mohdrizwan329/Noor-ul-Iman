import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/adhan_provider.dart';
import '../../data/models/prayer_time_model.dart';

class PrayerTimesScreen extends StatelessWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Schedule notifications when prayer times are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = context.read<PrayerProvider>();
      final adhanProvider = context.read<AdhanProvider>();
      if (prayerProvider.todayPrayerTimes != null) {
        adhanProvider.schedulePrayerNotifications(
          prayerProvider.todayPrayerTimes!,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Times')),
      body: Consumer<PrayerProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.initialize(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final prayerTimes = provider.todayPrayerTimes;
          if (prayerTimes == null) {
            return const Center(child: Text('No prayer times available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Next Prayer Card with Date
                _buildNextPrayerCard(context, provider, prayerTimes),
                const SizedBox(height: 20),

                // Prayer Times List
                Text(
                  "Today's Prayer Times",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                ...prayerTimes.toPrayerList().map(
                  (prayer) => _buildPrayerTimeCard(
                    context,
                    prayer,
                    provider.nextPrayer == prayer.name,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNextPrayerCard(
    BuildContext context,
    PrayerProvider provider,
    PrayerTimeModel prayerTimes,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Date and Hijri Date
              Text(
                prayerTimes.date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  prayerTimes.hijriDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Next Prayer
          const Text(
            'Next Prayer',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                provider.nextPrayer,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: Colors.white, size: 18),
                    const SizedBox(height: 8),
                    Text(
                      provider.formattedTimeRemaining,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeCard(
    BuildContext context,
    PrayerItem prayer,
    bool isNext,
  ) {
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isNext ? emeraldGreen : lightGreenBorder,
          width: isNext ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isNext ? darkGreen : lightGreenChip,
              shape: BoxShape.circle,
              boxShadow: isNext
                  ? [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(prayer.icon, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isNext ? darkGreen : darkGreen,
                  ),
                ),
                if (isNext)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Next Prayer',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: emeraldGreen,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Text(
            prayer.time,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isNext ? emeraldGreen : darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
