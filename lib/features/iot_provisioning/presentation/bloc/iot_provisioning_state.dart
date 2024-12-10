// lib/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:wifi_scan/wifi_scan.dart';

abstract class IotProvisioningState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial State - when the screen is loaded
class IotProvisioningInitial extends IotProvisioningState {}

// BLE
class BlePairingInProgress extends IotProvisioningState {}

class BlePairingSuccess extends IotProvisioningState {}

class BlePairingFailure extends IotProvisioningState {
  final String error;
  BlePairingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// WiFi States
class LoadingWifiNetworks extends IotProvisioningState {}

class WifiNetworksLoaded extends IotProvisioningState {
  final List<WiFiAccessPoint> networks;
  WifiNetworksLoaded(this.networks);

  @override
  List<Object?> get props => [networks];
}

class WifiNetworksError extends IotProvisioningState {
  final String error;
  WifiNetworksError(this.error);

  @override
  List<Object?> get props => [error];
}

// class CheckingWifiCredentials extends IotProvisioningState {}

// class WifiCredentialsValid extends IotProvisioningState {}

// class WifiCredentialsInvalid extends IotProvisioningState {
//   final String error;
//   WifiCredentialsInvalid(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// Node Configuration States
// class LoadingNodeHwInfo extends IotProvisioningState {}

// class NodeHwInfoLoaded extends IotProvisioningState {
//   final Map<String, String> hwInfo;
//   NodeHwInfoLoaded(this.hwInfo);

//   @override
//   List<Object?> get props => [hwInfo];
// }

// class NodeHwInfoError extends IotProvisioningState {
//   final String error;
//   NodeHwInfoError(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class RequestingNodePairing extends IotProvisioningState {}

// class NodePairingRequestSuccess extends IotProvisioningState {
//   final String transactionId;
//   NodePairingRequestSuccess(this.transactionId);

//   @override
//   List<Object?> get props => [transactionId];
// }

// class NodePairingRequestFailure extends IotProvisioningState {
//   final String error;
//   NodePairingRequestFailure(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class SendingNodeConfig extends IotProvisioningState {}

// class NodeConfigSent extends IotProvisioningState {}

// class NodeConfigError extends IotProvisioningState {
//   final String error;
//   NodeConfigError(this.error);

//   @override
//   List<Object?> get props => [error];
// }

// class CompletingNodePairing extends IotProvisioningState {}

// class NodePairingComplete extends IotProvisioningState {}

// class NodePairingError extends IotProvisioningState {
//   final String error;
//   NodePairingError(this.error);

//   @override
//   List<Object?> get props => [error];
// }
