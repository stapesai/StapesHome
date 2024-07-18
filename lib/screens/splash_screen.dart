import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../Cache/sessions_model.dart';
import 'Navigation/home.dart';
import 'Authentication/login.dart';
import '../main.dart'; // Import the main.dart for MainScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Hive.openBox<SessionsModel>('SessionBox'); // Open the Hive box
    var sessionBox = Hive.box<SessionsModel>('SessionBox');
    bool isLoggedIn = sessionBox.isNotEmpty;

    Timer(
      const Duration(milliseconds: 200),
      () {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()), // Redirect to MainScreen
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
    );
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
            const SizedBox(height: 20.0),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
