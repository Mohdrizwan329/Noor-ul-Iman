import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/settings_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quran_provider.dart';
import '../../core/services/location_service.dart';
import '../auth/login_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentCity = '';
  String _currentCountry = '';
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final locationService = LocationService();

      // Try to use cached location first
      if (locationService.currentCity != null &&
          locationService.currentCity!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _currentCity = locationService.currentCity ?? '';
            _currentCountry = locationService.currentCountry ?? '';
            _isLoadingLocation = false;
          });
        }
        return;
      }

      final position = await locationService.getCurrentLocation();

      if (position != null && mounted) {
        try {
          // Get address from coordinates with timeout
          final placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          ).timeout(
            const Duration(seconds: 10),
            onTimeout: () => <Placemark>[],
          );

          if (placemarks.isNotEmpty && mounted) {
            final place = placemarks.first;
            setState(() {
              _currentCity = place.locality ??
                  place.subAdministrativeArea ??
                  place.administrativeArea ??
                  '';
              _currentCountry = place.country ?? '';
              _isLoadingLocation = false;
            });

            // Update location service cache
            locationService.updateCity(_currentCity, _currentCountry);
          } else if (mounted) {
            setState(() {
              _isLoadingLocation = false;
            });
          }
        } catch (geocodeError) {
          debugPrint('Geocoding error: $geocodeError');
          if (mounted) {
            setState(() {
              _isLoadingLocation = false;
            });
          }
        }
      } else if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching location: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('profile'),
          style: TextStyle(fontSize: responsive.fontSize(18)),
        ),
      ),
      body: Consumer2<SettingsProvider, LanguageProvider>(
        builder: (context, settings, languageProvider, child) {
          return RefreshIndicator(
            onRefresh: _fetchCurrentLocation,
            color: AppColors.primary,
            child: ListView(
              padding: responsive.paddingRegular,
              children: [
                // Profile Card
                _buildProfileCard(context, responsive: responsive),
                SizedBox(height: responsive.spacing(24)),

                // Prayer Settings Section
                _buildSectionHeader(
                  context,
                  context.tr('prayer_times'),
                  responsive: responsive,
                ),
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
                SizedBox(height: responsive.spacing(24)),

                // Language Section
                _buildSectionHeader(
                  context,
                  context.tr('language'),
                  responsive: responsive,
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.language,
                  title: context.tr('change_language'),
                  subtitle: context.tr('select_your_language'),
                  onTap: () => _showLanguageDialog(context),
                ),
                SizedBox(height: responsive.spacing(24)),

                // About Section
                _buildSectionHeader(
                  context,
                  context.tr('about'),
                  responsive: responsive,
                ),
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
                SizedBox(height: responsive.spacing(24)),

                // Logout
                _buildLogoutCard(context, responsive: responsive),
                SizedBox(height: responsive.spaceXXLarge),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    required ResponsiveUtils responsive,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: responsive.spacing(8)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: responsive.fontSize(18),
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  // Helper function to translate city names
  String _translateCityName(String city) {
    final cityTranslations = {
      'Bengaluru': {
        'en': 'Bengaluru',
        'ur': 'بنگلور',
        'ar': 'بنغالور',
        'hi': 'बेंगलुरु',
      },
      'Mumbai': {'en': 'Mumbai', 'ur': 'ممبئی', 'ar': 'مومباي', 'hi': 'मुंबई'},
      'Delhi': {'en': 'Delhi', 'ur': 'دہلی', 'ar': 'دلهي', 'hi': 'दिल्ली'},
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
      'Pune': {'en': 'Pune', 'ur': 'پونے', 'ar': 'بونا', 'hi': 'पुणे'},
      'Ahmedabad': {
        'en': 'Ahmedabad',
        'ur': 'احمد آباد',
        'ar': 'أحمد آباد',
        'hi': 'अहमदाबाद',
      },
      'Jaipur': {'en': 'Jaipur', 'ur': 'جے پور', 'ar': 'جايبور', 'hi': 'जयपुर'},
      'Lucknow': {'en': 'Lucknow', 'ur': 'لکھنؤ', 'ar': 'لكناو', 'hi': 'लखनऊ'},
      'Karachi': {
        'en': 'Karachi',
        'ur': 'کراچی',
        'ar': 'كراتشي',
        'hi': 'कराची',
      },
      'Lahore': {'en': 'Lahore', 'ur': 'لاہور', 'ar': 'لاهور', 'hi': 'लाहौर'},
      'Islamabad': {
        'en': 'Islamabad',
        'ur': 'اسلام آباد',
        'ar': 'إسلام آباد',
        'hi': 'इस्लामाबाद',
      },
      'Dhaka': {'en': 'Dhaka', 'ur': 'ڈھاکہ', 'ar': 'دكا', 'hi': 'ढाका'},
      'Mecca': {'en': 'Mecca', 'ur': 'مکہ', 'ar': 'مكة', 'hi': 'मक्का'},
      'Medina': {'en': 'Medina', 'ur': 'مدینہ', 'ar': 'المدينة', 'hi': 'मदीना'},
      'Riyadh': {'en': 'Riyadh', 'ur': 'ریاض', 'ar': 'الرياض', 'hi': 'रियाद'},
      'Dubai': {'en': 'Dubai', 'ur': 'دبئی', 'ar': 'دبي', 'hi': 'दुबई'},
      'Abu Dhabi': {
        'en': 'Abu Dhabi',
        'ur': 'ابوظبی',
        'ar': 'أبو ظبي',
        'hi': 'अबू धाबी',
      },
    };

    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguage = languageProvider.languageCode;

    final cityData = cityTranslations[city];
    if (cityData != null) {
      return cityData[currentLanguage] ?? city;
    }

    return city;
  }

  // Helper function to translate country names
  String _translateCountryName(String country) {
    final countryTranslations = {
      'India': {'en': 'India', 'ur': 'بھارت', 'ar': 'الهند', 'hi': 'भारत'},
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

    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguage = languageProvider.languageCode;

    final countryData = countryTranslations[country];
    if (countryData != null) {
      return countryData[currentLanguage] ?? country;
    }

    return country;
  }

  // Helper function to transliterate names to different scripts
  String _transliterateName(String name) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguage = languageProvider.languageCode;

    if (currentLanguage == 'en') {
      return name;
    }

    final transliterations = {
      'Mohd': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मोहम्मद'},
      'Mohammad': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मोहम्मद'},
      'Muhammad': {'ur': 'محمد', 'ar': 'محمد', 'hi': 'मुहम्मद'},
      'Ahmed': {'ur': 'احمد', 'ar': 'أحمد', 'hi': 'अहमद'},
      'Ali': {'ur': 'علی', 'ar': 'علي', 'hi': 'अली'},
      'Hassan': {'ur': 'حسن', 'ar': 'حسن', 'hi': 'हसन'},
      'Hussain': {'ur': 'حسین', 'ar': 'حسين', 'hi': 'हुसैन'},
      'Fatima': {'ur': 'فاطمہ', 'ar': 'فاطمة', 'hi': 'फातिमा'},
      'Ayesha': {'ur': 'عائشہ', 'ar': 'عائشة', 'hi': 'आयशा'},
      'Reyan': {'ur': 'ریان', 'ar': 'ريان', 'hi': 'रेयान'},
      'Rizwan': {'ur': 'رضوان', 'ar': 'رضوان', 'hi': 'रिज़वान'},
      'Khan': {'ur': 'خان', 'ar': 'خان', 'hi': 'खान'},
      'Sheikh': {'ur': 'شیخ', 'ar': 'شيخ', 'hi': 'शेख'},
    };

    List<String> nameParts = name.split(' ');
    List<String> transliteratedParts = [];

    for (String part in nameParts) {
      final transliteration = transliterations[part];
      if (transliteration != null) {
        transliteratedParts.add(
          transliteration[currentLanguage] ?? part,
        );
      } else {
        transliteratedParts.add(part);
      }
    }

    return transliteratedParts.join(' ');
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required ResponsiveUtils responsive,
  }) {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Build location string
    String profileLocation;
    if (_isLoadingLocation) {
      profileLocation = context.tr('fetching_location');
    } else if (_currentCity.isNotEmpty) {
      final translatedCity = _translateCityName(_currentCity);
      if (_currentCountry.isNotEmpty) {
        final translatedCountry = _translateCountryName(_currentCountry);
        profileLocation = '$translatedCity, $translatedCountry';
      } else {
        profileLocation = translatedCity;
      }
    } else {
      profileLocation = context.tr('location_not_set');
    }

    // List of all translated default user names
    final defaultUserNames = ['User', 'صارف', 'المستخدم', 'उपयोगकर्ता'];

    // Get display name
    String displayName = authProvider.displayName;

    if (defaultUserNames.contains(displayName)) {
      displayName = context.tr('user');
    } else {
      displayName = _transliterateName(displayName);
    }

    String profileName;
    if (settings.profileName.isEmpty ||
        defaultUserNames.contains(settings.profileName)) {
      profileName = displayName;
    } else {
      profileName = settings.profileName;
    }

    if (!defaultUserNames.contains(profileName)) {
      profileName = _transliterateName(profileName);
    }

    final profileEmail = authProvider.userEmail ?? 'user@example.com';
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
              image: profileImagePath != null &&
                      File(profileImagePath).existsSync()
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
            child: profileImagePath == null ||
                    !File(profileImagePath).existsSync()
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
                    fontSize: responsive.fontSize(20),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
                          fontSize: responsive.fontSize(14),
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsive.spaceXSmall),
                Row(
                  children: [
                    _isLoadingLocation
                        ? SizedBox(
                            width: responsive.iconSize(14),
                            height: responsive.iconSize(14),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryLight,
                            ),
                          )
                        : Icon(
                            Icons.location_on_outlined,
                            size: responsive.iconSize(14),
                            color: AppColors.primaryLight,
                          ),
                    SizedBox(width: responsive.spaceXSmall),
                    Expanded(
                      child: Text(
                        profileLocation,
                        style: TextStyle(
                          fontSize: responsive.fontSize(14),
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
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
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
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
        contentPadding: responsive.paddingSymmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: responsive.spacing(44),
          height: responsive.spacing(44),
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, responsive.spacing(2)),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: responsive.iconSize(20)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: responsive.fontSize(16),
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: const Color(0xFF6B7F73),
            fontSize: responsive.fontSize(14),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: trailing ??
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

  Widget _buildLogoutCard(
    BuildContext context, {
    required ResponsiveUtils responsive,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(16)),
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
        contentPadding: responsive.paddingSymmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: responsive.spacing(44),
          height: responsive.spacing(44),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, responsive.spacing(2)),
              ),
            ],
          ),
          child: Icon(
            Icons.logout,
            color: Colors.white,
            size: responsive.iconSize(20),
          ),
        ),
        title: Text(
          context.tr('logout'),
          style: TextStyle(
            fontSize: responsive.fontSize(16),
            fontWeight: FontWeight.bold,
            color: Colors.red.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          context.tr('sign_out_message'),
          style: TextStyle(
            color: const Color(0xFF6B7F73),
            fontSize: responsive.fontSize(14),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
    final responsive = context.responsive;
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );
    final currentLanguage = languageProvider.languageCode;

    final languages = [
      {'code': 'ur', 'name': 'اردو', 'nativeName': 'Urdu', 'icon': '🇵🇰'},
      {'code': 'ar', 'name': 'العربية', 'nativeName': 'Arabic', 'icon': '🇸🇦'},
      {'code': 'hi', 'name': 'हिन्दी', 'nativeName': 'Hindi', 'icon': '🇮🇳'},
      {
        'code': 'en',
        'name': 'English',
        'nativeName': 'English',
        'icon': '🇬🇧',
      },
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
                  style: TextStyle(fontSize: responsive.fontSize(28)),
                ),
                title: Text(
                  language['name'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  language['nativeName'] as String,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                selected: isSelected,
                onTap: () async {
                  final code = language['code'] as String;
                  await languageProvider.setLanguage(code);

                  if (context.mounted) {
                    final quranProvider = Provider.of<QuranProvider>(
                      context,
                      listen: false,
                    );
                    final quranLang = _getQuranLanguage(code);
                    await quranProvider.setLanguage(quranLang);
                  }

                  if (context.mounted) {
                    Navigator.pop(context);
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

  QuranLanguage _getQuranLanguage(String code) {
    switch (code) {
      case 'ur':
        return QuranLanguage.urdu;
      case 'ar':
        return QuranLanguage.arabic;
      case 'hi':
        return QuranLanguage.hindi;
      case 'en':
      default:
        return QuranLanguage.english;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final responsive = context.responsive;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
          side: const BorderSide(color: AppColors.primary, width: 2),
        ),
        title: Row(
          children: [
            Container(
              width: responsive.spacing(40),
              height: responsive.spacing(40),
              decoration: BoxDecoration(
                color: Colors.red.shade600.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout,
                color: Colors.red.shade600,
                size: responsive.iconSize(24),
              ),
            ),
            responsive.hSpaceMedium,
            Expanded(
              child: Text(
                context.tr('logout'),
                style: TextStyle(
                  fontSize: responsive.fontSize(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Text(
          context.tr('logout_confirmation'),
          style: TextStyle(
            fontSize: responsive.fontSize(16),
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              padding: responsive.paddingSymmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
            ),
            child: Text(
              context.tr('cancel'),
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );

              try {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                await authProvider.signOut();

                if (context.mounted) {
                  Navigator.pop(context);
                }

                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                }

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${context.tr('error')}: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: responsive.paddingSymmetric(
                horizontal: 20,
                vertical: 12,
              ),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
            ),
            child: Text(
              context.tr('logout'),
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }
}
