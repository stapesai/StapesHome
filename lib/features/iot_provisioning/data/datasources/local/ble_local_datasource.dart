// lib/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/models/node_hw_info.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

abstract class BleLocalDataSource {
  Future<
      (
        bool success,
        String? failureReason,
        BluetoothDevice? device,
        BluetoothCharacteristic? configChar,
        BluetoothCharacteristic? hwVersionChar,
        BluetoothCharacteristic? checkWiFiCredentialsChar
      )> pairBleNode(IotQrModel qrData);
  Future<bool> checkWiFiCredentialsOnNode(BluetoothCharacteristic char, String ssid, String password);
  Future<NodeHwInfo> getHwInfo(BluetoothCharacteristic hwVersionChar);
  Future<bool> sendConfigToNode(SendConfigToNode configData);
}

class BleLocalDataSourceImpl implements BleLocalDataSource {
  @override
  Future<
      (
        bool success,
        String? failureReason,
        BluetoothDevice? device,
        BluetoothCharacteristic? configChar,
        BluetoothCharacteristic? hwVersionChar,
        BluetoothCharacteristic? checkWiFiCredentialsChar
      )> pairBleNode(IotQrModel qrData) async {
    // Start scanning
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));

    try {
      // Wait for device discovery
      final results = await FlutterBluePlus.scanResults
          .firstWhere((results) => results.any((r) => r.device.platformName == qrData.deviceName), orElse: () => []);

      if (results.isEmpty) {
        return (false, 'Device not found', null, null, null, null);
      }

      final device = results.firstWhere((r) => r.device.platformName == qrData.deviceName).device;

      // Connect to device
      await device.connect();

      // Discover services
      final services = await device.discoverServices();

      // Find required characteristics
      BluetoothCharacteristic? configChar;
      BluetoothCharacteristic? hwVersionChar;
      BluetoothCharacteristic? checkWiFiCredentialsChar;

      for (var service in services) {
        if (service.uuid.toString() == qrData.serviceUuid) {
          for (var char in service.characteristics) {
            if (char.uuid.toString() == qrData.configCharacteristicUuid) {
              configChar = char;
            } else if (char.uuid.toString() == qrData.versionCharacteristicUuid) {
              hwVersionChar = char;
            } else if (char.uuid.toString() == qrData.checkWiFiCredentialsCharacteristicUuid) {
              checkWiFiCredentialsChar = char;
            }
          }
        }
      }

      if (configChar == null || hwVersionChar == null || checkWiFiCredentialsChar == null) {
        return (false, 'Required characteristics not found', null, null, null, null);
      }

      return (true, null, device, configChar, hwVersionChar, checkWiFiCredentialsChar);
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
  Future<bool> sendConfigToNode(SendConfigToNode configData) async {
    try {
      // Send config
      await configData.configCharacteristicUuid.write(utf8.encode(configData.toBleString()));

      // Wait for notification response
      final response =
          await configData.configCharacteristicUuid.lastValueStream.firstWhere((value) => value.isNotEmpty);
      return response[0] == 1; // 1 = success, 0 = failure
    } catch (e) {
      return false;
    }
  }
}
