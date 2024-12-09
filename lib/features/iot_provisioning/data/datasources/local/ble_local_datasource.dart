// lib/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/models/node_hw_info.dart';

abstract class BleLocalDataSource {
  Future<bool> pairBleNode(
      String deviceName, String serviceUuid, String configUuid, String hwVersionUuid, String checkWiFiCredentialsUuid);
  Future<bool> checkWiFiCredentialsOnNode(BluetoothCharacteristic char, String ssid, String password);
  Future<NodeHwInfo> getHwInfo(BluetoothCharacteristic hwVersionChar);
  Future<bool> sendConfigToNode(BluetoothCharacteristic configChar, String wifiSSID, String wifiPassword, String userId,
      String mqttHost, String mqttPort, String mqttUsername, String mqttPassword);
}

class BleLocalDataSourceImpl implements BleLocalDataSource {
  @override
  Future<bool> pairBleNode(String deviceName, String serviceUuid, String configUuid, String hwVersionUuid,
      String checkWiFiCredentialsUuid) async {
    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    try {
      // Wait for device discovery
      final results = await FlutterBluePlus.scanResults
          .firstWhere((results) => results.any((r) => r.device.platformName == deviceName));

      final device = results.firstWhere((r) => r.device.platformName == deviceName).device;

      // Connect to device
      await device.connect();

      // Discover services
      final services = await device.discoverServices();

      // Find required characteristics
      BluetoothCharacteristic? configChar;
      BluetoothCharacteristic? hwVersionChar;
      BluetoothCharacteristic? checkWiFiCredentialsChar;

      for (var service in services) {
        if (service.uuid.toString() == serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid.toString() == configUuid) {
              configChar = char;
            } else if (char.uuid.toString() == hwVersionUuid) {
              hwVersionChar = char;
            } else if (char.uuid.toString() == checkWiFiCredentialsUuid) {
              checkWiFiCredentialsChar = char;
            }
          }
        }
      }

      if (configChar == null || hwVersionChar == null || checkWiFiCredentialsChar == null) {
        print('Required characteristics not found - Invaild QR code');
        return false;
      }

      return true;
    } finally {
      await FlutterBluePlus.stopScan();
    }
  }

  @override
  Future<NodeHwInfo> getHwInfo(BluetoothCharacteristic hwVersionChar) async {
    final hwInfo = utf8.decode(await hwVersionChar.read());
    return NodeHwInfo.fromBleString(hwInfo);
  }

  @override
  Future<bool> checkWiFiCredentialsOnNode(BluetoothCharacteristic char, String ssid, String password) async {
    try {
      // Format for checking credentials: "SSID=xxx;PASSWORD=xxx"
      final data = 'SSID=$ssid;PASSWORD=$password';
      await char.write(utf8.encode(data));

      // Wait for notification response
      final response = await char.lastValueStream.firstWhere((value) => value.isNotEmpty);
      return response[0] == 1; // 1 = success, 0 = failure
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> sendConfigToNode(BluetoothCharacteristic configChar, String ssid, String password, String userId,
      String mqttHost, String mqttPort, String mqttUsername, String mqttPassword) async {
    try {
      // Format config data
      final configData = 'WIFI_SSID=$ssid;'
          'WIFI_PASSWORD=$password;'
          'MQTT_BROKER=$mqttHost;'
          'MQTT_PORT=$mqttPort;'
          'MQTT_USERNAME=$mqttUsername;'
          'MQTT_PASSWORD=$mqttPassword;'
          'USER_ID=$userId';

      // Send config
      await configChar.write(utf8.encode(configData));

      // Wait for notification response
      final response = await configChar.lastValueStream.firstWhere((value) => value.isNotEmpty);
      return response[0] == 1; // 1 = success, 0 = failure
    } catch (e) {
      return false;
    }
  }
}
