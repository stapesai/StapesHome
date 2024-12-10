// lib/features/rooms/presentation/bloc/delete_room_state.dart

import 'package:equatable/equatable.dart';

abstract class DeleteRoomState extends Equatable {
  const DeleteRoomState();

  @override
  List<Object> get props => [];
}

class DeleteRoomInitial extends DeleteRoomState {}

class DeleteRoomLoading extends DeleteRoomState {}

class DeleteRoomSuccess extends DeleteRoomState {}

class DeleteRoomError extends DeleteRoomState {
  final String message;

  const DeleteRoomError(this.message);

  @override
  List<Object> get props => [message];
}