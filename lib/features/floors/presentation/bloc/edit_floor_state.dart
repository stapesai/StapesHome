import 'package:equatable/equatable.dart';

abstract class EditFloorState extends Equatable {
  const EditFloorState();

  @override
  List<Object> get props => [];
}

class EditFloorInitial extends EditFloorState {}

class EditFloorLoading extends EditFloorState {}

class EditFloorSuccess extends EditFloorState {}

class EditFloorError extends EditFloorState {
  final String message;

  const EditFloorError(this.message);

  @override
  List<Object> get props => [message];
}
