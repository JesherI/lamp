// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:lottie/lottie.dart';
import 'package:lamp/models/weather_model.dart';
import 'package:lamp/screens/alarm_screen.dart';
import 'package:lamp/screens/color_screen.dart';
import 'package:lamp/screens/on_screen.dart';
import 'package:lamp/screens/time_screen.dart';
import 'package:lamp/services/weather_service.dart';
import 'package:lamp/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int indexNavigation = 0;

  final _weatherService = WeatherService('12bbda216224097322b6abeebdd49b91');
  Weather? _weather;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      return Text('Error al obtener el clima: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  openScreen(int index, BuildContext context) {
    MaterialPageRoute ruta =
        MaterialPageRoute(builder: (context) => const HomeScreen());
    switch (index) {
      case 0:
        ruta = MaterialPageRoute(builder: (context) => const HomeScreen());
        break;
      case 1:
        ruta = MaterialPageRoute(builder: (context) => const OnScreen());
        break;
      case 2:
        ruta = MaterialPageRoute(builder: (context) => const TimeScreen());
        break;
      case 3:
        ruta = MaterialPageRoute(builder: (context) => const ColorScreen());
        break;
      case 4:
        ruta = MaterialPageRoute(builder: (context) => const AlarmScreen());
        break;
    }
    setState(() {
      indexNavigation = index;
      Navigator.pushReplacement(context, ruta); // Utiliza pushReplacement
    });
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      case 'snow':
        return 'assets/snow.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> weatherTranslations = {
      'Clouds': 'Nublado',
      'Mist': 'Niebla',
      'Smoke': 'Humo',
      'Haze': 'Neblina',
      'Dust': 'Polvo',
      'Fog': 'Niebla',
      'Rain': 'Lluvia',
      'Drizzle': 'Llovizna',
      'Shower Rain': 'Lluvia intensa',
      'Thunderstorm': 'Tormenta eléctrica',
      'Clear': 'Despejado',
      'Snow': 'Nieve',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: AppTheme.colorText)),
        backgroundColor: AppTheme.backColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: AppTheme.colorText),
                  const SizedBox(width: 10),
                  Text(_weather?.cityName ?? "Cargando ciudad",
                      style: const TextStyle(color: AppTheme.colorText)),
                ],
              ),
            ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text('${_weather?.temperature.round()}°C ',
                style: const TextStyle(color: AppTheme.colorText)),
            Text(weatherTranslations[_weather?.mainCondition] ?? "",
                style: const TextStyle(color: AppTheme.colorText))
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.backColor,
        currentIndex: indexNavigation,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: (index) => openScreen(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Tiempo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Uso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.color_lens),
            label: 'Color',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarma',
          ),
        ],
      ),
    );
  }
}
