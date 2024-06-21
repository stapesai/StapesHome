import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:
          Colors.primaryColour, // Adjust this color to match your theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,\nMarvin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '❤️ Favourites',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(width: 20),
                  Text(
                    '⚡ Active',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Nothing to show here.",
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Go to Devices or Nodes page and add a device to favorites list.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
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
