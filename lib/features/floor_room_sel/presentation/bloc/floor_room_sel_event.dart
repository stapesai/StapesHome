import 'package:equatable/equatable.dart';

abstract class FloorRoomSelEvent extends Equatable {
  const FloorRoomSelEvent();

  @override
  List<Object> get props => [];
}

class LoadFloors extends FloorRoomSelEvent {}

class LoadRooms extends FloorRoomSelEvent {
  final String floorId;

  const LoadRooms({required this.floorId});

  @override
  List<Object> get props => [floorId];
}

class SelectFloor extends FloorRoomSelEvent {
  final String floorId;

  const SelectFloor({required this.floorId});

  @override
  List<Object> get props => [floorId];
}

class SelectRoom extends FloorRoomSelEvent {
  final String roomId;

  const SelectRoom({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class DeleteFloor extends FloorRoomSelEvent {
  final String floorId;

  const DeleteFloor({required this.floorId});

  @override
  List<Object> get props => [floorId];
}

class DeleteRoom extends FloorRoomSelEvent {
  final String roomId;

  const DeleteRoom({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class RefreshData extends FloorRoomSelEvent {}
