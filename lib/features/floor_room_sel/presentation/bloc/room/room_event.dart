// File: lib/features/floor_room_sel/presentation/bloc/room/room_event.dart

import 'package:equatable/equatable.dart';

abstract class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class LoadRooms extends RoomEvent {
  final String floorId;
  const LoadRooms(this.floorId);

  @override
  List<Object> get props => [floorId];
}

class SelectRoom extends RoomEvent {
  final String roomId;
  const SelectRoom(this.roomId);

  @override
  List<Object> get props => [roomId];
}

class DeleteRoom extends RoomEvent {
  final String roomId;
  const DeleteRoom(this.roomId);

  @override
  List<Object> get props => [roomId];
}
