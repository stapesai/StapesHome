import 'dart:async';
import 'package:flutter/material.dart';
import 'SignIn/LoginSignIn.dart'; // Import the LoginScreen

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue, // Change to a specific color
      child: FlutterLogo(size: MediaQuery.of(context).size.height),
    );
  }
}
