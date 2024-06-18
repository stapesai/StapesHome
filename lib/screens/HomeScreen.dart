import 'package:flutter/material.dart';
import 'QrScannerScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRScannerScreen()),
            );
          },
          child: Text('Scan QR Code'),
        ),
      ),
    );
  }
}
