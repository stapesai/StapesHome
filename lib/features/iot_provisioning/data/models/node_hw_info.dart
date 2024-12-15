// lib/features/iot_provisioning/data/datasources/models/node_hw_info.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class NodeHwInfo {
  final String manifactureId;
  final String hardwareChip;
  final String hardwareVersion;
  final String firmwareVersion;

  NodeHwInfo({
    required this.manifactureId,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.firmwareVersion,
  });

  factory NodeHwInfo.fromBleString(String bleData) {
    // Format: <hardware_chip>;<hardware_version>;<firmware_version>
    final parts = bleData.split(';');

    if (parts.length != 4) {
      throw Exception('Invalid BLE data');
    }

    return NodeHwInfo(
      manifactureId: parts[0],
      hardwareChip: parts[1],
      hardwareVersion: parts[2],
      firmwareVersion: parts[3],
    );
  }
}

class SendConfigToNode {
  BluetoothCharacteristic configCharacteristicUuid;
  String wifiSSID;
  String wifiPassword;
  String userId;
  String mqttHost;
  String mqttPort;
  String mqttUsername;
  String mqttPassword;

  SendConfigToNode({
    required this.configCharacteristicUuid,
    required this.wifiSSID,
    required this.wifiPassword,
    required this.userId,
    required this.mqttHost,
    required this.mqttPort,
    required this.mqttUsername,
    required this.mqttPassword,
  });

  String toBleString() {
    return 'WIFI_SSID=$wifiSSID;'
        'WIFI_PASSWORD=$wifiPassword;'
        'MQTT_BROKER=$mqttHost;'
        'MQTT_PORT=$mqttPort;'
        'MQTT_USERNAME=$mqttUsername;'
        'MQTT_PASSWORD=$mqttPassword;'
        'USER_ID=$userId';
  }
}
