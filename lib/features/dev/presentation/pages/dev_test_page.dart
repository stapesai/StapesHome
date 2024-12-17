import 'package:flutter/material.dart';

class DevTestPage extends StatelessWidget {
  final String text;

  const DevTestPage({super.key, required this.text});

  @override
  StatelessElement createElement() {
    print('Creating DevTestPage for $text');
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Dev Page - $text', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'This page is under development.',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              'This is a temporary page to test the navigation.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
