// File: lib\features\floors\presentation\bloc\create_floor_event.dart
import 'package:equatable/equatable.dart';

abstract class CreateFloorEvent extends Equatable {
  const CreateFloorEvent();

  @override
  List<Object> get props => [];
}

class CreateFloorSubmitted extends CreateFloorEvent {
  final String alias;
  final String level;

  const CreateFloorSubmitted({
    required this.alias,
    required this.level,
  });

  @override
  List<Object> get props => [alias, level];
}
