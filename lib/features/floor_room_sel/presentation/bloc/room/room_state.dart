// File: lib/features/floor_room_sel/presentation/bloc/room/room_state.dart

import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/room_model.dart';

class RoomState extends Equatable {
  final bool isLoading;
  final List<RoomModel> rooms;
  final String? activeRoomId;
  final String? error;

  const RoomState({
    this.isLoading = false,
    this.rooms = const [],
    this.activeRoomId,
    this.error,
  });

  RoomState copyWith({
    bool? isLoading,
    List<RoomModel>? rooms,
    String? activeRoomId,
    String? error,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      rooms: rooms ?? this.rooms,
      activeRoomId: activeRoomId ?? this.activeRoomId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, rooms, activeRoomId, error];
}
