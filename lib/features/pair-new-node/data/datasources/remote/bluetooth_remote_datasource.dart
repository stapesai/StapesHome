// lib/features/pairnewnode/data/datasources/bluetooth_remote_data_source.dart

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothRemoteDataSource {
  final FlutterBluePlus? flutterBlue;
  BluetoothDevice? connectedDevice;
  StreamSubscription? scanSubscription;

  BluetoothRemoteDataSource({required this.flutterBlue});

  Future<void> startScan() async {
    await FlutterBluePlus.startScan(timeout: Duration(seconds: 10));
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;
  }

  Future<List<BluetoothService>> discoverServices() async {
    if (connectedDevice == null) throw Exception('No device connected');
    return await connectedDevice!.discoverServices();
  }

  Future<void> disconnect() async {
    await connectedDevice?.disconnect();
    scanSubscription?.cancel();
    connectedDevice = null;
  }
}