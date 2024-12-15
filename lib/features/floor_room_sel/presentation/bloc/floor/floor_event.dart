// File: lib/features/floor_room_sel/presentation/bloc/floor/floor_event.dart
import 'package:equatable/equatable.dart';

abstract class FloorEvent extends Equatable {
  const FloorEvent();

  @override
  List<Object> get props => [];
}

class LoadFloors extends FloorEvent {}

class SelectFloor extends FloorEvent {
  final String floorId;
  const SelectFloor(this.floorId);

  @override
  List<Object> get props => [floorId];
}

class DeleteFloor extends FloorEvent {
  @override
  List<Object> get props => [];
}
