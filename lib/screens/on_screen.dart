import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:lamp/screens/alarm_screen.dart';
import 'package:lamp/screens/color_screen.dart';
import 'package:lamp/screens/home_screen.dart';
import 'package:lamp/screens/time_screen.dart';
import 'package:lamp/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnScreen extends StatefulWidget {
  const OnScreen({super.key});

  @override
  State<OnScreen> createState() => _OnScreenState();
}

class _OnScreenState extends State<OnScreen> {
  int indexNavigation = 0;
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();
  String realTimeValue = '0';
  String getOnceValue = '0';
  bool status = false;

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
        title: const Text('Encendido',
            style: TextStyle(color: AppTheme.colorText)),
        backgroundColor: AppTheme.backColor,
      ),
      body: FutureBuilder(
        future: _fApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error de datos");
          } else if (snapshot.hasData) {
            return stade();
          } else {
            return const CircularProgressIndicator();
          }
        },
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

  Widget content() {
    DatabaseReference testRef = FirebaseDatabase.instance.ref().child('count');
    testRef.onValue.listen(
      (event) {
        setState(() {
          realTimeValue = event.snapshot.value.toString();
        });
      },
    );
    return Text('El valor es : $realTimeValue');
  }

  Widget stade() {
    DatabaseReference testRef = FirebaseDatabase.instance.ref().child('Config/Estado');
    testRef.set(status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text(
          '¿Encendido o apagado?',
        ),
        Switch(
          value: status,
          onChanged: (value) {
            setState(() {
              status = value;
            });
            testRef.set(status);
          },
        ),
      ],
    );
  }
}
