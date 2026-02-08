import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherData {
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int aqi; // Air Quality Index (US EPA scale 0-500)
  final String aqiLevel; // Good, Moderate, Unhealthy for Sensitive, Unhealthy, Very Unhealthy, Hazardous
  final double pm25; // PM2.5 value in μg/m³

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.aqi,
    required this.aqiLevel,
    this.pm25 = 0,
  });
}

class WeatherService {
  // OpenWeatherMap API key
  static const String _apiKey = 'c9a265c562d658b01faf8b2344239b19';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  // WAQI (World Air Quality Index) API token - free from https://aqicn.org/data-platform/token/
  static const String _waqiToken = 'b392e4ad279f2d58d3a26c73f824df1b4e7bd3e1';

  static Future<WeatherData?> getWeather({
    required double lat,
    required double lon,
  }) async {
    try {
      debugPrint('🌐 Calling Weather API for: $lat, $lon');
      // Fetch weather data
      final weatherUrl = Uri.parse(
        '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric',
      );

      debugPrint('🌐 Weather URL: $weatherUrl');
      final weatherResponse = await http.get(weatherUrl);

      debugPrint('🌐 Weather API Response Code: ${weatherResponse.statusCode}');
      if (weatherResponse.statusCode != 200) {
        debugPrint('🌐 Weather API Error Body: ${weatherResponse.body}');
        return null;
      }

      final weatherJson = json.decode(weatherResponse.body);

      // Fetch air quality data from WAQI (World Air Quality Index) API
      int aqi = 0;
      String aqiLevel = 'Unknown';
      double pm25 = 0;

      try {
        final waqiUrl = Uri.parse(
          'https://api.waqi.info/feed/geo:$lat;$lon/?token=$_waqiToken',
        );
        debugPrint('🌐 WAQI URL: $waqiUrl');
        final waqiResponse = await http.get(waqiUrl);
        debugPrint('🌐 WAQI Response Code: ${waqiResponse.statusCode}');

        if (waqiResponse.statusCode == 200) {
          final waqiJson = json.decode(waqiResponse.body);
          debugPrint('🌐 WAQI Response status: ${waqiJson['status']}');

          if (waqiJson['status'] == 'ok' && waqiJson['data'] != null) {
            aqi = (waqiJson['data']['aqi'] ?? 0) is int
                ? waqiJson['data']['aqi']
                : (waqiJson['data']['aqi'] ?? 0).toInt();
            aqiLevel = _getAQILevelFromValue(aqi);
            pm25 = (waqiJson['data']['iaqi']?['pm25']?['v'] ?? 0).toDouble();
            debugPrint('🌐 WAQI AQI: $aqi ($aqiLevel), PM2.5: $pm25');
          }
        }
      } catch (e) {
        debugPrint('🌐 WAQI API Error: $e');
      }

      // Fallback to OpenWeatherMap if WAQI failed
      if (aqi == 0) {
        try {
          final aqiUrl = Uri.parse(
            '$_baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey',
          );
          final aqiResponse = await http.get(aqiUrl);
          if (aqiResponse.statusCode == 200) {
            final aqiJson = json.decode(aqiResponse.body);
            if (aqiJson['list'] != null && aqiJson['list'].isNotEmpty) {
              // Use OpenWeatherMap's own AQI (1-5 scale) mapped to EPA ranges
              final owmAqi = aqiJson['list'][0]['main']?['aqi'] ?? 0;
              final components = aqiJson['list'][0]['components'];
              pm25 = (components?['pm2_5'] ?? 0).toDouble();
              aqi = _mapOwmAqiToEpa(owmAqi);
              aqiLevel = _getAQILevelFromValue(aqi);
              debugPrint('🌐 OWM Fallback AQI: $owmAqi → EPA: $aqi ($aqiLevel)');
            }
          }
        } catch (e) {
          debugPrint('🌐 OWM AQI Fallback Error: $e');
        }
      }

      return WeatherData(
        temperature: (weatherJson['main']['temp'] ?? 0).toDouble(),
        description: weatherJson['weather'][0]['description'] ?? '',
        icon: weatherJson['weather'][0]['icon'] ?? '01d',
        humidity: weatherJson['main']['humidity'] ?? 0,
        windSpeed: (weatherJson['wind']['speed'] ?? 0).toDouble(),
        aqi: aqi,
        aqiLevel: aqiLevel,
        pm25: pm25,
      );
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      return null;
    }
  }

  // Map OpenWeatherMap AQI (1-5) to approximate US EPA AQI
  static int _mapOwmAqiToEpa(int owmAqi) {
    switch (owmAqi) {
      case 1: return 25;   // Good
      case 2: return 75;   // Fair → Moderate
      case 3: return 125;  // Moderate → Unhealthy for Sensitive
      case 4: return 175;  // Poor → Unhealthy
      case 5: return 300;  // Very Poor → Very Unhealthy
      default: return 0;
    }
  }

  // Get AQI level description based on US EPA scale
  static String _getAQILevelFromValue(int aqi) {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi <= 100) {
      return 'Moderate';
    } else if (aqi <= 150) {
      return 'Unhealthy for Sensitive';
    } else if (aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  // Get color based on US EPA AQI scale
  static Color getAQIColor(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow.shade700;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else if (aqi <= 200) {
      return Colors.red;
    } else if (aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown.shade800;
    }
  }

  static IconData getWeatherIcon(String iconCode) {
    if (iconCode.startsWith('01')) {
      return Icons.wb_sunny;
    } else if (iconCode.startsWith('02')) {
      return Icons.wb_cloudy;
    } else if (iconCode.startsWith('03') || iconCode.startsWith('04')) {
      return Icons.cloud;
    } else if (iconCode.startsWith('09') || iconCode.startsWith('10')) {
      return Icons.grain;
    } else if (iconCode.startsWith('11')) {
      return Icons.flash_on;
    } else if (iconCode.startsWith('13')) {
      return Icons.ac_unit;
    } else if (iconCode.startsWith('50')) {
      return Icons.blur_on;
    }
    return Icons.wb_sunny;
  }
}
