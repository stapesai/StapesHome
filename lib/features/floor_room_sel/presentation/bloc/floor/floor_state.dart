// File: lib/features/floor_room_sel/presentation/bloc/floor/floor_state.dart

import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/floor_model.dart';

class FloorState extends Equatable {
  final bool isLoading;
  final List<FloorModel> floors;
  final String? activeFloorId;
  final String? error;

  const FloorState({
    this.isLoading = true,
    this.floors = const [],
    this.activeFloorId,
    this.error,
  });

  FloorState copyWith({
    bool? isLoading,
    List<FloorModel>? floors,
    String? activeFloorId,
    String? error,
  }) {
    return FloorState(
      isLoading: isLoading ?? this.isLoading,
      floors: floors ?? this.floors,
      activeFloorId: activeFloorId ?? this.activeFloorId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, floors, activeFloorId, error];
}
