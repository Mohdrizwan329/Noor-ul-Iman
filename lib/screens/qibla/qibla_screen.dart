import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/qibla_calculator.dart';
import '../../core/utils/app_utils.dart';
import '../../core/services/location_service.dart';
import '../../core/services/content_service.dart';
import '../../data/models/firestore_models.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final LocationService _locationService = LocationService();
  final ContentService _contentService = ContentService();
  double? _qiblaDirection;
  double? _compassHeading;
  Position? _currentPosition;
  bool _isLoading = true;
  bool _isContentLoading = true;
  String? _error;
  double? _distanceToKaaba;
  bool _hasCompass = true;
  bool _isSaved = false;
  QiblaContentFirestore? _qiblaContent;

  @override
  void initState() {
    super.initState();
    _checkCompassAvailability();
    _loadQiblaContent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _initializeQibla();
    }
  }

  /// Load all qibla screen content from Firebase - no static fallback
  Future<void> _loadQiblaContent() async {
    try {
      final content = await _contentService.getQiblaContent();
      if (mounted) {
        setState(() {
          _qiblaContent = content;
          _isContentLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading qibla content from Firebase: $e');
      if (mounted) {
        setState(() {
          _isContentLoading = false;
        });
      }
    }
  }

  /// Get translated string from Firebase only - no static fallback
  String _t(String key) {
    if (_qiblaContent == null) return '';
    final langCode =
        Provider.of<LanguageProvider>(context, listen: false).languageCode;
    return _qiblaContent!.getString(key, langCode);
  }

  /// Get the dua arabic text from Firebase only
  String get _duaArabicText {
    if (_qiblaContent != null && _qiblaContent!.duaArabicText.isNotEmpty) {
      return _qiblaContent!.duaArabicText;
    }
    return '';
  }

  Future<void> _checkCompassAvailability() async {
    try {
      final events = FlutterCompass.events;
      if (events == null) {
        setState(() {
          _hasCompass = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasCompass = false;
      });
    }
  }

  Future<void> _initializeQibla() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _error = _t('location_services_disabled');
            _isLoading = false;
          });
        }
        return;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _error = _t('location_permission_denied');
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _error = _t('location_permission_denied_forever');
            _isLoading = false;
          });
        }
        return;
      }

      // Get initial location
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition != null) {
        _updateQiblaData();
        _startLocationStream();
      } else {
        _error = _t('unable_to_get_location');
      }
    } catch (e) {
      _error = '${_t('location_error')}: ${e.toString()}';
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateQiblaData() {
    if (_currentPosition != null) {
      _qiblaDirection = QiblaCalculator.getQiblaDirection(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      _distanceToKaaba = QiblaCalculator.getDistanceToKaaba(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
    }
  }

  void _startLocationStream() {
    // Listen to real-time location updates (every 5 seconds or 10 meters movement)
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // Update every 10 meters
        timeLimit: Duration(seconds: 5),
      ),
    ).listen(
      (Position position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
            _updateQiblaData();
            _error = null;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.toString();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(_t('qibla')),
      ),
      body: Column(
        children: [
          Expanded(
            child: (_isLoading || _isContentLoading)
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorWidget()
                    : !_hasCompass
                        ? _buildNoCompassWidget()
                        : _buildCompassWidget(),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildNoCompassWidget() {
    final responsive = context.responsive;

    return SingleChildScrollView(
      padding: responsive.paddingXLarge,
      child: Column(
        children: [
          // Info Card with Qibla direction
          Container(
            width: double.infinity,
            padding: responsive.paddingLarge,
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mosque,
                  color: Colors.white,
                  size: responsive.iconXXLarge,
                ),
                responsive.vSpaceMedium,
                Text(
                  _t('qibla'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.textXXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_distanceToKaaba != null) ...[
                  responsive.vSpaceSmall,
                  Text(
                    '${_t('distance_to_kaaba')}: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: responsive.textMedium,
                    ),
                  ),
                ],
              ],
            ),
          ),
          responsive.vSpaceXXLarge,

          // Direction display without compass
          Container(
            padding: responsive.paddingXLarge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.explore,
                  size: responsive.iconHuge,
                  color: AppColors.primary,
                ),
                responsive.vSpaceRegular,
                Text(
                  '${(_qiblaDirection ?? 0).toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontSize: responsive.textHero,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                responsive.vSpaceSmall,
                Text(
                  _t('from_north'),
                  style: TextStyle(
                    fontSize: responsive.textRegular,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          responsive.vSpaceXLarge,

          // No compass warning
          Container(
            padding: responsive.paddingRegular,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange, size: responsive.iconMedium),
                SizedBox(width: responsive.spaceMedium),
                Expanded(
                  child: Text(
                    _t('compass_not_available'),
                    style: TextStyle(fontSize: responsive.textSmall),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    final responsive = context.responsive;
    final bool isPermissionError = _error?.contains('permission') ?? false;

    return Center(
      child: Padding(
        padding: responsive.paddingAll(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPermissionError ? Icons.location_disabled : Icons.location_off,
              size: responsive.iconHuge,
              color: Colors.grey,
            ),
            responsive.vSpaceXLarge,
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsive.textRegular,
                fontWeight: FontWeight.w500,
              ),
            ),
            responsive.vSpaceXLarge,

            // Show different buttons based on error type
            if (isPermissionError) ...[
              ElevatedButton.icon(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                icon: const Icon(Icons.settings),
                label: Text(_t('open_app_settings')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: responsive.paddingSymmetric(horizontal: 24, vertical: 12),
                ),
              ),
              responsive.vSpaceRegular,
              TextButton.icon(
                onPressed: _initializeQibla,
                icon: const Icon(Icons.refresh),
                label: Text(_t('try_again')),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _initializeQibla,
                icon: const Icon(Icons.refresh),
                label: Text(_t('retry')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: responsive.paddingSymmetric(horizontal: 24, vertical: 12),
                ),
              ),
              responsive.vSpaceRegular,
              TextButton.icon(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                },
                icon: const Icon(Icons.settings),
                label: Text(_t('open_location_settings')),
              ),
            ],

            // Help text
            responsive.vSpaceXXLarge,
            Container(
              padding: responsive.paddingRegular,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: responsive.iconMedium,
                  ),
                  SizedBox(width: responsive.spaceMedium),
                  Expanded(
                    child: Text(
                      _t('qibla_requires_location'),
                      style: TextStyle(
                        fontSize: responsive.textSmall,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassWidget() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        final responsive = context.responsive;

        if (snapshot.hasError) {
          // Compass error - show fallback with degree only
          return _buildNoCompassWidget();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                responsive.vSpaceRegular,
                Text(_t('initializing_compass')),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data?.heading == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                responsive.vSpaceRegular,
                Text(_t('calibrating_compass')),
                responsive.vSpaceSmall,
                Text(
                  _t('calibrate_instruction'),
                  style: const TextStyle(color: Colors.grey),
                ),
                responsive.vSpaceXLarge,
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasCompass = false;
                    });
                  },
                  child: Text(_t('show_direction_without_compass')),
                ),
              ],
            ),
          );
        }

        _compassHeading = snapshot.data!.heading;
        final qiblaFromNorth = _qiblaDirection ?? 0;
        final compassRotation = -(_compassHeading ?? 0) * (math.pi / 180);
        final qiblaRotation = (qiblaFromNorth - (_compassHeading ?? 0)) * (math.pi / 180);

        // Calculate accurate alignment percentage
        double rawDifference = qiblaFromNorth - (_compassHeading ?? 0);
        // Normalize to -180 to 180 range
        while (rawDifference > 180) {
          rawDifference -= 360;
        }
        while (rawDifference < -180) {
          rawDifference += 360;
        }
        final difference = rawDifference.abs();
        final isFacingQibla = difference < 1.5; // 100% alignment within 1.5 degrees

        // Calculate alignment percentage (100% at 0 degrees, 0% at 90+ degrees)
        int alignmentPercentage = ((90 - difference.clamp(0, 90)) / 90 * 100).toInt().clamp(0, 100);

        // Determine direction to turn
        String directionText = '';
        if (isFacingQibla) {
          directionText = _t('perfect_alignment');
        } else if (rawDifference > 0) {
          directionText = '${_t('turn_right')} ${difference.toStringAsFixed(1)}°';
        } else {
          directionText = '${_t('turn_left')} ${difference.toStringAsFixed(1)}°';
        }

        // Responsive compass size
        final compassSize = responsive.widthPercent(80).clamp(250.0, 350.0);
        final compassInnerSize = compassSize - responsive.spacing(20);

        // Get direction translations from Firebase
        final directions = [
          _t('north'),
          _t('east'),
          _t('south'),
          _t('west'),
        ];

        return SingleChildScrollView(
          padding: responsive.paddingXLarge,
          child: Column(
            children: [
              // Info Card with alignment percentage
              _buildInfoCard(isFacingQibla, alignmentPercentage, directionText),
              responsive.vSpaceXXLarge,

              // Compass with alignment indicator
              SizedBox(
                width: compassSize,
                height: compassSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Alignment percentage background ring
                    SizedBox(
                      width: compassSize,
                      height: compassSize,
                      child: CircularProgressIndicator(
                        value: alignmentPercentage / 100,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isFacingQibla ? AppColors.success : AppColors.primary,
                        ),
                      ),
                    ),
                    // Compass background
                    Transform.rotate(
                      angle: compassRotation,
                      child: Container(
                        width: compassInnerSize,
                        height: compassInnerSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: 5.0,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: CompassPainter(
                            responsive: responsive,
                            directions: directions,
                          ),
                        ),
                      ),
                    ),

                    // Qibla indicator
                    Transform.rotate(
                      angle: qiblaRotation,
                      child: Column(
                        children: [
                          Container(
                            padding: responsive.paddingSmall,
                            decoration: BoxDecoration(
                              color: isFacingQibla
                                  ? AppColors.success
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.mosque,
                              color: Colors.white,
                              size: responsive.iconMedium,
                            ),
                          ),
                          Container(
                            width: responsive.spacing(4),
                            height: responsive.spacing(100),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  isFacingQibla
                                      ? AppColors.success
                                      : AppColors.primary,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Center indicator with alignment percentage
                    Container(
                      width: responsive.spacing(80),
                      height: responsive.spacing(80),
                      decoration: BoxDecoration(
                        color: isFacingQibla ? AppColors.success : AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: responsive.spacing(3)),
                        boxShadow: [
                          BoxShadow(
                            color: (isFacingQibla ? AppColors.success : AppColors.primary)
                                .withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$alignmentPercentage%',
                            style: TextStyle(
                              fontSize: responsive.textXXLarge,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            isFacingQibla ? _t('perfect_label') : _t('aligned_label'),
                            style: TextStyle(
                              fontSize: responsive.textSmall,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              responsive.vSpaceXXLarge,

              // Direction info
              _buildDirectionInfo(qiblaFromNorth),
              responsive.vSpaceXLarge,

              // Dua Section
              _buildDuaSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(bool isFacingQibla, int alignmentPercentage, String directionText) {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        gradient: isFacingQibla
            ? const LinearGradient(
                colors: [AppColors.success, Color(0xFF81C784)],
              )
            : AppColors.headerGradient,
        borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
      ),
      child: Column(
        children: [
          // Alignment Percentage
          if (isFacingQibla)
            Container(
              padding: responsive.paddingSmall,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Text(
                _t('perfectly_aligned_100'),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.textLarge,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          SizedBox(height: responsive.spacing(2)),

          Text(
            isFacingQibla ? _t('facing_qibla') : _t('turn_to_face_qibla'),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.textXXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Direction indicator
          if (!isFacingQibla)
            Container(
              padding: responsive.paddingSmall,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(responsive.radiusMedium),
              ),
              child: Text(
                directionText,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: responsive.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

          if (_distanceToKaaba != null) ...[
            responsive.vSpaceSmall,
            Text(
              '${_t('distance_to_kaaba')}: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white70,
                fontSize: responsive.textMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDirectionInfo(double qiblaDirection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(
          _t('qibla'),
          '${qiblaDirection.toStringAsFixed(1)}°',
          Icons.mosque,
        ),
        _buildInfoItem(
          _t('compass'),
          '${(_compassHeading ?? 0).toStringAsFixed(1)}°',
          Icons.explore,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    final responsive = context.responsive;

    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: responsive.iconLarge),
        responsive.vSpaceSmall,
        Text(
          value,
          style: TextStyle(
            fontSize: responsive.textXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: responsive.textSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildDuaSection() {
    final responsive = context.responsive;

    return Container(
      width: double.infinity,
      padding: responsive.paddingLarge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusXXLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            _t('qibla_dua'),
            style: TextStyle(
              fontSize: responsive.textXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          responsive.vSpaceRegular,

          // Dua in Arabic
          Container(
            padding: responsive.paddingRegular,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _duaArabicText,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontSize: responsive.textLarge,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.8,
                  ),
                ),
                responsive.vSpaceRegular,
                Text(
                  '${_t('translation_label')} ${_t('qibla_dua_translation')}',
                  textAlign: TextAlign.left,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          responsive.vSpaceRegular,

          // Meaning/Explanation
          Container(
            padding: responsive.paddingRegular,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(responsive.radiusMedium),
              border: Border.all(
                color: Colors.blue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t('qibla_dua_meaning_title'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.textMedium,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                responsive.vSpaceSmall,
                Text(
                  _t('qibla_dua_meaning'),
                  textAlign: TextAlign.justify,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.textSmall,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          responsive.vSpaceXLarge,

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Save/Unsave Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isSaved = !_isSaved;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isSaved
                              ? _t('saved_successfully')
                              : _t('removed_successfully'),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(_isSaved ? _t('saved') : _t('save')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSaved ? AppColors.success : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: responsive.paddingSymmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: responsive.spaceMedium),

              // Delete Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation();
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(_t('delete')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: responsive.paddingSymmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(_t('confirm_delete')),
        content: Text(_t('delete_dua_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSaved = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_t('deleted_successfully')),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.red.shade400,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              foregroundColor: Colors.white,
            ),
            child: Text(_t('delete')),
          ),
        ],
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  final ResponsiveUtils responsive;
  final List<String> directions;

  CompassPainter({required this.responsive, required this.directions});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - responsive.spacing(20), circlePaint);
    canvas.drawCircle(center, radius - responsive.spacing(50), circlePaint);

    // Draw direction markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final colors = [Colors.red, Colors.grey, Colors.grey, Colors.grey];

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final x = center.dx + (radius - responsive.spacing(35)) * math.cos(angle);
      final y = center.dy + (radius - responsive.spacing(35)) * math.sin(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: colors[i],
          fontSize: responsive.textLarge,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw tick marks
    for (int i = 0; i < 360; i += 10) {
      final angle = i * math.pi / 180 - math.pi / 2;
      final isMain = i % 90 == 0;
      final isMedium = i % 30 == 0;

      final innerRadius = radius - (isMain ? responsive.spacing(60) : (isMedium ? responsive.spacing(55) : responsive.spacing(50)));
      final outerRadius = radius - responsive.spacing(45);

      final startX = center.dx + innerRadius * math.cos(angle);
      final startY = center.dy + innerRadius * math.sin(angle);
      final endX = center.dx + outerRadius * math.cos(angle);
      final endY = center.dy + outerRadius * math.sin(angle);

      final tickPaint = Paint()
        ..color = isMain ? Colors.grey[700]! : Colors.grey[400]!
        ..strokeWidth = isMain ? 2 : 1;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
