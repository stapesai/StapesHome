import 'package:StapesHome/widgets/input/password.dart';
import 'package:StapesHome/widgets/input/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiCredentials extends StatefulWidget {
  final Function(bool success, String? errorMessage) onComplete;

  const WifiCredentials({super.key, required this.onComplete});

  @override
  createState() => _WifiCredentialsState();
}

class _WifiCredentialsState extends State<WifiCredentials> {
  final TextEditingController wifiNameController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();
  bool _isScanning = false;
  bool _isConnecting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  Future<void> _scanAndConnect() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      List<WifiNetwork> networks = await WiFiForIoTPlugin.loadWifiList();
      WifiNetwork? targetNetwork = networks.firstWhere(
        (network) => network.ssid == wifiNameController.text,
        orElse: () => throw Exception('WiFi network not found'),
      );

      setState(() {
        _isScanning = false;
        _isConnecting = true;
      });

      bool connected = await WiFiForIoTPlugin.connect(
        targetNetwork.ssid!,
        password: wifiPasswordController.text,
        security: targetNetwork.capabilities!.contains("WPA")
            ? NetworkSecurity.WPA
            : NetworkSecurity.NONE,
      );

      if (connected) {
        widget.onComplete(true, null);
      } else {
        throw Exception('Failed to connect to WiFi');
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
        _isConnecting = false;
        _errorMessage = e.toString();
      });
      widget.onComplete(false, _errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  Text(
                    'Wi-Fi Credentials',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: AppFontSizes.pageHeading,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    'Enter your Wi-Fi details to connect the device.',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: AppFontSizes.pageSubHeading,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  NTextField(
                    hintText: 'Wi-Fi Name',
                    controller: wifiNameController,
                    icon: Icons.wifi,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  PasswordTextField(
                    hintText: 'Wi-Fi Password',
                    controller: wifiPasswordController,
                    icon: Icons.lock_outline,
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    margin: EdgeInsets.only(
                      bottom: keyboardHeight > 0
                          ? keyboardHeight + screenSize.height * 0.02
                          : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: _isScanning || _isConnecting
                          ? CircularProgressIndicator(color: AppColor.whiteColor)
                          : CustomButton(
                              text: "Connect",
                              onPressed: _scanAndConnect,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}