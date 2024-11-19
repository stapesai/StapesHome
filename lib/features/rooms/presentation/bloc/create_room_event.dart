import 'package:equatable/equatable.dart';

abstract class CreateRoomEvent extends Equatable {
  const CreateRoomEvent();

  @override
  List<Object> get props => [];
}

class CreateRoomSubmitted extends CreateRoomEvent {
  final String floorId;
  final String name;
  final String type;

  const CreateRoomSubmitted({
    required this.floorId,
    required this.name,
    required this.type,
  });

  @override
  List<Object> get props => [floorId, name, type];
}
