// lib/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart

import 'package:equatable/equatable.dart';
import 'package:wifi_scan/wifi_scan.dart';

abstract class IotProvisioningState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial State - when the screen is loaded
class IotProvisioningInitial extends IotProvisioningState {}

// BLE Pairing States
class BlePairingInProgress extends IotProvisioningState {}

class BlePairingSuccess extends IotProvisioningState {}

class BlePairingFailure extends IotProvisioningState {
  final String error;
  BlePairingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Load WiFi Networks States
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

// Check WiFi Credentials using BLE States
class CheckingWifiCredentials extends IotProvisioningState {}

class WifiCredentialsValid extends IotProvisioningState {}

class WifiCredentialsInvalid extends IotProvisioningState {
  final String error;
  WifiCredentialsInvalid(this.error);

  @override
  List<Object?> get props => [error];
}

// Provision Node States
// 1. Request Node Pairing from backend
class RequestingNodePairing extends IotProvisioningState {}

class NodePairingRequestSuccess extends IotProvisioningState {}

class NodePairingRequestFailure extends IotProvisioningState {
  final String error;
  NodePairingRequestFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// 2. Send Config to Node
class UploadConfigToNode extends IotProvisioningState {}

class UploadConfigToNodeSuccess extends IotProvisioningState {}

class UploadConfigToNodeFailure extends IotProvisioningState {
  final String error;
  UploadConfigToNodeFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// 3. Confirming Node Pairing
class CompletingNodePairing extends IotProvisioningState {}

class CompleteNodePairingSuccess extends IotProvisioningState {}

class CompleteNodePairingFailure extends IotProvisioningState {
  final String error;
  CompleteNodePairingFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class NodeProvisioned extends IotProvisioningState {}

class NodeProvisioningError extends IotProvisioningState {
  final String error;
  NodeProvisioningError(this.error);

  @override
  List<Object?> get props => [error];
}
