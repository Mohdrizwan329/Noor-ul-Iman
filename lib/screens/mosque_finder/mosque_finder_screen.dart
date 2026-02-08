import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/location_service.dart';
import '../../core/utils/app_utils.dart';
import '../../providers/language_provider.dart';
import '../../widgets/common/banner_ad_widget.dart';
import '../../core/utils/ad_list_helper.dart';

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
  String? _currentLanguage;

  // Multiple Overpass API endpoints for fallback
  final List<String> _overpassEndpoints = [
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass.openstreetmap.ru/api/interpreter',
  ];

  @override
  void initState() {
    super.initState();
    _loadMosques();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageProvider = Provider.of<LanguageProvider>(context);
    final newLanguage = languageProvider.languageCode;

    // If language changed, reload mosques with new translations
    if (_currentLanguage != null &&
        _currentLanguage != newLanguage &&
        _currentPosition != null) {
      _currentLanguage = newLanguage;
      _refreshData();
    } else {
      _currentLanguage ??= newLanguage;
    }
  }

  Future<void> _refreshData() async {
    await _loadMosques();
  }

  Future<void> _loadMosques() async {
    if (!mounted) return;

    // Get all translations and language info before any async operations
    final languageProvider = context.languageProvider;
    final enableLocationMsg = languageProvider.translate(
      'enable_location_services',
    );
    final defaultMosqueName = languageProvider.translate('mosque');
    final defaultAddress = languageProvider.translate('address_not_available');
    final errorText = languageProvider.translate('error');
    final currentLang = languageProvider.languageCode;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _currentPosition = await _locationService.getCurrentLocation();
      if (_currentPosition == null) {
        if (!mounted) return;
        setState(() {
          _error = enableLocationMsg;
          _isLoading = false;
        });
        return;
      }

      await _searchNearbyMosques(
        defaultMosqueName,
        defaultAddress,
        currentLang,
      );
    } catch (e) {
      debugPrint('Mosque Finder: Error in _loadMosques: $e');
      if (!mounted) return;
      setState(() {
        _error = '$errorText: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchNearbyMosques(
    String defaultMosqueName,
    String defaultAddress,
    String currentLang,
  ) async {
    if (_currentPosition == null) return;

    try {
      // Language code is now passed as parameter to avoid context issues

      // Map language codes to OpenStreetMap language tags
      String osmLangTag = 'name';
      if (currentLang == 'ur') {
        osmLangTag = 'name:ur';
      } else if (currentLang == 'ar') {
        osmLangTag = 'name:ar';
      } else if (currentLang == 'hi') {
        osmLangTag = 'name:hi';
      } else if (currentLang == 'en') {
        osmLangTag = 'name:en';
      }

      // Using Overpass API (OpenStreetMap) to find mosques
      // Search for nodes, ways, and relations within 5km radius
      // Increased timeout to 45 seconds for larger search area
      final query =
          '''
        [out:json][timeout:45];
        (
          node["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          way["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          relation["amenity"="place_of_worship"]["religion"="muslim"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["building"="mosque"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          way["building"="mosque"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          relation["building"="mosque"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out center;
      ''';

      debugPrint(
        'Mosque Finder: Searching for mosques near ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
      );

      // Try multiple endpoints with retry logic for reliability
      http.Response? response;
      String? lastError;
      bool success = false;

      for (
        int endpointIndex = 0;
        endpointIndex < _overpassEndpoints.length;
        endpointIndex++
      ) {
        final endpoint = _overpassEndpoints[endpointIndex];
        debugPrint(
          'Mosque Finder: Trying endpoint ${endpointIndex + 1}/${_overpassEndpoints.length}: $endpoint',
        );

        // Try each endpoint up to 2 times
        for (int attempt = 1; attempt <= 2; attempt++) {
          try {
            debugPrint('Mosque Finder: Attempt $attempt for $endpoint');

            response = await http
                .post(
                  Uri.parse(endpoint),
                  body: query,
                  headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                  },
                )
                .timeout(
                  const Duration(seconds: 60),
                  onTimeout: () {
                    throw Exception('Timeout after 60 seconds');
                  },
                );

            // Check response status
            if (response.statusCode == 200) {
              debugPrint(
                'Mosque Finder: ✓ Success with $endpoint on attempt $attempt',
              );
              success = true;
              break;
            } else if (response.statusCode == 429) {
              // Rate limited - try next endpoint immediately
              lastError = 'Server busy (rate limited)';
              debugPrint('Mosque Finder: Rate limited, trying next endpoint');
              break;
            } else if (response.statusCode == 504 ||
                response.statusCode >= 500) {
              // Server error - retry with delay
              lastError = 'Server error (${response.statusCode})';
              debugPrint('Mosque Finder: Server error ${response.statusCode}');
              if (attempt < 2) {
                await Future.delayed(Duration(seconds: attempt * 2));
              }
            } else {
              // Client error - don't retry this endpoint
              lastError = 'Request failed (${response.statusCode})';
              debugPrint('Mosque Finder: Client error ${response.statusCode}');
              break;
            }
          } catch (e) {
            lastError = e.toString();
            debugPrint(
              'Mosque Finder: Error on $endpoint attempt $attempt: $e',
            );
            if (attempt < 2) {
              // Exponential backoff before retry
              await Future.delayed(Duration(seconds: attempt * 2));
            }
          }
        }

        // If successful, break out of endpoint loop
        if (success) break;
      }

      // If all attempts failed, throw error
      if (!success || response == null || response.statusCode != 200) {
        throw Exception(lastError ?? 'All servers are currently unavailable');
      }

      // Parse successful response
      final data = json.decode(response.body);
      final elements = data['elements'] as List? ?? [];

      debugPrint('Mosque Finder: Found ${elements.length} elements from API');

      final mosques = <MosqueModel>[];
      final processedIds = <String>{};
      final processedCoords = <String>{};
      int skippedNoTags = 0;
      int skippedDuplicates = 0;
      int skippedNoCoords = 0;

      for (final element in elements) {
        final tags = element['tags'];
        final elementType = element['type'];
        final id = element['id'].toString();

        // Skip elements without tags (these are way nodes, not actual POIs)
        if (tags == null || tags.isEmpty) {
          skippedNoTags++;
          continue;
        }

        // Get lat/lon - handle both nodes and ways
        double? lat;
        double? lon;

        if (element['lat'] != null && element['lon'] != null) {
          // Node element
          lat = element['lat'].toDouble();
          lon = element['lon'].toDouble();
        } else if (element['center'] != null) {
          // Way element with center
          lat = element['center']['lat']?.toDouble();
          lon = element['center']['lon']?.toDouble();
        }

        // Skip if no coordinates available
        if (lat == null || lon == null) {
          skippedNoCoords++;
          final name = tags['name'] ?? tags['name:en'] ?? 'Unknown';
          debugPrint(
            'Mosque Finder: Skipped $elementType $id "$name" - no coordinates (has center: ${element['center'] != null})',
          );
          continue;
        }

        // Create composite key using element type + ID (OSM IDs are unique per type)
        final compositeId = '$elementType:$id';

        // Create coordinate key rounded to 5 decimal places (~1 meter precision)
        final coordKey = '${lat.toStringAsFixed(5)},${lon.toStringAsFixed(5)}';

        // Skip if we've already processed this element (by composite ID or coordinates)
        if (processedIds.contains(compositeId) ||
            processedCoords.contains(coordKey)) {
          skippedDuplicates++;
          debugPrint(
            'Mosque Finder: Skipped duplicate - type=$elementType, id=$id, coords=$coordKey',
          );
          continue;
        }

        processedIds.add(compositeId);
        processedCoords.add(coordKey);

        // Try to get name in current language, fallback to default languages
        final rawName =
            tags[osmLangTag] ??
            tags['name:$currentLang'] ??
            tags['name'] ??
            tags['name:en'] ??
            defaultMosqueName;

        // Transliterate name if not in English
        final name = currentLang == 'en'
            ? rawName
            : _transliterateName(rawName, currentLang);

        final distanceInMeters = _locationService.calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          lat,
          lon,
        );
        final distance = distanceInMeters / 1000; // Convert to kilometers

        final mosqueAddress = _buildAddress(tags, defaultAddress, currentLang);
        final mosque = MosqueModel(
          id: id,
          name: name,
          address: mosqueAddress,
          latitude: lat,
          longitude: lon,
          distance: distance,
          phone: tags['phone'] ?? tags['contact:phone'],
          website: tags['website'] ?? tags['contact:website'],
          openingHours: tags['opening_hours'],
        );

        debugPrint(
          'Adding mosque: name="$name", address="$mosqueAddress", distance=${distance.toStringAsFixed(2)}km',
        );
        mosques.add(mosque);
      }

      // Remove duplicates based on name and proximity (within 100 meters)
      final uniqueMosques = <MosqueModel>[];
      final seenMosques = <String, MosqueModel>{};

      for (final mosque in mosques) {
        // Create a key based on name and rounded distance (to nearest 100m)
        final distanceKey =
            (mosque.distance * 10).round() / 10; // Round to 0.1km
        final key = '${mosque.name.toLowerCase()}_$distanceKey';

        if (!seenMosques.containsKey(key)) {
          seenMosques[key] = mosque;
          uniqueMosques.add(mosque);
        } else {
          // If we already have a mosque with this name at this distance,
          // keep the one with more information (has address, phone, etc.)
          final existing = seenMosques[key]!;
          final hasMoreInfo =
              (mosque.address != defaultAddress &&
                  existing.address == defaultAddress) ||
              (mosque.phone != null && existing.phone == null) ||
              (mosque.website != null && existing.website == null);

          if (hasMoreInfo) {
            // Replace with the one that has more information
            uniqueMosques.remove(existing);
            uniqueMosques.add(mosque);
            seenMosques[key] = mosque;
            debugPrint(
              'Mosque Finder: Replaced duplicate "$key" with more detailed version',
            );
          } else {
            debugPrint('Mosque Finder: Skipped duplicate "$key"');
          }
        }
      }

      debugPrint(
        'Mosque Finder: After deduplication: ${uniqueMosques.length} unique mosques',
      );

      // Sort by distance
      uniqueMosques.sort((a, b) => a.distance.compareTo(b.distance));

      debugPrint('Mosque Finder: Processing Summary:');
      debugPrint('  - Total elements from API: ${elements.length}');
      debugPrint('  - Skipped (no tags): $skippedNoTags');
      debugPrint('  - Skipped (duplicates by ID/coords): $skippedDuplicates');
      debugPrint('  - Skipped (no coordinates): $skippedNoCoords');
      debugPrint('  - Initially processed: ${mosques.length} mosques');
      debugPrint(
        '  - After name/distance dedup: ${uniqueMosques.length} unique mosques',
      );

      if (!mounted) return;
      setState(() {
        _mosques = uniqueMosques;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Mosque Finder Error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Provide user-friendly error messages
      String userFriendlyError;
      if (e.toString().contains('Timeout')) {
        userFriendlyError =
            'Connection timeout. Please check your internet and try again.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Network')) {
        userFriendlyError =
            'No internet connection. Please check your network.';
      } else if (e.toString().contains('rate limited')) {
        userFriendlyError =
            'Service is busy. Please wait a moment and try again.';
      } else if (e.toString().contains('Server error')) {
        userFriendlyError = 'Server temporarily unavailable. Please try again.';
      } else if (e.toString().contains('unavailable')) {
        userFriendlyError =
            'Service temporarily unavailable. Pull down to retry.';
      } else {
        userFriendlyError = 'Unable to load mosques. Pull down to retry.';
      }

      if (!mounted) return;
      setState(() {
        _error = userFriendlyError;
        _isLoading = false;
      });
    }
  }

  String _transliterateName(String name, String currentLang) {
    // If already in target language, return as is
    if (name.contains('मस्जिद') || name.contains('مسجد')) {
      return name;
    }

    // Replace English word "Mosque" with target language equivalent
    String translatedName = name;
    if (currentLang == 'hi') {
      translatedName = translatedName
          .replaceAll('Mosque', 'मस्जिद')
          .replaceAll('mosque', 'मस्जिद')
          .replaceAll('MOSQUE', 'मस्जिद')
          .replaceAll('Masjid', 'मस्जिद')
          .replaceAll('masjid', 'मस्जिद');
    } else if (currentLang == 'ur') {
      translatedName = translatedName
          .replaceAll('Mosque', 'مسجد')
          .replaceAll('mosque', 'مسجد')
          .replaceAll('MOSQUE', 'مسجد')
          .replaceAll('Masjid', 'مسجد')
          .replaceAll('masjid', 'مسجد');
    } else if (currentLang == 'ar') {
      translatedName = translatedName
          .replaceAll('Mosque', 'مسجد')
          .replaceAll('mosque', 'مسجد')
          .replaceAll('MOSQUE', 'مسجد')
          .replaceAll('Masjid', 'مسجد')
          .replaceAll('masjid', 'مسجد');
    }

    // Simple transliteration maps for common letters
    if (currentLang == 'hi') {
      // First replace common English words in mosque names
      translatedName = translatedName
          .replaceAll('Town', 'टाउन')
          .replaceAll('town', 'टाउन')
          .replaceAll('City', 'शहर')
          .replaceAll('city', 'शहर')
          .replaceAll('Central', 'केंद्रीय')
          .replaceAll('central', 'केंद्रीय')
          .replaceAll('Grand', 'बड़ी')
          .replaceAll('grand', 'बड़ी')
          .replaceAll('Jamia', 'जामिआ')
          .replaceAll('Jama', 'जामा')
          .replaceAll('Islamic', 'इस्लामिक')
          .replaceAll('islamic', 'इस्लामिक')
          .replaceAll('Main', 'मुख्य')
          .replaceAll('main', 'मुख्य');

      return translatedName
          .replaceAll('A', 'ए')
          .replaceAll('B', 'बी')
          .replaceAll('C', 'सी')
          .replaceAll('D', 'डी')
          .replaceAll('E', 'ई')
          .replaceAll('F', 'एफ')
          .replaceAll('G', 'जी')
          .replaceAll('H', 'एच')
          .replaceAll('I', 'आई')
          .replaceAll('J', 'जे')
          .replaceAll('K', 'के')
          .replaceAll('L', 'एल')
          .replaceAll('M', 'एम')
          .replaceAll('N', 'एन')
          .replaceAll('O', 'ओ')
          .replaceAll('P', 'पी')
          .replaceAll('Q', 'क्यू')
          .replaceAll('R', 'आर')
          .replaceAll('S', 'एस')
          .replaceAll('T', 'टी')
          .replaceAll('U', 'यू')
          .replaceAll('V', 'वी')
          .replaceAll('W', 'डब्ल्यू')
          .replaceAll('X', 'एक्स')
          .replaceAll('Y', 'वाई')
          .replaceAll('Z', 'जेड')
          .replaceAll('a', 'अ')
          .replaceAll('b', 'ब')
          .replaceAll('c', 'क')
          .replaceAll('d', 'ड')
          .replaceAll('e', 'ई')
          .replaceAll('f', 'फ')
          .replaceAll('g', 'ग')
          .replaceAll('h', 'ह')
          .replaceAll('i', 'इ')
          .replaceAll('j', 'ज')
          .replaceAll('k', 'क')
          .replaceAll('l', 'ल')
          .replaceAll('m', 'म')
          .replaceAll('n', 'न')
          .replaceAll('o', 'ओ')
          .replaceAll('p', 'प')
          .replaceAll('q', 'क')
          .replaceAll('r', 'र')
          .replaceAll('s', 'स')
          .replaceAll('t', 'त')
          .replaceAll('u', 'उ')
          .replaceAll('v', 'व')
          .replaceAll('w', 'व')
          .replaceAll('x', 'क्स')
          .replaceAll('y', 'य')
          .replaceAll('z', 'ज');
    } else if (currentLang == 'ur') {
      // First replace common English words in mosque names
      translatedName = translatedName
          .replaceAll('Town', 'ٹاؤن')
          .replaceAll('town', 'ٹاؤن')
          .replaceAll('City', 'شہر')
          .replaceAll('city', 'شہر')
          .replaceAll('Central', 'مرکزی')
          .replaceAll('central', 'مرکزی')
          .replaceAll('Grand', 'بڑی')
          .replaceAll('grand', 'بڑی')
          .replaceAll('Jamia', 'جامعہ')
          .replaceAll('Jama', 'جامع')
          .replaceAll('Islamic', 'اسلامی')
          .replaceAll('islamic', 'اسلامی')
          .replaceAll('Main', 'مرکزی')
          .replaceAll('main', 'مرکزی');

      return translatedName
          .replaceAll('A', 'اے')
          .replaceAll('B', 'بی')
          .replaceAll('C', 'سی')
          .replaceAll('D', 'ڈی')
          .replaceAll('E', 'ای')
          .replaceAll('F', 'ایف')
          .replaceAll('G', 'جی')
          .replaceAll('H', 'ایچ')
          .replaceAll('I', 'آئی')
          .replaceAll('J', 'جے')
          .replaceAll('K', 'کے')
          .replaceAll('L', 'ایل')
          .replaceAll('M', 'ایم')
          .replaceAll('N', 'این')
          .replaceAll('O', 'او')
          .replaceAll('P', 'پی')
          .replaceAll('Q', 'کیو')
          .replaceAll('R', 'آر')
          .replaceAll('S', 'ایس')
          .replaceAll('T', 'ٹی')
          .replaceAll('U', 'یو')
          .replaceAll('V', 'وی')
          .replaceAll('W', 'ڈبلیو')
          .replaceAll('X', 'ایکس')
          .replaceAll('Y', 'وائی')
          .replaceAll('Z', 'زیڈ');
    } else if (currentLang == 'ar') {
      // First replace common English words in mosque names
      translatedName = translatedName
          .replaceAll('Town', 'بلدة')
          .replaceAll('town', 'بلدة')
          .replaceAll('City', 'مدينة')
          .replaceAll('city', 'مدينة')
          .replaceAll('Central', 'مركزي')
          .replaceAll('central', 'مركزي')
          .replaceAll('Grand', 'كبير')
          .replaceAll('grand', 'كبير')
          .replaceAll('Jamia', 'جامع')
          .replaceAll('Jama', 'جامع')
          .replaceAll('Islamic', 'إسلامي')
          .replaceAll('islamic', 'إسلامي')
          .replaceAll('Main', 'رئيسي')
          .replaceAll('main', 'رئيسي');

      return translatedName
          .replaceAll('A', 'ا')
          .replaceAll('B', 'ب')
          .replaceAll('C', 'س')
          .replaceAll('D', 'د')
          .replaceAll('E', 'ي')
          .replaceAll('F', 'ف')
          .replaceAll('G', 'ج')
          .replaceAll('H', 'ه')
          .replaceAll('I', 'ي')
          .replaceAll('J', 'ج')
          .replaceAll('K', 'ك')
          .replaceAll('L', 'ل')
          .replaceAll('M', 'م')
          .replaceAll('N', 'ن')
          .replaceAll('O', 'و')
          .replaceAll('P', 'ب')
          .replaceAll('Q', 'ق')
          .replaceAll('R', 'ر')
          .replaceAll('S', 'س')
          .replaceAll('T', 'ت')
          .replaceAll('U', 'و')
          .replaceAll('V', 'ف')
          .replaceAll('W', 'و')
          .replaceAll('X', 'كس')
          .replaceAll('Y', 'ي')
          .replaceAll('Z', 'ز');
    }

    return translatedName; // Return translated name for all languages
  }

  String _buildAddress(
    Map<dynamic, dynamic> tags,
    String defaultAddress,
    String currentLang,
  ) {
    final parts = <String>[];

    // Try to get street name in current language
    final street = tags['addr:street:$currentLang'] ?? tags['addr:street'];
    if (street != null) {
      parts.add(
        currentLang == 'en' ? street : _transliterateName(street, currentLang),
      );
    }

    // Try to get city name in current language
    final city = tags['addr:city:$currentLang'] ?? tags['addr:city'];
    if (city != null) {
      parts.add(
        currentLang == 'en' ? city : _transliterateName(city, currentLang),
      );
    }

    // Postcode doesn't need translation
    if (tags['addr:postcode'] != null) parts.add(tags['addr:postcode']);

    return parts.isEmpty ? defaultAddress : parts.join(', ');
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
      return '${(distance * 1000).toInt()} ${context.tr('unit_m')}';
    }
    return '${distance.toStringAsFixed(1)} ${context.tr('unit_km')}';
  }

  void _showMosqueDetails(MosqueModel mosque) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.responsive.radiusLarge),
        ),
      ),
      builder: (context) {
        final responsive = context.responsive;
        return Container(
          padding: responsive.paddingLarge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: responsive.spacing(40),
                  height: responsive.spacing(4),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(responsive.radiusSmall),
                  ),
                ),
              ),
              responsive.vSpaceLarge,
              Row(
                children: [
                  Container(
                    padding: responsive.paddingMedium,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                    ),
                    child: Icon(
                      Icons.mosque,
                      color: AppColors.primary,
                      size: responsive.iconLarge,
                    ),
                  ),
                  SizedBox(width: responsive.spaceRegular),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mosque.name,
                          style: TextStyle(
                            fontSize: responsive.textLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: responsive.spaceXSmall),
                        Container(
                          padding: responsive.paddingSymmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              responsive.radiusMedium,
                            ),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_formatDistance(mosque.distance)} ${context.tr('away')}',
                              style: TextStyle(
                                color: AppColors.secondaryDark,
                                fontWeight: FontWeight.w600,
                                fontSize: responsive.textSmall,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              responsive.vSpaceLarge,
              _buildDetailRow(Icons.location_on, mosque.address),
              if (mosque.openingHours != null)
                _buildDetailRow(Icons.access_time, mosque.openingHours!),
              if (mosque.phone != null)
                _buildDetailRow(Icons.phone, mosque.phone!),
              responsive.vSpaceLarge,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openInMaps(mosque);
                      },
                      icon: const Icon(Icons.directions),
                      label: Text(context.tr('directions')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: responsive.paddingSymmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  if (mosque.phone != null) ...[
                    SizedBox(width: responsive.spaceMedium),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _callMosque(mosque.phone!);
                        },
                        icon: const Icon(Icons.phone),
                        label: Text(context.tr('call')),
                        style: OutlinedButton.styleFrom(
                          padding: responsive.paddingSymmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              responsive.vSpaceSmall,
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    final responsive = context.responsive;
    return Padding(
      padding: responsive.paddingOnly(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: responsive.spacing(2)),
            child: Icon(
              icon,
              size: responsive.iconSmall,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: responsive.spaceMedium),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: responsive.textMedium,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to language changes to rebuild UI
    context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(context.tr('mosque_finder')),
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          const BannerAdWidget(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final responsive = context.responsive;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            responsive.vSpaceRegular,
            Text(
              context.tr('finding_mosques'),
              style: TextStyle(fontSize: responsive.textMedium),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: responsive.paddingXLarge,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: responsive.iconHuge,
                color: Colors.grey,
              ),
              responsive.vSpaceRegular,
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: responsive.textMedium,
                ),
              ),
              responsive.vSpaceXLarge,
              ElevatedButton.icon(
                onPressed: _loadMosques,
                icon: const Icon(Icons.refresh),
                label: Text(context.tr('try_again')),
              ),
            ],
          ),
        ),
      );
    }

    if (_mosques.isEmpty) {
      debugPrint('Mosque Finder UI: Showing empty state');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mosque, size: responsive.iconHuge, color: Colors.grey),
            responsive.vSpaceRegular,
            Text(
              context.tr('no_mosques_found'),
              style: TextStyle(
                color: Colors.grey,
                fontSize: responsive.textMedium,
              ),
            ),
          ],
        ),
      );
    }

    debugPrint('Mosque Finder UI: Showing ${_mosques.length} mosques in list');
    return Column(
      children: [
        // Header showing count
        Container(
          padding: responsive.paddingRegular,
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: responsive.iconSmall,
              ),
              SizedBox(width: responsive.spaceSmall),
              Text(
                '${_mosques.length} ${context.tr('mosques_found')}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: responsive.textMedium,
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
              padding: responsive.paddingSymmetric(horizontal: 16),
              itemCount: AdListHelper.totalCount(_mosques.length),
              itemBuilder: (context, index) {
                if (AdListHelper.isAdPosition(index)) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: BannerAdWidget(height: 250),
                  );
                }
                final dataIdx = AdListHelper.dataIndex(index);
                return _buildMosqueCard(_mosques[dataIdx], dataIdx + 1);
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
    final responsive = context.responsive;

    debugPrint(
      'Building mosque card #$rank: ${mosque.name}, ${mosque.address}, ${mosque.distance}km',
    );

    return Container(
      margin: responsive.paddingOnly(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        border: Border.all(color: lightGreenBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withValues(alpha: 0.08),
            blurRadius: 10.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showMosqueDetails(mosque),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingRegular,
          child: Row(
            children: [
              // Rank number
              // Mosque icon
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.mosque,
                  color: Colors.white,
                  size: responsive.iconMedium,
                ),
              ),
              SizedBox(width: responsive.spaceMedium),
              // Mosque info
              Expanded(
                child: Text(
                  mosque.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.fontSize(15),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: responsive.spaceSmall),
              // Distance badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: responsive.paddingSymmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(
                        responsive.radiusLarge,
                      ),
                    ),
                    child: Text(
                      _formatDistance(mosque.distance),
                      style: TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.w600,
                        fontSize: responsive.textSmall,
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
