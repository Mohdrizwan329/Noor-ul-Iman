import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/qibla_calculator.dart';
import '../../core/services/location_service.dart';

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
    _initializeQibla();
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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
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
        _error = 'Unable to get location. Please enable location services and grant permission.';
      }
    } catch (e) {
      _error = 'Location error: ${e.toString()}';
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Qibla Direction'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Info Card with Qibla direction
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.mosque,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Qibla Direction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_distanceToKaaba != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Distance to Kaaba: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Direction display without compass
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.explore,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  '${(_qiblaDirection ?? 0).toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'from North',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // No compass warning
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Compass not available on this device. Use the degree value above with an external compass or map.',
                    style: TextStyle(fontSize: 12),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeQibla,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Open Location Settings'),
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
        if (snapshot.hasError) {
          // Compass error - show fallback with degree only
          return _buildNoCompassWidget();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing compass...'),
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
                const SizedBox(height: 16),
                const Text('Calibrating compass...'),
                const SizedBox(height: 8),
                const Text(
                  'Move your phone in a figure-8 pattern',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasCompass = false;
                    });
                  },
                  child: const Text('Show direction without compass'),
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
        final difference = ((qiblaFromNorth - (_compassHeading ?? 0)) % 360).abs();
        final isFacingQibla = difference < 5 || difference > 355;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Info Card
              _buildInfoCard(isFacingQibla),
              const SizedBox(height: 32),

              // Compass
              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Compass background
                    Transform.rotate(
                      angle: compassRotation,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CustomPaint(
                          painter: CompassPainter(),
                        ),
                      ),
                    ),

                    // Qibla indicator
                    Transform.rotate(
                      angle: qiblaRotation,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isFacingQibla
                                  ? AppColors.success
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mosque,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 100,
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
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Direction info
              _buildDirectionInfo(qiblaFromNorth),
              const SizedBox(height: 24),

              // Calibration hint
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'For accurate readings, keep your phone flat and away from magnetic objects.',
                        style: TextStyle(fontSize: 12),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isFacingQibla
            ? const LinearGradient(
                colors: [AppColors.success, Color(0xFF81C784)],
              )
            : AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            isFacingQibla ? Icons.check_circle : Icons.explore,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isFacingQibla ? 'Facing Qibla' : 'Turn to Face Qibla',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_distanceToKaaba != null) ...[
            const SizedBox(height: 8),
            Text(
              'Distance to Kaaba: ${QiblaCalculator.formatDistance(_distanceToKaaba!)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
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
          'Qibla',
          '${qiblaDirection.toStringAsFixed(1)}°',
          Icons.mosque,
        ),
        _buildInfoItem(
          'Compass',
          '${(_compassHeading ?? 0).toStringAsFixed(1)}°',
          Icons.explore,
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw compass circle
    final circlePaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 20, circlePaint);
    canvas.drawCircle(center, radius - 50, circlePaint);

    // Draw direction markers
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final directions = ['N', 'E', 'S', 'W'];
    final colors = [Colors.red, Colors.grey, Colors.grey, Colors.grey];

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2 - math.pi / 2;
      final x = center.dx + (radius - 35) * math.cos(angle);
      final y = center.dy + (radius - 35) * math.sin(angle);

      textPainter.text = TextSpan(
        text: directions[i],
        style: TextStyle(
          color: colors[i],
          fontSize: 18,
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

      final innerRadius = radius - (isMain ? 60 : (isMedium ? 55 : 50));
      final outerRadius = radius - 45;

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
