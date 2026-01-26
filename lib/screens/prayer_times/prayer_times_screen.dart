import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/adhan_provider.dart';
import '../../data/models/prayer_time_model.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final ScrollController _scrollController = ScrollController();
  String _lastNextPrayer = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNextPrayer(String nextPrayer, List<PrayerItem> prayerList) {
    if (nextPrayer == _lastNextPrayer || nextPrayer.isEmpty) return;
    _lastNextPrayer = nextPrayer;

    // Find the index of the next prayer
    final index = prayerList.indexWhere(
      (prayer) => prayer.name.toLowerCase() == nextPrayer.toLowerCase(),
    );

    if (index != -1 && _scrollController.hasClients) {
      // Calculate scroll position (each card is approximately 80px height + spacing)
      final cardHeight = 90.0;
      final scrollPosition = index * cardHeight;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  String _translatePrayerName(BuildContext context, String prayerName) {
    // Convert prayer name to lowercase key for translation
    final key = prayerName.toLowerCase();
    return context.tr(key);
  }

  String _translateEnglishDate(BuildContext context, String englishDate) {
    // Format: "25 Jan 2026" or "25 January 2026"
    final parts = englishDate.split(' ');
    if (parts.length != 3) return englishDate;

    final day = parts[0];
    final monthName = parts[1];
    final year = parts[2];

    // Month name mapping
    final monthMap = {
      'Jan': 'january',
      'January': 'january',
      'Feb': 'february',
      'February': 'february',
      'Mar': 'march',
      'March': 'march',
      'Apr': 'april',
      'April': 'april',
      'May': 'may',
      'Jun': 'june',
      'June': 'june',
      'Jul': 'july',
      'July': 'july',
      'Aug': 'august',
      'August': 'august',
      'Sep': 'september',
      'September': 'september',
      'Oct': 'october',
      'October': 'october',
      'Nov': 'november',
      'November': 'november',
      'Dec': 'december',
      'December': 'december',
    };

    final monthKey = monthMap[monthName];
    if (monthKey != null) {
      final translatedMonth = context.tr(monthKey);
      return '$day $translatedMonth $year';
    }

    return englishDate;
  }

  String _translateTimeRemaining(BuildContext context, String timeString) {
    // Format: "0s", "5m 23s", "2h 15m"
    String translated = timeString;

    // Replace time units with translated versions
    translated = translated.replaceAll('h', ' ${context.tr('hours_short')}');
    translated = translated.replaceAll('m', ' ${context.tr('minutes_short')}');
    translated = translated.replaceAll('s', ' ${context.tr('seconds_short')}');

    return translated.trim();
  }

  String _translateHijriDate(BuildContext context, String hijriDate) {
    // Parse the Hijri date string (format: "6 Sha'aban 1447")
    final parts = hijriDate.split(' ');
    if (parts.length != 3) return hijriDate;

    final day = parts[0];
    final monthName = parts[1];
    final year = parts[2];

    // Normalize Unicode characters to ASCII equivalents
    String normalizedMonth = '';
    for (int i = 0; i < monthName.length; i++) {
      final char = monthName[i];
      final code = char.codeUnitAt(0);

      // Handle common Unicode vowel variations (convert to base ASCII)
      if (char == 'ā' || char == 'ă' || char == 'à' || char == 'á' || char == 'â' || char == 'ã' || char == 'ä' || char == 'å' || code == 0x0101 || code == 0x0103) {
        normalizedMonth += 'a';
      } else if (char == 'ē' || char == 'ĕ' || char == 'è' || char == 'é' || char == 'ê' || char == 'ë' || code == 0x0113 || code == 0x0115) {
        normalizedMonth += 'e';
      } else if (char == 'ī' || char == 'ĭ' || char == 'ì' || char == 'í' || char == 'î' || char == 'ï' || code == 0x012B || code == 0x012D) {
        normalizedMonth += 'i';
      } else if (char == 'ō' || char == 'ŏ' || char == 'ò' || char == 'ó' || char == 'ô' || char == 'õ' || char == 'ö' || char == 'ø' || code == 0x014D || code == 0x014F) {
        normalizedMonth += 'o';
      } else if (char == 'ū' || char == 'ŭ' || char == 'ù' || char == 'ú' || char == 'û' || char == 'ü' || code == 0x016B || code == 0x016D) {
        normalizedMonth += 'u';
      } else if (code >= 65 && code <= 90) { // A-Z
        normalizedMonth += char.toLowerCase();
      } else if (code >= 97 && code <= 122) { // a-z
        normalizedMonth += char;
      }
      // Skip all other characters (apostrophes, spaces, diacritics, etc.)
    }

    // Match based on cleaned substring to handle any variations
    String translationKey;
    if (normalizedMonth.contains('muharram')) {
      translationKey = 'month_muharram';
    } else if (normalizedMonth.contains('safar')) {
      translationKey = 'month_safar';
    } else if (normalizedMonth.contains('rabi') && (normalizedMonth.contains('awwal') || normalizedMonth.contains('al-awwal'))) {
      translationKey = 'month_rabi_ul_awwal';
    } else if (normalizedMonth.contains('rabi') && (normalizedMonth.contains('thani') || normalizedMonth.contains('aakhir') || normalizedMonth.contains('akhir'))) {
      translationKey = 'month_rabi_ul_aakhir';
    } else if (normalizedMonth.contains('jumada') && (normalizedMonth.contains('awwal') || normalizedMonth.contains('ula'))) {
      translationKey = 'month_jumada_ul_ula';
    } else if (normalizedMonth.contains('jumada') && (normalizedMonth.contains('thani') || normalizedMonth.contains('akhir'))) {
      translationKey = 'month_jumada_ul_aakhira';
    } else if (normalizedMonth.contains('rajab')) {
      translationKey = 'month_rajab';
    } else if (normalizedMonth.contains('shaban') || normalizedMonth.contains('shaaban') || normalizedMonth.contains('shabn')) {
      translationKey = 'month_shaban';
    } else if (normalizedMonth.contains('ramadan') || normalizedMonth.contains('ramadhan')) {
      translationKey = 'month_ramadan';
    } else if (normalizedMonth.contains('shawwal')) {
      translationKey = 'month_shawwal';
    } else if (normalizedMonth.contains('dhu') && (normalizedMonth.contains('qidah') || normalizedMonth.contains('qadah'))) {
      translationKey = 'month_dhul_qadah';
    } else if (normalizedMonth.contains('dhu') && (normalizedMonth.contains('hijja') || normalizedMonth.contains('hijjah'))) {
      translationKey = 'month_dhul_hijjah';
    } else {
      // Fallback: return original month name if no match
      return '$day $monthName $year ${context.tr('ah')}';
    }

    final translatedMonth = context.tr(translationKey);
    return '$day $translatedMonth $year ${context.tr('ah')}';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

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
      appBar: AppBar(title: Text(context.tr('prayer_times'))),
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
                  Icon(
                    Icons.location_off,
                    size: responsive.iconHuge,
                    color: Colors.grey,
                  ),
                  responsive.vSpaceRegular,
                  Text(provider.error!),
                  responsive.vSpaceRegular,
                  ElevatedButton(
                    onPressed: () => provider.initialize(),
                    child: Text(context.tr('retry')),
                  ),
                ],
              ),
            );
          }

          final prayerTimes = provider.todayPrayerTimes;
          if (prayerTimes == null) {
            return Center(child: Text(context.tr('no_prayer_times_available')));
          }

          final prayerList = prayerTimes.toPrayerList();

          // Auto-scroll to next prayer when it changes
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToNextPrayer(provider.nextPrayer, prayerList);
          });

          return SingleChildScrollView(
            controller: _scrollController,
            padding: responsive.paddingRegular,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Next Prayer Card with Date
                _buildNextPrayerCard(context, provider, prayerTimes),
                responsive.vSpaceLarge,

                // Prayer Times List
                Text(
                  context.tr('today_prayer_times'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                responsive.vSpaceMedium,
                ...prayerList.map(
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
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

        children: [
          Text(
            context.tr('next_prayer'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: responsive.textRegular,
            ),
          ),
          responsive.vSpaceRegular,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Date and Hijri Date
              Text(
                _translateEnglishDate(context, prayerTimes.date),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.textLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: responsive.spaceSmall),
              Text(
                _translateHijriDate(context, prayerTimes.hijriDate),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.textLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                _translatePrayerName(context, provider.nextPrayer),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.textLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              responsive.vSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: responsive.iconSmall,
                  ),
                  responsive.vSpaceSmall,
                  Text(
                    _translateTimeRemaining(context, provider.formattedTimeRemaining),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.textLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
    final responsive = context.responsive;
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      padding: responsive.paddingRegular,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(
          color: isNext ? emeraldGreen : lightGreenBorder,
          width: isNext ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: responsive.spacing(50),
            height: responsive.spacing(50),
            decoration: BoxDecoration(
              color: isNext ? darkGreen : lightGreenChip,
              shape: BoxShape.circle,
              boxShadow: isNext
                  ? [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.3),
                        blurRadius: responsive.spacing(8),
                        offset: Offset(0, responsive.spacing(2)),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                prayer.icon,
                style: TextStyle(fontSize: responsive.textXXLarge),
              ),
            ),
          ),
          SizedBox(width: responsive.spaceRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translatePrayerName(context, prayer.name),
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.w600,
                    color: isNext ? darkGreen : darkGreen,
                  ),
                ),
                if (isNext)
                  Container(
                    margin: responsive.paddingOnly(top: 4),
                    padding: responsive.paddingSymmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(
                        responsive.radiusSmall,
                      ),
                    ),
                    child: Text(
                      context.tr('next_prayer'),
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
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
              fontSize: responsive.textRegular,
              fontWeight: FontWeight.bold,
              color: isNext ? emeraldGreen : darkGreen,
            ),
          ),
        ],
      ),
    );
  }
}
