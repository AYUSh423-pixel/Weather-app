import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/weatherservices/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API Key
  final _weatherService = WeatherService(
      '581997cbe0de97b57759a22bb2b11406'); // Replace with your API key

  Weather? _weather;

  // Fetch weather data
  Future<void> _fetchWeather() async {
    try {
      String cityName = await _weatherService.getcurrentcity();
      Weather fetchedWeather = await _weatherService.getweather(cityName);

      setState(() {
        _weather = fetchedWeather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = Weather(
          cityName: "Error",
          temperature: 0.0,
          maincondition: e.toString(),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather when the page loads
  }

  @override
  Widget build(BuildContext context) {
    String animationPath = 'assets/cloudy.json'; // Default to cloudy

    if (_weather != null) {
      String condition = _weather!.maincondition.toLowerCase();

      switch (condition) {
        case 'clear':
          animationPath = 'assets/sunny.json'; // Adjust this as needed
          break;
        case 'clouds':
          animationPath = 'assets/cloudy.json';
          break;
        case 'rain':
          animationPath = 'assets/rainy.json';
          break;
        case 'snow':
          animationPath =
              'assets/snowy.json'; // Add snow animation if applicable
          break;
        default:
          animationPath = 'assets/cloudy.json'; // Fallback
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(animationPath), // Display the animation
            //city name
            Text(_weather?.cityName ?? "Loading city name"),
            //temperature
            Text(_weather?.temperature.round().toString() ??
                "Loading temperature"),
          ],
        ),
      ),
    );
  }
}
