// lib/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart

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
  final bool isLoadingFloors;
  final bool isLoadingRooms;

  const FloorRoomSelLoaded({
    required this.floors,
    required this.rooms,
    required this.activeFloorId,
    required this.activeRoomId,
    this.isLoadingFloors = false,
    this.isLoadingRooms = false,
  });

  FloorRoomSelLoaded copyWith({
    List<FloorModel>? floors,
    List<RoomModel>? rooms,
    String? activeFloorId,
    String? activeRoomId,
    bool? isLoadingFloors,
    bool? isLoadingRooms,
  }) {
    return FloorRoomSelLoaded(
      floors: floors ?? this.floors,
      rooms: rooms ?? this.rooms,
      activeFloorId: activeFloorId ?? this.activeFloorId,
      activeRoomId: activeRoomId ?? this.activeRoomId,
      isLoadingFloors: isLoadingFloors ?? this.isLoadingFloors,
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
    );
  }

  @override
  List<Object> get props => [
        floors,
        rooms,
        activeFloorId,
        activeRoomId,
        isLoadingFloors,
        isLoadingRooms,
      ];
}

class FloorRoomSelError extends FloorRoomSelState {
  final String message;

  const FloorRoomSelError(this.message);

  @override
  List<Object> get props => [message];
}
