// File: lib/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart

import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';

enum ItemType { floor, room }

class FloorRoomSelState extends Equatable {
  const FloorRoomSelState();

  @override
  List<Object> get props => [];
}

class FloorRoomSelInitial extends FloorRoomSelState {}

class FloorsLoading extends FloorRoomSelState {}

class FloorsLoadedEmpty extends FloorRoomSelState {}

class FloorsLoaded extends FloorRoomSelState {
  final List<FloorModel> floors;
  final String activeFloorId;

  const FloorsLoaded({
    required this.floors,
    required this.activeFloorId,
  });

  @override
  List<Object> get props => [floors, activeFloorId];
}

class FloorsLoadingError extends FloorRoomSelState {
  final String message;

  const FloorsLoadingError(this.message);

  @override
  List<Object> get props => [message];
}

class RoomsLoading extends FloorRoomSelState {}

class RoomsLoadedEmpty extends FloorRoomSelState {}

class RoomsLoaded extends FloorRoomSelState {
  final List<RoomModel> rooms;
  final String activeRoomId;

  const RoomsLoaded({
    required this.rooms,
    required this.activeRoomId,
  });

  @override
  List<Object> get props => [rooms, activeRoomId];
}

class RoomsLoadingError extends FloorRoomSelState {
  final String message;

  const RoomsLoadingError(this.message);

  @override
  List<Object> get props => [message];
}
