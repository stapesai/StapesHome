// lib/features/pairnewnode/presentation/bloc/pair_new_node_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:stapes_home/features/pair-new-node/domain/usecases/pair_bluetooth_device_usecase.dart';
import 'package:stapes_home/features/pair-new-node/domain/usecases/send_wifi_credentials_usecase.dart';
import 'pair_new_node_event.dart';
import 'pair_new_node_state.dart';

class PairNewNodeBloc extends Bloc<PairNewNodeEvent, PairNewNodeState> {
  final PairBluetoothDeviceUseCase pairBluetoothDeviceUseCase;
  final SendWifiCredentialsUseCase sendWifiCredentialsUseCase;

  PairNewNodeBloc({
    required this.pairBluetoothDeviceUseCase,
    required this.sendWifiCredentialsUseCase,
  }) : super(PairNewNodeInitial()) {
    on<StartPairingEvent>(_onStartPairing);
    on<SendWifiCredentialsEvent>(_onSendWifiCredentials);
    on<NameNodeEvent>(_onNameNode);
    on<CompletePairingEvent>(_onCompletePairing);
  }

  Future<void> _onStartPairing(
    StartPairingEvent event,
    Emitter<PairNewNodeState> emit,
  ) async {
    emit(PairNewNodeLoading());
    try {
      await pairBluetoothDeviceUseCase(event.deviceName, event.serviceUuid);
      emit(PairNewNodeBluetoothPaired());
    } catch (e) {
      emit(PairNewNodeError('Failed to pair Bluetooth device: $e'));
    }
  }

  Future<void> _onSendWifiCredentials(
    SendWifiCredentialsEvent event,
    Emitter<PairNewNodeState> emit,
  ) async {
    emit(PairNewNodeLoading());
    try {
      await sendWifiCredentialsUseCase(event.ssid, event.password);
      emit(PairNewNodeWifiCredentialsSent());
    } catch (e) {
      emit(PairNewNodeError('Failed to send Wi-Fi credentials: $e'));
    }
  }

  Future<void> _onNameNode(
    NameNodeEvent event,
    Emitter<PairNewNodeState> emit,
  ) async {
    // Implement node naming logic
    emit(PairNewNodeNamed());
  }

  Future<void> _onCompletePairing(
    CompletePairingEvent event,
    Emitter<PairNewNodeState> emit,
  ) async {
    // Implement pairing completion logic
    emit(PairNewNodeCompleted());
  }
}