import 'package:flutter/material.dart';
import 'package:smile_tech/screens/cirugia_screen.dart';
import 'package:smile_tech/screens/init_screen.dart';
import 'package:smile_tech/screens/main_screen.dart';
import 'package:smile_tech/screens/ortodoncia_screen.dart';

void main() {
  runApp(const InitApp());
}

class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Administrador",
      routes: {

        "main_screen": (context) => const MainScreen(),
        "init_screen": (context) => const InitScreen(),
        "ortodoncia_screen": (context) => const OrtodonciaScreen(),
        "cirugia_screen": (context) => const CirugiaScreen(),

      },
      initialRoute: "init_screen", //"formScreen",
    );
  }
}

