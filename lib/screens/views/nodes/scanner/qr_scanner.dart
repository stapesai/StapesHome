import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:StapesHome/screens/views/nodes/provisioning.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scanner_overlay.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scan_instructions.dart';

class QrScannerScreen extends StatefulWidget {
  final String floorId;
  final String roomId;
  final String userId;
  final String sessionId;

  const QrScannerScreen({
    super.key,
    required this.floorId,
    required this.roomId,
    required this.userId,
    required this.sessionId,
  });
  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  late MobileScannerController _controller;
  bool _torchOn = false;
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

  void _toggleTorch() {
    setState(() {
      _torchOn = !_torchOn;
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
        final String? configCharacteristicUuid =
            jsonData.containsKey('config_characteristic_uuid') ? jsonData['config_characteristic_uuid'] : null;
        final String? versionCharacteristicUuid =
            jsonData.containsKey('version_characteristic_uuid') ? jsonData['version_characteristic_uuid'] : null;

        if (deviceName != null && serviceUuid != null && configCharacteristicUuid != null && versionCharacteristicUuid != null) {
          print('Device Name: $deviceName');
          print('Service UUID: $serviceUuid');
          print('Config Characteristic UUID: $configCharacteristicUuid');
          print('Version Characteristic UUID: $versionCharacteristicUuid');


          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ProvisioningScreen(
                deviceName: deviceName,
                serviceUuid: serviceUuid,
                configCharacteristicUuid: configCharacteristicUuid,
                versionCharacteristicUuid: versionCharacteristicUuid,
                floorId: widget.floorId,
                roomId: widget.roomId,
                userId: widget.userId,
                sessionId: widget.sessionId,
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
            top: 45,
            right: 20,
            child: GestureDetector(
              onTap: _toggleTorch,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _torchOn ? Colors.white : Colors.transparent,
                ),
                child: Icon(
                  _torchOn ? Icons.flashlight_on : Icons.flashlight_off,
                  color: _torchOn ? Colors.black : Colors.white,
                  size: 24,
                ),
              ),
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