import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/models/floor_model.dart';

abstract class EditFloorEvent extends Equatable {
  const EditFloorEvent();

  @override
  List<Object> get props => [];
}

class EditFloorSubmitted extends EditFloorEvent {
  final FloorModel floor;

  const EditFloorSubmitted({required this.floor});

  @override
  List<Object> get props => [floor];
}
