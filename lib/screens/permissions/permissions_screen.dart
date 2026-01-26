import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/utils/localization_helper.dart';
import '../../core/services/geo_restriction_service.dart';
import '../main/main_screen.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  bool _locationGranted = false;
  bool _notificationGranted = false;
  bool _alarmGranted = false;
  bool _galleryGranted = false;
  bool _contactsGranted = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permissions when app resumes (user might have granted from settings)
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    setState(() => _isChecking = true);

    try {
      final locationStatus = await Permission.location.status;
      final notificationStatus = await Permission.notification.status;
      final alarmStatus = await Permission.scheduleExactAlarm.status;
      final galleryStatus = await Permission.photos.status;
      final contactsStatus = await Permission.contacts.status;

      if (mounted) {
        setState(() {
          _locationGranted = locationStatus.isGranted;
          _notificationGranted = notificationStatus.isGranted;
          _alarmGranted = alarmStatus.isGranted;
          _galleryGranted = galleryStatus.isGranted || galleryStatus.isLimited;
          _contactsGranted = contactsStatus.isGranted;
          _isChecking = false;
        });

        // If all permissions are granted, proceed to next screen
        if (_allPermissionsGranted) {
          _navigateToNextScreen();
        }
      }
    } catch (e) {
      debugPrint('Permission check error: $e');
      if (mounted) {
        setState(() => _isChecking = false);
        // Skip to next screen if permission check fails
        _navigateToNextScreen();
      }
    }
  }

  bool get _allPermissionsGranted =>
      _locationGranted &&
      _notificationGranted &&
      _alarmGranted &&
      _galleryGranted &&
      _contactsGranted;

  Future<void> _requestPermission(Permission permission) async {
    try {
      // Special handling for exact alarm permission
      if (permission == Permission.scheduleExactAlarm) {
        await _requestAlarmPermission();
        return;
      }

      final status = await permission.request();

      if (mounted) {
        setState(() {
          switch (permission) {
            case Permission.location:
              _locationGranted = status.isGranted;
              break;
            case Permission.notification:
              _notificationGranted = status.isGranted;
              break;
            case Permission.photos:
              _galleryGranted = status.isGranted || status.isLimited;
              break;
            case Permission.contacts:
              _contactsGranted = status.isGranted;
              break;
            default:
              break;
          }
        });

        if (status.isPermanentlyDenied) {
          _showSettingsDialog(permission);
        }

        if (_allPermissionsGranted) {
          _navigateToNextScreen();
        }
      }
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  Future<void> _requestAlarmPermission() async {
    // Check current status
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) {
      setState(() => _alarmGranted = true);
      if (_allPermissionsGranted) {
        _navigateToNextScreen();
      }
      return;
    }

    // Show dialog explaining the permission and open settings
    if (mounted) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(dialogContext.tr('alarm_permission_required')),
          content: Text(dialogContext.tr('alarm_permission_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(dialogContext.tr('cancel')),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                // This will open the exact alarm settings page
                await Permission.scheduleExactAlarm.request();
              },
              child: Text(dialogContext.tr('open_settings')),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _requestAllPermissions() async {
    if (!_locationGranted) {
      await _requestPermission(Permission.location);
    }
    if (!_notificationGranted) {
      await _requestPermission(Permission.notification);
    }
    if (!_alarmGranted) {
      await _requestPermission(Permission.scheduleExactAlarm);
    }
    if (!_galleryGranted) {
      await _requestPermission(Permission.photos);
    }
    if (!_contactsGranted) {
      await _requestPermission(Permission.contacts);
    }
  }

  void _showSettingsDialog(Permission permission) {
    String permissionName = '';
    switch (permission) {
      case Permission.location:
        permissionName = 'Location';
        break;
      case Permission.notification:
        permissionName = 'Notification';
        break;
      case Permission.scheduleExactAlarm:
        permissionName = 'Alarm & Reminder';
        break;
      case Permission.photos:
        permissionName = 'Gallery';
        break;
      case Permission.contacts:
        permissionName = 'Contacts';
        break;
      default:
        permissionName = 'Permission';
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr('permission_required')),
        content: Text(
          '$permissionName ${dialogContext.tr('permission_denied_message')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(dialogContext.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              openAppSettings();
            },
            child: Text(dialogContext.tr('open_settings')),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToNextScreen() async {
    // Check for geographic restrictions before proceeding
    final isRestricted = await GeoRestrictionService.checkCurrentLocation();

    if (isRestricted) {
      if (mounted) {
        GeoRestrictionService.showRestrictionDialog(context);
      }
      return;
    }

    // Location is allowed, proceed to main screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Padding(
            padding: responsive.paddingXLarge,
            child: Column(
              children: [
                SizedBox(height: responsive.spaceSmall),
                // Header
                Container(
                  width: responsive.iconSize(100),
                  height: responsive.iconSize(100),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security_rounded,
                    size: responsive.iconXXLarge,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: responsive.spaceMedium),
                Text(
                  context.tr('permissions_required'),
                  style: TextStyle(
                    fontSize: responsive.textHeading,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: responsive.spaceLarge),
                // Permission Items
                Expanded(
                  child: _isChecking
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildPermissionItem(
                                context: context,
                                icon: Icons.location_on_rounded,
                                title: context.tr('location_permission'),
                                description: context.tr('location_permission_desc'),
                                isGranted: _locationGranted,
                                onTap: () =>
                                    _requestPermission(Permission.location),
                              ),
                              SizedBox(height: responsive.spaceSmall),
                              _buildPermissionItem(
                                context: context,
                                icon: Icons.notifications_rounded,
                                title: context.tr('notification_permission'),
                                description: context.tr('notification_permission_desc'),
                                isGranted: _notificationGranted,
                                onTap: () =>
                                    _requestPermission(Permission.notification),
                              ),
                              SizedBox(height: responsive.spaceSmall),
                              _buildPermissionItem(
                                context: context,
                                icon: Icons.alarm_rounded,
                                title: context.tr('alarm_permission'),
                                description: context.tr('alarm_permission_desc'),
                                isGranted: _alarmGranted,
                                onTap: () => _requestPermission(
                                  Permission.scheduleExactAlarm,
                                ),
                              ),
                              SizedBox(height: responsive.spaceSmall),
                              _buildPermissionItem(
                                context: context,
                                icon: Icons.photo_library_rounded,
                                title: context.tr('gallery_permission'),
                                description: context.tr('gallery_permission_desc'),
                                isGranted: _galleryGranted,
                                onTap: () =>
                                    _requestPermission(Permission.photos),
                              ),
                              SizedBox(height: responsive.spaceSmall),
                              _buildPermissionItem(
                                context: context,
                                icon: Icons.contacts_rounded,
                                title: context.tr('contacts_permission'),
                                description: context.tr('contacts_permission_desc'),
                                isGranted: _contactsGranted,
                                onTap: () =>
                                    _requestPermission(Permission.contacts),
                              ),
                            ],
                          ),
                        ),
                ),
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _allPermissionsGranted
                        ? _navigateToNextScreen
                        : _requestAllPermissions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _allPermissionsGranted
                          ? AppColors.secondary
                          : Colors.white,
                      foregroundColor: _allPermissionsGranted
                          ? Colors.white
                          : AppColors.primary,
                      padding: responsive.paddingSymmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(responsive.radiusLarge),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _allPermissionsGranted
                          ? context.tr('continue')
                          : context.tr('grant_permission'),
                      style: TextStyle(
                        fontSize: responsive.textRegular,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: responsive.spaceRegular),
                Text(
                  context.tr('privacy_notice'),
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: responsive.spaceLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    final responsive = ResponsiveUtils(context);

    return GestureDetector(
      onTap: isGranted ? null : onTap,
      child: Container(
        padding: responsive.paddingRegular,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: responsive.iconSize(50),
              height: responsive.iconSize(50),
              decoration: BoxDecoration(
                color: isGranted
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Icon(
                icon,
                color: isGranted ? AppColors.success : AppColors.primary,
                size: responsive.iconLarge,
              ),
            ),
            SizedBox(width: responsive.spaceRegular),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: responsive.textRegular,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: responsive.spaceXSmall),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: responsive.textSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: responsive.iconSize(36),
              height: responsive.iconSize(36),
              decoration: BoxDecoration(
                color: isGranted
                    ? AppColors.success
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isGranted
                    ? Icons.check_rounded
                    : Icons.arrow_forward_ios_rounded,
                color: isGranted ? Colors.white : AppColors.primary,
                size: isGranted ? responsive.iconSmall : responsive.iconXSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
