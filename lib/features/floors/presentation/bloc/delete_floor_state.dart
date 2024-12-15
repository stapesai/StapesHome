// File: lib\features\floors\presentation\bloc\delete_floor_state.dart

import 'package:equatable/equatable.dart';

abstract class DeleteFloorState extends Equatable {
  const DeleteFloorState();

  @override
  List<Object> get props => [];
}

class DeleteFloorInitial extends DeleteFloorState {}

class DeleteFloorLoading extends DeleteFloorState {}

class DeleteFloorSuccess extends DeleteFloorState {}

class DeleteFloorError extends DeleteFloorState {
  final String message;

  const DeleteFloorError(this.message);

  @override
  List<Object> get props => [message];
}