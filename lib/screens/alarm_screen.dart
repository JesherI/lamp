import 'package:lamp/screens/color_screen.dart';
import 'package:lamp/screens/home_screen.dart';
import 'package:lamp/screens/on_screen.dart';
import 'package:lamp/screens/time_screen.dart';
import 'package:lamp/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  int indexNavigation = 0;

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
      Navigator.pushReplacement(context, ruta);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Alarmas', style: TextStyle(color: AppTheme.colorText)),
        backgroundColor: AppTheme.backColor,
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
            label: 'Home',
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
