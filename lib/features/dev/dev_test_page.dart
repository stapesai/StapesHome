import 'package:flutter/material.dart';

class DevTestPage extends StatelessWidget {
  final String text;

  const DevTestPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Dev Test Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
