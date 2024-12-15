// File: lib\features\floors\presentation\bloc\delete_floor_event.dart
import 'package:equatable/equatable.dart';

abstract class CreateRoomState extends Equatable {
  const CreateRoomState();

  @override
  List<Object> get props => [];
}

class CreateRoomInitial extends CreateRoomState {}

class CreateRoomLoading extends CreateRoomState {}

class CreateRoomSuccess extends CreateRoomState {}

class CreateRoomError extends CreateRoomState {
  final String message;

  const CreateRoomError(this.message);

  @override
  List<Object> get props => [message];
}
