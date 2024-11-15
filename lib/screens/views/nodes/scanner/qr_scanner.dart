import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stapes_home/screens/views/nodes/provisioning.dart';
import 'package:stapes_home/screens/views/nodes/scanner/scanner_overlay.dart';
import 'package:stapes_home/screens/views/nodes/scanner/scan_instructions.dart';

class QrScannerScreen extends StatefulWidget {
  final String roomId;
  final String userId;
  final String sessionId;

  const QrScannerScreen({super.key, required this.roomId, required this.userId, required this.sessionId});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver {
  MobileScannerController? _controller;
  bool _torchOn = false;
  bool _isProcessing = false;
  bool _hasTorch = true; // Assume torch is available until proven otherwise

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScanner();
    });
  }

  Future<void> _initializeScanner() async {
    _controller = MobileScannerController();
    await _controller?.start();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller?.start();
    } else if (state == AppLifecycleState.paused) {
      _controller?.stop();
    }
  }

  void _toggleTorch() async {
    try {
      if (_controller != null) {
        await _controller!.toggleTorch();
        setState(() {
          _torchOn = !_torchOn;
        });
      }
    } catch (e) {
      // If an error occurs (torch not available), we can assume there's no torch
      print('Torch is not available: $e');
      setState(() {
        _hasTorch = false; // Hide the torch toggle button if not available
      });
    }
  }

  void _handleQRCode(List<Barcode> barcodes) {
    if (barcodes.isNotEmpty && !_isProcessing) {
      setState(() {
        _isProcessing = true;
        _controller?.stop();
      });
      try {
        final Map<String, dynamic> jsonData = jsonDecode(barcodes.first.rawValue!);

        final String? deviceName = jsonData['device_name'];
        final String? serviceUuid = jsonData['service_uuid'];
        final String? configCharacteristicUuid = jsonData['config_characteristic_uuid'];
        final String? versionCharacteristicUuid = jsonData['version_characteristic_uuid'];

        if (deviceName != null &&
            serviceUuid != null &&
            configCharacteristicUuid != null &&
            versionCharacteristicUuid != null) {
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
          if (_controller != null)
            MobileScanner(
              controller: _controller!,
              onDetect: (barcode) => _handleQRCode(barcode.barcodes),
            ),
          QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
          if (_hasTorch) // Show torch toggle only if the torch is available
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
