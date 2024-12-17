// File: lib/features/rooms/presentation/bloc/edit_room_event.dart
import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/room_model.dart';

abstract class EditRoomEvent extends Equatable {
  const EditRoomEvent();

  @override
  List<Object> get props => [];
}

class EditRoomSubmitted extends EditRoomEvent {
  final RoomModel room;

  const EditRoomSubmitted({required this.room});

  @override
  List<Object> get props => [room];
}
