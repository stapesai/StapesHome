import 'dart:convert';
import 'package:StapesHome/screens/views/nodes/provisioning.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scanner_overlay.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scan_instructions.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.start();
    } else if (state == AppLifecycleState.paused) {
      _controller.stop();
    }
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
    _controller.toggleTorch();
  }

  void _handleQRCode(List<Barcode> barcodes) {
    if (barcodes.isNotEmpty && !_isProcessing) {
      setState(() {
        _isProcessing = true;
        _controller.stop();
      });

      try {
        final Map<String, dynamic> jsonData = jsonDecode(barcodes.first.rawValue!);
        final String deviceName = jsonData['device_name'];
        final String serviceUuid = jsonData['service_uuid'];
        final String characteristicUuid = jsonData['characteristic_uuid'];

        if (deviceName != null && serviceUuid != null && characteristicUuid != null) {
          print('Device Name: $deviceName');
          print('Service UUID: $serviceUuid');
          print('Characteristic UUID: $characteristicUuid');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProvisioningScreen(
                deviceName: deviceName,
                serviceUuid: serviceUuid,
                characteristicUuid: characteristicUuid,
              ),
            ),
          );
        } else {
          print('Error: QR code is missing required fields');
        }
      } catch (e) {
        print('Error parsing QR code: $e');
      }

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (barcode) => _handleQRCode(barcode.barcodes),
          ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 32,
              ),
              onPressed: _toggleFlash,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ScanInstructions(),
          ),
        ],
      ),
    );
  }
}
