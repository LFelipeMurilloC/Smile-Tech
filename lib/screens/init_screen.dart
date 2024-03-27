import 'package:flutter/material.dart';
import 'package:smile_tech/constants/constants.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 250),
          child: Column(
            children: <Widget>[

              Material(
                elevation: 30,
                shape: const CircleBorder(),
                color: kBackground2,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Image.asset(
                    "images/logo12.png",
                    width: 240,
                    height: 240,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 100, top: 50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "main_screen");
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 15,
                    backgroundColor: kButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text(
                    "Ingresar",
                    style: kButtonText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
