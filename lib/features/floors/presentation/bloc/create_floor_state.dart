// File: lib\features\floors\presentation\bloc\create_floor_state.dart
import 'package:equatable/equatable.dart';

abstract class CreateFloorState extends Equatable {
  const CreateFloorState();

  @override
  List<Object> get props => [];
}

class CreateFloorInitial extends CreateFloorState {}

class CreateFloorLoading extends CreateFloorState {}

class CreateFloorSuccess extends CreateFloorState {}

class CreateFloorError extends CreateFloorState {
  final String message;

  const CreateFloorError(this.message);

  @override
  List<Object> get props => [message];
}
