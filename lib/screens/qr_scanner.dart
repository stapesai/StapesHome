import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:jarvis/Constants/colors.dart';
import 'package:jarvis/main.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  _QrScannerScreenState createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;
  bool _isPanelVisible = true;
  late AnimationController _panelController;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _panelController.dispose();
    super.dispose();
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

      final Map<String, dynamic> jsonData =
          jsonDecode(barcodes.first.rawValue!);
      final String deviceName = jsonData['device_name'] ?? 'Unknown';
      final String serviceUuid = jsonData['service_uuid'] ?? 'Unknown';
      final String characteristicUuid =
          jsonData['characteristic_uuid'] ?? 'Unknown';

      print('Device Name: $deviceName');
      print('Service UUID: $serviceUuid');
      print('Characteristic UUID: $characteristicUuid');
    }
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInstructionsPanel() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          _buildInstruction('1. Scan the QR code on the device.'),
          _buildInstruction('2. Enter Wi-Fi credentials.'),
          _buildInstruction('3. Enter entity name and correct node number.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // back button
          
          MobileScanner(
            controller: _controller,
            onDetect: (barcode) => _handleQRCode(barcode.barcodes),
            overlayBuilder: (context, constraints) {
              // return two buttons
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  IconButton(
                    icon: Icon(
                      _flashOn ? Icons.flash_off : Icons.flash_on,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFlash,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                      // destroy the controller
                      _controller.dispose();
                    },
                  ),
                ],
              );
            },
           ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isPanelVisible = !_isPanelVisible;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width,
                height: _isPanelVisible ? 300 : 60,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColor.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // fix bottom overflow
                  
                    children: [
                      Container(
                        width: 60,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColor.secondaryTextColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Instructions',
                        style: TextStyle(
                          color: AppColor.iconBarColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildInstructionsPanel(),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
