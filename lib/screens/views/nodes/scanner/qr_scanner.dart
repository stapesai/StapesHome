import 'dart:convert';
import 'package:StapesHome/screens/views/nodes/scanner/scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:StapesHome/screens/views/nodes/scanner/scan_instructions.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with WidgetsBindingObserver, TickerProviderStateMixin {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;
  late AnimationController _lottieController;
  Future<bool>? _connectionFuture;

  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
     WidgetsBinding.instance.removeObserver(this);
    _lottieController.dispose();
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

  Future<bool> _connectToDevice(String deviceName, String serviceUuid, String characteristicUuid) async {
    // Simulate a connection attempt with a delay
    await Future.delayed(Duration(seconds: 2));
    // Simulate success or failure randomly for demonstration purposes
    return Future.value(true); // or false
  }

  void _handleQRCode(List<Barcode> barcodes) {
    if (barcodes.isNotEmpty && !_isProcessing) {
      setState(() {
        _isProcessing = true;
        _controller.stop();
      });

      final Map<String, dynamic> jsonData = jsonDecode(barcodes.first.rawValue!);
      final String deviceName = jsonData['device_name'] ?? 'Unknown';
      final String serviceUuid = jsonData['service_uuid'] ?? 'Unknown';
      final String characteristicUuid = jsonData['characteristic_uuid'] ?? 'Unknown';

      print('Device Name: $deviceName');
      print('Service UUID: $serviceUuid'); 
      print('Characteristic UUID: $characteristicUuid');

      // Set the connection future
      setState(() {
        _isProcessing = false;
        _connectionFuture = _connectToDevice(deviceName, serviceUuid, characteristicUuid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: AppColor.instructionPanelColor),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // The QR Scanner
                MobileScanner(controller: _controller, onDetect: (barcode) => _handleQRCode(barcode.barcodes)),
                QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5)),
                // Positioned mini-bar at the bottom
                Bottomsheet(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
