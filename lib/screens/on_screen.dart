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

  Widget stade() {
    DatabaseReference testRef =
        FirebaseDatabase.instance.ref().child('Config/Estado');
    testRef.set(status);
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context)
              .size
              .height), // Altura máxima igual al tamaño de la pantalla
      alignment: Alignment
          .topCenter, // Alinea el contenido en la parte superior del centro
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment
            .center, // Alinea el contenido horizontalmente en el centro
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              status ? 'Encendido' : 'Apagado',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: AppTheme.colorText,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Transform.scale(
              scale: 1.5,
              child: Switch(
                value: status,
                activeColor: Colors.yellow,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey[700], 
                activeTrackColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                  testRef.set(status);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
