// lib/features/iot_provisioning/data/datasources/local/wifi_local_datasource.dart

import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class WifiLocalDataSource {
  Future<List<WiFiAccessPoint>> getAvailableWifiNetworks();
}

class WifiLocalDataSourceImpl implements WifiLocalDataSource {
  @override
  Future<List<WiFiAccessPoint>> getAvailableWifiNetworks() async {
    // Check permissions
    final permissions = await [
      Permission.location,
      Permission.storage,
    ].request();

    if (!permissions[Permission.location]!.isGranted || !permissions[Permission.storage]!.isGranted) {
      throw Exception('Required permissions not granted');
    }

    // Start scan
    final canStartScan = await WiFiScan.instance.canStartScan();
    if (canStartScan != CanStartScan.yes) {
      throw Exception('Cannot start WiFi scan');
    }

    // Perform scan
    final scanStarted = await WiFiScan.instance.startScan();
    if (!scanStarted) {
      throw Exception('Failed to start WiFi scan');
    }

    // Get results
    final results = await WiFiScan.instance.getScannedResults();

    // Filter and return 2.4GHz networks only
    return results
        .where((network) => network.ssid.isNotEmpty && network.frequency >= 2400 && network.frequency <= 2500)
        .toList();
  }
}
