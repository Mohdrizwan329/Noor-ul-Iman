import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../core/services/location_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('profile'),
          style: TextStyle(fontSize: responsive.textLarge),
        ),
      ),
      body: Consumer2<SettingsProvider, LanguageProvider>(
        builder: (context, settings, languageProvider, child) {
          return ListView(
            padding: responsive.paddingRegular,
            children: [
              // Profile Card
              _buildProfileCard(context, responsive: responsive),
              SizedBox(height: responsive.spaceLarge),

              // Prayer Settings Section
              _buildSectionHeader(context, context.tr('prayer_times'), responsive: responsive),
              _buildSettingCard(
                context,
                responsive: responsive,
                icon: Icons.notifications,
                title: context.tr('prayer_notifications'),
                subtitle: settings.notificationsEnabled
                    ? context.tr('enabled')
                    : context.tr('disabled'),
                trailing: Switch(
                  value: settings.notificationsEnabled,
                  onChanged: (value) => settings.setNotificationsEnabled(value),
                  activeTrackColor: AppColors.primary,
                ),
              ),
              SizedBox(height: responsive.spaceLarge),

              // Language Section
              _buildSectionHeader(context, context.tr('language'), responsive: responsive),
              _buildSettingCard(
                context,
                responsive: responsive,
                icon: Icons.language,
                title: context.tr('change_language'),
                subtitle: context.tr('select_your_language'),
                onTap: () => _showLanguageDialog(context),
              ),
              SizedBox(height: responsive.spaceLarge),

              // About Section
              _buildSectionHeader(context, context.tr('about'), responsive: responsive),
              _buildSettingCard(
                context,
                responsive: responsive,
                icon: Icons.privacy_tip,
                title: context.tr('privacy_policy'),
                subtitle: context.tr('read_privacy_policy'),
                onTap: () => _openPrivacyPolicy(),
              ),
              _buildSettingCard(
                context,
                responsive: responsive,
                icon: Icons.info,
                title: context.tr('about'),
                subtitle: '${context.tr('version')} 1.0.0',
                onTap: () => _showAboutDialog(context),
              ),
              SizedBox(height: responsive.spaceLarge),

              // Logout
              _buildLogoutCard(context, responsive: responsive),
              SizedBox(height: responsive.spaceXXLarge),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {required ResponsiveUtils responsive}) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spaceSmall),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: responsive.textLarge,
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper function to translate city names
  String _translateCityName(String city, BuildContext context) {
    final cityTranslations = {
      'Bengaluru': {
        'en': 'Bengaluru',
        'ur': 'بنگلور',
        'ar': 'بنغالور',
        'hi': 'बेंगलुरु',
      },
      'Mumbai': {
        'en': 'Mumbai',
        'ur': 'ممبئی',
        'ar': 'مومباي',
        'hi': 'मुंबई',
      },
      'Delhi': {
        'en': 'Delhi',
        'ur': 'دہلی',
        'ar': 'دلهي',
        'hi': 'दिल्ली',
      },
      'New Delhi': {
        'en': 'New Delhi',
        'ur': 'نئی دہلی',
        'ar': 'نيودلهي',
        'hi': 'नई दिल्ली',
      },
      'Kolkata': {
        'en': 'Kolkata',
        'ur': 'کولکاتا',
        'ar': 'كولكاتا',
        'hi': 'कोलकाता',
      },
      'Chennai': {
        'en': 'Chennai',
        'ur': 'چنئی',
        'ar': 'تشيناي',
        'hi': 'चेन्नई',
      },
      'Hyderabad': {
        'en': 'Hyderabad',
        'ur': 'حیدرآباد',
        'ar': 'حيدر أباد',
        'hi': 'हैदराबाद',
      },
      'Pune': {
        'en': 'Pune',
        'ur': 'پونے',
        'ar': 'بونا',
        'hi': 'पुणे',
      },
      'Ahmedabad': {
        'en': 'Ahmedabad',
        'ur': 'احمد آباد',
        'ar': 'أحمد آباد',
        'hi': 'अहमदाबाद',
      },
      'Jaipur': {
        'en': 'Jaipur',
        'ur': 'جے پور',
        'ar': 'جايبور',
        'hi': 'जयपुर',
      },
      'Lucknow': {
        'en': 'Lucknow',
        'ur': 'لکھنؤ',
        'ar': 'لكناو',
        'hi': 'लखनऊ',
      },
      'Karachi': {
        'en': 'Karachi',
        'ur': 'کراچی',
        'ar': 'كراتشي',
        'hi': 'कराची',
      },
      'Lahore': {
        'en': 'Lahore',
        'ur': 'لاہور',
        'ar': 'لاهور',
        'hi': 'लाहौर',
      },
      'Islamabad': {
        'en': 'Islamabad',
        'ur': 'اسلام آباد',
        'ar': 'إسلام آباد',
        'hi': 'इस्लामाबाद',
      },
      'Dhaka': {
        'en': 'Dhaka',
        'ur': 'ڈھاکہ',
        'ar': 'دكا',
        'hi': 'ढाका',
      },
      'Mecca': {
        'en': 'Mecca',
        'ur': 'مکہ',
        'ar': 'مكة',
        'hi': 'मक्का',
      },
      'Medina': {
        'en': 'Medina',
        'ur': 'مدینہ',
        'ar': 'المدينة',
        'hi': 'मदीना',
      },
      'Riyadh': {
        'en': 'Riyadh',
        'ur': 'ریاض',
        'ar': 'الرياض',
        'hi': 'रियाद',
      },
      'Dubai': {
        'en': 'Dubai',
        'ur': 'دبئی',
        'ar': 'دبي',
        'hi': 'दुबई',
      },
      'Abu Dhabi': {
        'en': 'Abu Dhabi',
        'ur': 'ابوظبی',
        'ar': 'أبو ظبي',
        'hi': 'अबू धाबी',
      },
    };

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.languageCode;

    if (cityTranslations.containsKey(city)) {
      return cityTranslations[city]![currentLanguage] ?? city;
    }

    return city;
  }

  // Helper function to translate country names
  String _translateCountryName(String country, BuildContext context) {
    final countryTranslations = {
      'India': {
        'en': 'India',
        'ur': 'بھارت',
        'ar': 'الهند',
        'hi': 'भारत',
      },
      'Pakistan': {
        'en': 'Pakistan',
        'ur': 'پاکستان',
        'ar': 'باكستان',
        'hi': 'पाकिस्तान',
      },
      'Bangladesh': {
        'en': 'Bangladesh',
        'ur': 'بنگلہ دیش',
        'ar': 'بنغلاديش',
        'hi': 'बांग्लादेश',
      },
      'Saudi Arabia': {
        'en': 'Saudi Arabia',
        'ur': 'سعودی عرب',
        'ar': 'المملكة العربية السعودية',
        'hi': 'सऊदी अरब',
      },
      'United Arab Emirates': {
        'en': 'United Arab Emirates',
        'ur': 'متحدہ عرب امارات',
        'ar': 'الإمارات العربية المتحدة',
        'hi': 'संयुक्त अरब अमीरात',
      },
    };

    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.languageCode;

    if (countryTranslations.containsKey(country)) {
      return countryTranslations[country]![currentLanguage] ?? country;
    }

    return country;
  }

  // Helper function to transliterate names to different scripts
  String _transliterateName(String name, BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.languageCode;

    // If English, return as is
    if (currentLanguage == 'en') {
      return name;
    }

    // Create transliteration map for common name components
    final transliterations = {
      'Mohd': {
        'ur': 'محمد',
        'ar': 'محمد',
        'hi': 'मोहम्मद',
      },
      'Mohammad': {
        'ur': 'محمد',
        'ar': 'محمد',
        'hi': 'मोहम्मद',
      },
      'Muhammad': {
        'ur': 'محمد',
        'ar': 'محمد',
        'hi': 'मुहम्मद',
      },
      'Ahmed': {
        'ur': 'احمد',
        'ar': 'أحمد',
        'hi': 'अहमद',
      },
      'Ali': {
        'ur': 'علی',
        'ar': 'علي',
        'hi': 'अली',
      },
      'Hassan': {
        'ur': 'حسن',
        'ar': 'حسن',
        'hi': 'हसन',
      },
      'Hussain': {
        'ur': 'حسین',
        'ar': 'حسين',
        'hi': 'हुसैन',
      },
      'Fatima': {
        'ur': 'فاطمہ',
        'ar': 'فاطمة',
        'hi': 'फातिमा',
      },
      'Ayesha': {
        'ur': 'عائشہ',
        'ar': 'عائشة',
        'hi': 'आयशा',
      },
      'Reyan': {
        'ur': 'ریان',
        'ar': 'ريان',
        'hi': 'रेयान',
      },
      'Rizwan': {
        'ur': 'رضوان',
        'ar': 'رضوان',
        'hi': 'रिज़वान',
      },
      'Khan': {
        'ur': 'خان',
        'ar': 'خان',
        'hi': 'खान',
      },
      'Sheikh': {
        'ur': 'شیخ',
        'ar': 'شيخ',
        'hi': 'शेख',
      },
    };

    // Split name into parts and transliterate each part
    List<String> nameParts = name.split(' ');
    List<String> transliteratedParts = [];

    for (String part in nameParts) {
      if (transliterations.containsKey(part)) {
        transliteratedParts.add(transliterations[part]![currentLanguage] ?? part);
      } else {
        // If no mapping found, keep the original
        transliteratedParts.add(part);
      }
    }

    return transliteratedParts.join(' ');
  }

  Widget _buildProfileCard(BuildContext context, {required ResponsiveUtils responsive}) {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final locationService = LocationService();

    // Build default location from LocationService if available
    String defaultLocation = '';
    if (locationService.currentCity != null && locationService.currentCity!.isNotEmpty) {
      final city = locationService.currentCity!;
      final translatedCity = _translateCityName(city, context);
      debugPrint('📍 Location Translation Debug:');
      debugPrint('  - Original city: $city');
      debugPrint('  - Translated city: $translatedCity');
      if (locationService.currentCountry != null && locationService.currentCountry!.isNotEmpty) {
        final country = locationService.currentCountry!;
        final translatedCountry = _translateCountryName(country, context);
        debugPrint('  - Original country: $country');
        debugPrint('  - Translated country: $translatedCountry');
        defaultLocation = '$translatedCity, $translatedCountry';
      } else {
        defaultLocation = translatedCity;
      }
      debugPrint('  - Final location: $defaultLocation');
    }

    // List of all translated default user names to detect
    final defaultUserNames = ['User', 'صارف', 'المستخدم', 'उपयोगकर्ता'];

    // Use saved profile data or defaults
    // Priority: AuthProvider (from Firebase) > SettingsProvider (manually edited)
    String displayName = authProvider.displayName;

    // Debug logging
    debugPrint('🔍 Profile Name Debug:');
    debugPrint('  - AuthProvider displayName: $displayName');
    debugPrint('  - SettingsProvider profileName: ${settings.profileName}');
    debugPrint('  - Is default name: ${defaultUserNames.contains(displayName)}');

    // Translate if it's any default name (in any language)
    if (defaultUserNames.contains(displayName)) {
      displayName = context.tr('user');
      debugPrint('  - Translated to: $displayName');
    } else {
      // Apply transliteration to custom names from auth provider
      displayName = _transliterateName(displayName, context);
      debugPrint('  - Transliterated displayName: $displayName');
    }

    // Check if saved profile name is a translated default, if so re-translate it
    String profileName;
    if (settings.profileName.isEmpty || defaultUserNames.contains(settings.profileName)) {
      // It's a default value or empty, use translated version
      profileName = displayName;
      debugPrint('  - Using displayName: $profileName');
    } else {
      // It's a custom name, use as is
      profileName = settings.profileName;
      debugPrint('  - Using custom name: $profileName');
    }

    // Apply transliteration to custom names based on language
    if (!defaultUserNames.contains(profileName)) {
      profileName = _transliterateName(profileName, context);
      debugPrint('  - Transliterated name: $profileName');
    }

    final profileEmail = authProvider.userEmail ?? 'user@example.com';

    // Always use current GPS location, not saved static location
    String profileLocation;
    if (defaultLocation.isNotEmpty) {
      // Use current GPS location with translated city and country names
      profileLocation = defaultLocation;
    } else {
      // No GPS location available, show "Location not set"
      profileLocation = context.tr('location_not_set');
    }

    final profileImagePath = settings.profileImagePath;

    return Container(
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: responsive.spacing(70),
            height: responsive.spacing(70),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              image: profileImagePath != null && File(profileImagePath).existsSync()
                  ? DecorationImage(
                      image: FileImage(File(profileImagePath)),
                      fit: BoxFit.cover,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: responsive.spacing(10),
                  offset: Offset(0, responsive.spacing(3)),
                ),
              ],
            ),
            child: profileImagePath == null || !File(profileImagePath).existsSync()
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                    size: responsive.iconSize(36),
                  )
                : null,
          ),
          SizedBox(width: responsive.spaceRegular),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: TextStyle(
                    fontSize: responsive.textXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: responsive.spaceXSmall),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: responsive.iconSize(14),
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: responsive.spaceXSmall),
                    Expanded(
                      child: Text(
                        profileEmail,
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spaceXSmall),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: responsive.iconSize(14),
                      color: AppColors.primaryLight,
                    ),
                    SizedBox(width: responsive.spaceXSmall),
                    Expanded(
                      child: Text(
                        profileLocation,
                        style: TextStyle(
                          fontSize: responsive.textSmall,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required ResponsiveUtils responsive,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: responsive.paddingSymmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: responsive.spacing(44),
          height: responsive.spacing(44),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: responsive.spacing(8),
                offset: Offset(0, responsive.spacing(2)),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: responsive.iconSmall),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.textMedium,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF6B7F73),
            fontSize: responsive.textSmall,
          ),
        ),
        trailing:
            trailing ??
            (onTap != null
                ? Container(
                    padding: responsive.paddingXSmall,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: responsive.iconSize(12),
                      color: Colors.white,
                    ),
                  )
                : null),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutCard(BuildContext context, {required ResponsiveUtils responsive}) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spaceMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: AppColors.lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: responsive.spacing(10),
            offset: Offset(0, responsive.spacing(2)),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: responsive.paddingSymmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: responsive.spacing(44),
          height: responsive.spacing(44),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: responsive.spacing(8),
                offset: Offset(0, responsive.spacing(2)),
              ),
            ],
          ),
          child: Icon(
            Icons.logout,
            color: Colors.white,
            size: responsive.iconSmall,
          ),
        ),
        title: Text(
          context.tr('logout'),
          style: TextStyle(
            fontSize: responsive.textMedium,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade600,
          ),
        ),
        subtitle: Text(
          context.tr('sign_out_message'),
          style: TextStyle(
            color: const Color(0xFF6B7F73),
            fontSize: responsive.textSmall,
          ),
        ),
        trailing: Container(
          padding: responsive.paddingXSmall,
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: responsive.iconSize(12),
            color: Colors.white,
          ),
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.languageCode;

    final languages = [
      {'code': 'ur', 'name': 'اردو', 'nativeName': 'Urdu', 'icon': '🇵🇰'},
      {'code': 'ar', 'name': 'العربية', 'nativeName': 'Arabic', 'icon': '🇸🇦'},
      {'code': 'hi', 'name': 'हिन्दी', 'nativeName': 'Hindi', 'icon': '🇮🇳'},
      {'code': 'en', 'name': 'English', 'nativeName': 'English', 'icon': '🇬🇧'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('change_language')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = currentLanguage == language['code'];

              return ListTile(
                leading: Text(
                  language['icon'] as String,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(language['name'] as String),
                subtitle: Text(language['nativeName'] as String),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                selected: isSelected,
                onTap: () async {
                  final code = language['code'] as String;
                  debugPrint('Setting language to: $code');
                  await languageProvider.setLanguage(code);
                  debugPrint('Language set successfully. Current: ${languageProvider.languageCode}');
                  if (context.mounted) {
                    Navigator.pop(context);
                    // Show a snackbar to confirm
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${languageProvider.translate('language_changed_to')} ${language['nativeName']}',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('logout')),
        content: Text(context.tr('logout_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Add your logout logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: Text(context.tr('logout'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() async {
    final url = Uri.parse('https://nooruliman.com/privacy');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mosque,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(context.tr('app_name')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${context.tr('version')} 1.0.0'),
            const SizedBox(height: 16),
            Text(context.tr('app_subtitle')),
            const SizedBox(height: 8),
            Text(context.tr('feature_prayer_times')),
            Text(context.tr('feature_qibla_compass')),
            Text(context.tr('feature_quran')),
            Text(context.tr('feature_duas')),
            Text(context.tr('feature_tasbih')),
            Text(context.tr('feature_calendar')),
            Text(context.tr('feature_99_names')),
            Text(context.tr('feature_hadith')),
            Text(context.tr('feature_zakat')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('close')),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    // Get all translations before showing dialog to avoid Provider context issues
    final editProfileText = context.tr('edit_profile');
    final nameText = context.tr('name');
    final locationText = context.tr('location');
    final cancelText = context.tr('cancel');
    final saveText = context.tr('save');
    final profileUpdatedText = context.tr('profile_updated');
    final changePhotoText = context.tr('change_photo');
    final cameraText = context.tr('camera');
    final galleryText = context.tr('gallery');

    // Get saved profile data from SettingsProvider
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final savedLocation = settings.profileLocation;
    final savedImagePath = settings.profileImagePath;

    // Handle name translation - check if saved name is a translated default
    final defaultUserNames = ['User', 'صارف', 'المستخدم', 'उपयोगकर्ता'];
    String savedName;
    if (settings.profileName.isEmpty || defaultUserNames.contains(settings.profileName)) {
      // It's a default value, use translated version or Firebase name
      final firebaseName = authProvider.displayName;
      savedName = defaultUserNames.contains(firebaseName) ? context.tr('user') : firebaseName;
    } else {
      // It's a custom name, use as is
      savedName = settings.profileName;
    }

    // Get default location if no saved location
    final locationService = LocationService();
    final city = locationService.currentCity ?? context.tr('unknown');
    final translatedCity = _translateCityName(city, context);
    final country = locationService.currentCountry ?? '';
    final translatedCountry = country.isNotEmpty ? _translateCountryName(country, context) : '';
    final defaultLocation = translatedCountry.isNotEmpty ? '$translatedCity, $translatedCountry' : translatedCity;

    // Parse saved location and translate both city and country names if present
    String currentLocation;
    if (savedLocation.isEmpty) {
      currentLocation = defaultLocation;
    } else if (savedLocation.contains(',')) {
      // Format is "City, Country" - translate both parts
      final parts = savedLocation.split(',').map((s) => s.trim()).toList();
      if (parts.length == 2) {
        final savedCity = parts[0];
        final savedCountry = parts[1];
        final translatedSavedCity = _translateCityName(savedCity, context);
        final translatedSavedCountry = _translateCountryName(savedCountry, context);
        currentLocation = '$translatedSavedCity, $translatedSavedCountry';
      } else {
        currentLocation = savedLocation;
      }
    } else {
      // No comma, try to translate as city name
      final translatedLocation = _translateCityName(savedLocation, context);
      currentLocation = translatedLocation;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => _EditProfileDialog(
        editProfileText: editProfileText,
        nameText: nameText,
        locationText: locationText,
        cancelText: cancelText,
        saveText: saveText,
        profileUpdatedText: profileUpdatedText,
        userText: savedName,
        currentLocation: currentLocation,
        currentImagePath: savedImagePath,
        changePhotoText: changePhotoText,
        cameraText: cameraText,
        galleryText: galleryText,
        parentContext: context,
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  final String editProfileText;
  final String nameText;
  final String locationText;
  final String cancelText;
  final String saveText;
  final String profileUpdatedText;
  final String userText;
  final String currentLocation;
  final String? currentImagePath;
  final String changePhotoText;
  final String cameraText;
  final String galleryText;
  final BuildContext parentContext;

  const _EditProfileDialog({
    required this.editProfileText,
    required this.nameText,
    required this.locationText,
    required this.cancelText,
    required this.saveText,
    required this.profileUpdatedText,
    required this.userText,
    required this.currentLocation,
    this.currentImagePath,
    required this.changePhotoText,
    required this.cameraText,
    required this.galleryText,
    required this.parentContext,
  });

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController locationController;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userText);
    locationController = TextEditingController(text: widget.currentLocation);

    // Load existing image if available
    if (widget.currentImagePath != null && File(widget.currentImagePath!).existsSync()) {
      _selectedImage = File(widget.currentImagePath!);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImageSourceDialog() {
    final responsive = widget.parentContext.responsive;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.changePhotoText),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: responsive.paddingSmall,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: AppColors.primary),
              ),
              title: Text(widget.cameraText),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Container(
                padding: responsive.paddingSmall,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: Text(widget.galleryText),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = widget.parentContext.responsive;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        side: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(widget.editProfileText),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image Picker
            GestureDetector(
              onTap: _showImageSourceDialog,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: _selectedImage == null
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 50,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            // Name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: widget.nameText,
                prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.lightGreenBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Location field (editable with search and GPS)
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: widget.locationText,
                hintText: 'Search city, country or use GPS',
                prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.gps_fixed, color: AppColors.primary, size: 20),
                      onPressed: () async {
                        // Fetch current GPS location
                        final locationService = LocationService();
                        final position = await locationService.getCurrentLocation();

                        if (position != null && mounted) {
                          try {
                            final placemarks = await placemarkFromCoordinates(
                              position.latitude,
                              position.longitude,
                            );

                            if (placemarks.isNotEmpty && mounted) {
                              final placemark = placemarks.first;
                              final city = placemark.locality ?? placemark.subAdministrativeArea ?? 'Unknown';
                              final country = placemark.country ?? '';

                              locationService.updateCity(city, country);

                              // Update the text field with location (no translation in dialog)
                              setState(() {
                                locationController.text = '$city, $country';
                              });

                              debugPrint('📍 GPS Location fetched: $city, $country');
                            }
                          } catch (e) {
                            debugPrint('Geocoding error: $e');
                          }
                        }
                      },
                      tooltip: 'Use current GPS location',
                    ),
                    const Icon(Icons.search, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.lightGreenBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                helperText: 'Type to search or tap GPS icon for current location',
                helperStyle: TextStyle(
                  fontSize: responsive.textXSmall,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
          ),
          child: Text(
            widget.cancelText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            // Save profile changes to SettingsProvider
            final settings = Provider.of<SettingsProvider>(widget.parentContext, listen: false);

            await settings.updateProfile(
              name: nameController.text.trim().isNotEmpty ? nameController.text.trim() : 'User',
              location: locationController.text.trim(),
              imagePath: _selectedImage?.path,
            );

            if (context.mounted) {
              Navigator.pop(context);
            }

            if (widget.parentContext.mounted) {
              ScaffoldMessenger.of(widget.parentContext).showSnackBar(
                SnackBar(
                  content: Text(widget.profileUpdatedText),
                  duration: const Duration(seconds: 2),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
            elevation: 2,
          ),
          child: Text(
            widget.saveText,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
