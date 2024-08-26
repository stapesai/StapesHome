import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jarvis/screens/main.dart'; // Import the main.dart for MainScreen
import 'package:jarvis/utils/sessions_model.dart';
import 'package:jarvis/screens/authentication/login.dart'; // Import the LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Hive.openBox<SessionsModel>('SessionBox');
    var sessionBox = Hive.box<SessionsModel>('SessionBox');
    bool isLoggedIn = sessionBox.isNotEmpty;

    if (isLoggedIn) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen()), // Redirect to MainScreen
        );
      }
    } else {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161622),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/icons/logo.png',
              width: 400.0,
              height: 400.0,
            ),
          ],
        ),
      ),
    );
  }
}
