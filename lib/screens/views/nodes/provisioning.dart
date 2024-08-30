import 'dart:async';
import 'dart:convert';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/screens/views/nodes/wifi_credentials.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ProvisioningScreen extends StatefulWidget {
  final String deviceName;
  final String serviceUuid;
  final String characteristicUuid;
  final String floorId;
  final String roomId;

  const ProvisioningScreen({
    super.key,
    required this.deviceName,
    required this.serviceUuid,
    required this.characteristicUuid,
    required this.floorId,
    required this.roomId,
  });

  @override
  createState() => ProvisioningScreenState();
}

class ProvisioningStep {
  final String title;
  bool isCompleted;
  bool isCurrent;

  ProvisioningStep({required this.title, this.isCompleted = false, this.isCurrent = false});
}

class ProvisioningScreenState extends State<ProvisioningScreen> {
  List<ProvisioningStep> steps = [
    ProvisioningStep(title: 'Pairing Bluetooth', isCurrent: true),
    ProvisioningStep(title: 'Enter Wi-Fi Credentials'),
    ProvisioningStep(title: 'Sending Wi-Fi credentials'),
    ProvisioningStep(title: 'Checking provisioning status'),
  ];

  int currentStepIndex = 0;
  StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    _startProvisioning();
  }

  @override
  void dispose() {
    scanSubscription?.cancel(); // Cancel the scan subscription
    FlutterBluePlus.stopScan(); // Stop scanning
    super.dispose();
  }

  Future<void> _startProvisioning() async {
    await _pairBluetooth();
    await _showWifiCredentials();
    if (steps[0].isCompleted) {
      await _checkProvisioningStatus();
    }
  }

  Future<void> _pairBluetooth() async {
    if (!mounted) return;

    setState(() {
      currentStepIndex = 0;
      steps[0].isCurrent = true;
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      scanSubscription = FlutterBluePlus.scanResults.listen((List<ScanResult> scanResults) async {
        for (ScanResult result in scanResults) {
          print('Found device: ${result.device.platformName} (${result.device.remoteId})');

          if (result.device.platformName == widget.deviceName) {
            await FlutterBluePlus.stopScan();
            scanSubscription?.cancel();

            try {
              await result.device.connect();
              List<BluetoothService> services = await result.device.discoverServices();

              for (BluetoothService service in services) {
                if (service.uuid.toString() == widget.serviceUuid) {
                  for (BluetoothCharacteristic characteristic in service.characteristics) {
                    if (characteristic.uuid.toString() == widget.characteristicUuid) {
                      print('Found the correct characteristic');
                      await _sendWifiCredentials(characteristic);
                    }
                  }
                }
              }

              if (mounted) {
                setState(() {
                  steps[0].isCompleted = true;
                  steps[0].isCurrent = false;
                });
              }
              return;
            } catch (e) {
              print('Error connecting to the device: $e');
            }
          }
        }
      });

      await Future.delayed(Duration(seconds: 10));
      print('No device found with the name: ${widget.deviceName}');
      throw Exception('Device not found');
    } catch (e) {
      print('Error during Bluetooth pairing: $e');
    }
  }

  Future<void> _showWifiCredentials() async {
    if (!mounted) return;

    setState(() {
      currentStepIndex = 0;
      steps[0].isCurrent = true;
    });
    final result = null;
    // final result = await Navigator.push(
    // context,
    // MaterialPageRoute(
    // builder: (context) => WifiCredentials(
    //   onComplete: (bool success, String? errorMessage) {
    //     Navigator.pop(context, {'success': success, 'errorMessage': errorMessage});
    //   },
    // ),
    // ),
    // );

    if (result != null && result is Map<String, dynamic>) {
      bool success = result['success'] as bool;
      String? errorMessage = result['errorMessage'] as String?;

      if (success) {
        setState(() {
          steps[0].isCompleted = true;
          steps[0].isCurrent = false;
          currentStepIndex++;
          steps[currentStepIndex].isCurrent = true;
        });
      } else {
        // Handle the error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('WiFi connection failed: $errorMessage')),
          );
        }
        // Optionally, you can allow the user to retry
        await _showWifiCredentials();
      }
    }
  }

  Future<void> _sendWifiCredentials(BluetoothCharacteristic characteristic) async {
    if (!mounted) return;

    setState(() {
      currentStepIndex = 2;
      steps[1].isCurrent = true;
    });

    const wifiUsername = 'SwastikWiFi';
    const wifiPassword = 'jarvis@wifi';
    const mqttBroker = '192.168.0.252';
    const mqttPort = '1883';
    const mqttPassword = '123';
    const userId = 'test';
    const homeId = 'test';
    String data =
        'WIFI_SSID=$wifiUsername;WIFI_PASSWORD=$wifiPassword;MQTT_BROKER=$mqttBroker;MQTT_PORT=$mqttPort;MQTT_PASSWORD=$mqttPassword;USER_ID=$userId;HOME_ID=$homeId';

    List<int> bytes = utf8.encode(data);

    try {
      await characteristic.write(bytes, withoutResponse: true);
      print('Data sent to the device: $data');

      List<int> response = await characteristic.read();
      String hardwareInfo = utf8.decode(response);
      print('Received hardware info: $hardwareInfo');

      // Parse hardware info
      Map<String, String> hardwareData = {};
      hardwareInfo.split(';').forEach((item) {
        List<String> keyValue = item.split('=');
        if (keyValue.length == 2) {
          hardwareData[keyValue[0]] = keyValue[1];
        }
      });

      var hardwareChip = hardwareData['HARDWARE_CHIP'];
      var hardwareVersion = hardwareData['HARDWARE_VERSION'];
      var firmwareVersion = hardwareData['FIRMWARE_VERSION'];
      var macAddress = characteristic.device.remoteId;

      print('Hardware chip: $hardwareChip');
      print('Hardware version: $hardwareVersion');
      print('Firmware version: $firmwareVersion');
      print('MAC address: $macAddress');

      // try {
      //   final response = await http.post(
      //     BackendRoutes.createNode,
      //     body: {
      //       'room_id': widget.roomId,
      //       'name': '',
      //       'hardware_chip': hardwareChip,
      //       'hardware_version': hardwareVersion,
      //       'hardware_mac_address': macAddress,
      //       'firmware_version': firmwareVersion,
      //     },
      //   );

      //   if (response.statusCode == 201) {
      //     print('Node created successfully');
      //   } else {
      //     throw Exception('Failed to create node' + response.body);
      //   }
      // }

      if (mounted) {
        setState(() {
          steps[1].isCompleted = true;
          steps[1].isCurrent = false;
        });
      }
    } catch (e) {
      print('Error sending Wi-Fi credentials: $e');
    }
  }

  Future<void> _checkProvisioningStatus() async {
    if (!mounted) return;

    setState(() {
      currentStepIndex = 2;
      steps[2].isCurrent = true;
    });

    await Future.delayed(Duration(seconds: 3));

    if (mounted) {
      setState(() {
        steps[2].isCompleted = true;
        steps[2].isCurrent = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
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
                  'Provisioning Node',
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: AppFontSizes.pageHeading,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  'Setting up your device...',
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: AppFontSizes.pageSubHeading,
                    fontFamily: 'Ubuntu',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
                Center(
                  child: SizedBox(
                    width: 122.69,
                    height: 132.19,
                    child: Lottie.asset(
                      'assets/loties/cube.json',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.04),
                ...steps.map((step) => _buildStepIndicator(step)),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ProvisioningStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step.isCompleted
                  ? Color(0xFFFF9F1C)
                  : step.isCurrent
                      ? Color(0xFFFF9F1C)
                      : Color(0x7FFF9F1C),
            ),
            child: step.isCompleted
                ? Icon(Icons.check, color: Colors.white)
                : step.isCurrent
                    ? CircularProgressIndicator(color: Colors.white)
                    : null,
          ),
          SizedBox(width: 10),
          Text(
            step.title,
            style: TextStyle(
              color: step.isCompleted || step.isCurrent ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 20,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
