import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'wifi_credentials.dart';
import 'name_your_node.dart';

class ProvisioningScreen extends StatefulWidget {
  final String deviceName;
  final String serviceUuid;
  final String configCharacteristicUuid;
  final String versionCharacteristicUuid;
  final String roomId;
  final String userId;
  final String sessionId;

  const ProvisioningScreen({
    super.key,
    required this.deviceName,
    required this.serviceUuid,
    required this.configCharacteristicUuid,
    required this.versionCharacteristicUuid,
    required this.roomId,
    required this.userId,
    required this.sessionId,
  });

  @override
  ProvisioningScreenState createState() => ProvisioningScreenState();
}

class ProvisioningStep {
  final String title;
  bool isCompleted;
  bool isCurrent;

  ProvisioningStep({
    required this.title,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class ProvisioningScreenState extends State<ProvisioningScreen> {
  List<ProvisioningStep> steps = [
    ProvisioningStep(title: 'Pairing Bluetooth', isCurrent: true),
    ProvisioningStep(title: 'Enter Wi-Fi Credentials'),
    ProvisioningStep(title: 'Name your node'),
    ProvisioningStep(title: 'Sending Wi-Fi credentials'),
  ];

  int currentStepIndex = 0;
  StreamSubscription<List<ScanResult>>? scanSubscription;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? configCharacteristic;
  BluetoothCharacteristic? versionCharacteristic;
  String? wifiSsid;
  String? wifiPassword;
  String? nodeName;

  @override
  void initState() {
    super.initState();
    _startProvisioning();
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
    connectedDevice?.disconnect();
    super.dispose();
  }

  // Main provisioning process
  Future<void> _startProvisioning() async {
    await _pairBluetoothDevice();
    if (steps[0].isCompleted) {
      await _getWifiCredentials();
      if (steps[1].isCompleted) {
        await _nameNode();
        if (steps[2].isCompleted) {
          await _sendWifiCredentialsToDevice();
          // if (steps[3].isCompleted) {
          //   await _checkProvisioningStatus();
          // }
        }
      }
    }
  }

  // Step 1: Pair with the Bluetooth device
  Future<void> _pairBluetoothDevice() async {
    if (!mounted) return;

    setState(() {
      currentStepIndex = 0;
      steps[0].isCurrent = true;
    });

    try {
      await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

      scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult result in results) {
          if (result.device.platformName == widget.deviceName) {
            await FlutterBluePlus.stopScan();
            scanSubscription?.cancel();

            try {
              await result.device.connect();
              connectedDevice = result.device;
              List<BluetoothService> services = await result.device.discoverServices();

              for (BluetoothService service in services) {
                if (service.uuid.toString() == widget.serviceUuid) {
                  for (BluetoothCharacteristic characteristic in service.characteristics) {
                    if (characteristic.uuid.toString() == widget.configCharacteristicUuid) {
                      configCharacteristic = characteristic;
                    } else if (characteristic.uuid.toString() == widget.versionCharacteristicUuid) {
                      versionCharacteristic = characteristic;
                    }
                  }
                }
              }

              if (configCharacteristic != null && versionCharacteristic != null) {
                if (mounted) {
                  setState(() {
                    steps[0].isCompleted = true;
                    steps[0].isCurrent = false;
                    currentStepIndex++;
                    steps[currentStepIndex].isCurrent = true;
                  });
                }
                return;
              } else {
                throw Exception('Required characteristics not found');
              }
            } catch (e) {
              print('Error connecting to the device: $e');
              throw Exception('Failed to connect to the device');
            }
          }
        }
      });

      await Future.delayed(Duration(seconds: 10));
      throw Exception('Device not found');
    } catch (e) {
      print('Error during Bluetooth pairing: $e');
      _showErrorSnackBar('Bluetooth pairing failed: ${e.toString()}');
    }
  }

  // Step 2: Get Wi-Fi credentials from user
  Future<void> _getWifiCredentials() async {
    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WifiCredentials(
          onComplete: (bool success, String? errorMessage, String? ssid, String? password) {
            Navigator.pop(
                context, {'success': success, 'errorMessage': errorMessage, 'ssid': ssid, 'password': password});
          },
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      bool success = result['success'] as bool;
      String? errorMessage = result['errorMessage'] as String?;
      wifiSsid = result['ssid'] as String?;
      wifiPassword = result['password'] as String?;

      if (success && wifiSsid != null && wifiPassword != null) {
        setState(() {
          steps[1].isCompleted = true;
          steps[1].isCurrent = false;
          currentStepIndex++;
          steps[currentStepIndex].isCurrent = true;
        });
      } else {
        _showErrorSnackBar('Wi-Fi connection failed: $errorMessage');
        await _getWifiCredentials(); // Retry getting Wi-Fi credentials
      }
    }
  }

  // Step 3: Send Wi-Fi credentials to the device
  Future<void> _sendWifiCredentialsToDevice() async {
    if (!mounted || configCharacteristic == null || versionCharacteristic == null) return;

    setState(() {
      currentStepIndex = 3;
      steps[3].isCurrent = true;
    });

    try {
      List<int> response = await versionCharacteristic!.read();
      String hardwareInfo = utf8.decode(response);
      print('Received hardware info: $hardwareInfo');

      if (hardwareInfo.isEmpty || !hardwareInfo.contains('=')) {
        throw Exception('Invalid or empty hardware info received');
      }

      Map<String, String> hardwareData = Map.fromEntries(
        hardwareInfo.split(';').map((item) {
          List<String> keyValue = item.split('=');
          return MapEntry(keyValue[0], keyValue[1]);
        }),
      );

      final mqttDetails = await _getMqttBrokerDetails();

      String data = 'WIFI_SSID=$wifiSsid;'
          'WIFI_PASSWORD=$wifiPassword;'
          'MQTT_BROKER=${mqttDetails['host']};'
          'MQTT_PORT=${mqttDetails['port']};'
          'MQTT_USERNAME=${hardwareData['HARDWARE_MAC_ADDRESS']};'
          'MQTT_PASSWORD=${hardwareData['HARDWARE_MAC_ADDRESS']};'
          'USER_ID=${widget.userId}';

      List<int> bytes = utf8.encode(data);

      // Send data to the device
      await configCharacteristic!.write(bytes, withoutResponse: true);
      print('Data sent to the device: $data');

      await _createNodeInBackend(hardwareData);

      if (mounted) {
        setState(() {
          steps[3].isCompleted = true;
          steps[3].isCurrent = false;
          // currentStepIndex++;
          // steps[currentStepIndex].isCurrent = true;
        });
      }
    } catch (e) {
      print('Error sending Wi-Fi credentials: $e');
      _showErrorSnackBar('Failed to send Wi-Fi credentials: ${e.toString()}');
    }
  }

  // Step 4: Name the node
  Future<void> _nameNode() async {
    if (!mounted) return;

    setState(() {
      currentStepIndex++;
      steps[2].isCurrent = true;
    });

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NodeNamingScreen(
          onNameSubmitted: (name) {
            Navigator.pop(context, name);
          },
        ),
      ),
    );

    if (result != null && result is String) {
      nodeName = result;
      setState(() {
        steps[2].isCompleted = true;
        steps[2].isCurrent = false;
      });
    } else {
      _showErrorSnackBar('Please provide a name for your node');
      await _nameNode(); // Retry naming the node
    }
  }
  // Step 5: Check provisioning status
  // Future<void> _checkProvisioningStatus() async {
  //   if (!mounted) return;

  //   setState(() {
  //     currentStepIndex = 3;
  //     steps[3].isCurrent = true;
  //   });

  //   // TODO: Implement actual provisioning status check
  //   await Future.delayed(Duration(seconds: 3));

  //   if (mounted) {
  //     setState(() {
  //       steps[3].isCompleted = true;
  //       steps[3].isCurrent = false;
  //     });
  //     // TODO: Navigate to success screen or handle completion
  //   }
  // }

  // Helper method to get MQTT broker details
  Future<Map<String, String>> _getMqttBrokerDetails() async {
    try {
      final response = await http.get(
        BackendRoutes.mqttInfo,
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data.map((key, value) => MapEntry(key, value.toString()));
      } else {
        throw Exception('Failed to get MQTT broker details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting MQTT broker details: $e');
      rethrow;
    }
  }

  // Helper method to create node in the backend
  Future<void> _createNodeInBackend(Map<String, String> hardwareData) async {
    try {
      final response = await http.post(
        BackendRoutes.createNode,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
        body: json.encode({
          'room_id': widget.roomId,
          'name': nodeName,
          'hardware_chip': hardwareData['HARDWARE_CHIP'],
          'hardware_version': hardwareData['HARDWARE_VERSION'],
          'hardware_mac_address': hardwareData['HARDWARE_MAC_ADDRESS'],
          'firmware_version': hardwareData['FIRMWARE_VERSION'],
        }),
      );

      if (response.statusCode == 201) {
        print('Node created successfully');
      } else {
        throw Exception('Failed to create node: ${response.body}');
      }
    } catch (e) {
      print('Error creating node in backend: $e');
      rethrow;
    }
  }

  // Helper method to show error snackbar
  void _showErrorSnackBar(String message) {
    if (mounted) {
      CustomSnackbar(context, message, type: SnackbarType.error);
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
