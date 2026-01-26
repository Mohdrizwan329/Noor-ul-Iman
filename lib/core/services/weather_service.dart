import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class WeatherData {
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final int aqi; // Air Quality Index
  final String aqiLevel; // Good, Fair, Moderate, Poor, Very Poor

  WeatherData({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.aqi,
    required this.aqiLevel,
  });
}

class WeatherService {
  // OpenWeatherMap API key
  static const String _apiKey = 'c9a265c562d658b01faf8b2344239b19';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

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

      // Fetch air quality data
      final aqiUrl = Uri.parse(
        '$_baseUrl/air_pollution?lat=$lat&lon=$lon&appid=$_apiKey',
      );

      final aqiResponse = await http.get(aqiUrl);

      int aqi = 0;
      String aqiLevel = 'Unknown';

      if (aqiResponse.statusCode == 200) {
        final aqiJson = json.decode(aqiResponse.body);
        if (aqiJson['list'] != null && aqiJson['list'].isNotEmpty) {
          aqi = aqiJson['list'][0]['main']['aqi'] ?? 0;
          aqiLevel = _getAQILevel(aqi);
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
      );
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      return null;
    }
  }

  static String _getAQILevel(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  static Color getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
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
