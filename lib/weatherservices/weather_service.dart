import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apikey;

  WeatherService(this.apikey);

  Future<Weather> getweather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apikey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromjson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get weather report');
    }
  }

  Future<String> getcurrentcity() async {
    // Check location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Convert coordinates to city name
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract city name
    String? city = placemark[0].locality;

    return city ?? "Unknown City";
  }
}
