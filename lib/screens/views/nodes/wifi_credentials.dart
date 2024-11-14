import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/common/widgets/button.dart';
import 'package:stapes_home/core/common/widgets/input/dropdown.dart';
import 'package:stapes_home/core/common/widgets/input/password.dart';
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
  // Timer? _connectionCheckTimer;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  @override
  void dispose() {
    // _connectionCheckTimer?.cancel();
    wifiPasswordController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
      Permission.storage,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    if (statuses[Permission.locationWhenInUse]!.isGranted && statuses[Permission.storage]!.isGranted) {
      _startWifiScan();
    } else {
      setState(() {
        _errorMessage = 'Required permissions are not granted.';
      });
    }
  }

  Future<void> _startWifiScan() async {
    setState(() {
      _isScanning = true;
      _errorMessage = null;
    });

    try {
      var canStartScan = await WiFiScan.instance.canStartScan();
      if (canStartScan == CanStartScan.yes) {
        var result = await WiFiScan.instance.startScan();
        if (result) {
          await _loadWifiList();
        } else {
          throw Exception('startScan returned false');
        }
      } else {
        throw Exception('Cannot start scan: $canStartScan');
      }
    } catch (e) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Failed to start Wi-Fi scan: ${e.toString()}';
      });
    }
  }

  Future<void> _loadWifiList() async {
    try {
      List<WiFiAccessPoint> accessPoints = await WiFiScan.instance.getScannedResults();
      print('Access Points: ${accessPoints.length}');

      setState(() {
        _networks = accessPoints
            .where((network) => network.ssid.isNotEmpty && network.frequency >= 2400 && network.frequency <= 2500)
            .toList();
        _isScanning = false;
      });

      if (_networks.isEmpty) {
        _errorMessage = 'No 2.4GHz networks found. Try rescanning.';
      }
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
                      : CustomDropdown<WiFiAccessPoint>(
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
                  CustomPasswordTextField(
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
