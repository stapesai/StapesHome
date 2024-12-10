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

// Node configuration events
// class GetNodeHwInfoEvent extends IotProvisioningEvent {
//   final BluetoothCharacteristic characteristic;

//   GetNodeHwInfoEvent(this.characteristic);

//   @override
//   List<Object?> get props => [characteristic];
// }

// class RequestNodePairingEvent extends IotProvisioningEvent {
//   final String roomId;
//   final String nodeName;
//   final Map<String, String> hwInfo;

//   RequestNodePairingEvent({
//     required this.roomId,
//     required this.nodeName,
//     required this.hwInfo,
//   });

//   @override
//   List<Object?> get props => [roomId, nodeName, hwInfo];
// }

// class SendNodeConfigEvent extends IotProvisioningEvent {
//   final BluetoothCharacteristic configChar;
//   final String ssid;
//   final String password;
//   final String userId;
//   final Map<String, String> mqttDetails;

//   SendNodeConfigEvent({
//     required this.configChar,
//     required this.ssid,
//     required this.password,
//     required this.userId,
//     required this.mqttDetails,
//   });

//   @override
//   List<Object?> get props => [configChar, ssid, password, userId, mqttDetails];
// }

// class CompleteNodePairingEvent extends IotProvisioningEvent {
//   final String transactionId;

//   CompleteNodePairingEvent(this.transactionId);

//   @override
//   List<Object?> get props => [transactionId];
// }
