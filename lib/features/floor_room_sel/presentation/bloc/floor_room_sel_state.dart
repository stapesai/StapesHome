import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';

abstract class FloorRoomSelState extends Equatable {
  const FloorRoomSelState();

  @override
  List<Object> get props => [];
}

class FloorRoomSelInitial extends FloorRoomSelState {}

class FloorRoomSelLoading extends FloorRoomSelState {}

class FloorRoomSelLoaded extends FloorRoomSelState {
  final List<FloorModel> floors;
  final List<RoomModel> rooms;
  final String activeFloorId;
  final String activeRoomId;

  const FloorRoomSelLoaded({
    required this.floors,
    required this.rooms,
    required this.activeFloorId,
    required this.activeRoomId,
  });

  @override
  List<Object> get props => [floors, rooms, activeFloorId, activeRoomId];
}

class FloorRoomSelError extends FloorRoomSelState {
  final String message;

  const FloorRoomSelError(this.message);

  @override
  List<Object> get props => [message];
}
