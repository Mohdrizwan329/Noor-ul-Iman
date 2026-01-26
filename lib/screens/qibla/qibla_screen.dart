import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/qibla_calculator.dart';
import '../../core/utils/responsive_utils.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/localization_helper.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final LocationService _locationService = LocationService();
  double? _qiblaDirection;
  double? _compassHeading;
  Position? _currentPosition;
  bool _isLoading = true;
  String? _error;
  double? _distanceToKaaba;
  bool _hasCompass = true;

  @override
  void initState() {
    super.initState();
    _checkCompassAvailability();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _initializeQibla();
    }
  }

  Future<void> _checkCompassAvailability() async {
    try {
      // Check if compass is supported on this device
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
    // Get translations before async operations
    final locationDisabled = context.tr('location_services_disabled');
    final permissionDenied = context.tr('location_permission_denied');
    final permissionDeniedForever = context.tr('location_permission_denied_forever');
    final unableToGetLocation = context.tr('unable_to_get_location');
    final locationError = context.tr('location_error');

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
            _error = locationDisabled;
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
              _error = permissionDenied;
              _isLoading = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _error = permissionDeniedForever;
            _isLoading = false;
          });
        }
        return;
      }

      // Get location
      _currentPosition = await _locationService.getCurrentLocation();

      if (_currentPosition != null) {
        _qiblaDirection = QiblaCalculator.getQiblaDirection(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        _distanceToKaaba = QiblaCalculator.getDistanceToKaaba(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
      } else {
        _error = unableToGetLocation;
      }
    } catch (e) {
      _error = '$locationError: ${e.toString()}';
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr('qibla')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : !_hasCompass
                  ? _buildNoCompassWidget()
                  : _buildCompassWidget(),
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
                  context.tr('qibla'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.textXXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_distanceToKaaba != null) ...[
                  responsive.vSpaceSmall,
                  Text(
                    '${context.tr('distance_to_kaaba')}: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
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
                  blurRadius: responsive.spacing(20),
                  spreadRadius: responsive.spacing(5),
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
                  context.tr('from_north'),
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
                    context.tr('compass_not_available'),
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
                label: Text(context.tr('open_app_settings')),
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
                label: Text(context.tr('try_again')),
              ),
            ] else ...[
              ElevatedButton.icon(
                onPressed: _initializeQibla,
                icon: const Icon(Icons.refresh),
                label: Text(context.tr('retry')),
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
                label: Text(context.tr('open_location_settings')),
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
                      context.tr('qibla_requires_location'),
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
                Text(context.tr('initializing_compass')),
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
                Text(context.tr('calibrating_compass')),
                responsive.vSpaceSmall,
                Text(
                  context.tr('calibrate_instruction'),
                  style: const TextStyle(color: Colors.grey),
                ),
                responsive.vSpaceXLarge,
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasCompass = false;
                    });
                  },
                  child: Text(context.tr('show_direction_without_compass')),
                ),
              ],
            ),
          );
        }

        _compassHeading = snapshot.data!.heading;
        final qiblaFromNorth = _qiblaDirection ?? 0;
        final compassRotation = -(_compassHeading ?? 0) * (math.pi / 180);
        final qiblaRotation = (qiblaFromNorth - (_compassHeading ?? 0)) * (math.pi / 180);

        // Check if facing Qibla (within 5 degrees)
        // Properly handle circular angle difference
        double rawDifference = qiblaFromNorth - (_compassHeading ?? 0);
        // Normalize to -180 to 180 range
        while (rawDifference > 180) {
          rawDifference -= 360;
        }
        while (rawDifference < -180) {
          rawDifference += 360;
        }
        final difference = rawDifference.abs();
        final isFacingQibla = difference < 5;

        // Responsive compass size
        final compassSize = responsive.widthPercent(80).clamp(250.0, 350.0);
        final compassInnerSize = compassSize - responsive.spacing(20);

        // Get direction translations
        final directions = [
          context.tr('north'),
          context.tr('east'),
          context.tr('south'),
          context.tr('west'),
        ];

        return SingleChildScrollView(
          padding: responsive.paddingXLarge,
          child: Column(
            children: [
              // Info Card
              _buildInfoCard(isFacingQibla),
              responsive.vSpaceXXLarge,

              // Compass
              SizedBox(
                width: compassSize,
                height: compassSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                              blurRadius: responsive.spacing(20),
                              spreadRadius: responsive.spacing(5),
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

                    // Center indicator
                    Container(
                      width: responsive.spacing(20),
                      height: responsive.spacing(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ],
                ),
              ),
              responsive.vSpaceXXLarge,

              // Direction info
              _buildDirectionInfo(qiblaFromNorth),
              responsive.vSpaceXLarge,

              // Calibration hint
              Container(
                padding: responsive.paddingRegular,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(responsive.radiusMedium),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: responsive.iconMedium),
                    SizedBox(width: responsive.spaceMedium),
                    Expanded(
                      child: Text(
                        context.tr('accurate_reading_tip'),
                        style: TextStyle(fontSize: responsive.textSmall),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(bool isFacingQibla) {
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
          Icon(
            isFacingQibla ? Icons.check_circle : Icons.explore,
            color: Colors.white,
            size: responsive.iconXXLarge,
          ),
          responsive.vSpaceMedium,
          Text(
            isFacingQibla ? context.tr('facing_qibla') : context.tr('turn_to_face_qibla'),
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.textXXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_distanceToKaaba != null) ...[
            responsive.vSpaceSmall,
            Text(
              '${context.tr('distance_to_kaaba')}: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
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
          context.tr('qibla'),
          '${qiblaDirection.toStringAsFixed(1)}°',
          Icons.mosque,
        ),
        _buildInfoItem(
          context.tr('compass'),
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
