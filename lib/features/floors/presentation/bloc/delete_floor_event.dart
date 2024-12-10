import 'package:equatable/equatable.dart';

abstract class DeleteFloorEvent extends Equatable {
  const DeleteFloorEvent();

  @override
  List<Object> get props => [];
}

class DeleteFloorSubmitted extends DeleteFloorEvent {
  final String floorId;

  const DeleteFloorSubmitted({required this.floorId});

  @override
  List<Object> get props => [floorId];
}
