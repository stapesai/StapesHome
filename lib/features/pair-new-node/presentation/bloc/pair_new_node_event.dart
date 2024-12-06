// lib/features/pairnewnode/presentation/bloc/pair_new_node_event.dart

import 'package:equatable/equatable.dart';

abstract class PairNewNodeEvent extends Equatable {
  const PairNewNodeEvent();

  @override
  List<Object?> get props => [];
}

class StartPairingEvent extends PairNewNodeEvent {
  final String deviceName;
  final String serviceUuid;

  const StartPairingEvent({
    required this.deviceName,
    required this.serviceUuid,
  });

  @override
  List<Object?> get props => [deviceName, serviceUuid];
}

class SendWifiCredentialsEvent extends PairNewNodeEvent {
  final String ssid;
  final String password;

  const SendWifiCredentialsEvent({
    required this.ssid,
    required this.password,
  });

  @override
  List<Object?> get props => [ssid, password];
}

class NameNodeEvent extends PairNewNodeEvent {
  final String nodeName;

  const NameNodeEvent({
    required this.nodeName,
  });

  @override
  List<Object?> get props => [nodeName];
}

class CompletePairingEvent extends PairNewNodeEvent {}