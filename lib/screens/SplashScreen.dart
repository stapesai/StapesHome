import 'dart:async';
import 'package:flutter/material.dart';
import 'Authentication/login.dart'; // Import the LoginScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF161622), // Change to a specific color
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }
}
