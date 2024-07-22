import 'dart:convert';
import 'package:jarvis/main.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:jarvis/Constants/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:jarvis/screens/Additional/provisioning.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with TickerProviderStateMixin {
  late MobileScannerController _controller;
  bool _flashOn = false;
  bool _isProcessing = false;
  bool _isPanelVisible = true;
  late AnimationController _panelController;
  late Animation<double> _fadeAnimation;
  late AnimationController _lottieController;


  Future<bool>? _connectionFuture;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
    _panelController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );
    _lottieController = AnimationController(vsync: this);

    // Start the animation controller
    _panelController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _panelController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _flashOn = !_flashOn;
    });
    _controller.toggleTorch();
  }

  Future<bool> _connectToDevice(
      String deviceName, String serviceUuid, String characteristicUuid) async {
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

      final Map<String, dynamic> jsonData =
          jsonDecode(barcodes.first.rawValue!);
      final String deviceName = jsonData['device_name'] ?? 'Unknown';
      final String serviceUuid = jsonData['service_uuid'] ?? 'Unknown';
      final String characteristicUuid =
          jsonData['characteristic_uuid'] ?? 'Unknown';

      print('Device Name: $deviceName');
      print('Service UUID: $serviceUuid');
      print('Characteristic UUID: $characteristicUuid');

      // Set the connection future
      setState(() {
        _connectionFuture =
            _connectToDevice(deviceName, serviceUuid, characteristicUuid);
      });
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

  Widget _buildLottieAnimation(bool isSuccess) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          Lottie.asset(
              isSuccess
                  ? 'assets/lottie/success.json'
                  : 'assets/lottie/failure.json',
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.width / 3,
              repeat: true, onLoaded: (composition) {
            _lottieController
              ..duration = composition.duration
              ..forward();

            if (isSuccess) {
              _lottieController.addStatusListener(
                (status) {
                  if (status == AnimationStatus.completed) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ProvisioningScreen()));
                  }
                },
              );
            }
          }),
          Text(
            isSuccess ? 'Connection Successful!' : 'Connection Failed!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: AppColor
            .backgroundColor, // Ensure the background color matches your app theme
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _controller,
                    onDetect: (barcode) => _handleQRCode(barcode.barcodes),
                  ),
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                            _controller.dispose();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                              _flashOn ? Icons.flash_off : Icons.flash_on,
                              color: Colors.white),
                          onPressed: _toggleFlash,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isPanelVisible) {
                    _panelController.reverse();
                  } else {
                    _panelController.forward();
                  }
                  _isPanelVisible = !_isPanelVisible;
                });
              },
              child: AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: _isPanelVisible ? 300 : 60,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor
                        .backgroundColor, 
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
                      if (_isPanelVisible)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: FutureBuilder<bool>(
                            future: _connectionFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return _buildInstructionsPanel();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return _buildLottieAnimation(
                                    snapshot.data ?? false);
                              } else {
                                return _buildInstructionsPanel();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
