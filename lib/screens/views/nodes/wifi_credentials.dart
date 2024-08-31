import 'dart:async';
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:StapesHome/widgets/input/dropdown.dart';
import 'package:StapesHome/widgets/input/password.dart';
import 'package:wifi_scan/wifi_scan.dart';
// import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart';

class WifiCredentials extends StatefulWidget {
  final Function(bool success, String? errorMessage, String? ssid, String? password) onComplete;

  const WifiCredentials({super.key, required this.onComplete});

  @override
  createState() => _WifiCredentialsState();
}

class _WifiCredentialsState extends State<WifiCredentials> {
  final TextEditingController wifiPasswordController = TextEditingController();
  bool _isScanning = false;
  bool _isConnecting = false;
  String? _errorMessage;
  List<WiFiAccessPoint> _networks = [];
  WiFiAccessPoint? _selectedNetwork;
  // String? _originalSsid;
  Timer? _connectionCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    _connectionCheckTimer?.cancel();
    wifiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      _startWifiScan();
    } else {
      setState(() {
        _errorMessage = 'Location permission is required to scan for Wi-Fi networks.';
      });
    }
  }

  Future<void> _startWifiScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      await WiFiScan.instance.startScan();
      _loadWifiList();
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Failed to start Wi-Fi scan: ${e.toString()}';
      });
    }
  }

  Future<void> _loadWifiList() async {
    try {
      final List<WiFiAccessPoint> accessPoints = await WiFiScan.instance.getScannedResults();
      setState(() {
        _networks = accessPoints
            .where((network) =>
                network.ssid.isNotEmpty &&
                network.frequency >= 2400 &&
                network.frequency <= 2500) // Filter for 2.4GHz networks
            .toList();
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Failed to load Wi-Fi networks: ${e.toString()}';
      });
    }
  }

  Future<void> _connectToWifi() async {
    if (_selectedNetwork == null) {
      setState(() {
        _errorMessage = 'Please select a Wi-Fi network.';
      });
      return;
    }

    setState(() {
      _isConnecting = true;
      _errorMessage = null;
    });

    try {
      // Save the original network SSID
      // _originalSsid = await WiFiForIoTPlugin.getSSID();

      // Try connecting to the new Wi-Fi network
      // bool connected = await WiFiForIoTPlugin.connect(
      //   _selectedNetwork!.ssid,
      //   password: wifiPasswordController.text,
      //   security: _selectedNetwork!.capabilities.contains("WPA") ? NetworkSecurity.WPA : NetworkSecurity.NONE,
      // );

      widget.onComplete(true, null, _selectedNetwork!.ssid, wifiPasswordController.text);

      // if (connected) {
      //   _startConnectionCheck();
      // } else {
      //   throw Exception('Failed to connect to Wi-Fi');
      // }
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _errorMessage = e.toString();
      });
      widget.onComplete(false, _errorMessage, null, null);
    }
  }

  // void _startConnectionCheck() {
  //   _connectionCheckTimer = Timer.periodic(const Duration(seconds: 8), (timer) async {
  //     bool isConnected = await WiFiForIoTPlugin.isConnected();

  //     if (!isConnected) {
  //       _revertToOriginalWifi();
  //     } else {
  //       _connectionCheckTimer?.cancel();
  //       widget.onComplete(true, null, _selectedNetwork!.ssid, wifiPasswordController.text);
  //     }
  //   });
  // }

  // Future<void> _revertToOriginalWifi() async {
  //   if (_originalSsid != null) {
  //     try {
  //       await WiFiForIoTPlugin.connect(_originalSsid!, security: NetworkSecurity.NONE);
  //       setState(() {
  //         _isConnecting = false;
  //         _connectionCheckTimer?.cancel();
  //         _errorMessage = 'Failed to maintain connection to the new network. Reverted to the original network.';
  //       });
  //       widget.onComplete(false, _errorMessage, null, null);
  //     } catch (e) {
  //       setState(() {
  //         _errorMessage = 'Failed to revert to the original Wi-Fi network: ${e.toString()}';
  //       });
  //       widget.onComplete(false, _errorMessage, null, null);
  //     }
  //   }
  // }

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
                    'Select a Wi-Fi network and enter the password to connect.',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: AppFontSizes.pageSubHeading,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  _isScanning
                      ? Center(child: CircularProgressIndicator(color: AppColor.whiteColor))
                      : NDropdown<WiFiAccessPoint>(
                          hintText: 'Select Wi-Fi Network',
                          value: _selectedNetwork,
                          items: _networks
                              .map((network) => DropdownMenuItem(
                                    value: network,
                                    child: Text(
                                      network.ssid,
                                      style: TextStyle(color: AppColor.whiteColor),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedNetwork = value;
                            });
                          },
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
                      bottom: keyboardHeight > 0 ? keyboardHeight + screenSize.height * 0.02 : screenSize.height * 0.1,
                    ),
                    child: Center(
                      child: _isScanning || _isConnecting
                          ? CircularProgressIndicator(color: AppColor.whiteColor)
                          : Column(
                              children: [
                                CustomButton(
                                  text: "Connect",
                                  onPressed: _connectToWifi,
                                ),
                                SizedBox(height: 16),
                                TextButton(
                                  onPressed: _startWifiScan,
                                  child: Text(
                                    "Rescan Wi-Fi Networks",
                                    style: TextStyle(color: AppColor.whiteColor),
                                  ),
                                ),
                              ],
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
