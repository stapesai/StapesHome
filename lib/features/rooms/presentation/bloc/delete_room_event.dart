// lib/features/rooms/presentation/bloc/delete_room_event.dart

import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/room_model.dart';

abstract class DeleteRoomEvent extends Equatable {
  const DeleteRoomEvent();

  @override
  List<Object> get props => [];
}

class DeleteRoomSubmitted extends DeleteRoomEvent {
  final String roomId;

  const DeleteRoomSubmitted({required this.roomId});

  @override
  List<Object> get props => [roomId];
}