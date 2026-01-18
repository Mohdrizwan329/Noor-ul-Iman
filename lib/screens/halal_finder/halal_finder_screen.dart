import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';

class HalalFinderScreen extends StatefulWidget {
  const HalalFinderScreen({super.key});

  @override
  State<HalalFinderScreen> createState() => _HalalFinderScreenState();
}

class _HalalFinderScreenState extends State<HalalFinderScreen>
    with SingleTickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  late TabController _tabController;
  List<HalalPlaceModel> _restaurants = [];
  List<HalalPlaceModel> _groceries = [];
  bool _isLoading = true;
  String? _error;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPlaces();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPlaces() async {
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

      await Future.wait([
        _searchHalalRestaurants(),
        _searchHalalGroceries(),
      ]);
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchHalalRestaurants() async {
    if (_currentPosition == null) return;

    try {
      final query = '''
        [out:json][timeout:25];
        (
          node["amenity"="restaurant"]["cuisine"~"halal|muslim|arabic|turkish|pakistani|indian|middle_eastern"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["amenity"="fast_food"]["cuisine"~"halal|muslim|arabic|turkish|pakistani|indian|middle_eastern"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["diet:halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out body;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        final restaurants = <HalalPlaceModel>[];
        for (final element in elements) {
          if (element['lat'] != null && element['lon'] != null) {
            final tags = element['tags'] ?? {};
            final name = tags['name'] ?? tags['name:en'] ?? 'Halal Restaurant';

            final distanceInMeters = _locationService.calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              element['lat'].toDouble(),
              element['lon'].toDouble(),
            );
            final distance = distanceInMeters / 1000;

            restaurants.add(HalalPlaceModel(
              id: element['id'].toString(),
              name: name,
              type: HalalPlaceType.restaurant,
              cuisine: tags['cuisine'] ?? 'Halal',
              address: _buildAddress(tags),
              latitude: element['lat'].toDouble(),
              longitude: element['lon'].toDouble(),
              distance: distance,
              phone: tags['phone'] ?? tags['contact:phone'],
              website: tags['website'],
              openingHours: tags['opening_hours'],
              isHalalCertified: tags['diet:halal'] == 'yes' || tags['halal'] == 'yes',
            ));
          }
        }

        restaurants.sort((a, b) => a.distance.compareTo(b.distance));

        setState(() {
          _restaurants = restaurants;
        });
      }
    } catch (e) {
      debugPrint('Error searching restaurants: $e');
    }
  }

  Future<void> _searchHalalGroceries() async {
    if (_currentPosition == null) return;

    try {
      final query = '''
        [out:json][timeout:25];
        (
          node["shop"="butcher"]["halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="supermarket"]["halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="convenience"]["halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="grocery"]["halal"="yes"](around:10000,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out body;
      ''';

      final response = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        body: query,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        final groceries = <HalalPlaceModel>[];
        for (final element in elements) {
          if (element['lat'] != null && element['lon'] != null) {
            final tags = element['tags'] ?? {};
            final name = tags['name'] ?? tags['name:en'] ?? 'Halal Store';

            final distanceInMeters = _locationService.calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              element['lat'].toDouble(),
              element['lon'].toDouble(),
            );
            final distance = distanceInMeters / 1000;

            groceries.add(HalalPlaceModel(
              id: element['id'].toString(),
              name: name,
              type: HalalPlaceType.grocery,
              cuisine: tags['shop'] ?? 'Grocery',
              address: _buildAddress(tags),
              latitude: element['lat'].toDouble(),
              longitude: element['lon'].toDouble(),
              distance: distance,
              phone: tags['phone'] ?? tags['contact:phone'],
              website: tags['website'],
              openingHours: tags['opening_hours'],
              isHalalCertified: true,
            ));
          }
        }

        groceries.sort((a, b) => a.distance.compareTo(b.distance));

        setState(() {
          _groceries = groceries;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error searching groceries: $e');
      setState(() {
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

  Future<void> _openInMaps(HalalPlaceModel place) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPlace(String phone) async {
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

  void _showPlaceDetails(HalalPlaceModel place) {
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
                  child: Icon(
                    place.type == HalalPlaceType.restaurant
                        ? Icons.restaurant
                        : Icons.store,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              place.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (place.isHalalCertified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Colors.green, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'HALAL',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              place.cuisine,
                              style: TextStyle(
                                color: AppColors.secondaryDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_formatDistance(place.distance)} away',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.location_on, place.address),
            if (place.openingHours != null)
              _buildDetailRow(Icons.access_time, place.openingHours!),
            if (place.phone != null)
              _buildDetailRow(Icons.phone, place.phone!),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _openInMaps(place);
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
                if (place.phone != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _callPlace(place.phone!);
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
        toolbarHeight: 50,
        title: const Text('Halal Finder'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Restaurants'),
            Tab(text: 'Grocery'),
          ],
        ),
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
            Text('Finding halal places near you...'),
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
                onPressed: _loadPlaces,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildPlacesList(_restaurants, 'restaurants'),
        _buildPlacesList(_groceries, 'grocery stores'),
      ],
    );
  }

  Widget _buildPlacesList(List<HalalPlaceModel> places, String type) {
    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'restaurants' ? Icons.restaurant : Icons.store,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No halal $type found nearby',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Try expanding your search area',
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                '${places.length} halal $type found',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadPlaces,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: places.length,
              itemBuilder: (context, index) {
                return _buildPlaceCard(places[index], index + 1);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceCard(HalalPlaceModel place, int rank) {
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
        onTap: () => _showPlaceDetails(place),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: lightGreenChip,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
                child: Icon(
                  place.type == HalalPlaceType.restaurant
                      ? Icons.restaurant
                      : Icons.store,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (place.isHalalCertified)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'HALAL',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      place.address,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatDistance(place.distance),
                      style: const TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () => _openInMaps(place),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E8F5A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.directions,
                        color: Colors.white,
                        size: 16,
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

enum HalalPlaceType { restaurant, grocery }

class HalalPlaceModel {
  final String id;
  final String name;
  final HalalPlaceType type;
  final String cuisine;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;
  final String? phone;
  final String? website;
  final String? openingHours;
  final bool isHalalCertified;

  HalalPlaceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.cuisine,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    this.phone,
    this.website,
    this.openingHours,
    this.isHalalCertified = false,
  });
}
