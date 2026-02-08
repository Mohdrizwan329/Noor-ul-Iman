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
import '../../core/services/data_migration_service.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../auth/login_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_screen.dart';
import '../../widgets/common/banner_ad_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentCity = '';
  String _currentCountry = '';
  bool _isLoadingLocation = true;
  final ContentService _contentService = ContentService();
  SettingsScreenContentFirestore? _content;
  bool _isContentLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = await _contentService.getSettingsScreenContent();
      if (mounted) {
        setState(() {
          _content = content;
          _isContentLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading settings content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
      }
    }
  }

  String get _langCode =>
      Provider.of<LanguageProvider>(context, listen: false).languageCode;

  /// Get translated string from Firebase content
  String _t(String key) {
    if (_content == null) return '';
    return _content!.getString(key, _langCode);
  }

  /// Translate city name from Firebase content
  String _translateCityName(String city) {
    if (_content == null) return city;
    return _content!.getCityName(city, _langCode);
  }

  /// Translate country name from Firebase content
  String _translateCountryName(String country) {
    if (_content == null) return country;
    return _content!.getCountryName(country, _langCode);
  }

  /// Transliterate name from Firebase content
  String _transliterateName(String name) {
    if (_langCode == 'en') return name;
    if (_content == null) return name;
    return _content!.transliterateName(name, _langCode);
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

    if (_isContentLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t('profile'),
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
                  _t('prayer_times'),
                  responsive: responsive,
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.notifications,
                  title: _t('prayer_notifications'),
                  subtitle: settings.notificationsEnabled
                      ? _t('enabled')
                      : _t('disabled'),
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
                  _t('language'),
                  responsive: responsive,
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.language,
                  title: _t('change_language'),
                  subtitle: _t('select_your_language'),
                  onTap: () => _showLanguageDialog(context),
                ),
                SizedBox(height: responsive.spacing(24)),

                // About Section
                _buildSectionHeader(
                  context,
                  _t('about'),
                  responsive: responsive,
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.privacy_tip,
                  title: _t('privacy_policy'),
                  subtitle: _t('read_privacy_policy'),
                  onTap: () => _openPrivacyPolicy(),
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.info,
                  title: _t('about'),
                  subtitle: '${_t('version')} ${_t('app_version')}',
                  onTap: () => _showAboutDialog(context),
                ),
                _buildSettingCard(
                  context,
                  responsive: responsive,
                  icon: Icons.cloud_upload,
                  title: _t('migrate_data_to_firebase'),
                  subtitle: _t('upload_all_data_to_firestore'),
                  onTap: () => _showMigrationDialog(context),
                ),
                SizedBox(height: responsive.spacing(24)),

                // Logout
                _buildLogoutCard(context, responsive: responsive),
                SizedBox(height: responsive.spacing(24)),

                // Banner Ad at the end of content
                const BannerAdWidget(),
                SizedBox(height: responsive.spaceRegular),
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

  Widget _buildProfileCard(
    BuildContext context, {
    required ResponsiveUtils responsive,
  }) {
    final settings = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Build location string
    String profileLocation;
    if (_isLoadingLocation) {
      profileLocation = _t('fetching_location');
    } else if (_currentCity.isNotEmpty) {
      final translatedCity = _translateCityName(_currentCity);
      if (_currentCountry.isNotEmpty) {
        final translatedCountry = _translateCountryName(_currentCountry);
        profileLocation = '$translatedCity, $translatedCountry';
      } else {
        profileLocation = translatedCity;
      }
    } else {
      profileLocation = _t('location_not_set');
    }

    // List of all translated default user names from Firebase
    final defaultUserNames = _content?.defaultUserNames ?? [];

    // Get display name
    String displayName = authProvider.displayName;

    if (displayName.isEmpty || defaultUserNames.contains(displayName)) {
      displayName = _t('user');
    } else {
      displayName = _transliterateName(displayName);
    }

    String profileName;
    if (settings.profileName.isEmpty ||
        settings.profileName == 'User' ||
        defaultUserNames.contains(settings.profileName)) {
      profileName = displayName;
    } else {
      profileName = settings.profileName;
    }

    if (!defaultUserNames.contains(profileName)) {
      profileName = _transliterateName(profileName);
    }

    final profileEmail = authProvider.userEmail ?? _t('default_email');
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
          _t('logout'),
          style: TextStyle(
            fontSize: responsive.fontSize(16),
            fontWeight: FontWeight.bold,
            color: Colors.red.shade600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _t('sign_out_message'),
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

    // Get languages from Firebase content
    final languages = _content?.languages ?? [];
    if (languages.isEmpty) return;

    final languageList = languages.map((l) => {
      'code': l.code,
      'name': l.name,
      'nativeName': l.nativeName,
      'icon': l.icon,
    }).toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t('change_language')),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languageList.length,
            itemBuilder: (context, index) {
              final language = languageList[index];
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
            child: Text(_t('cancel')),
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
                _t('logout'),
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
          _t('logout_confirmation'),
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
              _t('cancel'),
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
                      content: Text('${_t('error')}: $e'),
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
              _t('logout'),
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

  void _showMigrationDialog(BuildContext context) {
    bool isMigrating = false;
    final logs = <String>[];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(_t('migrate_data_to_firebase')),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMigrating && logs.isEmpty)
                      Text(
                        _t('migration_description'),
                      ),
                    if (isMigrating)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(),
                      ),
                    if (logs.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: logs.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              logs[index],
                              style: TextStyle(
                                fontSize: 12,
                                color: logs[index].contains('failed') || logs[index].contains('Error')
                                    ? Colors.red
                                    : logs[index].contains('successfully') || logs[index].contains('completed')
                                        ? Colors.green
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                if (!isMigrating)
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(logs.isEmpty ? _t('cancel') : _t('close')),
                  ),
                if (!isMigrating && logs.isEmpty)
                  ElevatedButton(
                    onPressed: () async {
                      setDialogState(() {
                        isMigrating = true;
                        logs.clear();
                      });

                      final migrationService = DataMigrationService();

                      // Check if already migrated
                      final alreadyMigrated = await migrationService.isDataMigrated();
                      if (alreadyMigrated) {
                        setDialogState(() {
                          logs.add('Data already exists in Firestore.');
                          logs.add('Re-uploading will overwrite existing data...');
                        });
                      }

                      final result = await migrationService.migrateAll(
                        onProgress: (message) {
                          setDialogState(() {
                            logs.add(message);
                          });
                        },
                      );

                      setDialogState(() {
                        isMigrating = false;
                        logs.add('');
                        logs.add(result.toString());
                      });
                    },
                    child: Text(_t('start_migration')),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
