import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:jarvis/Constants/colors.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
    _controller.toggleTorch();
  }
  void _showDialog(String code) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Detected'??""),
          content: Text('Detected code: $code'??""), // Add a null check
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();

                if (mounted) {
                  setState(() {
                    _isProcessing = false;
                    _controller.start();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onpressed() {
    print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect:(code){
              final List<Barcode> codes = code.barcodes;
              if (codes.isNotEmpty && !_isProcessing) {
                setState(() {
                  _isProcessing = true;
                  _controller.stop();
                });
                final Map<String, dynamic> jsonData = jsonDecode(codes.first.rawValue!);
                final String deviceName = jsonData['device_name'] ?? 'Unknown';
                final String serviceUuid = jsonData['service_uuid'] ?? 'Unknown';
                final String characteristicUuid = jsonData['characteristic_uuid'] ?? 'Unknown';

//flutter_blue_plus: ^1.32.8

                print('Device Name: $deviceName');
                print('Service UUID: $serviceUuid');
                print('Characteristic UUID: $characteristicUuid');

               showDialog(context: context, builder: (context) => AlertDialog(
                 title: Text('QR Code Detected'),
                 content: Text('Detected code: ${codes.first.rawValue}'),
                 actions: [
                   TextButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                       if (mounted) {
                         setState(() {
                           _isProcessing = false;
                           _controller.start();
                         });
                       }
                     },
                     child: Text('OK'),
                   ),
                 ],
               )  );



              }
            },
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(_flashOn ? Icons.flash_on : Icons.flash_off,
                  size: 30.0, color: Colors.white),
              onPressed: _toggleFlash,
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Scan to discover more',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            height: 250,
            width: 415,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code, size: 40, color: Colors.orange),
                  Text(
                    'Instructions',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1. Scan the QR code on the device.\n'
                    '2. Enter Wi-Fi credentials.\n'
                    '3. Enter entity name and correct node number.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
