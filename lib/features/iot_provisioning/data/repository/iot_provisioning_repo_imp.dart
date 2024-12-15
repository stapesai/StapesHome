// lib/features/iot_provisioning/data/repository/iot_provisioning_repo_impl.dart

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/wifi_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/models/node_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

class IotProvisioningRepositoryImpl implements IotProvisioningRepository {
  final BleLocalDataSource bleDataSource;
  final WifiLocalDataSource wifiDataSource;

  IotProvisioningRepositoryImpl({
    required this.bleDataSource,
    required this.wifiDataSource,
  });

  @override
  Future<
      (
        bool success,
        String? failureReason,
        BluetoothDevice? device,
        BluetoothCharacteristic? configChar,
        BluetoothCharacteristic? hwVersionChar,
        BluetoothCharacteristic? checkWiFiCredentialsChar
      )> pairBleNode(IotQrModel qrData) {
    return bleDataSource.pairBleNode(qrData);
  }

  @override
  Future<List<WiFiAccessPoint>> getAvailableWifiNetworks() {
    return wifiDataSource.getAvailableWifiNetworks();
  }

  @override
  Future<bool> checkWiFiCredentialsOnNode(BluetoothCharacteristic char, String ssid, String password) {
    return bleDataSource.checkWiFiCredentialsOnNode(char, ssid, password);
  }

  @override
  Future<NodeHwInfo> getHwInfo(BluetoothCharacteristic hwVersionChar) {
    return bleDataSource.getHwInfo(hwVersionChar);
  }

  @override
  Future<bool> sendConfigToNode(SendConfigToNode configData) {
    return bleDataSource.sendConfigToNode(configData);
  }
}
