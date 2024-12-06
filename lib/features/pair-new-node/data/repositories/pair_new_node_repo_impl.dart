// lib/features/pairnewnode/data/repositories/pair_new_node_repository_impl.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/pair-new-node/data/datasources/remote/bluetooth_remote_datasource.dart';
import 'package:stapes_home/features/pair-new-node/domain/repository/pair_new_node_repo.dart';

class PairNewNodeRepositoryImpl implements PairNewNodeRepository {
  final BluetoothRemoteDataSource bluetoothDataSource;
  final HttpClient httpClient;

  PairNewNodeRepositoryImpl({
    required this.bluetoothDataSource,
    required this.httpClient,
  });

  @override
  Future<void> pairBluetoothDevice(String deviceName, String serviceUuid) async {
    try {
      await bluetoothDataSource.startScan();

      final completer = Completer<void>();

      bluetoothDataSource.scanSubscription = bluetoothDataSource.scanResults.listen((results) async {
        for (ScanResult result in results) {
          if (result.device.platformName == deviceName) {
            await bluetoothDataSource.stopScan();
            await bluetoothDataSource.scanSubscription?.cancel();

            await bluetoothDataSource.connectToDevice(result.device);

            final services = await bluetoothDataSource.discoverServices();

            BluetoothCharacteristic? configCharacteristic;
            BluetoothCharacteristic? versionCharacteristic;

            for (BluetoothService service in services) {
              if (service.uuid.toString() == serviceUuid) {
                for (BluetoothCharacteristic characteristic in service.characteristics) {
                  // Adjust UUIDs accordingly
                  if (characteristic.uuid.toString() == 'CONFIG_CHARACTERISTIC_UUID') {
                    configCharacteristic = characteristic;
                  } else if (characteristic.uuid.toString() == 'VERSION_CHARACTERISTIC_UUID') {
                    versionCharacteristic = characteristic;
                  }
                }
              }
            }

            if (configCharacteristic != null && versionCharacteristic != null) {
              // Save characteristics or proceed as needed
              completer.complete();
            } else {
              throw Exception('Required characteristics not found');
            }
            break;
          }
        }
      });

      await completer.future.timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Device not found');
      });
    } catch (e) {
      await bluetoothDataSource.disconnect();
      throw Exception('Pairing failed: $e');
    }
  }

  @override
  Future<void> sendWifiCredentials(String ssid, String password) async {
    // Implement sending Wi-Fi credentials via Bluetooth
    throw UnimplementedError();
  }

  @override
  Future<void> createNode(String roomId, String nodeName, Map<String, String> hardwareData) async {
    // Implement API call to create node
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> getMqttDetails() async {
    // Implement fetching MQTT details from the server
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> getHardwareInfo() async {
    // Implement fetching hardware info via Bluetooth
    throw UnimplementedError();
  }
}