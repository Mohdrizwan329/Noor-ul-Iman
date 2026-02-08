import 'package:flutter/material.dart';
import '../../core/utils/app_utils.dart';
import 'package:nooruliman/core/constants/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../core/services/hijri_date_service.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'dart:io';
import '../../providers/language_provider.dart';
import '../../core/utils/ad_navigation.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/services/data_migration_service.dart';
import '../../data/models/firestore_models.dart';

enum GreetingLanguage { english, urdu, hindi, arabic }

// Helper function to map global language code to GreetingLanguage
GreetingLanguage _getGreetingLanguage(String languageCode) {
  switch (languageCode) {
    case 'en':
      return GreetingLanguage.english;
    case 'ur':
      return GreetingLanguage.urdu;
    case 'hi':
      return GreetingLanguage.hindi;
    case 'ar':
      return GreetingLanguage.arabic;
    default:
      return GreetingLanguage.english;
  }
}

class GreetingCardsScreen extends StatefulWidget {
  const GreetingCardsScreen({super.key});

  @override
  State<GreetingCardsScreen> createState() => _GreetingCardsScreenState();
}

class _GreetingCardsScreenState extends State<GreetingCardsScreen> {
  late HijriCalendar _currentHijriDate;
  List<IslamicMonth> _allMonths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentHijriDate = HijriDateService.instance.getHijriNow();
    _loadFromFirestore();
  }

  Future<void> _loadFromFirestore() async {
    if (mounted) setState(() => _isLoading = true);
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('greeting_cards')
          .orderBy('number')
          .get();

      // Auto-push if Firebase is empty
      if (snapshot.docs.isEmpty) {
        debugPrint('Firebase greeting_cards empty - auto-pushing data...');
        await DataMigrationService().migrateAllGreetingCards();
        snapshot = await FirebaseFirestore.instance
            .collection('greeting_cards')
            .orderBy('number')
            .get();
      }

      if (snapshot.docs.isNotEmpty && mounted) {
        final firestoreMonths = snapshot.docs
            .map((doc) => IslamicMonthFirestore.fromFirestore(doc))
            .toList();

        debugPrint('Loaded ${firestoreMonths.length} Islamic months from Firebase');

        _allMonths = firestoreMonths.map((m) {
          // Parse gradient colors
          Color gradStart = const Color(0xFF4CAF50);
          Color gradEnd = const Color(0xFF2E7D32);
          try {
            gradStart = Color(int.parse(m.gradientStart.replaceFirst('#', '0xFF')));
            gradEnd = Color(int.parse(m.gradientEnd.replaceFirst('#', '0xFF')));
          } catch (_) {}

          return IslamicMonth(
            monthNumber: m.number,
            name: m.name.en,
            nameUrdu: m.name.ur,
            nameHindi: m.name.hi,
            arabicName: m.name.ar,
            specialOccasion: m.specialOccasion?.en,
            specialOccasionUrdu: m.specialOccasion?.ur,
            specialOccasionHindi: m.specialOccasion?.hi,
            specialOccasionArabic: m.specialOccasion?.ar,
            gradient: [gradStart, gradEnd],
            cards: m.cards.map((c) => GreetingCard(
              title: c.title.en,
              titleUrdu: c.title.ur,
              titleHindi: c.title.hi,
              titleArabic: c.title.ar,
              message: c.message.en,
              messageUrdu: c.message.ur,
              messageHindi: c.message.hi,
              messageArabic: c.message.ar,
              icon: _parseIcon(c.icon),
            )).toList(),
          );
        }).toList();
      }
    } catch (e) {
      debugPrint('Error loading greeting cards from Firestore: $e');
    }
    if (mounted) setState(() => _isLoading = false);
  }

  IconData _parseIcon(String iconName) {
    switch (iconName) {
      case 'calendar_today': return Icons.calendar_today;
      case 'calendar_month': return Icons.calendar_month;
      case 'star': return Icons.star;
      case 'stars': return Icons.stars;
      case 'favorite': return Icons.favorite;
      case 'favorite_border': return Icons.favorite_border;
      case 'celebration': return Icons.celebration;
      case 'mosque': return Icons.mosque;
      case 'nightlight': return Icons.nightlight;
      case 'nightlight_round': return Icons.nightlight_round;
      case 'auto_awesome': return Icons.auto_awesome;
      case 'brightness_5': return Icons.brightness_5;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'nights_stay': return Icons.nights_stay;
      case 'crescent_moon': return Icons.nightlight_round;
      case 'terrain': return Icons.terrain;
      case 'child_care': return Icons.child_care;
      case 'menu_book': return Icons.menu_book;
      case 'shield': return Icons.shield;
      case 'military_tech': return Icons.military_tech;
      case 'public': return Icons.public;
      case 'spa': return Icons.spa;
      case 'volunteer_activism': return Icons.volunteer_activism;
      case 'lightbulb': return Icons.lightbulb;
      case 'flight': return Icons.flight;
      case 'restaurant': return Icons.restaurant;
      case 'card_giftcard': return Icons.card_giftcard;
      default: return Icons.celebration;
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final languageProvider = context.watch<LanguageProvider>();
    final language = _getGreetingLanguage(languageProvider.languageCode);

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text(
          language == GreetingLanguage.urdu
              ? 'تہوار کے کارڈز'
              : language == GreetingLanguage.hindi
              ? 'ग्रीटिंग कार्ड्स'
              : language == GreetingLanguage.arabic
              ? 'بطاقات التهنئة'
              : 'Greeting Cards',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF), // White
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)), // White icons
      ),
      body: Column(
        children: [
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Color(0xFFE8F3ED),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F8F6), // Soft Off-White background
              child: _isLoading && _allMonths.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    )
                  : _allMonths.isEmpty
                  ? Center(
                      child: Text(
                        'No data available',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildCurrentMonthBanner(language, responsive),
                        _buildUpcomingEventsSection(language, responsive),
                        _buildMonthsSection(language, responsive),
                      ],
                    ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildCurrentMonthBanner(GreetingLanguage language, responsive) {
    const darkGreen = Color(0xFF0A5C36);
    const lightGreen = Color(0xFFE8F3ED);

    final currentMonthName = language == GreetingLanguage.urdu
        ? _allMonths[_currentHijriDate.hMonth - 1].nameUrdu
        : language == GreetingLanguage.hindi
        ? _allMonths[_currentHijriDate.hMonth - 1].nameHindi
        : language == GreetingLanguage.arabic
        ? _allMonths[_currentHijriDate.hMonth - 1].arabicName
        : _allMonths[_currentHijriDate.hMonth - 1].name;

    final dateLabel = language == GreetingLanguage.urdu
        ? 'آج کی اسلامی تاریخ'
        : language == GreetingLanguage.hindi
        ? 'आज की इस्लामी तारीख'
        : language == GreetingLanguage.arabic
        ? 'التاريخ الإسلامي اليوم'
        : 'Today\'s Islamic Date';

    return Container(
      margin: responsive.paddingAll(16.0),
      padding: responsive.paddingAll(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lightGreen, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(responsive.borderRadius(18.0)),
        border: Border.all(color: darkGreen, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: responsive.paddingAll(12.0),
            decoration: BoxDecoration(color: darkGreen, shape: BoxShape.circle),
            child: Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: responsive.iconSize(28.0),
            ),
          ),
          SizedBox(width: responsive.spacing(16.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    dateLabel,
                    style: TextStyle(
                      color: darkGreen.withValues(alpha: 0.8),
                      fontSize: responsive.fontSize(12.0),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(height: responsive.spacing(4.0)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_currentHijriDate.hDay} $currentMonthName ${_currentHijriDate.hYear}',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: responsive.fontSize(18.0),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(GreetingLanguage language, responsive) {
    // Get events for the current month and next 30 days
    final upcomingEvents = _getUpcomingEvents();

    if (upcomingEvents.isEmpty) {
      return const SizedBox.shrink();
    }

    final sectionTitle = language == GreetingLanguage.urdu
        ? 'آنے والے اسلامی واقعات'
        : language == GreetingLanguage.hindi
        ? 'आने वाले इस्लामी कार्यक्रम'
        : language == GreetingLanguage.arabic
        ? 'الأحداث الإسلامية القادمة'
        : 'Upcoming Islamic Events';

    return Container(
      margin: responsive.paddingSymmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: responsive.paddingOnly(left: 4.0, bottom: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.event_note,
                  color: AppColors.primary,
                  size: responsive.iconSize(24.0),
                ),
                SizedBox(width: responsive.spacing(8.0)),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sectionTitle,
                      style: TextStyle(
                        fontSize: responsive.fontSize(20.0),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...upcomingEvents.map(
            (event) => _buildEventCard(event, language, responsive),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthsSection(GreetingLanguage language, responsive) {
    final sectionTitle = language == GreetingLanguage.urdu
        ? 'اسلامی مہینے'
        : language == GreetingLanguage.hindi
        ? 'इस्लामी महीने'
        : language == GreetingLanguage.arabic
        ? 'الأشهر الإسلامية'
        : 'Islamic Months';

    return Container(
      margin: responsive.paddingSymmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: responsive.paddingOnly(left: 4.0, bottom: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: AppColors.primary,
                  size: responsive.iconSize(24.0),
                ),
                SizedBox(width: responsive.spacing(8.0)),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sectionTitle,
                      style: TextStyle(
                        fontSize: responsive.fontSize(20.0),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(_allMonths.length, (index) {
            final month = _allMonths[index];
            final isCurrentMonth =
                month.monthNumber == _currentHijriDate.hMonth;
            return _MonthCard(
              month: month,
              language: language,
              isCurrentMonth: isCurrentMonth,
            );
          }),
        ],
      ),
    );
  }

  List<IslamicEvent> _getUpcomingEvents() {
    final currentMonth = _currentHijriDate.hMonth;
    final currentDay = _currentHijriDate.hDay;

    // Get events from current month and next month
    final upcomingEvents = <IslamicEvent>[];

    for (var event in _islamicEvents) {
      // Check if event is today or in the future within the next 2 months
      if (event.month == currentMonth && event.day >= currentDay) {
        upcomingEvents.add(event);
      } else if (event.month == currentMonth + 1 ||
          (currentMonth == 12 && event.month == 1)) {
        upcomingEvents.add(event);
      }
    }

    // Limit to next 5 events
    return upcomingEvents.take(5).toList();
  }

  Widget _buildEventCard(
    IslamicEvent event,
    GreetingLanguage language,
    responsive,
  ) {
    final isToday =
        event.month == _currentHijriDate.hMonth &&
        event.day == _currentHijriDate.hDay;

    // Use consistent green color scheme like the month cards
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreen = Color(0xFFE8F3ED);
    const lightGreenBorder = Color(0xFF8AAF9A);

    // Get the month for this event (needed for navigation)
    final eventMonth = _allMonths[event.month - 1];

    return Container(
      margin: responsive.paddingOnly(bottom: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(18.0)),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? emeraldGreen.withValues(alpha: 0.3)
                : darkGreen.withValues(alpha: 0.15),
            blurRadius: isToday ? 16.0 : 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Find matching greeting card from the month
            GreetingCard? matchingCard;
            for (var card in eventMonth.cards) {
              if (card.title.toLowerCase().contains(
                    event.title.toLowerCase(),
                  ) ||
                  event.title.toLowerCase().contains(
                    card.title.toLowerCase(),
                  ) ||
                  card.titleHindi.contains(event.titleHindi) ||
                  card.titleUrdu.contains(event.titleUrdu)) {
                matchingCard = card;
                break;
              }
            }

            if (matchingCard != null) {
              // Navigate to StatusCardScreen with the matching greeting card
              final cardToShow = matchingCard;
              AdNavigator.push(context, StatusCardScreen(
                card: cardToShow,
                month: eventMonth,
                language: language,
              ));
            } else if (eventMonth.cards.isNotEmpty) {
              // If no matching card, show first card of the month
              AdNavigator.push(context, StatusCardScreen(
                card: eventMonth.cards.first,
                month: eventMonth,
                language: language,
              ));
            } else {
              // If no cards available, show month cards screen
              AdNavigator.push(context, MonthCardsScreen(month: eventMonth, language: language));
            }
          },
          borderRadius: BorderRadius.circular(responsive.borderRadius(18.0)),
          child: Container(
            padding: responsive.paddingAll(16.0),
            decoration: BoxDecoration(
              color: isToday ? lightGreen : Colors.white,
              borderRadius: BorderRadius.circular(
                responsive.borderRadius(18.0),
              ),
              border: Border.all(
                color: isToday ? emeraldGreen : lightGreenBorder,
                width: responsive.spacing(isToday ? 2.0 : 1.5),
              ),
            ),
            child: Row(
              children: [
                // Event icon circle - Dark Green
                Container(
                  width: responsive.spacing(58.0),
                  height: responsive.spacing(58.0),
                  decoration: BoxDecoration(
                    color: darkGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withValues(alpha: 0.3),
                        blurRadius: 8.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      event.icon,
                      color: Colors.white,
                      size: responsive.iconSize(28.0),
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacing(14.0)),
                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Event title - Dark Green (bigger text on top)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          event.getTitle(language),
                          style: TextStyle(
                            fontSize: responsive.fontSize(18.0),
                            fontWeight: FontWeight.bold,
                            color: darkGreen,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(4.0)),
                      // Event date - Dark Green (smaller text below)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${event.day} ${_allMonths[event.month - 1].getName(language)}',
                          style: TextStyle(
                            fontSize: responsive.fontSize(11.0),
                            color: emeraldGreen,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      // TODAY badge if today
                      if (isToday)
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          margin: responsive.paddingOnly(top: 6.0),
                          decoration: BoxDecoration(
                            color: emeraldGreen,
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(6.0),
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              language == GreetingLanguage.urdu
                                  ? 'آج'
                                  : language == GreetingLanguage.hindi
                                  ? 'आज'
                                  : language == GreetingLanguage.arabic
                                  ? 'اليوم'
                                  : 'TODAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: responsive.fontSize(10.0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Arrow button - Emerald Green
                Container(
                  padding: responsive.paddingAll(8.0),
                  decoration: BoxDecoration(
                    color: emeraldGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: responsive.iconSize(14.0),
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

class _MonthCard extends StatelessWidget {
  final IslamicMonth month;
  final GreetingLanguage language;
  final bool isCurrentMonth;

  const _MonthCard({
    required this.month,
    required this.language,
    this.isCurrentMonth = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreen = Color(0xFFE8F3ED);

    return Container(
      margin: responsive.paddingOnly(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
        boxShadow: [
          BoxShadow(
            color: isCurrentMonth
                ? emeraldGreen.withValues(alpha: 0.3)
                : darkGreen.withValues(alpha: 0.15),
            blurRadius: isCurrentMonth ? 16.0 : 12.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            AdNavigator.push(context, MonthCardsScreen(month: month, language: language));
          },
          borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
          child: Container(
            padding: responsive.paddingAll(16),
            decoration: BoxDecoration(
              color: isCurrentMonth
                  ? lightGreen
                  : const Color(
                      0xFFFFFFFF,
                    ), // Light green for current month, white otherwise
              borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
              border: Border.all(
                color: isCurrentMonth
                    ? emeraldGreen
                    : const Color(
                        0xFF8AAF9A,
                      ), // Emerald green border for current month
                width: responsive.spacing(isCurrentMonth ? 2.0 : 1.5),
              ),
            ),
            child: Row(
              children: [
                // Month Number Circle - Dark Green background
                Container(
                  width: responsive.spacing(58),
                  height: responsive.spacing(58),
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
                      style: TextStyle(
                        color: Color(0xFFFFFFFF), // White text
                        fontSize: responsive.fontSize(24),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacing(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month Name - Dark Green Bold
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          month.getName(language),
                          style: TextStyle(
                            color: darkGreen, // Dark Green
                            fontSize: responsive.fontSize(18),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (month.getSpecialOccasion(language) != null) ...[
                        SizedBox(height: responsive.spacing(6)),
                        // Event Chip - Light Green bg, Emerald text
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            month.getSpecialOccasion(language)!,
                            style: TextStyle(
                              color: emeraldGreen, // Emerald Green text
                              fontSize: responsive.fontSize(11),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: responsive.spacing(8)),
                // Arrow button - Emerald Green circle
                Container(
                  padding: responsive.paddingAll(8),
                  decoration: BoxDecoration(
                    color: emeraldGreen, // Emerald Green circle
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFFFFFF), // White arrow
                    size: responsive.iconSize(16),
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

// Event Card Full Screen Viewer with Templates and Themes
class EventCardScreen extends StatefulWidget {
  final IslamicEvent event;
  final IslamicMonth month;
  final GreetingLanguage language;

  const EventCardScreen({
    super.key,
    required this.event,
    required this.month,
    required this.language,
  });

  @override
  State<EventCardScreen> createState() => _EventCardScreenState();
}

class _EventCardScreenState extends State<EventCardScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  int _selectedThemeIndex = -1; // -1 means None (original colors)
  int _selectedTemplateIndex = 0; // Default to first template
  String _customTitle = '';
  String _customDescription = '';

  @override
  void initState() {
    super.initState();
    _customTitle = widget.event.getTitle(widget.language);
    _customDescription = widget.event.getDescription(widget.language);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            _customTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(16),
          child: Column(
            children: [
              // Main Card Display (wrapped with Screenshot) - Uses Selected Template
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  height: responsive.spacing(570.0),
                  width: double.infinity,
                  margin: responsive.paddingSymmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(20.0),
                    ),
                    child: _buildEventCardVariation(
                      _selectedTemplateIndex,
                      isPreview: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: responsive.spacing(10)),

              // 9 Different Card Design Templates
              SizedBox(
                height: responsive.spacing(80),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedTemplateIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTemplateIndex = index;
                        });
                      },
                      child: Container(
                        width: responsive.spacing(80),
                        margin: responsive.paddingSymmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(12),
                          ),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : Colors.transparent,
                            width: responsive.spacing(3),
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(10),
                          ),
                          child: FittedBox(
                            child: SizedBox(
                              width: responsive.spacing(300),
                              height: responsive.spacing(400),
                              child: _buildEventCardVariation(
                                index,
                                isPreview: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: responsive.spacing(10)),

              // Color Theme Selector with None button
              SizedBox(
                height: responsive.spacing(60),
                child: Row(
                  children: [
                    // None Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedThemeIndex = -1;
                        });
                      },
                      child: Container(
                        width: responsive.spacing(70),
                        margin: responsive.paddingSymmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E2A2A),
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(12),
                          ),
                          border: Border.all(
                            color: _selectedThemeIndex == -1
                                ? const Color(0xFFD4AF37)
                                : Colors.transparent,
                            width: responsive.spacing(3),
                          ),
                          boxShadow: _selectedThemeIndex == -1
                              ? [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            widget.language == GreetingLanguage.urdu
                                ? 'اصل'
                                : widget.language == GreetingLanguage.hindi
                                ? 'मूल'
                                : widget.language == GreetingLanguage.arabic
                                ? 'أصلي'
                                : 'None',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: responsive.fontSize(12),
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    // Color themes list
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _colorThemes.length,
                        itemBuilder: (context, index) {
                          final theme = _colorThemes[index];
                          final isSelected = _selectedThemeIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedThemeIndex = index;
                              });
                            },
                            child: Container(
                              width: responsive.spacing(60),
                              margin: responsive.paddingSymmetric(
                                horizontal: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    theme.headerColor,
                                    theme.footerColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(12),
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.accentColor
                                      : Colors.transparent,
                                  width: responsive.spacing(3),
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: theme.accentColor.withValues(
                                            alpha: 0.5,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  theme.getName(widget.language),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: responsive.fontSize(8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spacing(10)),

              // Action Buttons Row - Edit, Share, Download
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Edit Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: _showEditDialog,
                        icon: Icon(Icons.edit, size: responsive.iconSize(18)),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'ترمیم'
                              : widget.language == GreetingLanguage.hindi
                              ? 'संपादित'
                              : widget.language == GreetingLanguage.arabic
                              ? 'تعديل'
                              : 'Edit',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF0A5C36,
                          ), // Fixed Islamic Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Share Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () => _shareEventCard(context),
                        icon: Icon(Icons.share, size: responsive.iconSize(18)),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'شیئر'
                              : widget.language == GreetingLanguage.hindi
                              ? 'शेयर'
                              : widget.language == GreetingLanguage.arabic
                              ? 'مشاركة'
                              : 'Share',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E8F5A,
                          ), // Fixed Emerald Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Download Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: _downloadEventCard,
                        icon: Icon(
                          Icons.download,
                          size: responsive.iconSize(18),
                        ),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'ڈاؤن لوڈ'
                              : widget.language == GreetingLanguage.hindi
                              ? 'डाउनलोड'
                              : widget.language == GreetingLanguage.arabic
                              ? 'تحميل'
                              : 'Download',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E8F5A,
                          ), // Fixed Emerald Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing(6)),
            ],
          ),
        ),
      ),
    );
  }

  // Build event card variations - 9 different premium Islamic templates
  Widget _buildEventCardVariation(int index, {bool isPreview = false}) {
    // Remap indices: Original premium card (was index 8) is now at index 0
    const indexMap = [8, 0, 1, 2, 3, 4, 5, 6, 7];
    index = indexMap[index];

    final responsive = context.responsive;
    final Color darkTealBg;
    final Color deepGreen;
    final Color goldenBorder;
    final Color softGoldText;
    final Color warmGold;
    const creamText = Color(0xFFF5F1E6);
    final Color lanternGlow;
    final Color shadowGreen;

    // If it's a preview card (small thumbnail), always use original colors
    // If None is selected (_selectedThemeIndex == -1), use original colors
    // Otherwise, use selected theme colors
    if (isPreview || _selectedThemeIndex == -1) {
      // Original hardcoded colors for preview thumbnails or when None is selected
      darkTealBg = const Color(0xFF0E2A2A);
      deepGreen = const Color(0xFF123838);
      goldenBorder = const Color(0xFFD4AF37);
      softGoldText = const Color(0xFFE6C87A);
      warmGold = const Color(0xFFBFA24A);
      lanternGlow = const Color(0xFFFFD36A);
      shadowGreen = const Color(0xFF081C1C);
    } else {
      // Use selected theme colors for main top card
      final currentTheme = _colorThemes[_selectedThemeIndex];
      darkTealBg = currentTheme.headerColor;
      deepGreen = currentTheme.footerColor;
      goldenBorder = currentTheme.accentColor;
      softGoldText = currentTheme.accentColor.withValues(alpha: 0.8);
      warmGold = currentTheme.accentColor;
      lanternGlow = currentTheme.accentColor;
      shadowGreen = currentTheme.headerColor.withValues(alpha: 0.5);
    }

    switch (index) {
      case 0:
        // Design 1: Classic Ornate Islamic Event Card with Diamond Pattern
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Diamond pattern background
              Positioned.fill(
                child: CustomPaint(
                  painter: DiamondPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.1),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: responsive.paddingAll(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                widget.event.icon,
                                color: goldenBorder,
                                size: responsive.iconSize(40.0),
                              ),
                              SizedBox(height: responsive.spacing(16.0)),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _customTitle,
                                    style: TextStyle(
                                      color: warmGold,
                                      fontSize: responsive.fontSize(18.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.spacing(12.0)),
                              Flexible(
                                child: Padding(
                                  padding: responsive.paddingSymmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    _customDescription,
                                    style: TextStyle(
                                      color: creamText,
                                      fontSize: responsive.fontSize(14.0),
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: deepGreen,
                      accentColor: goldenBorder,
                      responsive: responsive,
                      showStars: true,
                      showBorder: true,
                      borderColor: goldenBorder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 1:
        // Design 2: Golden Frame Style with Ornate Border
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkTealBg, deepGreen],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Islamic pattern background
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.08),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: responsive.paddingSymmetric(
                        vertical: 16.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: goldenBorder.withValues(alpha: 0.3),
                            width: responsive.spacing(2.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildCornerOrnament(goldenBorder),
                          SizedBox(width: responsive.spacing(10)),
                          Icon(
                            widget.event.icon,
                            color: goldenBorder,
                            size: responsive.iconSize(28.0),
                          ),
                          SizedBox(width: responsive.spacing(10)),
                          _buildCornerOrnament(goldenBorder),
                        ],
                      ),
                    ),
                    // Body
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _customTitle,
                                  style: TextStyle(
                                    color: warmGold,
                                    fontSize: responsive.fontSize(20.0),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            _buildGoldenBorder(goldenBorder, responsive),
                            SizedBox(height: responsive.spacing(16.0)),
                            Flexible(
                              child: Text(
                                _customDescription,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(13.0),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: softGoldText,
                      backgroundColor: deepGreen.withValues(alpha: 0.5),
                      accentColor: goldenBorder,
                      responsive: responsive,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 2:
        // Design 3: Elegant Mandala Pattern Style
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            child: Stack(
              children: [
                // Gradient background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [deepGreen, darkTealBg],
                    ),
                  ),
                ),
                // Mandala pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: MandalaPatternPainter(
                      color: goldenBorder.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Top section with icon
                    Container(
                      padding: responsive.paddingAll(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: responsive.paddingAll(16.0),
                            decoration: BoxDecoration(
                              color: goldenBorder.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: goldenBorder,
                                width: responsive.spacing(2.0),
                              ),
                            ),
                            child: Icon(
                              widget.event.icon,
                              color: goldenBorder,
                              size: responsive.iconSize(32.0),
                            ),
                          ),
                          SizedBox(height: responsive.spacing(16.0)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _customTitle,
                              style: TextStyle(
                                color: warmGold,
                                fontSize: responsive.fontSize(19.0),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Middle divider
                    Padding(
                      padding: responsive.paddingSymmetric(horizontal: 32.0),
                      child: Container(
                        height: responsive.spacing(2.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              goldenBorder,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Description
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(24.0),
                        child: Center(
                          child: Text(
                            _customDescription,
                            style: TextStyle(
                              color: creamText,
                              fontSize: responsive.fontSize(13.0),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: darkTealBg.withValues(alpha: 0.8),
                      accentColor: goldenBorder,
                      responsive: responsive,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );

      case 3:
        // Design 4: Geometric Islamic Pattern Style
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkTealBg, deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3.0),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Geometric pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: GeometricPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.1),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon with decorative border
                            Container(
                              padding: responsive.paddingAll(14.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: goldenBorder,
                                  width: responsive.spacing(2.5),
                                ),
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(12.0),
                                ),
                              ),
                              child: Icon(
                                widget.event.icon,
                                color: goldenBorder,
                                size: responsive.iconSize(36.0),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(20.0)),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _customTitle,
                                  style: TextStyle(
                                    color: warmGold,
                                    fontSize: responsive.fontSize(19.0),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: responsive.spacing(30.0),
                                  height: responsive.spacing(1.5),
                                  color: goldenBorder,
                                ),
                                SizedBox(width: responsive.spacing(8.0)),
                                _buildStar(goldenBorder, 8.0),
                                SizedBox(width: responsive.spacing(8.0)),
                                Container(
                                  width: responsive.spacing(30.0),
                                  height: responsive.spacing(1.5),
                                  color: goldenBorder,
                                ),
                              ],
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Flexible(
                              child: Text(
                                _customDescription,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(13.0),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: softGoldText,
                      backgroundColor: deepGreen.withValues(alpha: 0.6),
                      accentColor: goldenBorder,
                      responsive: responsive,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 4:
        // Design 5: Hanging Lanterns Style
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkTealBg, deepGreen],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            child: Column(
              children: [
                // Top section with lanterns
                Container(
                  padding: responsive.paddingSymmetric(
                    vertical: 20.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    children: [
                      // Lanterns
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLantern(warmGold, lanternGlow, 0.5, responsive),
                          Icon(
                            widget.event.icon,
                            color: goldenBorder,
                            size: responsive.iconSize(40.0),
                          ),
                          _buildLantern(warmGold, lanternGlow, 0.5, responsive),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(16.0)),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _customTitle,
                          style: TextStyle(
                            color: warmGold,
                            fontSize: responsive.fontSize(19.0),
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Container(
                  margin: responsive.paddingSymmetric(horizontal: 24.0),
                  height: responsive.spacing(2.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        goldenBorder,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Description
                Expanded(
                  child: Padding(
                    padding: responsive.paddingAll(24.0),
                    child: Center(
                      child: Text(
                        _customDescription,
                        style: TextStyle(
                          color: creamText,
                          fontSize: responsive.fontSize(13.0),
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                _buildAppFooter(
                  textColor: creamText,
                  backgroundColor: deepGreen.withValues(alpha: 0.7),
                  accentColor: goldenBorder,
                  responsive: responsive,
                ),
              ],
            ),
          ),
        );

      case 5:
        // Design 6: Elegant Frame with Corner Ornaments
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(2.5),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corner ornaments
              Positioned(
                top: responsive.spacing(12.0),
                left: responsive.spacing(12.0),
                child: _buildCornerOrnament(goldenBorder),
              ),
              Positioned(
                top: responsive.spacing(12.0),
                right: responsive.spacing(12.0),
                child: Transform.rotate(
                  angle: 1.5708, // 90 degrees
                  child: _buildCornerOrnament(goldenBorder),
                ),
              ),
              Positioned(
                bottom: responsive.spacing(12.0),
                left: responsive.spacing(12.0),
                child: Transform.rotate(
                  angle: -1.5708, // -90 degrees
                  child: _buildCornerOrnament(goldenBorder),
                ),
              ),
              Positioned(
                bottom: responsive.spacing(12.0),
                right: responsive.spacing(12.0),
                child: Transform.rotate(
                  angle: 3.14159, // 180 degrees
                  child: _buildCornerOrnament(goldenBorder),
                ),
              ),
              // Main content
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.event.icon,
                              color: goldenBorder,
                              size: responsive.iconSize(40.0),
                            ),
                            SizedBox(height: responsive.spacing(20.0)),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _customTitle,
                                  style: TextStyle(
                                    color: warmGold,
                                    fontSize: responsive.fontSize(19.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Container(
                              width: responsive.spacing(60.0),
                              height: responsive.spacing(2.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    goldenBorder,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Flexible(
                              child: Text(
                                _customDescription,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(13.0),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: darkTealBg.withValues(alpha: 0.8),
                      accentColor: goldenBorder,
                      responsive: responsive,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 6:
        // Design 7: Premium Celebration with Arch Pattern
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C4C3C),
            borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3.0),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Arch pattern background
              Positioned.fill(
                child: CustomPaint(
                  painter: ArchPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.1),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(22),
                ),
                child: Column(
                  children: [
                    // Top decorative section
                    Container(
                      padding: responsive.paddingSymmetric(
                        vertical: 16.0,
                        horizontal: 20.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: goldenBorder,
                            width: responsive.spacing(2.0),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStar(goldenBorder, 10.0),
                          SizedBox(width: responsive.spacing(12.0)),
                          Icon(
                            widget.event.icon,
                            color: goldenBorder,
                            size: responsive.iconSize(32.0),
                          ),
                          SizedBox(width: responsive.spacing(12.0)),
                          _buildStar(goldenBorder, 10.0),
                        ],
                      ),
                    ),
                    // Main content
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(28.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _customTitle,
                                  style: TextStyle(
                                    color: warmGold,
                                    fontSize: responsive.fontSize(20.0),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(20.0)),
                            _buildGoldenBorder(goldenBorder, responsive),
                            SizedBox(height: responsive.spacing(20.0)),
                            Flexible(
                              child: Text(
                                _customDescription,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(13.0),
                                  height: 1.7,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: softGoldText,
                      backgroundColor: Color(0xFF0A3A2E),
                      accentColor: goldenBorder,
                      responsive: responsive,
                      showStars: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 7:
        // Design 8: Modern Turquoise Elegance
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepGreen.withValues(alpha: 0.9), darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corner ornament details
              Positioned.fill(
                child: CustomPaint(
                  painter: CornerOrnamentDetailPainter(
                    color: goldenBorder.withValues(alpha: 0.15),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  children: [
                    // Header with gradient
                    Container(
                      width: double.infinity,
                      padding: responsive.paddingSymmetric(
                        vertical: 20.0,
                        horizontal: 24.0,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            goldenBorder.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: responsive.paddingAll(12.0),
                            decoration: BoxDecoration(
                              color: goldenBorder.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.event.icon,
                              color: goldenBorder,
                              size: responsive.iconSize(36.0),
                            ),
                          ),
                          SizedBox(height: responsive.spacing(16.0)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _customTitle,
                              style: TextStyle(
                                color: warmGold,
                                fontSize: responsive.fontSize(19.0),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Description
                    Expanded(
                      child: Padding(
                        padding: responsive.paddingAll(24.0),
                        child: Center(
                          child: Text(
                            _customDescription,
                            style: TextStyle(
                              color: creamText,
                              fontSize: responsive.fontSize(13.0),
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: deepGreen.withValues(alpha: 0.6),
                      accentColor: goldenBorder,
                      responsive: responsive,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 8:
        // Design 9: Original Premium Islamic Card with Hanging Lanterns
        return Container(
          margin: responsive.paddingSymmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: shadowGreen,
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            child: Stack(
              children: [
                // Background ornament pattern
                Positioned.fill(
                  child: CustomPaint(
                    painter: OrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Top hanging lanterns
                    Container(
                      padding: responsive.paddingSymmetric(
                        vertical: 12.0,
                        horizontal: 16.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLantern(warmGold, lanternGlow, 0.6, responsive),
                          _buildLantern(warmGold, lanternGlow, 0.5, responsive),
                          _buildLantern(warmGold, lanternGlow, 0.6, responsive),
                        ],
                      ),
                    ),
                    // Main content
                    Expanded(
                      child: Container(
                        margin: responsive.paddingAll(16.0),
                        padding: responsive.paddingAll(20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [darkTealBg, deepGreen],
                          ),
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(16.0),
                          ),
                          border: Border.all(
                            color: goldenBorder,
                            width: responsive.spacing(2.5),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.event.icon,
                              color: goldenBorder,
                              size: responsive.iconSize(40.0),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  _customTitle,
                                  style: TextStyle(
                                    color: warmGold,
                                    fontSize: responsive.fontSize(19.0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStar(lanternGlow, 8.0),
                                SizedBox(width: responsive.spacing(12.0)),
                                Container(
                                  width: responsive.spacing(50.0),
                                  height: responsive.spacing(2.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        goldenBorder,
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: responsive.spacing(12.0)),
                                _buildStar(lanternGlow, 8.0),
                              ],
                            ),
                            SizedBox(height: responsive.spacing(16.0)),
                            Flexible(
                              child: Text(
                                _customDescription,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(12.0),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Footer
                    Container(
                      padding: responsive.paddingSymmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStar(lanternGlow, 6),
                          SizedBox(width: responsive.spacing(10)),
                          Text(
                            'Noor-ul-Iman',
                            style: TextStyle(
                              color: creamText,
                              fontSize: responsive.fontSize(12),
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: responsive.spacing(10)),
                          _buildStar(lanternGlow, 6),
                        ],
                      ),
                    ),
                    SizedBox(height: responsive.spacing(8)),
                    _buildGoldenBorder(goldenBorder, responsive),
                  ],
                ),
              ],
            ),
          ),
        );

      default:
        return Container();
    }
  }

  void _showEditDialog() {
    final responsive = context.responsive;
    final titleController = TextEditingController(text: _customTitle);
    final descriptionController = TextEditingController(
      text: _customDescription,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
          side: BorderSide(
            color: Color(0xFF0A5C36),
            width: responsive.spacing(3),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: Color(0xFF0A5C36),
              size: responsive.iconSize(28),
            ),
            SizedBox(width: responsive.spacing(12)),
            Expanded(
              child: Text(
                widget.language == GreetingLanguage.urdu
                    ? 'ایونٹ میں ترمیم کریں'
                    : widget.language == GreetingLanguage.hindi
                    ? 'इवेंट संपादित करें'
                    : widget.language == GreetingLanguage.arabic
                    ? 'تعديل الحدث'
                    : 'Edit Event',
                style: const TextStyle(
                  color: Color(0xFF0A5C36),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'عنوان'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शीर्षक'
                      : widget.language == GreetingLanguage.arabic
                      ? 'العنوان'
                      : 'Title',
                  labelStyle: const TextStyle(color: Color(0xFF0A5C36)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF8AAF9A),
                      width: responsive.spacing(1.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                ),
                maxLines: 2,
              ),
              SizedBox(height: responsive.spacing(16)),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'تفصیل'
                      : widget.language == GreetingLanguage.hindi
                      ? 'विवरण'
                      : widget.language == GreetingLanguage.arabic
                      ? 'الوصف'
                      : 'Description',
                  labelStyle: const TextStyle(color: Color(0xFF0A5C36)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF8AAF9A),
                      width: responsive.spacing(1.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                ),
                maxLines: 5,
                minLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'منسوخ کریں'
                  : widget.language == GreetingLanguage.hindi
                  ? 'रद्द करें'
                  : widget.language == GreetingLanguage.arabic
                  ? 'إلغاء'
                  : 'Cancel',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _customTitle = titleController.text;
                _customDescription = descriptionController.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A5C36),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(12),
                ),
              ),
            ),
            child: Text(
              widget.language == GreetingLanguage.urdu
                  ? 'محفوظ کریں'
                  : widget.language == GreetingLanguage.hindi
                  ? 'सहेजें'
                  : widget.language == GreetingLanguage.arabic
                  ? 'حفظ'
                  : 'Save',
            ),
          ),
        ],
      ),
    );
  }

  // Premium Islamic Design Helper Methods for Event Cards
  Widget _buildLantern(
    Color bodyColor,
    Color glowColor,
    double scale,
    ResponsiveUtils responsive,
  ) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hanging chain
          Container(
            width: responsive.spacing(2),
            height: responsive.spacing(15),
            color: bodyColor.withValues(alpha: 0.6),
          ),
          // Lantern top
          Container(
            width: responsive.spacing(30),
            height: responsive.spacing(8),
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(responsive.borderRadius(4)),
              ),
            ),
          ),
          // Lantern body with glow
          Container(
            width: responsive.spacing(35),
            height: responsive.spacing(40),
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [glowColor, bodyColor]),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.wb_incandescent,
                color: glowColor,
                size: responsive.iconSize(20),
              ),
            ),
          ),
          // Lantern bottom
          Container(
            width: responsive.spacing(30),
            height: responsive.spacing(8),
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(responsive.borderRadius(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenBorder(Color color, ResponsiveUtils responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: responsive.spacing(40),
          height: responsive.spacing(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, color, color],
            ),
          ),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(8),
          height: responsive.spacing(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(30),
          height: responsive.spacing(2),
          color: color,
        ),
        SizedBox(width: responsive.spacing(8)),
        Icon(Icons.circle, color: color, size: responsive.iconSize(6)),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(30),
          height: responsive.spacing(2),
          color: color,
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(8),
          height: responsive.spacing(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(40),
          height: responsive.spacing(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStar(Color color, double size) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(Icons.star, color: color, size: size),
    );
  }

  Widget _buildCornerOrnament(Color color) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: CornerOrnamentPainter(color: color),
    );
  }

  Widget _buildAppFooter({
    required Color textColor,
    required Color backgroundColor,
    required Color accentColor,
    required ResponsiveUtils responsive,
    bool showStars = true,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingSymmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder && borderColor != null
            ? Border(
                top: BorderSide(
                  color: borderColor,
                  width: responsive.spacing(2.0),
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showStars) ...[
            _buildStar(accentColor, 6.0),
            SizedBox(width: responsive.spacing(8.0)),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Noor-ul-Iman',
              style: TextStyle(
                color: textColor,
                fontSize: responsive.fontSize(12.0),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showStars) ...[
            SizedBox(width: responsive.spacing(8.0)),
            _buildStar(accentColor, 6.0),
          ],
        ],
      ),
    );
  }

  Future<void> _downloadEventCard() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ ہو رہا ہے...'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड हो रहा है...'
                      : widget.language == GreetingLanguage.arabic
                      ? 'جاري التحميل...'
                      : 'Downloading...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );

      // Wait for widgets to fully render
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture at high quality (3x pixel ratio for retina quality)
      final image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 50),
      );

      if (image == null) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    widget.language == GreetingLanguage.urdu
                        ? 'ڈاؤن لوڈ ناکام ہو گیا'
                        : widget.language == GreetingLanguage.hindi
                        ? 'डाउनलोड विफल हो गया'
                        : widget.language == GreetingLanguage.arabic
                        ? 'فشل التحميل'
                        : 'Download failed',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/islamic_event_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      await Gal.putImage(imagePath, album: 'Noor-ul-Iman');
      await imageFile.delete();

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ کامیاب! گیلری میں محفوظ ہو گیا'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड सफल! गैलरी में सहेजा गया'
                      : widget.language == GreetingLanguage.arabic
                      ? 'تم التحميل بنجاح! تم الحفظ في المعرض'
                      : 'Download successful! Saved to gallery',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ میں خرابی: ${e.toString()}'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड में त्रुटि: ${e.toString()}'
                      : widget.language == GreetingLanguage.arabic
                      ? 'خطأ في التحميل: ${e.toString()}'
                      : 'Download error: ${e.toString()}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _shareEventCard(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'شیئر کے لیے تیار ہو رہا ہے...'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शेयर के लिए तैयार हो रहा है...'
                      : widget.language == GreetingLanguage.arabic
                      ? 'جاري التحضير للمشاركة...'
                      : 'Preparing to share...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );

      // Wait for widgets to fully render
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture at high quality (3x pixel ratio for retina quality)
      final image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 50),
      );

      if (image == null) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    widget.language == GreetingLanguage.urdu
                        ? 'شیئر ناکام ہو گیا'
                        : widget.language == GreetingLanguage.hindi
                        ? 'शेयर विफल हो गया'
                        : widget.language == GreetingLanguage.arabic
                        ? 'فشلت المشاركة'
                        : 'Share failed',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/islamic_event_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      await Share.shareXFiles(
        [XFile(imagePath)],
        text: widget.language == GreetingLanguage.urdu
            ? 'نور الایمان سے اسلامی تقریب کا کارڈ'
            : widget.language == GreetingLanguage.hindi
            ? 'नूर-उल-ईमान से इस्लामी कार्यक्रम कार्ड'
            : widget.language == GreetingLanguage.arabic
            ? 'بطاقة حدث إسلامي من نور الإيمان'
            : 'Islamic Event Card from Noor-ul-Iman',
      );

      Future.delayed(const Duration(seconds: 5), () {
        if (imageFile.existsSync()) {
          imageFile.delete();
        }
      });
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'شیئر میں خرابی: ${e.toString()}'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शेयर में त्रुटि: ${e.toString()}'
                      : widget.language == GreetingLanguage.arabic
                      ? 'خطأ في المشاركة: ${e.toString()}'
                      : 'Share error: ${e.toString()}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
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
    final responsive = context.responsive;
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
                      padding: responsive.paddingAll(20),
                      decoration: BoxDecoration(
                        color: darkGreen.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.card_giftcard,
                        size: responsive.iconSize(64),
                        color: darkGreen,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    Text(
                      language == GreetingLanguage.urdu
                          ? 'اس مہینے کے لیے کوئی خاص کارڈ نہیں'
                          : language == GreetingLanguage.hindi
                          ? 'इस महीने के लिए कोई विशेष कार्ड नहीं'
                          : language == GreetingLanguage.arabic
                          ? 'لا توجد بطاقات خاصة لهذا الشهر'
                          : 'No special cards for this month',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: responsive.fontSize(16),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: responsive.paddingAll(16),
                itemCount: AdListHelper.totalCount(month.cards.length),
                itemBuilder: (context, index) {
                  if (AdListHelper.isAdPosition(index)) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: BannerAdWidget(height: 250),
                    );
                  }
                  final dataIdx = AdListHelper.dataIndex(index);
                  return _GreetingCardTile(
                    card: month.cards[dataIdx],
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
    final responsive = context.responsive;
    // Islamic Color Scheme Constants
    const darkGreen = Color(0xFF0A5C36);
    const emeraldGreen = Color(0xFF1E8F5A);
    const lightGreenBorder = Color(0xFF8AAF9A);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: responsive.paddingOnly(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
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
          borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
          child: Container(
            padding: responsive.paddingAll(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
              border: Border.all(
                color: lightGreenBorder,
                width: responsive.spacing(1.5),
              ),
            ),
            child: Row(
              children: [
                // Icon with dark green circle
                Container(
                  width: responsive.spacing(58),
                  height: responsive.spacing(58),
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
                      size: responsive.iconSize(28),
                    ),
                  ),
                ),
                SizedBox(width: responsive.spacing(14)),
                // Card title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.getTitle(language),
                        style: TextStyle(
                          color: darkGreen,
                          fontSize: responsive.fontSize(16),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: responsive.spacing(6)),
                      Container(
                        padding: responsive.paddingSymmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: lightGreenChip,
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(8),
                          ),
                        ),
                        child: Text(
                          language == GreetingLanguage.urdu
                              ? 'دیکھنے کے لیے ٹیپ کریں'
                              : language == GreetingLanguage.hindi
                              ? 'देखने के लिए टैप करें'
                              : language == GreetingLanguage.arabic
                              ? 'اضغط للعرض'
                              : 'Tap to view',
                          style: TextStyle(
                            color: emeraldGreen,
                            fontSize: responsive.fontSize(11),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: responsive.spacing(8)),
                // Arrow button
                Container(
                  padding: responsive.paddingAll(8),
                  decoration: BoxDecoration(
                    color: emeraldGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFFFFFFFF),
                    size: responsive.iconSize(16),
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
    AdNavigator.push(context, StatusCardScreen(card: card, month: month, language: language));
  }
}

// Color Theme Data Class
class CardColorTheme {
  final String name;
  final String nameUrdu;
  final String nameHindi;
  final String nameArabic;
  final Color headerColor;
  final Color footerColor;
  final Color accentColor;

  const CardColorTheme({
    required this.name,
    required this.nameUrdu,
    required this.nameHindi,
    required this.nameArabic,
    required this.headerColor,
    required this.footerColor,
    required this.accentColor,
  });

  String getName(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return name;
      case GreetingLanguage.urdu:
        return nameUrdu;
      case GreetingLanguage.hindi:
        return nameHindi;
      case GreetingLanguage.arabic:
        return nameArabic;
    }
  }
}

// 8 Available Color Themes
final List<CardColorTheme> _colorThemes = [
  CardColorTheme(
    name: 'Islamic Green',
    nameUrdu: 'اسلامی سبز',
    nameHindi: 'इस्लामी हरा',
    nameArabic: 'الأخضر الإسلامي',
    headerColor: Color(0xFF0A5C36),
    footerColor: Color(0xFF1E8F5A),
    accentColor: Color(0xFFC9A24D),
  ),
  CardColorTheme(
    name: 'Royal Blue',
    nameUrdu: 'شاہی نیلا',
    nameHindi: 'रॉयल नीला',
    nameArabic: 'الأزرق الملكي',
    headerColor: Color(0xFF1565C0),
    footerColor: Color(0xFF1976D2),
    accentColor: Color(0xFFFFD700),
  ),
  CardColorTheme(
    name: 'Purple Elegance',
    nameUrdu: 'جامنی خوبصورتی',
    nameHindi: 'बैंगनी भव्यता',
    nameArabic: 'الأناقة الأرجوانية',
    headerColor: Color(0xFF6A1B9A),
    footerColor: Color(0xFF8E24AA),
    accentColor: Color(0xFFFFC107),
  ),
  CardColorTheme(
    name: 'Teal Ocean',
    nameUrdu: 'فیروزی سمندر',
    nameHindi: 'टील महासागर',
    nameArabic: 'المحيط الفيروزي',
    headerColor: Color(0xFF00695C),
    footerColor: Color(0xFF00897B),
    accentColor: Color(0xFFFFE082),
  ),
  CardColorTheme(
    name: 'Burgundy Wine',
    nameUrdu: 'برگنڈی شراب',
    nameHindi: 'बरगंडी वाइन',
    nameArabic: 'النبيذ البرغندي',
    headerColor: Color(0xFF880E4F),
    footerColor: Color(0xFFC2185B),
    accentColor: Color(0xFFFFEB3B),
  ),
  CardColorTheme(
    name: 'Indigo Night',
    nameUrdu: 'نیلی رات',
    nameHindi: 'इंडिगो रात',
    nameArabic: 'ليلة النيلي',
    headerColor: Color(0xFF283593),
    footerColor: Color(0xFF3949AB),
    accentColor: Color(0xFFFFCA28),
  ),
  CardColorTheme(
    name: 'Deep Orange',
    nameUrdu: 'گہرا نارنجی',
    nameHindi: 'गहरा नारंगी',
    nameArabic: 'البرتقالي العميق',
    headerColor: Color(0xFFD84315),
    footerColor: Color(0xFFE64A19),
    accentColor: Color(0xFFFFD54F),
  ),
  CardColorTheme(
    name: 'Brown Earth',
    nameUrdu: 'بھورا زمین',
    nameHindi: 'भूरा पृथ्वी',
    nameArabic: 'الأرض البنية',
    headerColor: Color(0xFF4E342E),
    footerColor: Color(0xFF6D4C41),
    accentColor: Color(0xFFFFB74D),
  ),
];

// Full Screen Craft Style Card Design
class StatusCardScreen extends StatefulWidget {
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
  State<StatusCardScreen> createState() => _StatusCardScreenState();
}

class _StatusCardScreenState extends State<StatusCardScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  int _selectedThemeIndex = -1; // -1 means None (original colors)
  int _selectedTemplateIndex = 0; // Default to original premium Islamic card
  String _customTitle = '';
  String _customMessage = '';
  bool _showTemplates = true; // true = show templates, false = show colors

  @override
  void initState() {
    super.initState();
    _customTitle = widget.card.getTitle(widget.language);
    _customMessage = widget.card.getMessage(widget.language);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_customTitle),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.paddingAll(16),
          child: Column(
            children: [
              // Main Card Display (wrapped with Screenshot) - Uses Selected Template
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  height: responsive.spacing(570.0),
                  width: double.infinity,
                  margin: responsive.paddingSymmetric(horizontal: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(20.0),
                    ),
                    child: _buildCardVariation(
                      _selectedTemplateIndex,
                      isPreview: false,
                    ),
                  ),
                ),
              ), // Screenshot widget
              SizedBox(height: responsive.spacing(10)),

              // Template and Color Toggle Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showTemplates = true;
                        });
                      },
                      child: Container(
                        padding: responsive.paddingSymmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _showTemplates
                              ? const Color(0xFF1E8F5A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(10),
                          ),
                          border: Border.all(
                            color: _showTemplates
                                ? const Color(0xFF0A5C36)
                                : const Color(0xFF1E8F5A),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: _showTemplates
                                  ? Colors.white
                                  : Colors.black,
                              size: responsive.iconSize(18),
                            ),
                            SizedBox(width: responsive.spacing(6)),
                            Text(
                              widget.language == GreetingLanguage.urdu
                                  ? 'ٹیمپلیٹ'
                                  : widget.language == GreetingLanguage.hindi
                                  ? 'टेम्पलेट'
                                  : widget.language == GreetingLanguage.arabic
                                  ? 'قالب'
                                  : 'Template',
                              style: TextStyle(
                                color: _showTemplates
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.spacing(10)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showTemplates = false;
                        });
                      },
                      child: Container(
                        padding: responsive.paddingSymmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_showTemplates
                              ? const Color(0xFF1E8F5A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(
                            responsive.borderRadius(10),
                          ),
                          border: Border.all(
                            color: !_showTemplates
                                ? const Color(0xFF0A5C36)
                                : const Color(0xFF1E8F5A),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.palette,
                              color: !_showTemplates
                                  ? Colors.white
                                  : Colors.black,
                              size: responsive.iconSize(18),
                            ),
                            SizedBox(width: responsive.spacing(6)),
                            Text(
                              widget.language == GreetingLanguage.urdu
                                  ? 'رنگ'
                                  : widget.language == GreetingLanguage.hindi
                                  ? 'रंग'
                                  : widget.language == GreetingLanguage.arabic
                                  ? 'لون'
                                  : 'Color',
                              style: TextStyle(
                                color: !_showTemplates
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: responsive.fontSize(14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing(10)),

              // Show Templates or Colors based on selection
              if (_showTemplates)
                // 9 Different Card Design Templates
                SizedBox(
                  height: responsive.spacing(80),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTemplateIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTemplateIndex = index;
                          });
                        },
                        child: Container(
                          width: responsive.spacing(80),
                          margin: responsive.paddingSymmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(12),
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFD4AF37)
                                  : Colors.transparent,
                              width: responsive.spacing(3),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(10),
                            ),
                            child: FittedBox(
                              child: SizedBox(
                                width: responsive.spacing(300),
                                height: responsive.spacing(400),
                                child: _buildCardVariation(
                                  index,
                                  isPreview: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                // Color Theme Selector with None button
                SizedBox(
                  height: responsive.spacing(60),
                  child: Row(
                    children: [
                      // None Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedThemeIndex = -1;
                          });
                        },
                        child: Container(
                          width: responsive.spacing(70),
                          margin: responsive.paddingSymmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E2A2A),
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(12),
                            ),
                            border: Border.all(
                              color: _selectedThemeIndex == -1
                                  ? const Color(0xFFD4AF37)
                                  : Colors.transparent,
                              width: responsive.spacing(3),
                            ),
                            boxShadow: _selectedThemeIndex == -1
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              widget.language == GreetingLanguage.urdu
                                  ? 'اصل'
                                  : widget.language == GreetingLanguage.hindi
                                  ? 'मूल'
                                  : widget.language == GreetingLanguage.arabic
                                  ? 'أصلي'
                                  : 'None',
                              style: TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: responsive.fontSize(12),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      // Color themes list
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _colorThemes.length,
                          itemBuilder: (context, index) {
                            final theme = _colorThemes[index];
                            final isSelected = _selectedThemeIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedThemeIndex = index;
                                });
                              },
                              child: Container(
                                width: responsive.spacing(60),
                                margin: responsive.paddingSymmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.headerColor,
                                      theme.footerColor,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    responsive.borderRadius(12),
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? theme.accentColor
                                        : Colors.transparent,
                                    width: responsive.spacing(3),
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: theme.accentColor.withValues(
                                              alpha: 0.5,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    theme.getName(widget.language),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: responsive.fontSize(8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: responsive.spacing(10)),

              // Action Buttons Row - Edit, Share, Download
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Edit Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: _showEditDialog,
                        icon: Icon(Icons.edit, size: responsive.iconSize(18)),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'ترمیم'
                              : widget.language == GreetingLanguage.hindi
                              ? 'संपादित'
                              : widget.language == GreetingLanguage.arabic
                              ? 'تعديل'
                              : 'Edit',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF0A5C36,
                          ), // Fixed Islamic Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Share Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: () => _shareCard(context),
                        icon: Icon(Icons.share, size: responsive.iconSize(18)),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'شیئر'
                              : widget.language == GreetingLanguage.hindi
                              ? 'शेयर'
                              : widget.language == GreetingLanguage.arabic
                              ? 'مشاركة'
                              : 'Share',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E8F5A,
                          ), // Fixed Emerald Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Download Button
                  Expanded(
                    child: Padding(
                      padding: responsive.paddingSymmetric(horizontal: 4),
                      child: ElevatedButton.icon(
                        onPressed: _downloadCard,
                        icon: Icon(
                          Icons.download,
                          size: responsive.iconSize(18),
                        ),
                        label: Text(
                          widget.language == GreetingLanguage.urdu
                              ? 'ڈاؤن لوڈ'
                              : widget.language == GreetingLanguage.hindi
                              ? 'डाउनलोड'
                              : widget.language == GreetingLanguage.arabic
                              ? 'تحميل'
                              : 'Download',
                          style: TextStyle(fontSize: responsive.fontSize(13)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E8F5A,
                          ), // Fixed Emerald Green
                          foregroundColor: Colors.white,
                          padding: responsive.paddingSymmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(30),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.spacing(6)),
            ],
          ),
        ),
      ),
    );
  }

  // Premium Islamic Design Helper Methods
  Widget _buildLantern(
    Color bodyColor,
    Color glowColor,
    double scale,
    ResponsiveUtils responsive,
  ) {
    return Transform.scale(
      scale: scale,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hanging chain
          Container(
            width: responsive.spacing(2),
            height: responsive.spacing(15),
            color: bodyColor.withValues(alpha: 0.6),
          ),
          // Lantern top
          Container(
            width: responsive.spacing(30),
            height: responsive.spacing(8),
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(responsive.borderRadius(4)),
              ),
            ),
          ),
          // Lantern body with glow
          Container(
            width: responsive.spacing(35),
            height: responsive.spacing(40),
            decoration: BoxDecoration(
              gradient: RadialGradient(colors: [glowColor, bodyColor]),
              borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.6),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.wb_incandescent,
                color: glowColor,
                size: responsive.iconSize(20),
              ),
            ),
          ),
          // Lantern bottom
          Container(
            width: responsive.spacing(30),
            height: responsive.spacing(8),
            decoration: BoxDecoration(
              color: bodyColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(responsive.borderRadius(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldenBorder(Color color, ResponsiveUtils responsive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: responsive.spacing(40),
          height: responsive.spacing(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, color, color],
            ),
          ),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(8),
          height: responsive.spacing(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(30),
          height: responsive.spacing(2),
          color: color,
        ),
        SizedBox(width: responsive.spacing(8)),
        Icon(Icons.circle, color: color, size: responsive.iconSize(6)),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(30),
          height: responsive.spacing(2),
          color: color,
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(8),
          height: responsive.spacing(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: responsive.spacing(8)),
        Container(
          width: responsive.spacing(40),
          height: responsive.spacing(2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color, Colors.transparent],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStar(Color color, double size) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(Icons.star, color: color, size: size),
    );
  }

  Widget _buildCornerOrnament(Color color) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: CornerOrnamentPainter(color: color),
    );
  }

  Widget _buildAppFooter({
    required Color textColor,
    required Color backgroundColor,
    required Color accentColor,
    required ResponsiveUtils responsive,
    bool showStars = true,
    bool showBorder = false,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: responsive.paddingSymmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: showBorder && borderColor != null
            ? Border(
                top: BorderSide(
                  color: borderColor,
                  width: responsive.spacing(2.0),
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showStars) ...[
            _buildStar(accentColor, 6.0),
            SizedBox(width: responsive.spacing(8.0)),
          ],
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Noor-ul-Iman',
              style: TextStyle(
                color: textColor,
                fontSize: responsive.fontSize(12.0),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showStars) ...[
            SizedBox(width: responsive.spacing(8.0)),
            _buildStar(accentColor, 6.0),
          ],
        ],
      ),
    );
  }

  // Build 9 Different Card Design Variations
  Widget _buildCardVariation(int index, {bool isPreview = false}) {
    // Remap indices: Original premium card (was index 8) is now at index 0
    const indexMap = [8, 0, 1, 2, 3, 4, 5, 6, 7];
    index = indexMap[index];

    final responsive = context.responsive;
    final Color darkTealBg;
    final Color deepGreen;
    final Color goldenBorder;
    final Color softGoldText;
    final Color warmGold;
    const creamText = Color(0xFFF5F1E6);
    final Color lanternGlow;
    final Color shadowGreen;

    // If it's a preview card (small thumbnail), always use original colors
    // If None is selected (_selectedThemeIndex == -1), use original colors
    // Otherwise, use selected theme colors
    if (isPreview || _selectedThemeIndex == -1) {
      // Original hardcoded colors for preview thumbnails or when None is selected
      darkTealBg = const Color(0xFF0E2A2A);
      deepGreen = const Color(0xFF123838);
      goldenBorder = const Color(0xFFD4AF37);
      softGoldText = const Color(0xFFE6C87A);
      warmGold = const Color(0xFFBFA24A);
      lanternGlow = const Color(0xFFFFD36A);
      shadowGreen = const Color(0xFF081C1C);
    } else {
      // Use selected theme colors for main top card
      final currentTheme = _colorThemes[_selectedThemeIndex];
      darkTealBg = currentTheme.headerColor;
      deepGreen = currentTheme.footerColor;
      goldenBorder = currentTheme.accentColor;
      softGoldText = currentTheme.accentColor.withValues(alpha: 0.8);
      warmGold = currentTheme.accentColor;
      lanternGlow = currentTheme.accentColor;
      shadowGreen = currentTheme.headerColor.withValues(alpha: 0.5);
    }

    switch (index) {
      case 0:
        // Design 1: Classic Ornate with Diamond Pattern
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Diamond pattern background
              Positioned.fill(
                child: CustomPaint(
                  painter: DiamondPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.1),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: responsive.paddingAll(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.brightness_2,
                                color: goldenBorder,
                                size: responsive.iconSize(40.0),
                              ),
                              SizedBox(height: responsive.spacing(16.0)),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _customTitle,
                                    style: TextStyle(
                                      color: warmGold,
                                      fontSize: responsive.fontSize(18.0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.spacing(12.0)),
                              Flexible(
                                child: Padding(
                                  padding: responsive.paddingSymmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: Text(
                                    _customMessage,
                                    style: TextStyle(
                                      color: creamText,
                                      fontSize: responsive.fontSize(14.0),
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 6,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: deepGreen,
                      accentColor: goldenBorder,
                      responsive: responsive,
                      showStars: true,
                      showBorder: true,
                      borderColor: goldenBorder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 1:
        // Design 2: Eid Al-Adha Golden Frame Style
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(color: goldenBorder, width: 4),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.7),
                blurRadius: 25,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Geometric Islamic Pattern Background
              Positioned.fill(
                child: CustomPaint(
                  painter: GeometricPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Top Golden Stars
              Positioned(
                top: 15,
                left: 30,
                child: _buildStar(goldenBorder, 10),
              ),
              Positioned(top: 20, left: 50, child: _buildStar(goldenBorder, 6)),
              Positioned(
                top: 15,
                right: 30,
                child: _buildStar(goldenBorder, 10),
              ),
              Positioned(
                top: 20,
                right: 50,
                child: _buildStar(goldenBorder, 6),
              ),
              // Main Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top ornament
                  Container(
                    width: responsive.spacing(60),
                    height: responsive.spacing(60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [goldenBorder, warmGold],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: goldenBorder.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.brightness_2,
                      color: Color(0xFF0A2A1A),
                      size: responsive.iconSize(32),
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Golden decorative line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: responsive.spacing(50),
                        height: responsive.spacing(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, goldenBorder],
                          ),
                        ),
                      ),
                      Container(
                        margin: responsive.paddingSymmetric(horizontal: 10),
                        width: responsive.spacing(8),
                        height: responsive.spacing(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: goldenBorder,
                        ),
                      ),
                      Container(
                        width: responsive.spacing(50),
                        height: responsive.spacing(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [goldenBorder, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Title
                  Padding(
                    padding: responsive.paddingSymmetric(horizontal: 30),
                    child: Text(
                      _customTitle,
                      style: TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: responsive.fontSize(22),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(16)),
                  // Message
                  Padding(
                    padding: responsive.paddingSymmetric(horizontal: 35),
                    child: Text(
                      _customMessage,
                      style: TextStyle(
                        color: creamText,
                        fontSize: responsive.fontSize(14),
                        height: 1.6,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(20)),
                  // Bottom ornamental line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: responsive.spacing(40),
                        height: 1.5,
                        color: goldenBorder,
                      ),
                      Padding(
                        padding: responsive.paddingSymmetric(horizontal: 8),
                        child: Icon(
                          Icons.auto_awesome,
                          color: goldenBorder,
                          size: responsive.iconSize(16),
                        ),
                      ),
                      Container(
                        width: responsive.spacing(40),
                        height: 1.5,
                        color: goldenBorder,
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(20.0)),
                  _buildAppFooter(
                    textColor: creamText,
                    backgroundColor: deepGreen.withValues(alpha: 0.5),
                    accentColor: goldenBorder,
                    responsive: responsive,
                    showStars: true,
                  ),
                ],
              ),
            ],
          ),
        );

      case 2:
        // Design 3: Royal Mosque - Islamic Theme with Dynamic Colors
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [darkTealBg, deepGreen, shadowGreen],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(color: goldenBorder, width: 3),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.borderRadius(17)),
            child: Stack(
              children: [
                // Background stars pattern
                ...List.generate(15, (index) {
                  final random = index * 17 % 10;
                  return Positioned(
                    top: (index * 31 % 200).toDouble(),
                    left: (index * 47 % 280).toDouble(),
                    child: Icon(
                      Icons.star,
                      color: softGoldText.withValues(
                        alpha: 0.15 + (random * 0.02),
                      ),
                      size: 8 + (random * 0.5),
                    ),
                  );
                }),
                // Islamic geometric pattern overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: IslamicPatternPainter(
                      color: goldenBorder.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                // Mosque dome silhouette at bottom
                Positioned(
                  bottom: 35,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(double.infinity, responsive.spacing(80)),
                    painter: MosqueSilhouettePainter(
                      color: shadowGreen.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                // Top decorative arch frame
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: responsive.spacing(60),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          goldenBorder.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Crescent moon and star at top
                Positioned(
                  top: responsive.spacing(20),
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStar(softGoldText, 8),
                      SizedBox(width: responsive.spacing(12)),
                      Container(
                        padding: responsive.paddingAll(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: goldenBorder, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: goldenBorder.withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.brightness_2,
                          color: goldenBorder,
                          size: responsive.iconSize(28),
                        ),
                      ),
                      SizedBox(width: responsive.spacing(12)),
                      _buildStar(softGoldText, 8),
                    ],
                  ),
                ),
                // Main content
                Padding(
                  padding: responsive.paddingSymmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: responsive.spacing(55)),
                      // Ornamental top divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: responsive.spacing(50),
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, goldenBorder],
                              ),
                            ),
                          ),
                          Padding(
                            padding: responsive.paddingSymmetric(
                              horizontal: 10,
                            ),
                            child: Container(
                              width: responsive.spacing(8),
                              height: responsive.spacing(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: goldenBorder,
                                boxShadow: [
                                  BoxShadow(
                                    color: goldenBorder.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: responsive.spacing(50),
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [goldenBorder, Colors.transparent],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(16)),
                      // Title with golden glow
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _customTitle,
                          style: TextStyle(
                            color: goldenBorder,
                            fontSize: responsive.fontSize(24),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(
                                color: goldenBorder.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(12)),
                      // Arabic style decorative element
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStar(softGoldText, 6),
                          Container(
                            margin: responsive.paddingSymmetric(horizontal: 8),
                            width: responsive.spacing(60),
                            height: 1.5,
                            color: softGoldText.withValues(alpha: 0.6),
                          ),
                          Icon(
                            Icons.auto_awesome,
                            color: softGoldText,
                            size: responsive.iconSize(14),
                          ),
                          Container(
                            margin: responsive.paddingSymmetric(horizontal: 8),
                            width: responsive.spacing(60),
                            height: 1.5,
                            color: softGoldText.withValues(alpha: 0.6),
                          ),
                          _buildStar(softGoldText, 6),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(16)),
                      // Message
                      Container(
                        constraints: BoxConstraints(
                          maxHeight: responsive.spacing(100),
                        ),
                        child: Text(
                          _customMessage,
                          style: TextStyle(
                            color: creamText.withValues(alpha: 0.9),
                            fontSize: responsive.fontSize(13),
                            height: 1.7,
                            letterSpacing: 0.4,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(12)),
                      // Bottom ornamental divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: responsive.spacing(30),
                            height: 1,
                            color: softGoldText.withValues(alpha: 0.4),
                          ),
                          Padding(
                            padding: responsive.paddingSymmetric(horizontal: 6),
                            child: Icon(
                              Icons.brightness_2,
                              color: softGoldText.withValues(alpha: 0.6),
                              size: responsive.iconSize(10),
                            ),
                          ),
                          Container(
                            width: responsive.spacing(30),
                            height: 1,
                            color: softGoldText.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Corner ornaments
                Positioned(
                  top: 8,
                  left: 8,
                  child: _buildCornerOrnament(goldenBorder),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Transform.rotate(
                    angle: 1.5708,
                    child: _buildCornerOrnament(goldenBorder),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 8,
                  child: Transform.rotate(
                    angle: -1.5708,
                    child: _buildCornerOrnament(goldenBorder),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  right: 8,
                  child: Transform.rotate(
                    angle: 3.1416,
                    child: _buildCornerOrnament(goldenBorder),
                  ),
                ),
                // Noor-ul-Iman Footer
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildAppFooter(
                    textColor: creamText,
                    backgroundColor: shadowGreen.withValues(alpha: 0.9),
                    accentColor: goldenBorder,
                    responsive: responsive,
                    showStars: true,
                  ),
                ),
              ],
            ),
          ),
        );

      case 3:
        // Design 4: Islamic New Year Blue Elegance
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkTealBg, deepGreen],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
            border: Border.all(color: goldenBorder, width: 3.5),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF000000).withValues(alpha: 0.4),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corner ornaments
              Positioned(
                top: 15,
                left: 15,
                child: CustomPaint(
                  size: Size(30, 30),
                  painter: CornerOrnamentPainter(
                    color: goldenBorder.withValues(alpha: 0.4),
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: Transform.rotate(
                  angle: 1.5708,
                  child: CustomPaint(
                    size: Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Transform.rotate(
                  angle: -1.5708,
                  child: CustomPaint(
                    size: Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: CustomPaint(
                    size: Size(30, 30),
                    painter: CornerOrnamentPainter(
                      color: goldenBorder.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: responsive.paddingAll(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top ornament
                    Container(
                      width: responsive.spacing(55),
                      height: responsive.spacing(55),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [goldenBorder, warmGold],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: goldenBorder.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.star,
                        color: Color(0xFF1A4D7A),
                        size: responsive.iconSize(30),
                      ),
                    ),
                    SizedBox(height: responsive.spacing(20)),
                    // Title
                    Text(
                      _customTitle,
                      style: TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: responsive.fontSize(24),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.spacing(14)),
                    // Decorative line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: responsive.spacing(60),
                          height: responsive.spacing(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, goldenBorder],
                            ),
                          ),
                        ),
                        Padding(
                          padding: responsive.paddingSymmetric(horizontal: 10),
                          child: Icon(
                            Icons.auto_awesome,
                            color: goldenBorder,
                            size: responsive.iconSize(16),
                          ),
                        ),
                        Container(
                          width: responsive.spacing(60),
                          height: responsive.spacing(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [goldenBorder, Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(14)),
                    // Message
                    Text(
                      _customMessage,
                      style: TextStyle(
                        color: Color(0xFFE8E8E8),
                        fontSize: responsive.fontSize(13),
                        height: 1.6,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: deepGreen.withValues(alpha: 0.5),
                      accentColor: goldenBorder,
                      responsive: responsive,
                      showStars: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 4:
        // Design 5: Eid Al-Fitr with Hanging Lanterns
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [deepGreen, darkTealBg],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background mandala pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.08),
                  ),
                ),
              ),
              // Hanging lanterns at top
              Positioned(
                top: 10,
                left: 30,
                child: Transform.scale(
                  scale: 0.5,
                  child: _buildLantern(
                    Color(0xFF8B4513),
                    lanternGlow,
                    1.0,
                    responsive,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 30,
                child: Transform.scale(
                  scale: 0.5,
                  child: _buildLantern(
                    Color(0xFF8B4513),
                    lanternGlow,
                    1.0,
                    responsive,
                  ),
                ),
              ),
              // Palm leaves decoration
              Positioned(
                top: 0,
                left: 10,
                child: Icon(
                  Icons.eco,
                  color: Color(0xFF2D5F3F).withValues(alpha: 0.5),
                  size: responsive.iconSize(50),
                ),
              ),
              Positioned(
                top: 0,
                right: 10,
                child: Transform.flip(
                  flipX: true,
                  child: Icon(
                    Icons.eco,
                    color: Color(0xFF2D5F3F).withValues(alpha: 0.5),
                    size: responsive.iconSize(50),
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: responsive.paddingSymmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Happy text
                    Text(
                      'HAPPY',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: responsive.fontSize(16),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 3,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(12)),
                    // Title
                    Text(
                      _customTitle,
                      style: TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: responsive.fontSize(26),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    // Message
                    Container(
                      padding: responsive.paddingAll(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF0A3A2E).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(12),
                        ),
                        border: Border.all(
                          color: goldenBorder.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _customMessage,
                        style: TextStyle(
                          color: creamText,
                          fontSize: responsive.fontSize(13),
                          height: 1.6,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildAppFooter(
                      textColor: creamText,
                      backgroundColor: deepGreen.withValues(alpha: 0.5),
                      accentColor: goldenBorder,
                      responsive: responsive,
                      showStars: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case 5:
        // Design 6: Iftar Invitation Elegant Frame
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkTealBg, deepGreen],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.7),
                blurRadius: 25,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(
                color: goldenBorder,
                width: responsive.spacing(3),
              ),
              borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [darkTealBg, deepGreen],
              ),
            ),
            child: Container(
              margin: responsive.paddingAll(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: goldenBorder.withValues(alpha: 0.4),
                  width: responsive.spacing(1.5),
                ),
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(12),
                ),
              ),
              padding: responsive.paddingAll(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Top decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: responsive.spacing(40),
                        height: 1.5,
                        color: goldenBorder,
                      ),
                      Padding(
                        padding: responsive.paddingSymmetric(horizontal: 10),
                        child: Icon(
                          Icons.mosque,
                          color: goldenBorder,
                          size: responsive.iconSize(22),
                        ),
                      ),
                      Container(
                        width: responsive.spacing(40),
                        height: 1.5,
                        color: goldenBorder,
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(16)),
                  // Invitation text
                  Text(
                    'Invitation',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: responsive.fontSize(13),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(12)),
                  // Title
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _customTitle,
                      style: TextStyle(
                        color: Color(0xFFFFE5A0),
                        fontSize: responsive.fontSize(22),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: Color(0xFF000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: responsive.spacing(14)),
                  // Message
                  Text(
                    _customMessage,
                    style: TextStyle(
                      color: Color(0xFFE8E8E8),
                      fontSize: responsive.fontSize(12),
                      height: 1.7,
                      letterSpacing: 0.4,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: responsive.spacing(14)),
                  // Bottom decoration
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStar(goldenBorder, 8),
                      SizedBox(width: responsive.spacing(10)),
                      Container(
                        width: responsive.spacing(50),
                        height: 1.5,
                        color: goldenBorder,
                      ),
                      SizedBox(width: responsive.spacing(10)),
                      _buildStar(goldenBorder, 8),
                    ],
                  ),
                  SizedBox(height: responsive.spacing(12)),
                  _buildAppFooter(
                    textColor: creamText,
                    backgroundColor: deepGreen.withValues(alpha: 0.5),
                    accentColor: goldenBorder,
                    responsive: responsive,
                    showStars: true,
                  ),
                ],
              ),
            ),
          ),
        );

      case 6:
        // Design 7: Premium Wedding/Celebration Invitation
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFF0C4C3C),
            borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.8),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
              BoxShadow(
                color: goldenBorder.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Top golden decorative border pattern
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: responsive.spacing(45),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [goldenBorder, warmGold, goldenBorder],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(responsive.borderRadius(22)),
                      topRight: Radius.circular(responsive.borderRadius(22)),
                    ),
                  ),
                  child: CustomPaint(
                    painter: GeometricPatternPainter(
                      color: Color(0xFF0C4C3C).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              // Bottom golden decorative border pattern
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: responsive.spacing(45),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [goldenBorder, warmGold, goldenBorder],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(responsive.borderRadius(22)),
                      bottomRight: Radius.circular(responsive.borderRadius(22)),
                    ),
                  ),
                  child: CustomPaint(
                    painter: GeometricPatternPainter(
                      color: Color(0xFF0C4C3C).withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              // Main content area
              Padding(
                padding: responsive.paddingOnly(
                  top: 50,
                  bottom: 50,
                  left: 20,
                  right: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [darkTealBg, deepGreen],
                    ),
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(16),
                    ),
                    border: Border.all(
                      color: goldenBorder,
                      width: responsive.spacing(2),
                    ),
                  ),
                  padding: responsive.paddingAll(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top ornament
                      Container(
                        padding: responsive.paddingAll(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [warmGold, goldenBorder],
                          ),
                        ),
                        child: Icon(
                          Icons.brightness_2,
                          color: Color(0xFF0F5C48),
                          size: responsive.iconSize(24),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(16)),
                      // Title
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _customTitle,
                          style: TextStyle(
                            color: Color(0xFFFFE5A0),
                            fontSize: responsive.fontSize(24),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            shadows: [
                              Shadow(
                                color: Color(0xFF000000),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: responsive.spacing(14)),
                      // Decorative divider
                      Container(
                        width: responsive.spacing(100),
                        height: responsive.spacing(2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              goldenBorder,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: responsive.spacing(14)),
                      // Message
                      Text(
                        _customMessage,
                        style: TextStyle(
                          color: creamText,
                          fontSize: responsive.fontSize(13),
                          height: 1.6,
                          letterSpacing: 0.4,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Noor-ul-Iman Footer
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildAppFooter(
                  textColor: creamText,
                  backgroundColor: Color(0xFF0C4C3C),
                  accentColor: goldenBorder,
                  responsive: responsive,
                  showStars: true,
                ),
              ),
            ],
          ),
        );

      case 7:
        // Design 8: Turquoise Celebration Elegance
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [darkTealBg, deepGreen, darkTealBg],
              stops: [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3),
            ),
            boxShadow: [
              BoxShadow(
                color: darkTealBg.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: responsive.paddingAll(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top star decoration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStar(Color(0xFFFFE5A0), 12),
                        SizedBox(width: responsive.spacing(15)),
                        Icon(
                          Icons.brightness_2,
                          color: goldenBorder,
                          size: responsive.iconSize(28),
                        ),
                        SizedBox(width: responsive.spacing(15)),
                        _buildStar(Color(0xFFFFE5A0), 12),
                      ],
                    ),
                    SizedBox(height: responsive.spacing(18)),
                    // Wishing you text (translated)
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.language == GreetingLanguage.urdu
                            ? 'آپ سب کو مبارک ہو'
                            : widget.language == GreetingLanguage.hindi
                            ? 'आप सभी को मुबारक हो'
                            : widget.language == GreetingLanguage.arabic
                            ? 'نتمنى لكم جميعاً'
                            : 'Wishing you all a very',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: responsive.fontSize(13),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(12)),
                    // Title
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _customTitle,
                        style: TextStyle(
                          color: Color(0xFFFFE5A0),
                          fontSize: responsive.fontSize(26),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Color(0xFF000000),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    // Message in frame
                    Container(
                      padding: responsive.paddingAll(14),
                      decoration: BoxDecoration(
                        color: Color(0xFF0A6666).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(12),
                        ),
                        border: Border.all(
                          color: goldenBorder.withValues(alpha: 0.5),
                          width: responsive.spacing(1.5),
                        ),
                      ),
                      child: Text(
                        _customMessage,
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: responsive.fontSize(12),
                          height: 1.7,
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    // Bottom decoration
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.4,
                          child: _buildLantern(
                            Color(0xFF8B4513),
                            Color(0xFFFFD700),
                            1.0,
                            responsive,
                          ),
                        ),
                        SizedBox(width: responsive.spacing(20)),
                        Transform.scale(
                          scale: 0.4,
                          child: _buildLantern(
                            Color(0xFF8B4513),
                            Color(0xFFFFD700),
                            1.0,
                            responsive,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Corner mandalas
              Positioned(
                top: 10,
                left: 10,
                child: CustomPaint(
                  size: Size(40, 40),
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: CustomPaint(
                  size: Size(40, 40),
                  painter: MandalaPatternPainter(
                    color: goldenBorder.withValues(alpha: 0.3),
                  ),
                ),
              ),
              // Noor-ul-Iman Footer
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildAppFooter(
                  textColor: creamText,
                  backgroundColor: deepGreen.withValues(alpha: 0.8),
                  accentColor: goldenBorder,
                  responsive: responsive,
                  showStars: true,
                ),
              ),
            ],
          ),
        );

      case 8:
        // Design 9: Original Premium Islamic Card with Lanterns
        return Container(
          margin: responsive.paddingSymmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: shadowGreen,
            borderRadius: BorderRadius.circular(responsive.borderRadius(24)),
            border: Border.all(
              color: goldenBorder,
              width: responsive.spacing(3),
            ),
            boxShadow: [
              BoxShadow(
                color: shadowGreen.withValues(alpha: 0.6),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: goldenBorder.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(responsive.borderRadius(22)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Header with Lanterns
                  Container(
                    width: double.infinity,
                    padding: responsive.paddingSymmetric(vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [deepGreen, deepGreen.withValues(alpha: 0.8)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Background Mandala Pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: MandalaPatternPainter(
                              color: Color(0xFFD4AF37).withValues(alpha: 0.15),
                            ),
                          ),
                        ),
                        // Hanging Lanterns
                        Positioned(
                          top: -10,
                          left: 20,
                          child: _buildLantern(
                            Color(0xFF8B4513),
                            lanternGlow,
                            0.7,
                            responsive,
                          ),
                        ),
                        Positioned(
                          top: -10,
                          right: 20,
                          child: _buildLantern(
                            Color(0xFF8B4513),
                            lanternGlow,
                            0.7,
                            responsive,
                          ),
                        ),
                        // Content
                        Column(
                          children: [
                            // HAPPY text
                            Text(
                              widget.language == GreetingLanguage.urdu
                                  ? 'مبارک ہو'
                                  : widget.language == GreetingLanguage.hindi
                                  ? 'मुबारक हो'
                                  : widget.language == GreetingLanguage.arabic
                                  ? 'مبارك'
                                  : 'HAPPY',
                              style: TextStyle(
                                color: softGoldText,
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 3,
                              ),
                            ),
                            SizedBox(height: responsive.spacing(8)),
                            // Golden decorative border
                            _buildGoldenBorder(goldenBorder, responsive),
                            SizedBox(height: responsive.spacing(10)),
                            // Moon and Stars decoration
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildStar(lanternGlow, 8),
                                SizedBox(width: responsive.spacing(12)),
                                Icon(
                                  Icons.brightness_2,
                                  color: goldenBorder,
                                  size: responsive.iconSize(24),
                                ),
                                SizedBox(width: responsive.spacing(12)),
                                _buildStar(lanternGlow, 8),
                              ],
                            ),
                            SizedBox(height: responsive.spacing(8)),

                            _buildGoldenBorder(goldenBorder, responsive),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Card Content Area
                  Container(
                    padding: responsive.paddingSymmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [deepGreen.withValues(alpha: 0.9), darkTealBg],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Month Name with Same Style as Title Card
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: goldenBorder,
                              width: responsive.spacing(2),
                            ),
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                deepGreen.withValues(alpha: 0.6),
                                shadowGreen.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: Consumer<LanguageProvider>(
                            builder: (context, languageProvider, child) {
                              String monthName;
                              switch (languageProvider.languageCode) {
                                case 'en':
                                  monthName = widget.month.name;
                                  break;
                                case 'ur':
                                  monthName = widget.month.nameUrdu;
                                  break;
                                case 'hi':
                                  monthName = widget.month.nameHindi;
                                  break;
                                case 'ar':
                                  monthName = widget.month.arabicName;
                                  break;
                                default:
                                  monthName = widget.month.name;
                              }

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildCornerOrnament(goldenBorder),
                                  SizedBox(width: responsive.spacing(10)),
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        monthName,
                                        style: TextStyle(
                                          color: warmGold,
                                          fontSize: responsive.fontSize(18),
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          fontFamily: 'Poppins',
                                          shadows: [
                                            Shadow(
                                              color: shadowGreen,
                                              blurRadius: 4,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: responsive.spacing(10)),
                                  _buildCornerOrnament(goldenBorder),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: responsive.spacing(10)),

                        // Main Title with Golden Frame
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: goldenBorder,
                              width: responsive.spacing(2),
                            ),
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(16),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                deepGreen.withValues(alpha: 0.6),
                                shadowGreen.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildCornerOrnament(goldenBorder),
                              SizedBox(width: responsive.spacing(10)),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _customTitle,
                                    style: TextStyle(
                                      color: warmGold,
                                      fontSize: responsive.fontSize(18),
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      shadows: [
                                        Shadow(
                                          color: shadowGreen,
                                          blurRadius: 4,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              SizedBox(width: responsive.spacing(10)),
                              _buildCornerOrnament(goldenBorder),
                            ],
                          ),
                        ),
                        SizedBox(height: responsive.spacing(10)),

                        // Message with Decorative Frame
                        Container(
                          padding: responsive.paddingAll(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                deepGreen.withValues(alpha: 0.4),
                                shadowGreen.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(
                              responsive.borderRadius(20),
                            ),
                            border: Border.all(
                              color: goldenBorder,
                              width: responsive.spacing(2),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: shadowGreen.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Top ornament
                              CustomPaint(
                                size: const Size(80, 18),
                                painter: OrnamentPainter(color: softGoldText),
                              ),
                              SizedBox(height: responsive.spacing(12)),
                              // Message text
                              Text(
                                _customMessage,
                                style: TextStyle(
                                  color: creamText,
                                  fontSize: responsive.fontSize(16),
                                  height: 1.8,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.5,
                                  shadows: [
                                    Shadow(
                                      color: shadowGreen,
                                      blurRadius: 2,
                                      offset: const Offset(1, 1),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: responsive.spacing(12)),
                              // Bottom ornament
                              Transform.rotate(
                                angle: 3.14159,
                                child: CustomPaint(
                                  size: const Size(80, 18),
                                  painter: OrnamentPainter(color: softGoldText),
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
                    padding: responsive.paddingSymmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [deepGreen.withValues(alpha: 0.9), shadowGreen],
                      ),
                      border: Border(
                        top: BorderSide(
                          color: goldenBorder,
                          width: responsive.spacing(2),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildGoldenBorder(goldenBorder, responsive),
                        SizedBox(height: responsive.spacing(8)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStar(lanternGlow, 6),
                            SizedBox(width: responsive.spacing(10)),
                            Text(
                              'Noor-ul-Iman',
                              style: TextStyle(
                                color: creamText,
                                fontSize: responsive.fontSize(12),
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: responsive.spacing(10)),
                            _buildStar(lanternGlow, 6),
                          ],
                        ),
                        SizedBox(height: responsive.spacing(8)),

                        _buildGoldenBorder(goldenBorder, responsive),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Future<void> _downloadCard() async {
    try {
      // Show loading message
      if (!mounted) return;

      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Show loading snackbar
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ ہو رہا ہے...'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड हो रहा है...'
                      : widget.language == GreetingLanguage.arabic
                      ? 'جاري التحميل...'
                      : 'Downloading...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );

      // Wait for widgets to fully render
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture at high quality (3x pixel ratio for retina quality)
      final image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 50),
      );

      if (image == null) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    widget.language == GreetingLanguage.urdu
                        ? 'ڈاؤن لوڈ ناکام ہو گیا'
                        : widget.language == GreetingLanguage.hindi
                        ? 'डाउनलोड विफल हो गया'
                        : widget.language == GreetingLanguage.arabic
                        ? 'فشل التحميل'
                        : 'Download failed',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Save to temporary directory first
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/greeting_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Save to gallery using Gal package
      await Gal.putImage(imagePath, album: 'Noor-ul-Iman');

      // Delete temporary file
      await imageFile.delete();

      if (!mounted) return;

      // Show success message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ کامیاب! گیلری میں محفوظ ہو گیا'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड सफल! गैलरी में सहेजा गया'
                      : widget.language == GreetingLanguage.arabic
                      ? 'تم التحميل بنجاح! تم الحفظ في المعرض'
                      : 'Download successful! Saved to gallery',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'ڈاؤن لوڈ میں خرابی: ${e.toString()}'
                      : widget.language == GreetingLanguage.hindi
                      ? 'डाउनलोड में त्रुटि: ${e.toString()}'
                      : widget.language == GreetingLanguage.arabic
                      ? 'خطأ في التحميل: ${e.toString()}'
                      : 'Download error: ${e.toString()}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showEditDialog() {
    final responsive = context.responsive;
    final titleController = TextEditingController(text: _customTitle);
    final messageController = TextEditingController(text: _customMessage);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
          side: BorderSide(
            color: Color(0xFF0A5C36), // Islamic Green border
            width: responsive.spacing(3),
          ),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: Color(0xFF0A5C36),
              size: responsive.iconSize(28),
            ),
            SizedBox(width: responsive.spacing(12)),
            Expanded(
              child: Text(
                widget.language == GreetingLanguage.urdu
                    ? 'کارڈ میں ترمیم کریں'
                    : widget.language == GreetingLanguage.hindi
                    ? 'कार्ड संपादित करें'
                    : widget.language == GreetingLanguage.arabic
                    ? 'تعديل البطاقة'
                    : 'Edit Card',
                style: const TextStyle(
                  color: Color(0xFF0A5C36),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'عنوان'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शीर्षक'
                      : widget.language == GreetingLanguage.arabic
                      ? 'العنوان'
                      : 'Title',
                  labelStyle: const TextStyle(color: Color(0xFF0A5C36)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF8AAF9A),
                      width: responsive.spacing(1.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                ),
                maxLines: 1,
              ),
              SizedBox(height: responsive.spacing(16)),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: widget.language == GreetingLanguage.urdu
                      ? 'پیغام'
                      : widget.language == GreetingLanguage.hindi
                      ? 'संदेश'
                      : widget.language == GreetingLanguage.arabic
                      ? 'الرسالة'
                      : 'Message',
                  labelStyle: const TextStyle(color: Color(0xFF0A5C36)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF8AAF9A),
                      width: responsive.spacing(1.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      responsive.borderRadius(12),
                    ),
                    borderSide: BorderSide(
                      color: Color(0xFF0A5C36),
                      width: responsive.spacing(2),
                    ),
                  ),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Reset Button
              Expanded(
                child: Padding(
                  padding: responsive.paddingSymmetric(horizontal: 4),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Reset to original
                      setState(() {
                        _customTitle = widget.card.getTitle(widget.language);
                        _customMessage = widget.card.getMessage(
                          widget.language,
                        );
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.refresh, size: responsive.iconSize(16)),
                    label: Text(
                      widget.language == GreetingLanguage.urdu
                          ? 'ری سیٹ'
                          : widget.language == GreetingLanguage.hindi
                          ? 'रीसेट'
                          : widget.language == GreetingLanguage.arabic
                          ? 'إعادة'
                          : 'Reset',
                      style: TextStyle(fontSize: responsive.fontSize(12)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9800), // Orange
                      foregroundColor: Colors.white,
                      padding: responsive.paddingSymmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Cancel Button
              Expanded(
                child: Padding(
                  padding: responsive.paddingSymmetric(horizontal: 4),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: responsive.iconSize(16)),
                    label: Text(
                      widget.language == GreetingLanguage.urdu
                          ? 'منسوخ'
                          : widget.language == GreetingLanguage.hindi
                          ? 'रद्द'
                          : widget.language == GreetingLanguage.arabic
                          ? 'إلغاء'
                          : 'Cancel',
                      style: TextStyle(fontSize: responsive.fontSize(12)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F), // Red
                      foregroundColor: Colors.white,
                      padding: responsive.paddingSymmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Save Button
              Expanded(
                child: Padding(
                  padding: responsive.paddingSymmetric(horizontal: 4),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _customTitle = titleController.text;
                        _customMessage = messageController.text;
                      });
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.check, size: responsive.iconSize(16)),
                    label: Text(
                      widget.language == GreetingLanguage.urdu
                          ? 'محفوظ'
                          : widget.language == GreetingLanguage.hindi
                          ? 'सहेजें'
                          : widget.language == GreetingLanguage.arabic
                          ? 'حفظ'
                          : 'Save',
                      style: TextStyle(fontSize: responsive.fontSize(12)),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A5C36), // Islamic Green
                      foregroundColor: Colors.white,
                      padding: responsive.paddingSymmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareCard(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Show loading snackbar
      if (!mounted) return;

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'شیئر کے لیے تیار ہو رہا ہے...'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शेयर के लिए तैयार हो रहा है...'
                      : widget.language == GreetingLanguage.arabic
                      ? 'جاري التحضير للمشاركة...'
                      : 'Preparing to share...',
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );

      // Wait for widgets to fully render
      await Future.delayed(const Duration(milliseconds: 100));

      // Capture at high quality (3x pixel ratio for retina quality)
      final image = await _screenshotController.capture(
        pixelRatio: 3.0,
        delay: const Duration(milliseconds: 50),
      );

      if (image == null) {
        if (!mounted) return;
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    widget.language == GreetingLanguage.urdu
                        ? 'شیئر ناکام ہو گیا'
                        : widget.language == GreetingLanguage.hindi
                        ? 'शेयर विफल हो गया'
                        : widget.language == GreetingLanguage.arabic
                        ? 'فشلت المشاركة'
                        : 'Share failed',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Save to temporary directory
      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/greeting_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      // Share the image
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: widget.language == GreetingLanguage.urdu
            ? 'نور الایمان سے اسلامی کارڈ'
            : widget.language == GreetingLanguage.hindi
            ? 'नूर-उल-ईमान से इस्लामी कार्ड'
            : widget.language == GreetingLanguage.arabic
            ? 'بطاقة إسلامية من نور الإيمان'
            : 'Islamic Card from Noor-ul-Iman',
      );

      // Delete temporary file after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (imageFile.existsSync()) {
          imageFile.delete();
        }
      });
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  widget.language == GreetingLanguage.urdu
                      ? 'شیئر میں خرابی: ${e.toString()}'
                      : widget.language == GreetingLanguage.hindi
                      ? 'शेयर में त्रुटि: ${e.toString()}'
                      : widget.language == GreetingLanguage.arabic
                      ? 'خطأ في المشاركة: ${e.toString()}'
                      : 'Share error: ${e.toString()}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
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

// Mandala Pattern Painter for Premium Islamic Design
class MandalaPatternPainter extends CustomPainter {
  final Color color;

  MandalaPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw mandala patterns
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw concentric circles
    for (var r = 20.0; r < 100; r += 25) {
      canvas.drawCircle(Offset(centerX, centerY), r, paint);
    }

    // Draw radiating lines
    for (var i = 0; i < 8; i++) {
      final angle = (i * 45) * 3.14159 / 180;
      final x1 = centerX + 30 * _cos(angle);
      final y1 = centerY + 30 * _sin(angle);
      final x2 = centerX + 80 * _cos(angle);
      final y2 = centerY + 80 * _sin(angle);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  double _cos(double radians) {
    // Simple approximation
    if (radians.abs() < 0.01) return 1;
    if ((radians - 1.5708).abs() < 0.01) return 0;
    if ((radians - 3.14159).abs() < 0.01) return -1;
    if ((radians - 4.71239).abs() < 0.01) return 0;
    // For 45-degree angles
    if ((radians - 0.7854).abs() < 0.01) return 0.707;
    if ((radians - 2.3562).abs() < 0.01) return -0.707;
    if ((radians - 3.9270).abs() < 0.01) return -0.707;
    if ((radians - 5.4978).abs() < 0.01) return 0.707;
    return 0;
  }

  double _sin(double radians) {
    // Simple approximation
    if (radians.abs() < 0.01) return 0;
    if ((radians - 1.5708).abs() < 0.01) return 1;
    if ((radians - 3.14159).abs() < 0.01) return 0;
    if ((radians - 4.71239).abs() < 0.01) return -1;
    // For 45-degree angles
    if ((radians - 0.7854).abs() < 0.01) return 0.707;
    if ((radians - 2.3562).abs() < 0.01) return 0.707;
    if ((radians - 3.9270).abs() < 0.01) return -0.707;
    if ((radians - 5.4978).abs() < 0.01) return -0.707;
    return 0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Ornament Painter for Message Decoration
class OrnamentPainter extends CustomPainter {
  final Color color;

  OrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Draw decorative curves
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height / 2,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width,
      size.height / 2,
    );

    canvas.drawPath(path, paint);

    // Draw center ornament
    final centerPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner Ornament Painter
class CornerOrnamentPainter extends CustomPainter {
  final Color color;

  CornerOrnamentPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw small decorative pattern
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 6, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 3, fillPaint);

    // Draw corner lines
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width / 2 - 8, size.height / 2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2 + 8, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Mosque Silhouette Painter for Royal Mosque Theme
class MosqueSilhouettePainter extends CustomPainter {
  final Color color;

  MosqueSilhouettePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Base line
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.7);

    // Left minaret
    path.lineTo(size.width * 0.08, size.height * 0.7);
    path.lineTo(size.width * 0.08, size.height * 0.25);
    path.lineTo(size.width * 0.10, size.height * 0.15);
    path.lineTo(size.width * 0.12, size.height * 0.25);
    path.lineTo(size.width * 0.12, size.height * 0.7);

    // Left small dome
    path.lineTo(size.width * 0.22, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.27,
      size.height * 0.45,
      size.width * 0.32,
      size.height * 0.7,
    );

    // Center main dome
    path.lineTo(size.width * 0.35, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.0,
      size.width * 0.65,
      size.height * 0.7,
    );

    // Right small dome
    path.lineTo(size.width * 0.68, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.73,
      size.height * 0.45,
      size.width * 0.78,
      size.height * 0.7,
    );

    // Right minaret
    path.lineTo(size.width * 0.88, size.height * 0.7);
    path.lineTo(size.width * 0.88, size.height * 0.25);
    path.lineTo(size.width * 0.90, size.height * 0.15);
    path.lineTo(size.width * 0.92, size.height * 0.25);
    path.lineTo(size.width * 0.92, size.height * 0.7);

    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Diamond Pattern Painter for Card Variation 1
class DiamondPatternPainter extends CustomPainter {
  final Color color;

  DiamondPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const spacing = 50.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        final path = Path();
        path.moveTo(x, y - 15);
        path.lineTo(x + 15, y);
        path.lineTo(x, y + 15);
        path.lineTo(x - 15, y);
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Arch Pattern Painter for Card Variation 5
class ArchPatternPainter extends CustomPainter {
  final Color color;

  ArchPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw arches
    final archWidth = size.width / 5;
    for (var i = 0; i < 5; i++) {
      final rect = Rect.fromLTWH(
        i * archWidth,
        size.height * 0.3,
        archWidth,
        size.height * 0.4,
      );
      canvas.drawArc(rect, 3.14159, 3.14159, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Geometric Pattern Painter for Card Variation 6
class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        // Draw hexagons
        final path = Path();
        const hexRadius = 15.0;
        for (var i = 0; i < 6; i++) {
          final angle = (i * 60) * 3.14159 / 180;
          final xPos = x + hexRadius * _cos(angle);
          final yPos = y + hexRadius * _sin(angle);
          if (i == 0) {
            path.moveTo(xPos, yPos);
          } else {
            path.lineTo(xPos, yPos);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  double _cos(double radians) {
    if (radians.abs() < 0.01) return 1;
    if ((radians - 1.5708).abs() < 0.01) return 0;
    if ((radians - 3.14159).abs() < 0.01) return -1;
    if ((radians - 4.71239).abs() < 0.01) return 0;
    if ((radians - 1.0472).abs() < 0.01) return 0.5;
    if ((radians - 2.0944).abs() < 0.01) return -0.5;
    if ((radians - 4.1888).abs() < 0.01) return -0.5;
    if ((radians - 5.2360).abs() < 0.01) return 0.5;
    return 0;
  }

  double _sin(double radians) {
    if (radians.abs() < 0.01) return 0;
    if ((radians - 1.5708).abs() < 0.01) return 1;
    if ((radians - 3.14159).abs() < 0.01) return 0;
    if ((radians - 4.71239).abs() < 0.01) return -1;
    if ((radians - 1.0472).abs() < 0.01) return 0.866;
    if ((radians - 2.0944).abs() < 0.01) return 0.866;
    if ((radians - 4.1888).abs() < 0.01) return -0.866;
    if ((radians - 5.2360).abs() < 0.01) return -0.866;
    return 0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Corner Ornament Detail Painter for Card Variation 7
class CornerOrnamentDetailPainter extends CustomPainter {
  final Color color;

  CornerOrnamentDetailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    // Draw ornate corner design
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.3,
      0,
      size.width * 0.4,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.2,
      size.width * 0.3,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.4,
      0,
      size.width * 0.4,
    );
    path.lineTo(0, 0);
    path.close();
    canvas.drawPath(path, paint);

    // Add decorative circles
    final circlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.15),
      3,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.08),
      2,
      circlePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.25),
      2,
      circlePaint,
    );
  }

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
  final String? specialOccasionArabic;
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
    this.specialOccasionArabic,
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
      case GreetingLanguage.arabic:
        return arabicName;
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
      case GreetingLanguage.arabic:
        return specialOccasionArabic;
    }
  }
}

class GreetingCard {
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final String message;
  final String messageUrdu;
  final String messageHindi;
  final String messageArabic;
  final IconData icon;
  final List<Color>? gradient;

  GreetingCard({
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.message,
    required this.messageUrdu,
    required this.messageHindi,
    required this.messageArabic,
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
      case GreetingLanguage.arabic:
        return titleArabic;
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
      case GreetingLanguage.arabic:
        return messageArabic;
    }
  }
}

// Islamic Events Class
class IslamicEvent {
  final int month;
  final int day;
  final String title;
  final String titleUrdu;
  final String titleHindi;
  final String titleArabic;
  final String description;
  final String descriptionUrdu;
  final String descriptionHindi;
  final String descriptionArabic;
  final IconData icon;
  final Color color;
  final String eventType; // 'viladat', 'shahadat', 'festival', 'special'

  IslamicEvent({
    required this.month,
    required this.day,
    required this.title,
    required this.titleUrdu,
    required this.titleHindi,
    required this.titleArabic,
    required this.description,
    required this.descriptionUrdu,
    required this.descriptionHindi,
    required this.descriptionArabic,
    required this.icon,
    required this.color,
    required this.eventType,
  });

  String getTitle(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return title;
      case GreetingLanguage.urdu:
        return titleUrdu;
      case GreetingLanguage.hindi:
        return titleHindi;
      case GreetingLanguage.arabic:
        return titleArabic;
    }
  }

  String getDescription(GreetingLanguage language) {
    switch (language) {
      case GreetingLanguage.english:
        return description;
      case GreetingLanguage.urdu:
        return descriptionUrdu;
      case GreetingLanguage.hindi:
        return descriptionHindi;
      case GreetingLanguage.arabic:
        return descriptionArabic;
    }
  }
}

// Important Islamic Events Throughout the Year
final List<IslamicEvent> _islamicEvents = [
  // Muharram (Month 1)
  IslamicEvent(
    month: 1,
    day: 1,
    title: 'Islamic New Year',
    titleUrdu: 'اسلامی نیا سال',
    titleHindi: 'इस्लामी नया साल',
    titleArabic: 'رأس السنة الهجرية',
    description:
        'The first day of Muharram marks the beginning of the Islamic calendar year.',
    descriptionUrdu: 'محرم کا پہلا دن اسلامی سال کی شروعات کی نشاندہی کرتا ہے۔',
    descriptionHindi:
        'मुहर्रम का पहला दिन इस्लामी कैलेंडर वर्ष की शुरुआत का प्रतीक है।',
    descriptionArabic: 'اليوم الأول من المحرم يمثل بداية السنة الهجرية.',
    icon: Icons.calendar_today,
    color: Color(0xFF5C6BC0),
    eventType: 'festival',
  ),
  IslamicEvent(
    month: 1,
    day: 10,
    title: 'Day of Ashura',
    titleUrdu: 'یوم عاشورہ',
    titleHindi: 'आशूरा का दिन',
    titleArabic: 'يوم عاشوراء',
    description:
        'A sacred day of fasting and remembrance of the martyrdom of Imam Hussain (RA).',
    descriptionUrdu: 'روزے اور امام حسین (رض) کی شہادت کی یاد کا مقدس دن۔',
    descriptionHindi:
        'रोज़े और इमाम हुसैन (रज़ि.) की शहादत की याद का पवित्र दिन।',
    descriptionArabic:
        'يوم مقدس من الصيام وإحياء ذكرى استشهاد الإمام الحسين (رض).',
    icon: Icons.nights_stay,
    color: Color(0xFF5C6BC0),
    eventType: 'shahadat',
  ),

  // Safar (Month 2)
  IslamicEvent(
    month: 2,
    day: 20,
    title: 'Arbaeen',
    titleUrdu: 'اربعین',
    titleHindi: 'अरबईन',
    titleArabic: 'الأربعين',
    description: 'The 40th day after Ashura, commemorating Imam Hussain (RA).',
    descriptionUrdu: 'عاشورہ کے 40 دن بعد، امام حسین (رض) کی یاد میں۔',
    descriptionHindi: 'आशूरा के 40 दिन बाद, इमाम हुसैन (रज़ि.) की याद में।',
    descriptionArabic:
        'اليوم الأربعين بعد عاشوراء، إحياء لذكرى الإمام الحسين (رض).',
    icon: Icons.favorite,
    color: Color(0xFF8D6E63),
    eventType: 'special',
  ),

  // Rabi al-Awwal (Month 3)
  IslamicEvent(
    month: 3,
    day: 12,
    title: 'Eid Milad-un-Nabi (SAW)',
    titleUrdu: 'عید میلاد النبی ﷺ',
    titleHindi: 'ईद मिलाद-उन-नबी (सल्ल.)',
    titleArabic: 'المولد النبوي الشريف',
    description:
        'The birth anniversary of Prophet Muhammad (Peace Be Upon Him).',
    descriptionUrdu: 'حضور نبی کریم ﷺ کی ولادت با سعادت کی سالگرہ۔',
    descriptionHindi: 'पैगंबर मुहम्मद (सल्ल.) की जन्म वर्षगांठ।',
    descriptionArabic: 'ذكرى مولد النبي محمد صلى الله عليه وسلم.',
    icon: Icons.auto_awesome,
    color: Color(0xFF43A047),
    eventType: 'viladat',
  ),

  // Rajab (Month 7)
  IslamicEvent(
    month: 7,
    day: 13,
    title: 'Wiladat Imam Ali (RA)',
    titleUrdu: 'ولادت حضرت علی (رض)',
    titleHindi: 'विलादत इमाम अली (रज़ि.)',
    titleArabic: 'ولادة الإمام علي (رض)',
    description:
        'The birth anniversary of Hazrat Ali (RA), the fourth Caliph of Islam.',
    descriptionUrdu: 'حضرت علی (رض)، اسلام کے چوتھے خلیفہ کی ولادت با سعادت۔',
    descriptionHindi:
        'हज़रत अली (रज़ि.), इस्लाम के चौथे खलीफा की जन्म वर्षगांठ।',
    descriptionArabic: 'ذكرى ميلاد الإمام علي (رض)، الخليفة الرابع للإسلام.',
    icon: Icons.star,
    color: Color(0xFFE53935),
    eventType: 'viladat',
  ),
  IslamicEvent(
    month: 7,
    day: 27,
    title: 'Shab-e-Meraj',
    titleUrdu: 'شب معراج',
    titleHindi: 'शब-ए-मेराज',
    titleArabic: 'ليلة المعراج',
    description:
        'The night of the Prophet\'s (SAW) miraculous journey to heaven.',
    descriptionUrdu: 'نبی کریم ﷺ کے آسمانوں کی طرف معجزاتی سفر کی رات۔',
    descriptionHindi: 'पैगंबर (सल्ल.) की स्वर्ग की ओर चमत्कारी यात्रा की रात।',
    descriptionArabic: 'ليلة الإسراء والمعراج المباركة.',
    icon: Icons.nights_stay,
    color: Color(0xFFE53935),
    eventType: 'special',
  ),

  // Shaban (Month 8)
  IslamicEvent(
    month: 8,
    day: 15,
    title: 'Shab-e-Barat',
    titleUrdu: 'شب برات',
    titleHindi: 'शब-ए-बारात',
    titleArabic: 'ليلة البراءة',
    description:
        'The night of forgiveness and blessings, seeking Allah\'s mercy.',
    descriptionUrdu: 'معافی اور برکتوں کی رات، اللہ کی رحمت کی طلب۔',
    descriptionHindi: 'माफी और बरकतों की रात, अल्लाह की रहमत की तलाश।',
    descriptionArabic: 'ليلة المغفرة والبركات، طلب رحمة الله.',
    icon: Icons.nightlight_round,
    color: Color(0xFF7B1FA2),
    eventType: 'special',
  ),

  // Ramadan (Month 9)
  IslamicEvent(
    month: 9,
    day: 1,
    title: 'First Day of Ramadan',
    titleUrdu: 'رمضان کا پہلا دن',
    titleHindi: 'रमज़ान का पहला दिन',
    titleArabic: 'أول يوم من رمضان',
    description:
        'The beginning of the holy month of fasting and spiritual reflection.',
    descriptionUrdu: 'روزے اور روحانی غور و ف��ر کے مقدس مہینے کی شروعات۔',
    descriptionHindi: 'रोज़े और आध्यात्मिक चिंतन के पवित्र महीने की शुरुआत।',
    descriptionArabic: 'بداية شهر الصيام والتأمل الروحي.',
    icon: Icons.calendar_today,
    color: Color(0xFF00897B),
    eventType: 'festival',
  ),
  IslamicEvent(
    month: 9,
    day: 21,
    title: 'Laylat al-Qadr (Estimated)',
    titleUrdu: 'شب قدر (تخمینہ)',
    titleHindi: 'लैलतुल कद्र (अनुमानित)',
    titleArabic: 'ليلة القدر (تقديري)',
    description:
        'The Night of Power, better than a thousand months. Likely on odd nights in last 10 days.',
    descriptionUrdu:
        'شب قدر، ہزار مہینوں سے بہتر۔ آخری 10 دنوں کی طاق راتوں میں ممکن۔',
    descriptionHindi:
        'क़द्र की रात, हज़ार महीनों से बेहतर। आखिरी 10 दिनों की ताक रातों में संभव।',
    descriptionArabic:
        'ليلة القدر، خير من ألف شهر. من المحتمل في الليالي الفردية من العشر الأواخر.',
    icon: Icons.stars,
    color: Color(0xFF00897B),
    eventType: 'special',
  ),
  IslamicEvent(
    month: 9,
    day: 27,
    title: 'Laylat al-Qadr (27th)',
    titleUrdu: 'شب قدر (27ویں)',
    titleHindi: 'लैलतुल कद्र (27वीं)',
    titleArabic: 'ليلة القدر (27)',
    description:
        'The most likely night of Laylat al-Qadr, a night of immense blessings.',
    descriptionUrdu: 'شب قدر کی سب سے زیادہ ممکنہ رات، بے شمار برکتوں کی رات۔',
    descriptionHindi: 'लैलतुल क़द्र की सबसे संभावित रात, अपार बरकतों की रात।',
    descriptionArabic:
        'الليلة الأكثر احتمالاً لليلة القدر، ليلة من البركات الهائلة.',
    icon: Icons.star,
    color: Color(0xFF00897B),
    eventType: 'special',
  ),

  // Shawwal (Month 10)
  IslamicEvent(
    month: 10,
    day: 1,
    title: 'Eid al-Fitr',
    titleUrdu: 'عید الفطر',
    titleHindi: 'ईद-उल-फ़ित्र',
    titleArabic: 'عيد الفطر',
    description:
        'The Festival of Breaking the Fast, celebrating the end of Ramadan.',
    descriptionUrdu: 'روزوں کے اختتام کی خوشی کا تہوار، رمضان کے بعد۔',
    descriptionHindi: 'रोज़ों के समापन की खुशी का त्योहार, रमज़ान के बाद।',
    descriptionArabic: 'عيد الفطر، الاحتفال بنهاية شهر رمضان المبارك.',
    icon: Icons.celebration,
    color: Color(0xFF00897B),
    eventType: 'festival',
  ),

  // Dhul Hijjah (Month 12)
  IslamicEvent(
    month: 12,
    day: 9,
    title: 'Day of Arafah',
    titleUrdu: 'یوم عرفہ',
    titleHindi: 'यौम-ए-अरफा',
    titleArabic: 'يوم عرفة',
    description:
        'The most important day of Hajj, a day of forgiveness and mercy.',
    descriptionUrdu: 'حج کا سب سے اہم دن، معافی اور رحمت کا دن۔',
    descriptionHindi: 'हज का सबसे महत्वपूर्ण दिन, माफी और रहमत का दिन।',
    descriptionArabic: 'أهم يوم في الحج، يوم المغفرة والرحمة.',
    icon: Icons.terrain,
    color: Color(0xFFD32F2F),
    eventType: 'special',
  ),
  IslamicEvent(
    month: 12,
    day: 10,
    title: 'Eid al-Adha',
    titleUrdu: 'عید الاضحی',
    titleHindi: 'ईद-उल-अज़हा',
    titleArabic: 'عيد الأضحى',
    description:
        'The Festival of Sacrifice, commemorating Prophet Ibrahim\'s (AS) devotion.',
    descriptionUrdu:
        'قربانی کا تہوار، حضرت ابراہیم (علیہ السلام) کی قربانی کی یاد میں۔',
    descriptionHindi:
        'कुर्बानी का त्योहार, हज़रत इब्राहीम (अ.स.) की निष्ठा की याद में।',
    descriptionArabic:
        'عيد الأضحى، إحياء لذكرى تفاني النبي إبراهيم (عليه السلام).',
    icon: Icons.mosque,
    color: Color(0xFFD32F2F),
    eventType: 'festival',
  ),
  IslamicEvent(
    month: 12,
    day: 18,
    title: 'Eid-e-Ghadeer',
    titleUrdu: 'عید غدیر',
    titleHindi: 'ईद-ए-ग़दीर',
    titleArabic: 'عيد الغدير',
    description:
        'Celebration of the appointment of Hazrat Ali (RA) at Ghadeer Khumm.',
    descriptionUrdu: 'غدیر خم میں حضرت علی (رض) کی تقرری کی خوشی۔',
    descriptionHindi: 'ग़दीर खुम में हज़रत अली (रज़ि.) की नियुक्ति का उत्सव।',
    descriptionArabic: 'الاحتفال بتعيين الإمام علي (رض) في غدير خم.',
    icon: Icons.celebration,
    color: Color(0xFFD32F2F),
    eventType: 'special',
  ),

  // Rabi al-Awwal (Month 3) - Additional events
  IslamicEvent(
    month: 3,
    day: 8,
    title: 'Wiladat Imam Hassan (RA)',
    titleUrdu: 'ولادت امام حسن (رض)',
    titleHindi: 'विलादत इमाम हसन (रज़ि.)',
    titleArabic: 'ولادة الإمام الحسن (رض)',
    description:
        'The birth anniversary of Imam Hassan ibn Ali (RA), grandson of Prophet Muhammad (SAW).',
    descriptionUrdu:
        'امام حسن بن علی (رض)، نبی کریم ﷺ کے نواسے کی ولادت با سعادت۔',
    descriptionHindi:
        'इमाम हसन बिन अली (रज़ि.), पैगंबर मुहम्मद (सल्ल.) के नवासे की जन्म वर्षगांठ।',
    descriptionArabic:
        'ذكرى ميلاد الإمام الحسن بن علي (رض)، حفيد النبي محمد (صلى الله عليه وسلم).',
    icon: Icons.child_care,
    color: Color(0xFF43A047),
    eventType: 'viladat',
  ),
  IslamicEvent(
    month: 3,
    day: 17,
    title: 'Wiladat Imam Jafar Sadiq (RA)',
    titleUrdu: 'ولادت امام جعفر صادق (رض)',
    titleHindi: 'विलादत इमाम जाफर सादिक़ (रज़ि.)',
    titleArabic: 'ولادة الإمام جعفر الصادق (رض)',
    description:
        'The birth anniversary of Imam Jafar Sadiq (RA), renowned Islamic scholar.',
    descriptionUrdu:
        'امام جعفر صادق (رض)، مشہور اسلامی عالم کی ولادت با سعادت۔',
    descriptionHindi:
        'इमाम जाफर सादिक़ (रज़ि.), प्रसिद्ध इस्लामी विद्वान की जन्म वर्षगांठ।',
    descriptionArabic:
        'ذكرى ميلاد الإمام جعفر الصادق (رض)، العالم الإسلامي المشهور.',
    icon: Icons.menu_book,
    color: Color(0xFF43A047),
    eventType: 'viladat',
  ),

  // Rajab (Month 7) - Additional events
  IslamicEvent(
    month: 7,
    day: 1,
    title: 'Beginning of Rajab',
    titleUrdu: 'رجب کی شروعات',
    titleHindi: 'रजब की शुरुआत',
    titleArabic: 'بداية شهر رجب',
    description:
        'The beginning of the sacred month of Rajab, one of the four sacred months.',
    descriptionUrdu: 'رجب کے مقدس مہینے کی شروعات، چار مقدس مہینوں میں سے ایک۔',
    descriptionHindi:
        'रजब के पवित्र महीने की शुरुआत, चार पवित्र महीनों में से एक।',
    descriptionArabic: 'بداية شهر رجب المبارك، أحد الأشهر الحرم الأربعة.',
    icon: Icons.calendar_month,
    color: Color(0xFFE53935),
    eventType: 'special',
  ),
  IslamicEvent(
    month: 7,
    day: 3,
    title: 'Wiladat Imam Ali Naqi (RA)',
    titleUrdu: 'ولادت امام علی نقی (رض)',
    titleHindi: 'विलादत इमाम अली नक़ी (रज़ि.)',
    titleArabic: 'ولادة الإمام علي النقي (رض)',
    description:
        'The birth anniversary of Imam Ali al-Naqi (RA), the tenth Imam.',
    descriptionUrdu: 'امام علی النقی (رض)، دسویں امام کی ولادت با سعادت۔',
    descriptionHindi: 'इमाम अली अल-नक़ी (रज़ि.), दसवें इमाम की जन्म वर्षगांठ।',
    descriptionArabic: 'ذكرى ميلاد الإمام علي النقي (رض)، الإمام العاشر.',
    icon: Icons.star,
    color: Color(0xFFE53935),
    eventType: 'viladat',
  ),

  // Jamadi al-Awwal (Month 5)
  IslamicEvent(
    month: 5,
    day: 13,
    title: 'Wiladat Bibi Fatima (RA)',
    titleUrdu: 'ولادت بی بی فاطمہ (رض)',
    titleHindi: 'विलादत बीबी फ़ातिमा (रज़ि.)',
    titleArabic: 'ولادة فاطمة الزهراء (رض)',
    description:
        'The birth anniversary of Bibi Fatima (RA), daughter of Prophet Muhammad (SAW).',
    descriptionUrdu:
        'بی بی فاطمہ (رض)، نبی کریم ﷺ کی صاحبزادی کی ولادت با سعادت۔',
    descriptionHindi:
        'बीबी फ़ातिमा (रज़ि.), पैगंबर मुहम्मद (सल्ल.) की बेटी की जन्म वर्षगांठ।',
    descriptionArabic:
        'ذكرى ميلاد فاطمة الزهراء (رض)، ابنة النبي محمد (صلى الله عليه وسلم).',
    icon: Icons.favorite,
    color: Color(0xFFFF6F00),
    eventType: 'viladat',
  ),

  // Rajab (Month 7) - More events
  IslamicEvent(
    month: 7,
    day: 10,
    title: 'Wiladat Imam Muhammad Taqi (RA)',
    titleUrdu: 'ولادت امام محمد تقی (رض)',
    titleHindi: 'विलादत इमाम मुहम्मद तक़ी (रज़ि.)',
    titleArabic: 'ولادة الإمام محمد التقي (رض)',
    description:
        'The birth anniversary of Imam Muhammad al-Taqi (RA), the ninth Imam.',
    descriptionUrdu: 'امام محمد التقی (رض)، نویں امام کی ولادت با سعادت۔',
    descriptionHindi:
        'इमाम मुहम्मद अल-तक़ी (रज़ि.), नौवें इमाम की जन्म वर्षगांठ।',
    descriptionArabic: 'ذكرى ميلاد الإمام محمد التقي (رض)، الإمام التاسع.',
    icon: Icons.star,
    color: Color(0xFFE53935),
    eventType: 'viladat',
  ),

  // Shaban (Month 8) - Additional events
  IslamicEvent(
    month: 8,
    day: 3,
    title: 'Wiladat Imam Hussain (RA)',
    titleUrdu: 'ولادت امام حسین (رض)',
    titleHindi: 'विलादत इमाम हुसैन (रज़ि.)',
    titleArabic: 'ولادة الإمام الحسين (رض)',
    description:
        'The birth anniversary of Imam Hussain ibn Ali (RA), the grandson of Prophet Muhammad (SAW).',
    descriptionUrdu:
        'امام حسین بن علی (رض)، نبی کریم ﷺ کے نواسے کی ولادت با سعادت۔',
    descriptionHindi:
        'इमाम हुसैन बिन अली (रज़ि.), पैगंबर मुहम्मद (सल्ल.) के नवासे की जन्म वर्षगांठ।',
    descriptionArabic:
        'ذكرى ميلاد الإمام الحسين بن علي (رض)، حفيد النبي محمد (صلى الله عليه وسلم).',
    icon: Icons.child_care,
    color: Color(0xFF7B1FA2),
    eventType: 'viladat',
  ),
  IslamicEvent(
    month: 8,
    day: 4,
    title: 'Wiladat Hazrat Abbas (RA)',
    titleUrdu: 'ولادت حضرت عباس (رض)',
    titleHindi: 'विलादत हज़रत अब्बास (रज़ि.)',
    titleArabic: 'ولادة العباس (رض)',
    description:
        'The birth anniversary of Hazrat Abbas ibn Ali (RA), the loyal companion of Imam Hussain (RA).',
    descriptionUrdu:
        'حضرت عباس بن علی (رض)، امام حسین (رض) کے وفادار ساتھی کی ولادت با سعادت۔',
    descriptionHindi:
        'हज़रत अब्बास बिन अली (रज़ि.), इमाम हुसैन (रज़ि.) के वफादार साथी की जन्म वर्षगांठ।',
    descriptionArabic:
        'ذكرى ميلاد العباس بن علي (رض)، الصاحب الوفي للإمام الحسين (رض).',
    icon: Icons.shield,
    color: Color(0xFF7B1FA2),
    eventType: 'viladat',
  ),

  // Ramadan (Month 9) - Additional events
  IslamicEvent(
    month: 9,
    day: 10,
    title: 'Wafat Bibi Khadija (RA)',
    titleUrdu: 'وفات بی بی خدیجہ (رض)',
    titleHindi: 'वफात बीबी खदीजा (रज़ि.)',
    titleArabic: 'وفاة خديجة (رض)',
    description:
        'Remembering Bibi Khadija (RA), the first wife of Prophet Muhammad (SAW).',
    descriptionUrdu: 'بی بی خدیجہ (رض)، نبی کریم ﷺ کی پہلی بیوی کی یاد۔',
    descriptionHindi:
        'बीबी खदीजा (रज़ि.), पैगंबर मुहम्मद (सल्ल.) की पहली पत्नी की याद।',
    descriptionArabic:
        'في ذكرى وفاة خديجة (رض)، الزوجة الأولى للنبي محمد (صلى الله عليه وسلم).',
    icon: Icons.favorite_border,
    color: Color(0xFF00897B),
    eventType: 'shahadat',
  ),
  IslamicEvent(
    month: 9,
    day: 17,
    title: 'Battle of Badr Anniversary',
    titleUrdu: 'غزوہ بدر کی سالگرہ',
    titleHindi: 'गज़वा-ए-बद्र की वर्षगांठ',
    titleArabic: 'ذكرى غزوة بدر',
    description: 'Commemorating the historic victory of the Battle of Badr.',
    descriptionUrdu: 'غزوہ بدر کی تاریخی فتح کی یاد۔',
    descriptionHindi: 'गज़वा-ए-बद्र की ऐतिहासिक जीत की याद।',
    descriptionArabic: 'إحياء ذكرى النصر التاريخي في غزوة بدر.',
    icon: Icons.military_tech,
    color: Color(0xFF00897B),
    eventType: 'special',
  ),
  IslamicEvent(
    month: 9,
    day: 19,
    title: 'Shahadat Hazrat Ali (RA)',
    titleUrdu: 'شہادت حضرت علی (رض)',
    titleHindi: 'शहादत हज़रत अली (रज़ि.)',
    titleArabic: 'استشهاد الإمام علي (رض)',
    description:
        'The martyrdom anniversary of Hazrat Ali ibn Abi Talib (RA), the fourth Caliph.',
    descriptionUrdu: 'حضرت علی بن ابی طالب (رض)، چوتھے خلیفہ کی شہادت کی یاد۔',
    descriptionHindi:
        'हज़रत अली बिन अबी तालिब (रज़ि.), चौथे खलीफा की शहादत की याद।',
    descriptionArabic: 'ذكرى استشهاد علي بن أبي طالب (رض)، الخليفة الرابع.',
    icon: Icons.favorite,
    color: Color(0xFF00897B),
    eventType: 'shahadat',
  ),

  // Dhul Qa'dah (Month 11)
  IslamicEvent(
    month: 11,
    day: 11,
    title: 'Wiladat Imam Reza (RA)',
    titleUrdu: 'ولادت امام رضا (رض)',
    titleHindi: 'विलादत इमाम रज़ा (रज़ि.)',
    titleArabic: 'ولادة الإمام الرضا (رض)',
    description:
        'The birth anniversary of Imam Ali al-Reza (RA), the eighth Imam.',
    descriptionUrdu: 'امام علی الرضا (رض)، آٹھویں امام کی ولادت با سعادت۔',
    descriptionHindi: 'इमाम अली अल-रज़ा (रज़ि.), आठवें इमाम की जन्म वर्षगांठ।',
    descriptionArabic: 'ذكرى ميلاد الإمام علي الرضا (رض)، الإمام الثامن.',
    icon: Icons.star,
    color: Color(0xFF6A1B9A),
    eventType: 'viladat',
  ),
  IslamicEvent(
    month: 11,
    day: 25,
    title: 'Dahw al-Ardh (Earth Day)',
    titleUrdu: 'دحو الارض',
    titleHindi: 'दह्व अल-अर्ध़',
    titleArabic: 'دحو الأرض',
    description:
        'Commemorating the spreading of the earth from beneath the Kaaba.',
    descriptionUrdu: 'کعبہ کے نیچے سے زمین کی پھیلاؤ کی یاد۔',
    descriptionHindi: 'काबा के नीचे से पृथ्वी के विस्तार की याद।',
    descriptionArabic: 'إحياء ذكرى بسط الأرض من تحت الكعبة.',
    icon: Icons.public,
    color: Color(0xFF6A1B9A),
    eventType: 'special',
  ),

  // Dhul Hijjah (Month 12) - Additional events
  IslamicEvent(
    month: 12,
    day: 7,
    title: 'Shahadat Imam Muhammad Baqir (RA)',
    titleUrdu: 'شہادت امام محمد باقر (رض)',
    titleHindi: 'शहादत इमाम मुहम्मद बाक़िर (रज़ि.)',
    titleArabic: 'استشهاد الإمام محمد الباقر (رض)',
    description:
        'The martyrdom anniversary of Imam Muhammad al-Baqir (RA), the fifth Imam.',
    descriptionUrdu: 'امام محمد الباقر (رض)، پانچویں امام کی شہادت کی یاد۔',
    descriptionHindi:
        'इमाम मुहम्मद अल-बाक़िर (रज़ि.), पांचवें इमाम की शहादत की याद।',
    descriptionArabic: 'ذكرى استشهاد الإمام محمد الباقر (رض)، الإمام الخامس.',
    icon: Icons.favorite,
    color: Color(0xFFD32F2F),
    eventType: 'shahadat',
  ),
];

// Islamic Months Data with Cards
final List<IslamicMonth> islamicMonths = [
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
    specialOccasionArabic: 'السنة الهجرية الجديدة، عاشوراء',
    gradient: [const Color(0xFF5C6BC0), const Color(0xFF7986CB)],
    cards: [
      GreetingCard(
        title: 'Islamic New Year',
        titleUrdu: 'اسلامی نیا سال مبارک',
        titleHindi: 'इस्लामी नया साल मुबारक',
        titleArabic: 'سنة هجرية سعيدة',
        message:
            'May this new Islamic year bring you closer to Allah and fill your life with His blessings. Happy Islamic New Year!',
        messageUrdu:
            'یہ نیا اسلامی سال آپ کو اللہ کے قریب لائے اور آپ کی زندگی اس کی برکتوں سے بھر دے۔ اسلامی نیا سال مبارک!',
        messageHindi:
            'यह नया इस्लामी साल आपको अल्लाह के करीब लाए और आपकी जिंदगी को उनकी बरकतों से भर दे। इस्लामी नया साल मुबारक!',
        messageArabic:
            'نسأل الله أن تقربك هذه السنة الهجرية الجديدة إلى الله وتملأ حياتك ببركاته. كل عام وأنتم بخير!',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Muharram Mubarak',
        titleUrdu: 'محرم مبارک',
        titleHindi: 'मुहर्रम मुबारक',
        titleArabic: 'محرم مبارك',
        message:
            'As the new Islamic year begins, may Allah guide you towards the right path and shower His blessings upon you.',
        messageUrdu:
            'جیسے ہی نیا اسلامی سال شروع ہو، اللہ آپ کو صراط مستقیم کی طرف رہنمائی فرمائے اور اپنی رحمتیں نازل فرمائے۔',
        messageHindi:
            'जैसे ही नया इस्लामी साल शुरू हो, अल्लाह आपको सही राह की ओर मार्गदर्शन करें और अपनी रहमतें नाज़िल फरमाएं।',
        messageArabic:
            'مع بداية السنة الهجرية الجديدة، نسأل الله أن يهديك إلى الصراط المستقيم ويغدق عليك بركاته.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Day of Ashura',
        titleUrdu: 'یوم عاشورہ',
        titleHindi: 'आशूरा का दिन',
        titleArabic: 'يوم عاشوراء',
        message:
            'On this blessed day of Ashura, may Allah accept our fasting and forgive our sins. May peace be upon the Ummah.',
        messageUrdu:
            'عاشورہ کے اس مبارک دن پر، اللہ ہمارے روزے قبول فرمائے اور ہمارے گناہ معاف فرمائے۔ امت پر سلامتی ہو۔',
        messageHindi:
            'आशूरा के इस मुबारक दिन पर, अल्लाह हमारे रोज़े कबूल फरमाए और हमारे गुनाह माफ करे। उम्मत पर सलामती हो।',
        messageArabic:
            'في هذا اليوم المبارك من عاشوراء، نسأل الله أن يتقبل صيامنا ويغفر ذنوبنا. السلام على الأمة.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'New Year Blessings',
        titleUrdu: 'نئے سال کی مبارکباد',
        titleHindi: 'नए साल की मुबारकबाद',
        titleArabic: 'بركات السنة الجديدة',
        message:
            'May the new Hijri year bring peace, prosperity, and spiritual growth. Wishing you a blessed year ahead!',
        messageUrdu:
            'نیا ہجری سال امن، خوشحالی اور روحانی ترقی لائے۔ آپ کو آنے والے سال کی مبارکباد!',
        messageHindi:
            'नया हिजरी साल शांति, खुशहाली और आध्यात्मिक तरक्की लाए। आने वाले साल की मुबारकबाद!',
        messageArabic:
            'نسأل الله أن تجلب السنة الهجرية الجديدة السلام والازدهار والنمو الروحي. نتمنى لكم عاماً مباركاً قادماً!',
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
        titleArabic: 'بركات شهر صفر',
        message:
            'May Allah protect you and your family throughout this month and always. Trust in Allah\'s plan.',
        messageUrdu:
            'اللہ اس مہینے اور ہمیشہ آپ کی اور آپ کے خاندان کی حفاظت فرمائے۔ اللہ کی منصوبہ بندی پر بھروسہ رکھیں۔',
        messageHindi:
            'अल्लाह इस महीने और हमेशा आपकी और आपके परिवार की हिफाज़त फरमाए। अल्लाह की योजना पर भरोसा रखें।',
        messageArabic:
            'نسأل الله أن يحميك ويحمي عائلتك طوال هذا الشهر ودائماً. توكل على تدبير الله.',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Prayer for Safety',
        titleUrdu: 'سلامتی کی دعا',
        titleHindi: 'सलामती की दुआ',
        titleArabic: 'دعاء السلامة',
        message:
            'O Allah, protect us from all harm and guide us to the straight path. May this month bring peace and safety.',
        messageUrdu:
            'اے اللہ، ہمیں ہر نقصان سے بچا اور ہمیں صراط مستقیم کی طرف رہنمائی فرما۔ یہ مہینہ امن اور سلامتی لائے۔',
        messageHindi:
            'ऐ अल्लाह, हमें हर नुकसान से बचा और हमें सीधे रास्ते की ओर मार्गदर्शन कर। यह महीना शांति और सलामती लाए।',
        messageArabic:
            'اللهم احفظنا من كل سوء واهدنا إلى الصراط المستقيم. نسأل الله أن يجلب هذا الشهر السلام والأمان.',
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
    specialOccasionArabic: 'مولد النبي محمد ﷺ',
    gradient: [const Color(0xFF66BB6A), const Color(0xFF81C784)],
    cards: [
      GreetingCard(
        title: 'Eid Milad-un-Nabi',
        titleUrdu: 'عید میلاد النبی',
        titleHindi: 'ईद मीलाद-उन-नबी',
        titleArabic: 'عيد المولد النبوي',
        message:
            'On this blessed occasion of the Prophet\'s birth, may we be inspired to follow his teachings of peace, love, and compassion.',
        messageUrdu:
            'نبی کریم ﷺ کی ولادت کے اس مبارک موقع پر، ہم ان کی امن، محبت اور رحمت کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'नबी करीम ﷺ की विलादत के इस मुबारक मौके पर, हम उनकी अमन, मोहब्बत और रहमत की तालीमात पर अमल करें।',
        messageArabic:
            'في هذه المناسبة المباركة لمولد النبي، نسأل الله أن نُلهم لاتباع تعاليمه في السلام والمحبة والرحمة.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Prophet\'s Birthday',
        titleUrdu: 'یوم ولادت نبی',
        titleHindi: 'नबी का जन्मदिन',
        titleArabic: 'يوم ميلاد النبي',
        message:
            'Peace and blessings upon the Prophet Muhammad ﷺ. May his life continue to be a guiding light for all humanity.',
        messageUrdu:
            'نبی کریم ﷺ پر درود و سلام۔ ان کی زندگی ہمیشہ پوری انسانیت کے لیے رہنما روشنی بنی رہے۔',
        messageHindi:
            'नबी करीम ﷺ पर दरूद व सलाम। उनकी ज़िंदगी हमेशा पूरी इंसानियत के लिए मार्गदर्शक रोशनी बनी रहे।',
        messageArabic:
            'الصلاة والسلام على النبي محمد ﷺ. نسأل الله أن تستمر حياته نوراً هادياً للبشرية جمعاء.',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Rabi al-Awwal Mubarak',
        titleUrdu: 'ربیع الاول مبارک',
        titleHindi: 'रबीउल अव्वल मुबारक',
        titleArabic: 'ربيع الأول مبارك',
        message:
            'In this blessed month, let us remember the beautiful example of our beloved Prophet ﷺ and strive to embody his teachings.',
        messageUrdu:
            'اس مبارک مہینے میں، آئیے ہم اپنے پیارے نبی ﷺ کی خوبصورت مثال یاد کریں اور ان کی تعلیمات پر عمل کریں۔',
        messageHindi:
            'इस मुबारक महीने में, आइए हम अपने प्यारे नबी ﷺ की खूबसूरत मिसाल याद करें और उनकी तालीमात पर अमल करें।',
        messageArabic:
            'في هذا الشهر المبارك، لنتذكر المثال الجميل لنبينا الحبيب ﷺ ونسعى لتجسيد تعاليمه.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Seerah Reminder',
        titleUrdu: 'سیرت کی یاد',
        titleHindi: 'सीरत की याद',
        titleArabic: 'تذكير بالسيرة',
        message:
            'The Prophet ﷺ said: "None of you truly believes until I am more beloved to him than his father, his child, and all of mankind."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "تم میں سے کوئی اس وقت تک مومن نہیں ہوتا جب تک میں اسے اس کے والد، اولاد اور تمام لوگوں سے زیادہ محبوب نہ ہوں۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "तुम में से कोई उस वक्त तक मोमिन नहीं होता जब तक मैं उसे उसके वालिद, औलाद और तमाम लोगों से ज़्यादा महबूब न होऊं।"',
        messageArabic:
            'قال النبي ﷺ: "لا يؤمن أحدكم حتى أكون أحب إليه من والده وولده والناس أجمعين."',
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
        titleArabic: 'شهر البركات',
        message:
            'May this month bring you peace, happiness, and countless blessings from Allah SWT.',
        messageUrdu:
            'یہ مہینہ آپ کو اللہ تعالیٰ کی طرف سے امن، خوشی او�� بے شمار برکتیں لائے۔',
        messageHindi:
            'यह महीना आपको अल्लाह तआला की तरफ से अमन, खुशी और बेशुमार बरकतें लाए।',
        messageArabic:
            'نسأل الله أن يجلب لك هذا الشهر السلام والسعادة والبركات الوفيرة من الله سبحانه وتعالى.',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Dua for You',
        titleUrdu: 'آپ کے لیے دعا',
        titleHindi: 'आपके लिए दुआ',
        titleArabic: 'دعاء لك',
        message:
            'May Allah fill your life with joy, protect you from harm, and grant you success in this life and the hereafter.',
        messageUrdu:
            'اللہ آپ کی زندگی خوشیوں سے بھر دے، آپ کو نقصان سے بچائے، اور دنیا و آخرت میں کامیابی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपकी ज़िंदगी खुशियों से भर दे, आपको नुकसान से बचाए, और दुनिया व आखिरत में कामयाबी अता फरमाए।',
        messageArabic:
            'نسأل الله أن يملأ حياتك بالفرح ويحميك من الأذى ويمنحك النجاح في الدنيا والآخرة.',
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
        titleArabic: 'البركات الشهرية',
        message:
            'May Allah bless you with good health, prosperity, and spiritual growth this month.',
        messageUrdu:
            'اللہ آپ کو اس مہینے اچھی صحت، خوشحالی اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'अल्लाह आपको इस महीने अच्छी सेहत, खुशहाली और रूहानी तरक्की अता फरमाए।',
        messageArabic:
            'نسأل الله أن يرزقك هذا الشهر الصحة الجيدة والازدهار والنمو الروحي.',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Peace and Blessings',
        titleUrdu: 'امن اور برکات',
        titleHindi: 'अमन और बरकात',
        titleArabic: 'السلام والبركات',
        message:
            'Wishing you a month filled with peace, love, and the mercy of Allah SWT.',
        messageUrdu:
            'آپ کو امن، محبت اور اللہ تعالیٰ کی رحمت سے بھرا مہینہ مبارک ہو۔',
        messageHindi:
            'आपको अमन, मोहब्बत और अल्लाह तआला की रहमत से भरा महीना मुबारक हो।',
        messageArabic:
            'نتمنى لك شهراً مليئاً بالسلام والمحبة ورحمة الله سبحانه وتعالى.',
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
        titleArabic: 'شهر مبارك',
        message:
            'May this month be filled with blessings, forgiveness, and spiritual enlightenment.',
        messageUrdu: 'یہ مہینہ برکتوں، مغفرت اور روحانی روشنی سے بھرا ہو۔',
        messageHindi: 'यह महीना बरकतों, माफी और रूहानी रोशनी से भरा हो।',
        messageArabic:
            'نسأل الله أن يكون هذا الشهر مليئاً بالبركات والمغفرة والاستنارة الروحية.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Prayer for Guidance',
        titleUrdu: 'ہدایت کی دعا',
        titleHindi: 'हिदायत की दुआ',
        titleArabic: 'دعاء للهداية',
        message:
            'O Allah, guide us to what is good, protect us from evil, and keep us on the straight path.',
        messageUrdu:
            'اے اللہ، ہمیں نیکی کی طرف رہنمائی فرما، برائی سے بچا، اور صراط مستقیم پر رکھ۔',
        messageHindi:
            'ऐ अल्लाह, हमें नेकी की तरफ मार्गदर्शन कर, बुराई से बचा, और सीधे रास्ते पर रख।',
        messageArabic:
            'اللهم اهدنا إلى ما هو خير واحمنا من الشر وأبقنا على الصراط المستقيم.',
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
    specialOccasionArabic: 'الإسراء والمعراج',
    gradient: [const Color(0xFF7C4DFF), const Color(0xFFB388FF)],
    cards: [
      GreetingCard(
        title: 'Rajab Mubarak',
        titleUrdu: 'رجب مبارک',
        titleHindi: 'रजब मुबारक',
        titleArabic: 'رجب مبارك',
        message:
            'Welcome to the sacred month of Rajab. May Allah bless you and prepare your heart for the upcoming Ramadan.',
        messageUrdu:
            'رجب کے مقدس مہینے میں خوش آمدید۔ اللہ آپ کو برکت دے اور آپ کا دل آنے والے رمضان کے لیے تیار فرمائے۔',
        messageHindi:
            'रजब के मुकद्दस महीने में खुश आमदीद। अल्लाह आपको बरकत दे और आपका दिल आने वाले रमज़ान के लिए तैयार फरमाए।',
        messageArabic:
            'مرحباً بك في شهر رجب المقدس. نسأل الله أن يباركك ويعد قلبك لشهر رمضان القادم.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Isra and Mi\'raj',
        titleUrdu: 'اسراء و معراج',
        titleHindi: 'इसरा और मेराज',
        titleArabic: 'الإسراء والمعراج',
        message:
            'On this blessed night, the Prophet ﷺ was taken on a miraculous journey. May we be inspired by this divine event.',
        messageUrdu:
            'اس مبارک رات نبی کریم ﷺ کو معجزاتی سفر پر لے جایا گیا۔ ہم اس الہی واقعے سے متاثر ہوں۔',
        messageHindi:
            'इस मुबारक रात नबी करीम ﷺ को मोजिज़ाती सफर पर ले जाया गया। हम इस इलाही वाक़िए से प्रेरित हों।',
        messageArabic:
            'في هذه الليلة المباركة، أُسري بالنبي ﷺ في رحلة معجزة. نسأل الله أن نُلهم بهذا الحدث الإلهي.',
        icon: Icons.flight,
      ),
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        titleArabic: 'شهر مقدس',
        message:
            'Rajab is one of the sacred months. Increase your worship and good deeds. May Allah accept from us.',
        messageUrdu:
            'رجب حرمت والے مہینوں میں سے ایک ہے۔ عبادت اور نیک اعمال بڑھائیں۔ اللہ ہم سے قبول فرمائے۔',
        messageHindi:
            'रजब हुरमत वाले महीनों में से एक है। इबादत और नेक आमाल बढ़ाएं। अल्लाह हम से कबूल फरमाए।',
        messageArabic:
            'رجب من الأشهر الحرم. أكثروا من العبادة والأعمال الصالحة. نسأل الله أن يتقبل منا.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Preparation for Ramadan',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        titleArabic: 'التحضير لرمضان',
        message:
            'As Rajab arrives, let us begin preparing our hearts for the blessed month of Ramadan.',
        messageUrdu:
            'جیسے ہی رجب آئے، آئیے ہم اپنے دلوں کو رمضان المبارک کے لیے تیار کریں۔',
        messageHindi:
            'जैसे ही रजब आए, आइए हम अपने दिलों को रमज़ान उल-मुबारक के लिए तैयार करें।',
        messageArabic: 'مع قدوم رجب، لنبدأ في إعداد قلوبنا لشهر رمضان المبارك.',
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
    specialOccasionArabic: 'ليلة البراءة',
    gradient: [const Color(0xFF4DB6AC), const Color(0xFF80CBC4)],
    cards: [
      GreetingCard(
        title: 'Sha\'ban Mubarak',
        titleUrdu: 'شعبان مبارک',
        titleHindi: 'शाबान मुबारक',
        titleArabic: 'شعبان مبارك',
        message:
            'May this blessed month prepare you spiritually for Ramadan. Increase your fasting and prayers.',
        messageUrdu:
            'یہ مبارک مہینہ آپ کو روحانی طور پر رمضان کے لیے تیار کرے۔ روزے اور نماز بڑھائیں۔',
        messageHindi:
            'यह मुबारक महीना आपको रूहानी तौर पर रमज़ान के लिए तैयार करे। रोज़े और नमाज़ बढ़ाएं।',
        messageArabic:
            'نسأل الله أن يعدك هذا الشهر المبارك روحياً لشهر رمضان. أكثر من الصيام والصلاة.',
        icon: Icons.spa,
      ),
      GreetingCard(
        title: 'Shab-e-Barat',
        titleUrdu: 'شب برات مبارک',
        titleHindi: 'शब-ए-बारात मुबारक',
        titleArabic: 'شب برات مبارك',
        message:
            'On this night of forgiveness, may Allah forgive our sins and write our destiny with goodness.',
        messageUrdu:
            'مغفرت کی اس رات، اللہ ہمارے گناہ معاف فرمائے اور ہماری تقدیر بھلائی سے لکھے۔',
        messageHindi:
            'माफी की इस रात, अल्लाह हमारे गुनाह माफ फरमाए और हमारी तकदीर भलाई से लिखे।',
        messageArabic:
            'في ليلة المغفرة هذه، نسأل الله أن يغفر ذنوبنا ويكتب قدرنا بالخير.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Night of Records',
        titleUrdu: 'تقدیر کی رات',
        titleHindi: 'तक़दीर की रात',
        titleArabic: 'ليلة القدر',
        message:
            'May Allah write for you a year full of blessings, health, and success. Seek forgiveness on this blessed night.',
        messageUrdu:
            'اللہ آپ کے لیے برکتوں، صحت اور کامیابی سے بھرا سال لکھے۔ اس مبارک رات مغفرت مانگیں۔',
        messageHindi:
            'अल्लाह आपके लिए बरकतों, सेहत और कामयाबी से भरा साल लिखे। इस मुबारक रात माफी मांगें।',
        messageArabic:
            'نسأل الله أن يكتب لك عاماً مليئاً بالبركات والصحة والنجاح. اطلب المغفرة في هذه الليلة المباركة.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Ramadan Preparation',
        titleUrdu: 'رمضان کی تیاری',
        titleHindi: 'रमज़ान की तैयारी',
        titleArabic: 'التحضير لرمضان',
        message:
            'The Prophet ﷺ used to fast more in Sha\'ban. Let us follow his sunnah and prepare for Ramadan.',
        messageUrdu:
            'نبی کریم ﷺ شعبان میں زیادہ روزے رکھتے تھے۔ آئیے ان کی سنت پر عمل کریں اور رمضان کی تیاری کریں۔',
        messageHindi:
            'नबी करीम ﷺ शाबान में ज़्यादा रोज़े रखते थे। आइए उनकी सुन्नत पर अमल करें और रमज़ान की तैयारी करें।',
        messageArabic:
            'كان النبي ﷺ يكثر من الصيام في شعبان. لنتبع سنته ونستعد لرمضان.',
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
    specialOccasionArabic: 'شهر الصيام، ليلة القدر',
    gradient: [const Color(0xFFBA68C8), const Color(0xFFCE93D8)],
    cards: [
      GreetingCard(
        title: 'Ramadan Mubarak',
        titleUrdu: 'رمضان مبارک',
        titleHindi: 'रमज़ान मुबारक',
        titleArabic: 'رمضان مبارك',
        message:
            'May this Ramadan bring you peace, prosperity, and happiness. May Allah accept your prayers and fasts.',
        messageUrdu:
            'یہ رمضان آپ کو امن، خوشحالی اور خوشی لائے۔ اللہ آپ کی نمازیں اور روزے قبول فرمائے۔',
        messageHindi:
            'यह रमज़ान आपको अमन, खुशहाली और खुशी लाए। अल्लाह आपकी नमाज़ें और रोज़े कबूल फरमाए।',
        messageArabic:
            'نسأل الله أن يجلب لك هذا الشهر الكريم السلام والازدهار والسعادة. نسأل الله أن يتقبل صلواتك وصيامك.',
        icon: Icons.nights_stay,
      ),
      GreetingCard(
        title: 'Ramadan Kareem',
        titleUrdu: 'رمضان کریم',
        titleHindi: 'रमज़ान करीम',
        titleArabic: 'رمضان كريم',
        message:
            'May the holy month of Ramadan light up your heart and home. Wishing you a blessed Ramadan!',
        messageUrdu:
            'رمضان کا مقدس مہینہ آپ کے دل اور گھر کو روشن کرے۔ آپ کو مبارک رمضان کی دعا!',
        messageHindi:
            'रमज़ान का मुकद्दस महीना आपके दिल और घर को रोशन करे। आपको मुबारक रमज़ान की दुआ!',
        messageArabic:
            'نسأل الله أن ينير شهر رمضان المقدس قلبك وبيتك. نتمنى لك رمضان مباركاً!',
        icon: Icons.wb_sunny,
      ),
      GreetingCard(
        title: 'Blessed Month',
        titleUrdu: 'مبارک مہینہ',
        titleHindi: 'मुबारक महीना',
        titleArabic: 'شهر مبارك',
        message:
            'As the crescent moon is sighted, may Allah bless you with happiness and grace your home with peace.',
        messageUrdu:
            'جیسے ہی چاند نظر آئے، اللہ آپ کو خوشی سے نوازے اور آپ کے گھر کو امن سے مالا مال کرے۔',
        messageHindi:
            'जैसे ही चाँद नज़र आए, अल्लाह आपको खुशी से नवाज़े और आपके घर को अमन से माला माल करे।',
        messageArabic:
            'نسأل الله أن يكون هذا الشهر مليئاً بالبركات والمغفرة والاستنارة الروحية.',
        icon: Icons.auto_awesome,
      ),
      GreetingCard(
        title: 'Laylatul Qadr',
        titleUrdu: 'لیلۃ القدر',
        titleHindi: 'लैलतुल क़द्र',
        titleArabic: 'ليلة القدر',
        message:
            'Seek Laylatul Qadr in the last ten nights. It is better than a thousand months. May Allah grant us its blessings.',
        messageUrdu:
            'آخری دس راتوں میں لیلۃ القدر تلاش کریں۔ یہ ہزار مہینوں سے بہتر ہے۔ اللہ ہمیں اس کی برکتیں عطا فرمائے۔',
        messageHindi:
            'आखिरी दस रातों में लैलतुल क़द्र तलाश करें। यह हज़ार महीनों से बेहतर है। अल्लाह हमें इसकी बरकतें अता फरमाए।',
        messageArabic:
            'اطلبوا ليلة القدر في العشر الأواخر. إنها خير من ألف شهر. نسأل الله أن يرزقنا بركاتها.',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Iftar Blessings',
        titleUrdu: 'افطار مبارک',
        titleHindi: 'इफ्तार मुबारक',
        titleArabic: 'بركات الإفطار',
        message:
            'May every iftar be a source of blessings and every suhoor give you strength. Ramadan Mubarak!',
        messageUrdu:
            'ہر افطار برکت کا ذریعہ ہو اور ہر سحری آپ کو طاقت دے۔ رمضان مبارک!',
        messageHindi:
            'हर इफ्तार बरकत का ज़रिया हो और हर सहरी आपको ताकत दे। रमज़ान मुबारक!',
        messageArabic:
            'نسأل الله أن يكون كل إفطار مصدر بركة وكل سحور يمنحك القوة. رمضان مبارك!',
        icon: Icons.restaurant,
      ),
      GreetingCard(
        title: 'Taraweeh Greetings',
        titleUrdu: 'تراویح مبارک',
        titleHindi: 'तरावीह मुबारक',
        titleArabic: 'تحية التراويح',
        message:
            'May your Taraweeh prayers be accepted and your recitation of Quran bring light to your heart.',
        messageUrdu:
            'آپ کی تراویح قبول ہوں اور قرآن کی تلاوت آپ کے دل کو روشن کرے۔',
        messageHindi:
            'आपकी तरावीह कबूल हों और कुरआन की तिलावत आपके दिल को रोशन करे।',
        messageArabic:
            'نسأل الله أن تُقبل صلاة التراويح وأن يجلب تلاوة القرآن النور لقلبك.',
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
    specialOccasionArabic: 'عيد الفطر',
    gradient: [const Color(0xFFFFB74D), const Color(0xFFFFE082)],
    cards: [
      GreetingCard(
        title: 'Eid Mubarak',
        titleUrdu: 'عید مبارک',
        titleHindi: 'ईद मुबारक',
        titleArabic: 'عيد مبارك',
        message:
            'May Allah accept your good deeds, forgive your transgressions and ease the suffering of all peoples. Eid Mubarak!',
        messageUrdu:
            'اللہ آپ کے نیک اعمال قبول فرمائے، گناہ معاف فرمائے اور سب کی تکالیف دور کرے۔ عید مبارک!',
        messageHindi:
            'अल्लाह आपके नेक आमाल कबूल फरमाए, गुनाह माफ करे और सबकी तकलीफें दूर करे। ईद मुबारक!',
        messageArabic:
            'نسأل الله أن يتقبل أعمالك الصالحة ويغفر ذنوبك ويخفف معاناة جميع الناس. عيد مبارك!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Eid',
        titleUrdu: 'مبارک عید',
        titleHindi: 'मुबारक ईद',
        titleArabic: 'عيد مبارك',
        message:
            'On this blessed day of Eid, may your heart be filled with joy and your home with happiness. Eid Mubarak!',
        messageUrdu:
            'عید کے اس مبارک دن، آپ کا دل خوشی سے بھرا ہو اور آپ کا گھر خوشیوں سے۔ عید مبارک!',
        messageHindi:
            'ईद के इस मुबारक दिन, आपका दिल खुशी से भरा हो और आपका घर खुशियों से। ईद मुबारक!',
        messageArabic:
            'في هذا اليوم المبارك من العيد، نسأل الله أن يملأ قلبك بالفرح وبيتك بالسعادة. عيد مبارك!',
        icon: Icons.star,
      ),
      GreetingCard(
        title: 'Eid Greetings',
        titleUrdu: 'عید کی مبارکباد',
        titleHindi: 'ईद की मुबारकबाद',
        titleArabic: 'تحية العيد',
        message:
            'May the magic of this Eid bring lots of happiness in your life. Celebrate it with all your loved ones!',
        messageUrdu:
            'اس عید کا جادو آپ کی زندگی میں بہت ساری خوشیاں لائے۔ اپنے پیاروں کے ساتھ منائیں!',
        messageHindi:
            'इस ईद का जादू आपकी ज़िंदगी में बहुत सारी खुशियां लाए। अपने प्यारों के साथ मनाएं!',
        messageArabic:
            'نسأل الله أن يجلب لك سحر هذا العيد الكثير من السعادة في حياتك. احتفل به مع جميع أحبائك!',
        icon: Icons.card_giftcard,
      ),
      GreetingCard(
        title: 'Eid ul-Fitr',
        titleUrdu: 'عید الفطر مبارک',
        titleHindi: 'ईद-उल-फ़ित्र मुबारक',
        titleArabic: 'عيد الفطر مبارك',
        message:
            'After a month of fasting and prayers, may this Eid bring you endless blessings. Taqabbal Allahu minna wa minkum!',
        messageUrdu:
            'روزوں اور نمازوں کے مہینے کے بعد، یہ عید آپ کو بے شمار برکتیں لائے۔ تقبل اللہ منا و منکم!',
        messageHindi:
            'रोज़ों और नमाज़ों के महीने के बाद, यह ईद आपको बेशुमार बरकतें लाए। तक़ब्बल अल्लाहु मिन्ना व मिनकुम!',
        messageArabic:
            'بعد شهر من الصيام والصلاة، نسأل الله أن يجلب لك هذا العيد بركات لا نهاية لها. تقبل الله منا ومنكم!',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'Six Fasts of Shawwal',
        titleUrdu: 'شوال کے چھ روزے',
        titleHindi: 'शव्वाल के छह रोज़े',
        titleArabic: 'صيام الست من شوال',
        message:
            'The Prophet ﷺ said: "Whoever fasts Ramadan and follows it with six days of Shawwal, it is as if he fasted the entire year."',
        messageUrdu:
            'نبی کریم ﷺ نے فرمایا: "جس نے رمضان کے روزے رکھے اور شوال کے چھ روزے رکھے، گویا اس نے سال بھر روزے رکھے۔"',
        messageHindi:
            'नबी करीम ﷺ ने फरमाया: "जिसने रमज़ान के रोज़े रखे और शव्वाल के छह रोज़े रखे, गोया उसने साल भर रोज़े रखे।"',
        messageArabic:
            'قال النبي ﷺ: "من صام رمضان ثم أتبعه ستاً من شوال، كان كصيام الدهر."',
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
    specialOccasionArabic: 'شهر حرام',
    gradient: [const Color(0xFF78909C), const Color(0xFFB0BEC5)],
    cards: [
      GreetingCard(
        title: 'Sacred Month',
        titleUrdu: 'مقدس مہینہ',
        titleHindi: 'मुकद्दस महीना',
        titleArabic: 'شهر مقدس',
        message:
            'Dhul Qa\'dah is one of the sacred months. May Allah bless you with peace and spiritual growth.',
        messageUrdu:
            'ذوالقعدہ حرمت والے مہینوں میں سے ایک ہے۔ اللہ آپ کو امن اور روحانی ترقی عطا فرمائے۔',
        messageHindi:
            'ज़ुल-क़ादा हुरमत वाले महीनों में से एक है। अल्लाह आपको अमन और रूहानी तरक्की अता फरमाए।',
        messageArabic:
            'رجب من الأشهر الحرم. أكثروا من العبادة والأعمال الصالحة. نسأل الله أن يتقبل منا.',
        icon: Icons.shield,
      ),
      GreetingCard(
        title: 'Hajj Preparation',
        titleUrdu: 'حج کی تیاری',
        titleHindi: 'हज की तैयारी',
        titleArabic: 'التحضير للحج',
        message:
            'For those preparing for Hajj, may Allah accept your pilgrimage and grant you a journey of a lifetime.',
        messageUrdu:
            'حج کی تیاری کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور زندگی کا بہترین سفر عطا فرمائے۔',
        messageHindi:
            'हज की तैयारी करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और ज़िंदगी का बेहतरीन सफर अता फरमाए।',
        messageArabic:
            'للذين يستعدون للحج، نسأل الله أن يتقبل حجكم ويمنحكم رحلة العمر.',
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
    specialOccasionArabic: 'الحج، عيد الأضحى، يوم عرفة',
    gradient: [const Color(0xFFFF8A65), const Color(0xFFFFAB91)],
    cards: [
      GreetingCard(
        title: 'Eid ul-Adha Mubarak',
        titleUrdu: 'عید الاضحی مبارک',
        titleHindi: 'ईद-उल-अज़हा मुबारक',
        titleArabic: 'عيد الأضحى مبارك',
        message:
            'May Allah flood your life with happiness on this occasion. Wishing you a very happy Eid ul-Adha!',
        messageUrdu:
            'اس موقع پر اللہ آپ کی زندگی خوشیوں سے بھر دے۔ آپ کو عید الاضحی بہت مبارک!',
        messageHindi:
            'इस मौके पर अल्लाह आपकी ज़िंदगी खुशियों से भर दे। आपको ईद-उल-अज़हा बहुत मुबारक!',
        messageArabic:
            'نسأل الله أن يغمر حياتك بالسعادة في هذه المناسبة. نتمنى لك عيد أضحى سعيد جداً!',
        icon: Icons.celebration,
      ),
      GreetingCard(
        title: 'Blessed Sacrifice',
        titleUrdu: 'مبارک قربانی',
        titleHindi: 'मुबारक कुर्बानी',
        titleArabic: 'قربان مبارك',
        message:
            'On this Eid ul-Adha, may your sacrifices be appreciated and your prayers be answered. Eid Mubarak!',
        messageUrdu:
            'اس عید الاضحی پر، آپ کی قربانیاں قبول ہوں اور دعائیں مقبول ہوں۔ عید مبارک!',
        messageHindi:
            'इस ईद-उल-अज़हा पर, आपकी कुर्बानियां कबूल हों और दुआएं मकबूल हों। ईद मुबारक!',
        messageArabic:
            'في هذا العيد الأضحى، نسأل الله أن تُقدر تضحياتك وتُجاب صلواتك. عيد مبارك!',
        icon: Icons.favorite,
      ),
      GreetingCard(
        title: 'Day of Arafah',
        titleUrdu: 'یوم عرفہ',
        titleHindi: 'यौम-ए-अरफा',
        titleArabic: 'يوم عرفة',
        message:
            'The best dua is the dua on the Day of Arafah. May Allah accept all your prayers on this blessed day.',
        messageUrdu:
            'سب سے بہترین دعا یوم عرفہ کی دعا ہے۔ اللہ اس مبارک دن آپ کی تمام دعائیں قبول فرمائے۔',
        messageHindi:
            'सबसे बेहतरीन दुआ यौम-ए-अरफा की दुआ है। अल्लाह इस मुबारक दिन आपकी तमाम दुआएं कबूल फरमाए।',
        messageArabic:
            'أفضل الدعاء دعاء يوم عرفة. نسأل الله أن يستجيب جميع دعواتك في هذا اليوم المبارك.',
        icon: Icons.terrain,
      ),
      GreetingCard(
        title: 'Hajj Mubarak',
        titleUrdu: 'حج مبارک',
        titleHindi: 'हज मुबारक',
        titleArabic: 'حج مبارك',
        message:
            'For those performing Hajj, may Allah accept your pilgrimage and grant you Hajj Mabroor.',
        messageUrdu:
            'حج کرنے والوں کے لیے، اللہ آپ کا حج قبول فرمائے اور حج مبرور عطا فرمائے۔',
        messageHindi:
            'हज करने वालों के लिए, अल्लाह आपका हज कबूल फरमाए और हज मबरूर अता फरमाए।',
        messageArabic:
            'للذين يؤدون فريضة الحج، نسأل الله أن يتقبل حجكم ويمنحكم حجاً مبروراً.',
        icon: Icons.mosque,
      ),
      GreetingCard(
        title: 'First Ten Days',
        titleUrdu: 'پہلے دس دن',
        titleHindi: 'पहले दस दिन',
        titleArabic: 'الأيام العشر الأولى',
        message:
            'The first ten days of Dhul Hijjah are the best days of the year. Increase your good deeds and worship.',
        messageUrdu:
            'ذوالحجہ کے پہلے دس دن سال کے بہترین دن ہیں۔ نیک اعمال اور عبادت بڑھائیں۔',
        messageHindi:
            'ज़ुल-हिज्जा के पहले दस दिन साल के बेहतरीन दिन हैं। नेक आमाल और इबादत बढ़ाएं।',
        messageArabic:
            'الأيام العشر الأولى من ذي الحجة هي أفضل أيام السنة. أكثروا من الأعمال الصالحة والعبادة.',
        icon: Icons.calendar_today,
      ),
      GreetingCard(
        title: 'Qurbani Blessings',
        titleUrdu: 'قربانی مبارک',
        titleHindi: 'कुर्बानी मुबारक',
        titleArabic: 'بركات القربان',
        message:
            'May your Qurbani be accepted and may Allah reward you for your sacrifice. Eid ul-Adha Mubarak!',
        messageUrdu:
            'آپ کی قربانی قبول ہو اور اللہ آپ کو اجر عطا فرمائے۔ عید الاضحی مبارک!',
        messageHindi:
            'आपकी कुर्बानी कबूल हो और अल्लाह आपको अज्र अता फरमाए। ईद-उल-अज़हा मुबारक!',
        messageArabic:
            'نسأل الله أن يُقبل قربانك ويجزيك على تضحيتك. عيد الأضحى مبارك!',
        icon: Icons.card_giftcard,
      ),
    ],
  ),
];
