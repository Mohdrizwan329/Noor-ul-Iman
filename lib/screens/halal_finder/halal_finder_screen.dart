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

class HalalFinderScreen extends StatefulWidget {
  const HalalFinderScreen({super.key});

  @override
  State<HalalFinderScreen> createState() => _HalalFinderScreenState();
}

class _HalalFinderScreenState extends State<HalalFinderScreen> {
  final LocationService _locationService = LocationService();
  List<HalalPlaceModel> _allPlaces = [];
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
    _loadPlaces();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageProvider = Provider.of<LanguageProvider>(context);
    final newLanguage = languageProvider.languageCode;

    // If language changed, reload places with new translations
    if (_currentLanguage != null &&
        _currentLanguage != newLanguage &&
        _currentPosition != null) {
      _currentLanguage = newLanguage;
      _refreshData();
    } else {
      _currentLanguage ??= newLanguage;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    if (!mounted) return;

    // Get all translations before any async operations using listen: false
    final languageProvider = context.languageProvider;
    final enableLocationMsg = languageProvider.translate(
      'enable_location_services',
    );
    final defaultRestaurantName = languageProvider.translate(
      'halal_restaurant',
    );
    final defaultStoreName = languageProvider.translate('halal_store');
    final defaultAddress = languageProvider.translate('address_not_available');
    final defaultCuisine = languageProvider.translate('halal');
    final errorText = languageProvider.translate('error');

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

      await _searchHalalPlaces(
        defaultRestaurantName,
        defaultStoreName,
        defaultAddress,
        defaultCuisine,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = '$errorText: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchHalalPlaces(
    String defaultRestaurantName,
    String defaultStoreName,
    String defaultAddress,
    String defaultCuisine,
  ) async {
    if (_currentPosition == null) return;

    try {
      // Get current language code for fetching localized names
      final languageProvider = context.languageProvider;
      final currentLang = languageProvider.languageCode;

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

      // Combined query for both restaurants and groceries
      // Search within 5km radius with 45 second timeout
      final query =
          '''
        [out:json][timeout:45];
        (
          node["amenity"="restaurant"]["cuisine"~"halal|muslim|arabic|turkish|pakistani|indian|middle_eastern"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["amenity"="fast_food"]["cuisine"~"halal|muslim|arabic|turkish|pakistani|indian|middle_eastern"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["diet:halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="butcher"]["halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="supermarket"]["halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="convenience"]["halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
          node["shop"="grocery"]["halal"="yes"](around:5000,${_currentPosition!.latitude},${_currentPosition!.longitude});
        );
        out body;
      ''';

      debugPrint(
        'Halal Finder: Searching near ${_currentPosition!.latitude}, ${_currentPosition!.longitude}',
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
          'Halal Finder: Trying endpoint ${endpointIndex + 1}/${_overpassEndpoints.length}: $endpoint',
        );

        // Try each endpoint up to 2 times
        for (int attempt = 1; attempt <= 2; attempt++) {
          try {
            debugPrint('Halal Finder: Attempt $attempt for $endpoint');

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
                'Halal Finder: ✓ Success with $endpoint on attempt $attempt',
              );
              success = true;
              break;
            } else if (response.statusCode == 429) {
              // Rate limited - try next endpoint immediately
              lastError = 'Server busy (rate limited)';
              debugPrint('Halal Finder: Rate limited, trying next endpoint');
              break;
            } else if (response.statusCode == 504 ||
                response.statusCode >= 500) {
              // Server error - retry with delay
              lastError = 'Server error (${response.statusCode})';
              debugPrint('Halal Finder: Server error ${response.statusCode}');
              if (attempt < 2) {
                await Future.delayed(Duration(seconds: attempt * 2));
              }
            } else {
              // Client error - don't retry this endpoint
              lastError = 'Request failed (${response.statusCode})';
              debugPrint('Halal Finder: Client error ${response.statusCode}');
              break;
            }
          } catch (e) {
            lastError = e.toString();
            debugPrint('Halal Finder: Error on $endpoint attempt $attempt: $e');
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final elements = data['elements'] as List? ?? [];

        final places = <HalalPlaceModel>[];
        for (final element in elements) {
          if (element['lat'] != null && element['lon'] != null) {
            final tags = element['tags'] ?? {};

            // Determine if it's a restaurant or grocery
            final isRestaurant =
                tags['amenity'] == 'restaurant' ||
                tags['amenity'] == 'fast_food';
            final isGrocery = tags['shop'] != null;

            // Try to get name in current language, fallback to default languages
            final rawName =
                tags[osmLangTag] ??
                tags['name:$currentLang'] ??
                tags['name'] ??
                tags['name:en'] ??
                (isRestaurant ? defaultRestaurantName : defaultStoreName);

            // Transliterate name if not in English
            final name = currentLang == 'en'
                ? rawName
                : _transliterateName(rawName, currentLang);

            final distanceInMeters = _locationService.calculateDistance(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              element['lat'].toDouble(),
              element['lon'].toDouble(),
            );
            final distance = distanceInMeters / 1000;

            places.add(
              HalalPlaceModel(
                id: element['id'].toString(),
                name: name,
                type: isRestaurant
                    ? HalalPlaceType.restaurant
                    : HalalPlaceType.grocery,
                cuisine: tags['cuisine'] ?? tags['shop'] ?? defaultCuisine,
                address: _buildAddress(tags, defaultAddress, currentLang),
                latitude: element['lat'].toDouble(),
                longitude: element['lon'].toDouble(),
                distance: distance,
                phone: tags['phone'] ?? tags['contact:phone'],
                website: tags['website'],
                openingHours: tags['opening_hours'],
                isHalalCertified:
                    tags['diet:halal'] == 'yes' ||
                    tags['halal'] == 'yes' ||
                    isGrocery,
              ),
            );
          }
        }

        places.sort((a, b) => a.distance.compareTo(b.distance));

        if (!mounted) return;
        setState(() {
          _allPlaces = places;
          _isLoading = false;
        });
      } else {
        debugPrint('API returned status code: ${response.statusCode}');
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Halal Finder Error: $e');
      debugPrint('Stack trace: $stackTrace');

      // Provide user-friendly error messages (translated via Firebase)
      String userFriendlyError;
      if (e.toString().contains('Timeout')) {
        userFriendlyError = context.trRead('connection_timeout');
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Network')) {
        userFriendlyError = context.trRead('no_internet_connection');
      } else if (e.toString().contains('rate limited')) {
        userFriendlyError = context.trRead('service_busy');
      } else if (e.toString().contains('Server error')) {
        userFriendlyError = context.trRead('server_unavailable');
      } else if (e.toString().contains('unavailable')) {
        userFriendlyError = context.trRead('service_unavailable');
      } else {
        userFriendlyError = context.trRead('unable_to_load_halal');
      }

      if (!mounted) return;
      setState(() {
        _error = userFriendlyError;
        _isLoading = false;
      });
    }
  }

  String _translateCuisine(String cuisine) {
    // Split by semicolon or comma to handle multiple cuisines
    final parts = cuisine.split(RegExp(r'[;,]'));
    final translatedParts = <String>[];

    for (final part in parts) {
      final trimmed = part.trim().toLowerCase();
      // Try to translate known cuisine types
      if (trimmed == 'indian' ||
          trimmed == 'pakistani' ||
          trimmed == 'turkish' ||
          trimmed == 'muslim' ||
          trimmed == 'middle_eastern' ||
          trimmed == 'butcher' ||
          trimmed == 'supermarket' ||
          trimmed == 'convenience' ||
          trimmed == 'halal' ||
          trimmed == 'arabic') {
        translatedParts.add(context.tr(trimmed));
      } else {
        // If not a known type, keep original
        translatedParts.add(part.trim());
      }
    }

    return translatedParts.join(';');
  }

  String _translateOpeningHours(String hours) {
    // Translate day abbreviations in opening hours
    String translated = hours;

    // Map of day abbreviations to translation keys
    final dayMap = {
      'Su': 'day_su',
      'Mo': 'day_mo',
      'Tu': 'day_tu',
      'We': 'day_we',
      'Th': 'day_th',
      'Fr': 'day_fr',
      'Sa': 'day_sa',
    };

    // Replace each day abbreviation with its translation
    dayMap.forEach((abbr, key) {
      translated = translated.replaceAll(abbr, context.tr(key));
    });

    return translated;
  }

  String _transliterateName(String name, String currentLang) {
    // If already in target language, return as is
    if (name.contains('रेस्टोरेंट') ||
        name.contains('ریستوراں') ||
        name.contains('مطعم') ||
        name.contains('स्टोर') ||
        name.contains('اسٹور') ||
        name.contains('متجر')) {
      return name;
    }

    // Replace English words with target language equivalent
    String translatedName = name;
    if (currentLang == 'hi') {
      translatedName = translatedName
          .replaceAll('Restaurant', 'रेस्टोरेंट')
          .replaceAll('restaurant', 'रेस्टोरेंट')
          .replaceAll('RESTAURANT', 'रेस्टोरेंट')
          .replaceAll('Store', 'स्टोर')
          .replaceAll('store', 'स्टोर')
          .replaceAll('Shop', 'दुकान')
          .replaceAll('shop', 'दुकान')
          .replaceAll('Cafe', 'कैफे')
          .replaceAll('cafe', 'कैफे')
          .replaceAll('Kitchen', 'किचन')
          .replaceAll('kitchen', 'किचन')
          .replaceAll('Food', 'खाना')
          .replaceAll('food', 'खाना')
          .replaceAll('Market', 'बाज़ार')
          .replaceAll('market', 'बाज़ार')
          .replaceAll('Grill', 'ग्रिल')
          .replaceAll('grill', 'ग्रिल');
    } else if (currentLang == 'ur') {
      translatedName = translatedName
          .replaceAll('Restaurant', 'ریستوراں')
          .replaceAll('restaurant', 'ریستوراں')
          .replaceAll('RESTAURANT', 'ریستوراں')
          .replaceAll('Store', 'اسٹور')
          .replaceAll('store', 'اسٹور')
          .replaceAll('Shop', 'دکان')
          .replaceAll('shop', 'دکان')
          .replaceAll('Cafe', 'کیفے')
          .replaceAll('cafe', 'کیفے')
          .replaceAll('Kitchen', 'کچن')
          .replaceAll('kitchen', 'کچن')
          .replaceAll('Food', 'کھانا')
          .replaceAll('food', 'کھانا')
          .replaceAll('Market', 'بازار')
          .replaceAll('market', 'بازار')
          .replaceAll('Grill', 'گرل')
          .replaceAll('grill', 'گرل');
    } else if (currentLang == 'ar') {
      translatedName = translatedName
          .replaceAll('Restaurant', 'مطعم')
          .replaceAll('restaurant', 'مطعم')
          .replaceAll('RESTAURANT', 'مطعم')
          .replaceAll('Store', 'متجر')
          .replaceAll('store', 'متجر')
          .replaceAll('Shop', 'محل')
          .replaceAll('shop', 'محل')
          .replaceAll('Cafe', 'مقهى')
          .replaceAll('cafe', 'مقهى')
          .replaceAll('Kitchen', 'مطبخ')
          .replaceAll('kitchen', 'مطبخ')
          .replaceAll('Food', 'طعام')
          .replaceAll('food', 'طعام')
          .replaceAll('Market', 'سوق')
          .replaceAll('market', 'سوق')
          .replaceAll('Grill', 'شواء')
          .replaceAll('grill', 'شواء');
    }

    // Simple transliteration maps for common letters
    if (currentLang == 'hi') {
      return name
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
      return '${(distance * 1000).toInt()} ${context.tr('unit_m')}';
    }
    return '${distance.toStringAsFixed(1)} ${context.tr('unit_km')}';
  }

  void _showPlaceDetails(HalalPlaceModel place) {
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
                      place.type == HalalPlaceType.restaurant
                          ? Icons.restaurant
                          : Icons.store,
                      color: AppColors.primary,
                      size: responsive.iconLarge,
                    ),
                  ),
                  SizedBox(width: responsive.spaceRegular),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: context.tr(
                                        place.type == HalalPlaceType.restaurant
                                            ? 'restaurant'
                                            : 'grocery',
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: responsive.textSmall,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' • ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: responsive.textLarge,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    TextSpan(
                                      text: place.name,
                                      style: TextStyle(
                                        fontSize: responsive.textLarge,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (place.isHalalCertified)
                              Container(
                                padding: responsive.paddingSymmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    responsive.radiusSmall,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                      size: responsive.iconSize(16),
                                    ),
                                    SizedBox(width: responsive.spaceXSmall),
                                    Text(
                                      context.tr('halal'),
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: responsive.textSmall,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: responsive.spaceXSmall),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: responsive.paddingSymmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    responsive.radiusMedium,
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _translateCuisine(place.cuisine),
                                    style: TextStyle(
                                      color: AppColors.secondaryDark,
                                      fontWeight: FontWeight.w500,
                                      fontSize: responsive.textSmall,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: responsive.spaceSmall),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${_formatDistance(place.distance)} ${context.tr('away')}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: responsive.textSmall,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              responsive.vSpaceLarge,
              _buildDetailRow(Icons.location_on, place.address),
              if (place.openingHours != null)
                _buildDetailRow(
                  Icons.access_time,
                  _translateOpeningHours(place.openingHours!),
                ),
              if (place.phone != null)
                _buildDetailRow(Icons.phone, place.phone!),
              responsive.vSpaceLarge,
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _openInMaps(place);
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
                  if (place.phone != null) ...[
                    SizedBox(width: responsive.spaceMedium),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _callPlace(place.phone!);
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
      padding: responsive.paddingOnly(bottom: 6),
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
        toolbarHeight: 50,
        title: Text(context.tr('halal_finder')),
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
              context.tr('finding_halal_places'),
              style: TextStyle(color: AppColors.primary, fontSize: responsive.textMedium),
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
                onPressed: _loadPlaces,
                icon: const Icon(Icons.refresh),
                label: Text(context.tr('try_again')),
              ),
            ],
          ),
        ),
      );
    }

    return _buildPlacesList(_allPlaces, context.tr('halal_places'));
  }

  Widget _buildPlacesList(List<HalalPlaceModel> places, String type) {
    final responsive = context.responsive;

    if (places.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == 'restaurants' ? Icons.restaurant : Icons.store,
              size: responsive.iconHuge,
              color: Colors.grey,
            ),
            responsive.vSpaceRegular,
            Text(
              context.tr('no_halal_found').replaceAll('{type}', type),
              style: TextStyle(
                color: Colors.grey,
                fontSize: responsive.textMedium,
              ),
            ),
            responsive.vSpaceSmall,
            Text(
              context.tr('try_expanding_search'),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: responsive.textMedium,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: responsive.paddingMedium,
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: responsive.iconSize(18),
              ),
              SizedBox(width: responsive.spaceSmall),
              Expanded(
                child: Text(
                  context
                      .tr('halal_places_found')
                      .replaceAll('{count}', '${places.length}')
                      .replaceAll('{type}', type),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: responsive.textSmall,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              padding: responsive.paddingSymmetric(horizontal: 16),
              itemCount: AdListHelper.totalCount(places.length),
              itemBuilder: (context, index) {
                if (AdListHelper.isAdPosition(index)) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: BannerAdWidget(height: 250),
                  );
                }
                final dataIdx = AdListHelper.dataIndex(index);
                return _buildPlaceCard(places[dataIdx], dataIdx + 1);
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
    final responsive = context.responsive;

    return Container(
      margin: responsive.paddingOnly(bottom: 6),
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
        onTap: () => _showPlaceDetails(place),
        borderRadius: BorderRadius.circular(responsive.radiusLarge),
        child: Padding(
          padding: responsive.paddingSymmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              SizedBox(width: responsive.spacing(10)),
              Container(
                width: responsive.spacing(50),
                height: responsive.spacing(50),
                decoration: BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withValues(alpha: 0.3),
                      blurRadius: responsive.spacing(8),
                      offset: Offset(0, responsive.spacing(2)),
                    ),
                  ],
                ),
                child: Icon(
                  place.type == HalalPlaceType.restaurant
                      ? Icons.restaurant
                      : Icons.store,
                  color: Colors.white,
                  size: 22.0,
                ),
              ),
              SizedBox(width: responsive.spaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: responsive.textMedium,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (place.isHalalCertified)
                          Container(
                            padding: responsive.paddingSymmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(
                                responsive.radiusSmall,
                              ),
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                context.tr('halal'),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: responsive.fontSize(9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: responsive.spaceSmall),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: responsive.paddingSymmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: lightGreenChip,
                      borderRadius: BorderRadius.circular(
                        responsive.radiusMedium,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _formatDistance(place.distance),
                        style: TextStyle(
                          color: darkGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.fontSize(11),
                        ),
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
