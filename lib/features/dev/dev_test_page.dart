import 'package:flutter/material.dart';

class DevTestPage extends StatelessWidget {
  final String text;

  const DevTestPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dev Test Page'),
      ),
      body: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}