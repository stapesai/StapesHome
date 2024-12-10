// lib/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/wifi_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
import 'package:stapes_home/features/nodes/data/models/complete_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/request_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class IotProvisioningBloc extends Bloc<IotProvisioningEvent, IotProvisioningState> {
  final BleLocalDataSource _bleDataSource = serviceLocator<BleLocalDataSource>();
  final WifiLocalDataSource _wifiDataSource = serviceLocator<WifiLocalDataSource>();
  // final NodeRepository _nodeRepository = serviceLocator<NodeRepository>();

  // BLE Related variables are stored in Bloc instead of UI
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? hwVersionChar;
  BluetoothCharacteristic? checkWiFiCredentialsChar;

  IotProvisioningBloc() : super(IotProvisioningInitial()) {
    // BLE Pairing
    on<PairBleDeviceEvent>(_onPairBleDevice);

    // WiFi Operations
    on<GetAvailableWifiNetworksEvent>(_onGetAvailableWifiNetworks);
    // on<CheckWifiCredentialsEvent>(_onCheckWifiCredentials);

    // Node Configuration
    // on<GetNodeHwInfoEvent>(_onGetNodeHwInfo);
    // on<RequestNodePairingEvent>(_onRequestNodePairing);
    // on<SendNodeConfigEvent>(_onSendNodeConfig);
    // on<CompleteNodePairingEvent>(_onCompleteNodePairing);
  }

  Future<void> _onPairBleDevice(
    PairBleDeviceEvent event,
    Emitter<IotProvisioningState> emit,
  ) async {
    emit(BlePairingInProgress());
    try {
      final (success, failureReason, device, configCharResult, hwVersionCharResult, checkWiFiCredentialsCharResult) =
          await _bleDataSource.pairBleNode(event.qrData);

      configChar = configCharResult;
      hwVersionChar = hwVersionCharResult;
      checkWiFiCredentialsChar = checkWiFiCredentialsCharResult;

      if (success) {
        emit(BlePairingSuccess());
      } else {
        emit(BlePairingFailure(failureReason ?? 'Unknown error'));
      }
    } catch (e) {
      emit(BlePairingFailure(e.toString()));
    }
  }

  Future<void> _onGetAvailableWifiNetworks(
    GetAvailableWifiNetworksEvent event,
    Emitter<IotProvisioningState> emit,
  ) async {
    emit(LoadingWifiNetworks());
    try {
      final networks = await _wifiDataSource.getAvailableWifiNetworks();
      emit(WifiNetworksLoaded(networks));
    } catch (e) {
      emit(WifiNetworksError(e.toString()));
    }
  }

  // Future<void> _onCheckWifiCredentials(
  //   CheckWifiCredentialsEvent event,
  //   Emitter<IotProvisioningState> emit,
  // ) async {
  //   emit(CheckingWifiCredentials());
  //   try {
  //     final isValid = await _bleDataSource.checkWiFiCredentialsOnNode(
  //       event.characteristic,
  //       event.ssid,
  //       event.password,
  //     );
  //     if (isValid) {
  //       emit(WifiCredentialsValid());
  //     } else {
  //       emit(WifiCredentialsInvalid('Invalid WiFi credentials'));
  //     }
  //   } catch (e) {
  //     emit(WifiCredentialsInvalid(e.toString()));
  //   }
  // }

  // Future<void> _onGetNodeHwInfo(
  //   GetNodeHwInfoEvent event,
  //   Emitter<IotProvisioningState> emit,
  // ) async {
  //   emit(LoadingNodeHwInfo());
  //   try {
  //     final hwInfo = await _bleDataSource.getHwInfo(event.characteristic);
  //     emit(NodeHwInfoLoaded(hwInfo.toJson()));
  //   } catch (e) {
  //     emit(NodeHwInfoError(e.toString()));
  //   }
  // }

  // Future<void> _onRequestNodePairing(
  //   RequestNodePairingEvent event,
  //   Emitter<IotProvisioningState> emit,
  // ) async {
  //   emit(RequestingNodePairing());
  //   try {
  //     final response = await _nodeRepository.requestNodePairing(
  //       RequestNodePairingParams(
  //         roomId: event.roomId,
  //         name: event.nodeName,
  //         hardwareInfo: event.hwInfo,
  //       ),
  //     );

  //     response.fold(
  //       (failure) => emit(NodePairingRequestFailure(failure.toString())),
  //       (success) => emit(NodePairingRequestSuccess(success.transactionId)),
  //     );
  //   } catch (e) {
  //     emit(NodePairingRequestFailure(e.toString()));
  //   }
  // }

  // Future<void> _onSendNodeConfig(
  //   SendNodeConfigEvent event,
  //   Emitter<IotProvisioningState> emit,
  // ) async {
  //   emit(SendingNodeConfig());
  //   try {
  //     final success = await _bleDataSource.sendConfigToNode(
  //       event.configChar,
  //       event.ssid,
  //       event.password,
  //       event.userId,
  //       event.mqttDetails['host']!,
  //       event.mqttDetails['port']!,
  //       event.mqttDetails['username']!,
  //       event.mqttDetails['password']!,
  //     );

  //     if (success) {
  //       emit(NodeConfigSent());
  //     } else {
  //       emit(NodeConfigError('Failed to send configuration'));
  //     }
  //   } catch (e) {
  //     emit(NodeConfigError(e.toString()));
  //   }
  // }

  // Future<void> _onCompleteNodePairing(
  //   CompleteNodePairingEvent event,
  //   Emitter<IotProvisioningState> emit,
  // ) async {
  //   emit(CompletingNodePairing());
  //   try {
  //     final response = await _nodeRepository.completeNodePairing(
  //       CompleteNodePairingParams(transactionId: event.transactionId),
  //     );

  //     response.fold(
  //       (failure) => emit(NodePairingError(failure.toString())),
  //       (success) => emit(NodePairingComplete()),
  //     );
  //   } catch (e) {
  //     emit(NodePairingError(e.toString()));
  //   }
  // }
}
