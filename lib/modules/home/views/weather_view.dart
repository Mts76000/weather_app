import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  bool isDarkMode = false;

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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.nightlight_round : Icons.sunny,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                print(isDarkMode);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'San Francisco',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),

                    Container(child: Lottie.asset('assets/json/sun.json')),

                    Text(
                      '9°C',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
