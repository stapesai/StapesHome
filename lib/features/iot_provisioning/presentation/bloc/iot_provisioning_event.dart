// lib/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart

import 'package:equatable/equatable.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

abstract class IotProvisioningEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// BLE Pairing Event
class PairBleDeviceEvent extends IotProvisioningEvent {
  final IotQrModel qrData;

  PairBleDeviceEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

// Load WiFi Networks Event
class GetAvailableWifiNetworksEvent extends IotProvisioningEvent {}

// Check WiFi Credentials using BLE Event
class CheckWifiCredentialsEvent extends IotProvisioningEvent {
  final String ssid;
  final String password;

  CheckWifiCredentialsEvent({
    required this.ssid,
    required this.password,
  });

  @override
  List<Object?> get props => [ssid, password];
}

// Provision Node Event
class ProvisionNodeEvent extends IotProvisioningEvent {
  final String roomId;
  final String nodeName;
  final String wifiSSID;
  final String wifiPassword;

  ProvisionNodeEvent({
    required this.roomId,
    required this.nodeName,
    required this.wifiSSID,
    required this.wifiPassword,
  });

  @override
  List<Object?> get props => [roomId, nodeName, wifiSSID, wifiPassword];
}
