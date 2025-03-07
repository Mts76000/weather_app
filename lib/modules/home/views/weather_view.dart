import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/modules/home/controllers/weather_controller.dart';
import 'package:weather_app/modules/home/data/weather_model.dart';
import 'package:weather_app/modules/home/services/weather_services.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  final WeatherController weatherController = WeatherController();
  final WeatherServices _weatherServices = WeatherServices();

  WeatherModel? weatherModel;

  bool _isLoading = true;
  String _errorMessage = '';
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchWatherData();
  }

  Future<void> _fetchWatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final weatherData = await _weatherServices.getWeatherData();
      setState(() {
        weatherModel = weatherData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.location_on,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.sunny,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              child: Center(
                child:
                    _isLoading
                        ? CircularProgressIndicator()
                        : _errorMessage.isNotEmpty
                        ? Text(_errorMessage)
                        : weatherModel != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weatherModel!.cityName,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.07),
                            Container(
                              child: Lottie.asset(
                                weatherController.getWeatherLottie(
                                  weatherModel!.weatherCode,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.07),
                            Text(
                              weatherModel!.temperature.toString(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        )
                        : const Text('no data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
