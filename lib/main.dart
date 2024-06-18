import 'package:flutter/material.dart';
import 'Screens/SplashScreen.dart';
import 'Screens/SignIn/LoginSignIn.dart'; // Import the LoginScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Text(
          "Welcome to Home Page",
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    );
  }
}
