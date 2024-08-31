import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:StapesHome/screens/views/nodes/provisioning.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scanner_overlay.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scan_instructions.dart';

class QrScannerScreen extends StatefulWidget {
  final String floorId;
  final String roomId;
  final String userId;

  const QrScannerScreen({
    super.key,
    required this.floorId,
    required this.roomId,
    required this.userId,
  });

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
    try {
      _controller.toggleTorch();
    } catch (e) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleQRCode(List<Barcode> barcodes) {
    if (barcodes.isNotEmpty && !_isProcessing) {
      setState(() {
        _isProcessing = true;
        _controller.stop();
      });

      try {
        final Map<String, dynamic> jsonData = jsonDecode(barcodes.first.rawValue!);

        final String? deviceName = jsonData.containsKey('device_name') ? jsonData['device_name'] : null;
        final String? serviceUuid = jsonData.containsKey('service_uuid') ? jsonData['service_uuid'] : null;
        final String? characteristicUuid =
            jsonData.containsKey('characteristic_uuid') ? jsonData['characteristic_uuid'] : null;

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
                roomId: widget.roomId,
                userId: widget.userId,
                floorId: widget.floorId,
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
            child: SimpleInstructionPanel(),
          ),
        ],
      ),
    );
  }
}
