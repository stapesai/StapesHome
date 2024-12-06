// lib/features/pairnewnode/presentation/bloc/pair_new_node_state.dart

import 'package:equatable/equatable.dart';

abstract class PairNewNodeState extends Equatable {
  const PairNewNodeState();

  @override
  List<Object?> get props => [];
}

class PairNewNodeInitial extends PairNewNodeState {}

class PairNewNodeLoading extends PairNewNodeState {}

class PairNewNodeBluetoothPaired extends PairNewNodeState {}

class PairNewNodeWifiCredentialsSent extends PairNewNodeState {}

class PairNewNodeNamed extends PairNewNodeState {}

class PairNewNodeCompleted extends PairNewNodeState {}

class PairNewNodeError extends PairNewNodeState {
  final String message;

  const PairNewNodeError(this.message);

  @override
  List<Object?> get props => [message];
}