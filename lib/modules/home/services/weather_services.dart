import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/modules/home/data/weather_model.dart';

class WeatherServices {
  static const String _weatherUrl = 'https://api.open-meteo.com/v1/forecast';
  static const String _geocodingUrl =
      'https://nominatim.openstreetmap.org/reverse?format=json';

  Future<WeatherModel> getWeatherData() async {
    // position gps

    Position position = await _determinePosition();

    String cityName = await _getCityName(49.433331, 1.08333);

    return _getWeatherData(49.433331, 1.08333, cityName);
  }

  Future<String> _getCityName(double lat, double long) async {
    final response = await http.get(
      Uri.parse('$_geocodingUrl&lat=$lat&lon=$long'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('address')) {
        return data['address']['city'] ??
            data['address']['town'] ??
            data['address']['village'] ??
            data['address']['county'] ??
            data['address']['municipality'] ??
            "Unknown";
      }
    }
    throw Exception('Failed to get city name');
  }

  //POSITION GPS
  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permison are denied');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permison are denied forever');
      }
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<WeatherModel> _getWeatherData(
    double latitude,
    double longitude,
    String cityName,
  ) async {
    final url =
        '$_weatherUrl?latitude=$latitude&longitude=$longitude&current=weather_code&hourly=temperature_2m,weather_code&timezone=auto';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return WeatherModel(
        cityName: cityName,
        temperature: _getCurrentHourlyTemperature(data),
        weatherCode: _getCurrentHourlyWeatherCode(data),
      );
    } else {
      throw Exception('Failed to get weather data');
    }
  }

  double _getCurrentHourlyTemperature(Map<String, dynamic> data) {
    final times = data['hourly']['time'];
    final temperature = data['hourly']['temperature_2m'];
    final currentTime = _getCurrentUtcTime();

    final index = times.indexOf(currentTime);

    return index != -1 ? temperature[index] : temperature.last;
  }

  int _getCurrentHourlyWeatherCode(Map<String, dynamic> data) {
    final times = data['hourly']['time'];
    final weatherCodes = data['hourly']['weather_code'];
    final currentTime = _getCurrentUtcTime();

    final index = times.indexOf(currentTime);

    return index != -1 ? weatherCodes[index] : weatherCodes.last;
  }

  String _getCurrentUtcTime() {
    return DateFormat("YYYY-MM-ddTHH:00").format(DateTime.now().toUtc());
  }
}
