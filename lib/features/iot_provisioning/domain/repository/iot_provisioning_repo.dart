// lib/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:stapes_home/features/iot_provisioning/data/models/node_hw_info.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

abstract class IotProvisioningRepository {
  Future<
      (
        bool success,
        String? failureReason,
        BluetoothDevice? device,
        BluetoothCharacteristic? configChar,
        BluetoothCharacteristic? hwVersionChar,
        BluetoothCharacteristic? checkWiFiCredentialsChar
      )> pairBleNode(IotQrModel qrData);
  Future<List<WiFiAccessPoint>> getAvailableWifiNetworks();
  Future<bool> checkWiFiCredentialsOnNode(BluetoothCharacteristic char, String ssid, String password);
  Future<NodeHwInfo> getHwInfo(BluetoothCharacteristic hwVersionChar);
  Future<bool> sendConfigToNode(SendConfigToNode configData);
}
