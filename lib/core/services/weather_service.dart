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

      debugPrint('🌐 AQI URL: $aqiUrl');
      final aqiResponse = await http.get(aqiUrl);
      debugPrint('🌐 AQI Response Code: ${aqiResponse.statusCode}');

      int aqi = 0;
      String aqiLevel = 'Unknown';
      double pm25 = 0;

      if (aqiResponse.statusCode == 200) {
        final aqiJson = json.decode(aqiResponse.body);
        debugPrint('🌐 AQI Response: $aqiJson');

        if (aqiJson['list'] != null && aqiJson['list'].isNotEmpty) {
          final components = aqiJson['list'][0]['components'];

          // Get PM2.5 value (most important for AQI)
          pm25 = (components?['pm2_5'] ?? 0).toDouble();
          debugPrint('🌐 PM2.5: $pm25 μg/m³');

          // Calculate US EPA AQI from PM2.5
          aqi = _calculateAQIFromPM25(pm25);
          aqiLevel = _getAQILevelFromValue(aqi);

          debugPrint('🌐 Calculated AQI: $aqi ($aqiLevel)');
        }
      } else {
        debugPrint('🌐 AQI API Error: ${aqiResponse.body}');
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

  // Calculate US EPA AQI from PM2.5 concentration (μg/m³)
  static int _calculateAQIFromPM25(double pm25) {
    if (pm25 <= 12.0) {
      return _linearScale(pm25, 0, 12.0, 0, 50);
    } else if (pm25 <= 35.4) {
      return _linearScale(pm25, 12.1, 35.4, 51, 100);
    } else if (pm25 <= 55.4) {
      return _linearScale(pm25, 35.5, 55.4, 101, 150);
    } else if (pm25 <= 150.4) {
      return _linearScale(pm25, 55.5, 150.4, 151, 200);
    } else if (pm25 <= 250.4) {
      return _linearScale(pm25, 150.5, 250.4, 201, 300);
    } else if (pm25 <= 350.4) {
      return _linearScale(pm25, 250.5, 350.4, 301, 400);
    } else if (pm25 <= 500.4) {
      return _linearScale(pm25, 350.5, 500.4, 401, 500);
    } else {
      return 500; // Maximum AQI
    }
  }

  static int _linearScale(double value, double iLow, double iHigh, int aqiLow, int aqiHigh) {
    return ((aqiHigh - aqiLow) / (iHigh - iLow) * (value - iLow) + aqiLow).round();
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
