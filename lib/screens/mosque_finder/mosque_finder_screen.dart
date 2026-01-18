import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';

class MosqueFinderScreen extends StatefulWidget {
  const MosqueFinderScreen({super.key});

  @override
  State<MosqueFinderScreen> createState() => _MosqueFinderScreenState();
}

class _MosqueFinderScreenState extends State<MosqueFinderScreen> {
  final LocationService _locationService = LocationService();
  List<MosqueModel> _mosques = [];
  bool _isLoading = true;
  String? _error;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _loadMosques();
  }

  Future<void> _loadMosques() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _currentPosition = await _locationService.getCurrentLocation();
      if (_currentPosition == null) {
        setState(() {
          _error = 'Unable to get your location. Please enable location services.';
          _isLoading = false;
        });
        return;
      }

      await _searchNearbyMosques();
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyMosques() async {
    if (_currentPosition == null) return;

    try {
      // Using Overpass API (OpenStreetMap) to find mosques
      final query = '''
        [out:json][timeout:25];
        (
          node["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          way["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["building"="mosque"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          way["building"="mosque"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        final mosques = <MosqueModel>[];
        for (final element in elements) {
          if (element['lat'] != null && element['lon'] != null) {
            final tags = element['tags'] ?? {};
            final name = tags['name'] ?? tags['name:en'] ?? 'Mosque';
            final address = _buildAddress(tags);

            final distanceInMeters = _locationService.calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              element['lat'].toDouble(),
              element['lon'].toDouble(),
            );
            final distance = distanceInMeters / 1000; // Convert to kilometers

            mosques.add(MosqueModel(
              id: element['id'].toString(),
              name: name,
              address: address,
              latitude: element['lat'].toDouble(),
              longitude: element['lon'].toDouble(),
              distance: distance,
              phone: tags['phone'] ?? tags['contact:phone'],
              website: tags['website'] ?? tags['contact:website'],
              openingHours: tags['opening_hours'],
            ));
          }
        }

        // Sort by distance
        mosques.sort((a, b) => a.distance.compareTo(b.distance));

        setState(() {
          _mosques = mosques;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch mosques');
      }
    } catch (e) {
      setState(() {
        _error = 'Could not load mosques. Please try again.';
        _isLoading = false;
      });
    }
  }

  String _buildAddress(Map<dynamic, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:street'] != null) parts.add(tags['addr:street']);
    if (tags['addr:city'] != null) parts.add(tags['addr:city']);
    if (tags['addr:postcode'] != null) parts.add(tags['addr:postcode']);
    return parts.isEmpty ? 'Address not available' : parts.join(', ');
  }

  Future<void> _openInMaps(MosqueModel mosque) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${mosque.latitude},${mosque.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callMosque(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  String _formatDistance(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toInt()} m';
    }
    return '${distance.toStringAsFixed(1)} km';
  }

  void _showMosqueDetails(MosqueModel mosque) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mosque, color: AppColors.primary, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mosque.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_formatDistance(mosque.distance)} away',
                          style: TextStyle(
                            color: AppColors.secondaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.location_on, mosque.address),
            if (mosque.openingHours != null)
              _buildDetailRow(Icons.access_time, mosque.openingHours!),
            if (mosque.phone != null)
              _buildDetailRow(Icons.phone, mosque.phone!),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openInMaps(mosque);
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Directions'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
                if (mosque.phone != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _callMosque(mosque.phone!);
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Nearby Mosques'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finding mosques near you...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadMosques,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_mosques.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No mosques found nearby',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header showing count
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                '${_mosques.length} mosques found near you',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Mosque list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadMosques,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _mosques.length,
              itemBuilder: (context, index) {
                return _buildMosqueCard(_mosques[index], index + 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMosqueCard(MosqueModel mosque, int rank) {
    const lightGreenBorder = Color(0xFF8AAF9A);
    const darkGreen = Color(0xFF0A5C36);
    const lightGreenChip = Color(0xFFE8F3ED);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showMosqueDetails(mosque),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: lightGreenChip,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Mosque icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: darkGreen,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mosque,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              // Mosque info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mosque.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mosque.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Distance badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _formatDistance(mosque.distance),
                      style: const TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _openInMaps(mosque),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E8F5A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.directions,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MosqueModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? phone;
  final String? website;
  final String? openingHours;

  MosqueModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phone,
    this.website,
    this.openingHours,
  });
}
