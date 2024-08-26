import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MiniBar extends StatelessWidget {
  final VoidCallback onTap;

  const MiniBar({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: double.infinity,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Center(
                child: Container(
              height: 5,
              width: 100,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            )),
          ),
        ],
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniBar(onTap: () => Navigator.of(context).pop()),
          SizedBox(height: 16),
          Text('Instructions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('1. Scan the QR code on the device.'),
          Text('2. Enter Wi-Fi credentials.'),
          Text('3. Enter device name and correct node number.'),
        ],
      ),
    );
  }
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with TickerProviderStateMixin {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;
  late AnimationController _lottieController;
  Future<bool>? _connectionFuture;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _lottieController.dispose();
    super.dispose();
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
        _connectionFuture = _connectToDevice(deviceName, serviceUuid, characteristicUuid);
      });
    }
  }

  // Function to open the bottom sheet
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: AppColor.backgroundColorgradient,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // The QR Scanner
                MobileScanner(controller: _controller, onDetect: (barcode) => _handleQRCode(barcode.barcodes)),

                // Positioned mini-bar at the bottom
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: MiniBar(onTap: () => _showBottomSheet(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
