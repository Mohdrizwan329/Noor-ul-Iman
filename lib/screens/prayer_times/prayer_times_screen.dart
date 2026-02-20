import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/location_service.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/prayer_provider.dart';
import '../../providers/adhan_provider.dart';
import '../../providers/language_provider.dart';
import '../../data/models/prayer_time_model.dart';
import '../../widgets/common/banner_ad_widget.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final ScrollController _scrollController = ScrollController();
  final ContentService _contentService = ContentService();
  String _lastNextPrayer = '';
  PrayerTimesScreenContentFirestore? _content;
  bool _isContentLoading = true;
  bool _hasScheduledNotifications = false;

  // Local fallback for Hijri month translations (used when Firestore data is missing)
  static const _hijriMonthFallback = {
    'month_muharram': {'en': 'Muharram', 'hi': 'मुहर्रम', 'ur': 'محرم', 'ar': 'محرّم'},
    'month_safar': {'en': 'Safar', 'hi': 'सफ़र', 'ur': 'صفر', 'ar': 'صفر'},
    'month_rabi_ul_awwal': {'en': 'Rabi ul Awwal', 'hi': 'रबीउल अव्वल', 'ur': 'ربیع الاول', 'ar': 'ربيع الأوّل'},
    'month_rabi_ul_aakhir': {'en': 'Rabi ul Aakhir', 'hi': 'रबीउल आख़िर', 'ur': 'ربیع الثانی', 'ar': 'ربيع الثاني'},
    'month_jumada_ul_ula': {'en': 'Jumada ul Ula', 'hi': 'जुमादा अल-ऊला', 'ur': 'جمادی الاول', 'ar': 'جمادى الأولى'},
    'month_jumada_ul_aakhira': {'en': 'Jumada ul Aakhira', 'hi': 'जुमादा अल-आख़िरा', 'ur': 'جمادی الثانی', 'ar': 'جمادى الآخرة'},
    'month_rajab': {'en': 'Rajab', 'hi': 'रजब', 'ur': 'رجب', 'ar': 'رجب'},
    'month_shaban': {'en': 'Shaban', 'hi': 'शाबान', 'ur': 'شعبان', 'ar': 'شعبان'},
    'month_ramadan': {'en': 'Ramadan', 'hi': 'रमज़ान', 'ur': 'رمضان', 'ar': 'رمضان'},
    'month_shawwal': {'en': 'Shawwal', 'hi': 'शव्वाल', 'ur': 'شوال', 'ar': 'شوّال'},
    'month_dhul_qadah': {'en': 'Dhul Qadah', 'hi': 'ज़ुल क़ादा', 'ur': 'ذوالقعدہ', 'ar': 'ذو القعدة'},
    'month_dhul_hijjah': {'en': 'Dhul Hijjah', 'hi': 'ज़ुल हिज्जा', 'ur': 'ذوالحجہ', 'ar': 'ذو الحجّة'},
  };

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    try {
      final content = await _contentService.getPrayerTimesScreenContent();
      if (mounted) {
        setState(() {
          _content = content;
          _isContentLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading prayer times content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
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

  /// Get translated prayer name from Firebase
  String _translatePrayerName(String prayerName) {
    if (_content == null) return prayerName;
    return _content!.getPrayerName(prayerName, _langCode);
  }

  /// Get prayer icon from Firebase
  String _getPrayerIcon(String prayerKey) {
    if (_content == null) return '🕌';
    return _content!.getPrayerIcon(prayerKey);
  }

  void _scrollToNextPrayer(String nextPrayer, List<PrayerItem> prayerList) {
    if (nextPrayer == _lastNextPrayer || nextPrayer.isEmpty) return;
    _lastNextPrayer = nextPrayer;

    final index = prayerList.indexWhere(
      (prayer) => prayer.name.toLowerCase() == nextPrayer.toLowerCase(),
    );

    if (index != -1 && _scrollController.hasClients) {
      final responsive = context.responsive;
      final cardHeight = responsive.spacing(90);
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

  String _translateEnglishDate(String englishDate) {
    if (_content == null) return englishDate;
    final parts = englishDate.split(' ');
    if (parts.length != 3) return englishDate;

    final day = parts[0];
    final monthName = parts[1];
    final year = parts[2];

    final monthMap = {
      'Jan': 'january', 'January': 'january',
      'Feb': 'february', 'February': 'february',
      'Mar': 'march', 'March': 'march',
      'Apr': 'april', 'April': 'april',
      'May': 'may',
      'Jun': 'june', 'June': 'june',
      'Jul': 'july', 'July': 'july',
      'Aug': 'august', 'August': 'august',
      'Sep': 'september', 'September': 'september',
      'Oct': 'october', 'October': 'october',
      'Nov': 'november', 'November': 'november',
      'Dec': 'december', 'December': 'december',
    };

    final monthKey = monthMap[monthName];
    if (monthKey != null) {
      final translatedMonth = _content!.getGregorianMonth(monthKey, _langCode);
      return '$day $translatedMonth $year';
    }

    return englishDate;
  }

  String _translateTimeRemaining(String timeString) {
    if (_content == null) return timeString;
    String translated = timeString;

    translated = translated.replaceAll('h', ' ${_t('hours_short')}');
    translated = translated.replaceAll('m', ' ${_t('minutes_short')}');
    translated = translated.replaceAll('s', ' ${_t('seconds_short')}');

    return translated.trim();
  }

  String _translateHijriDate(String hijriDate) {
    if (_content == null) return hijriDate;
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
      } else if (code >= 65 && code <= 90) {
        normalizedMonth += char.toLowerCase();
      } else if (code >= 97 && code <= 122) {
        normalizedMonth += char;
      }
    }

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
      return '$day $monthName $year ${_t('ah')}';
    }

    var translatedMonth = _content!.getHijriMonth(translationKey, _langCode);
    // If Firestore returned the key itself, use local fallback
    if (translatedMonth == translationKey) {
      final fallback = _hijriMonthFallback[translationKey];
      if (fallback != null) {
        translatedMonth = fallback[_langCode] ?? fallback['en'] ?? translatedMonth;
      }
    }
    return '$day $translatedMonth $year ${_t('ah')}';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    // Schedule notifications once when prayer times are loaded (not on every rebuild)
    if (!_hasScheduledNotifications) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_hasScheduledNotifications) return;
        final prayerProvider = context.read<PrayerProvider>();
        final adhanProvider = context.read<AdhanProvider>();
        if (prayerProvider.todayPrayerTimes != null) {
          final locationService = LocationService();
          final position = prayerProvider.currentPosition;
          if (position != null) {
            final city = locationService.currentCity ?? '';
            adhanProvider.updateLocation(
              city: city,
              latitude: position.latitude,
              longitude: position.longitude,
            );
          }

          adhanProvider.schedulePrayerNotifications(
            prayerProvider.todayPrayerTimes!,
          );
          _hasScheduledNotifications = true;
        }
      });
    }

    if (_isContentLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('prayer_times'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
                          child: Text(_t('retry')),
                        ),
                      ],
                    ),
                  );
                }

                final prayerTimes = provider.todayPrayerTimes;
                if (prayerTimes == null) {
                  return Center(child: Text(_t('no_prayer_times_available')));
                }

                final prayerList = prayerTimes.toPrayerList();

                // Auto-scroll to next prayer when it changes
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollToNextPrayer(provider.nextPrayer, prayerList);
                });

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.initialize();
                  },
                  color: const Color(0xFF0A5C36),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: responsive.paddingRegular,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Next Prayer Card with Date
                        _buildNextPrayerCard(context, provider, prayerTimes),
                        responsive.vSpaceMedium,

                        // Prayer Times List
                        Text(
                          _t('today_prayer_times'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        responsive.vSpaceSmall,
                        ...prayerList.map(
                          (prayer) => _buildPrayerTimeCard(
                            context,
                            prayer,
                            provider.nextPrayer == prayer.name,
                          ),
                        ),
                        responsive.vSpaceLarge,
                        const BannerAdWidget(),
                        responsive.vSpaceMedium,
                      ],
                    ),
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
            _t('next_prayer'),
            style: TextStyle(
              color: Colors.white70,
              fontSize: responsive.textRegular,
            ),
          ),
          responsive.vSpaceRegular,
          // Date and Hijri Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  _translateEnglishDate(prayerTimes.date),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  _translateHijriDate(prayerTimes.hijriDate),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.fontSize(14),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          responsive.vSpaceSmall,
          // Next Prayer and Time Remaining Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _translatePrayerName(provider.nextPrayer),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.fontSize(18),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.white,
                    size: responsive.iconSize(18),
                  ),
                  SizedBox(width: responsive.spacing(4)),
                  Flexible(
                    child: Text(
                      _translateTimeRemaining(provider.formattedTimeRemaining),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

    // Get icon from Firebase data
    final prayerIcon = _getPrayerIcon(prayer.name);

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
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
            blurRadius: 10.0,
            offset: Offset(0, 2.0),
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
                        blurRadius: 8,
                        offset: Offset(0, responsive.spacing(2)),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                prayerIcon,
                style: TextStyle(color: AppColors.primary, fontSize: responsive.fontSize(28)),
              ),
            ),
          ),
          SizedBox(width: responsive.spaceRegular),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _translatePrayerName(prayer.name),
                  style: TextStyle(
                    fontSize: responsive.fontSize(18),
                    fontWeight: FontWeight.w600,
                    color: darkGreen,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                      _t('next_prayer'),
                      style: TextStyle(
                        fontSize: responsive.textXSmall,
                        fontWeight: FontWeight.w600,
                        color: emeraldGreen,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
