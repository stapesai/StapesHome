// lib/features/iot_provisioning/presentation/bloc/iot_provisioning_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/core/models/node_model.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/wifi_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/models/node_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_event.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/bloc/iot_provisioning_state.dart';
import 'package:stapes_home/features/nodes/data/models/complete_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/request_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';

class IotProvisioningBloc extends Bloc<IotProvisioningEvent, IotProvisioningState> {
  final BleLocalDataSource bleDataSource;
  final WifiLocalDataSource wifiDataSource;
  final NodeRepository nodeRepository;
  final AuthLocalDataSource authLocalDataSource;

  // BLE Related variables are stored in Bloc instead of UI
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? hwVersionChar;
  BluetoothCharacteristic? checkWiFiCredentialsChar;

  IotProvisioningBloc({
    required this.bleDataSource,
    required this.wifiDataSource,
    required this.nodeRepository,
    required this.authLocalDataSource,
  }) : super(IotProvisioningInitial()) {
    // BLE Pairing
    on<PairBleDeviceEvent>(_onPairBleDevice);

    // WiFi Operations
    on<GetAvailableWifiNetworksEvent>(_onGetAvailableWifiNetworks);
    on<CheckWifiCredentialsEvent>(_onCheckWifiCredentials);

    // Node Configuration
    on<ProvisionNodeEvent>(_provisionNode);
  }

  Future<void> _onPairBleDevice(
    PairBleDeviceEvent event,
    Emitter<IotProvisioningState> emit,
  ) async {
    emit(BlePairingInProgress());
    try {
      final (success, failureReason, device, configCharResult, hwVersionCharResult, checkWiFiCredentialsCharResult) =
          await bleDataSource.pairBleNode(event.qrData);

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
      final networks = await wifiDataSource.getAvailableWifiNetworks();
      emit(WifiNetworksLoaded(networks));
    } catch (e) {
      emit(WifiNetworksError(e.toString()));
    }
  }

  Future<void> _onCheckWifiCredentials(
    CheckWifiCredentialsEvent event,
    Emitter<IotProvisioningState> emit,
  ) async {
    emit(CheckingWifiCredentials());
    try {
      final isValid = await bleDataSource.checkWiFiCredentialsOnNode(
        checkWiFiCredentialsChar!,
        event.ssid,
        event.password,
      );
      if (isValid) {
        emit(WifiCredentialsValid());
      } else {
        emit(WifiCredentialsInvalid('Invalid WiFi credentials'));
      }
    } catch (e) {
      emit(WifiCredentialsInvalid(e.toString()));
    }
  }

  Future<void> _provisionNode(
    ProvisionNodeEvent event,
    Emitter<IotProvisioningState> emit,
  ) async {
    late final String nodePairingRequestTransactionId;
    late final String responseMqttHost;
    late final String responseMqttPort;
    late final String responseMqttUsername;
    late final String responseMqttPassword;

    emit(RequestingNodePairing());
    try {
      // 1. Get HW Info from the Node
      final NodeHwInfo hwInfo = await bleDataSource.getHwInfo(hwVersionChar!);

      // 2. Request Node Pairing from backend
      final response = await nodeRepository.requestNodePairing(
        RequestNodePairingParams(
          node: NodeModel(
            id: null,
            roomId: event.roomId,
            name: event.nodeName,
          ),
          hardwareChip: hwInfo.hardwareChip,
          hardwareVersion: hwInfo.hardwareChip,
          manifactureId: hwInfo.hardwareChip,
          firmwareVersion: hwInfo.hardwareChip,
        ),
      );

      response.fold(
        (failure) => emit(NodePairingRequestFailure(failure.toString())),
        (success) {
          nodePairingRequestTransactionId = success.transactionId;
          responseMqttHost = success.mqttHost;
          responseMqttPort = success.mqttPort;
          responseMqttUsername = success.mqttUsername;
          responseMqttPassword = success.mqttPassword;
          emit(NodePairingRequestSuccess());
        },
      );

      // 3. Send Config to Node
      emit(UploadConfigToNode());

      // 3.1 Get UserId from local storage
      final userSession = await authLocalDataSource.getUserSession();
      final userId = userSession?.userId;

      final configData = SendConfigToNode(
        configCharacteristicUuid: configChar!,
        wifiSSID: event.wifiSSID,
        wifiPassword: event.wifiPassword,
        userId: userId!,
        mqttHost: responseMqttHost,
        mqttPort: responseMqttPort,
        mqttUsername: responseMqttUsername,
        mqttPassword: responseMqttPassword,
      );
      final success = await bleDataSource.sendConfigToNode(configData);

      if (success) {
        emit(UploadConfigToNodeSuccess());
      } else {
        emit(UploadConfigToNodeFailure('Failed to send configuration'));
      }

      // 4. Confirming Node Pairing
      emit(CompletingNodePairing());

      final responseComplete = await nodeRepository.completeNodePairing(
        CompleteNodePairingParams(transactionId: nodePairingRequestTransactionId),
      );

      responseComplete.fold(
        (failure) => emit(CompleteNodePairingFailure(failure.toString())),
        (success) => emit(CompleteNodePairingSuccess()),
      );

      // 5. Node Provisioned
      emit(NodeProvisioned());
    } catch (e) {
      emit(NodeProvisioningError(e.toString()));
    }
  }
}
