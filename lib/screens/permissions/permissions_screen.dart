import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_colors.dart';
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
        builder: (context) => AlertDialog(
          title: const Text('Alarm Permission Required'),
          content: const Text(
            'To send exact prayer time notifications, please allow "Alarms & reminders" permission in the next screen.\n\nTap "Allow" on the settings page.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                // This will open the exact alarm settings page
                await Permission.scheduleExactAlarm.request();
              },
              child: const Text('Open Settings'),
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
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission Required'),
        content: Text(
          '$permissionName permission is permanently denied. Please enable it from app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Header
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'App Permissions',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),
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
                                icon: Icons.location_on_rounded,
                                title: 'Location',
                                description:
                                    'For prayer times & Qibla direction',
                                isGranted: _locationGranted,
                                onTap: () =>
                                    _requestPermission(Permission.location),
                              ),
                              const SizedBox(height: 10),
                              _buildPermissionItem(
                                icon: Icons.notifications_rounded,
                                title: 'Notifications',
                                description: 'For prayer reminders & updates',
                                isGranted: _notificationGranted,
                                onTap: () =>
                                    _requestPermission(Permission.notification),
                              ),
                              const SizedBox(height: 10),
                              _buildPermissionItem(
                                icon: Icons.alarm_rounded,
                                title: 'Alarm & Reminder',
                                description: 'For exact prayer time alarms',
                                isGranted: _alarmGranted,
                                onTap: () => _requestPermission(
                                  Permission.scheduleExactAlarm,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildPermissionItem(
                                icon: Icons.photo_library_rounded,
                                title: 'Gallery',
                                description: 'To save & share Islamic content',
                                isGranted: _galleryGranted,
                                onTap: () =>
                                    _requestPermission(Permission.photos),
                              ),
                              const SizedBox(height: 10),
                              _buildPermissionItem(
                                icon: Icons.contacts_rounded,
                                title: 'Contacts',
                                description: 'To share with friends & family',
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _allPermissionsGranted
                          ? 'Continue'
                          : 'Grant All Permissions',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your privacy is important to us',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isGranted ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isGranted
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isGranted ? AppColors.success : AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
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
                size: isGranted ? 20 : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
