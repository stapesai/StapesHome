import 'package:equatable/equatable.dart';

abstract class EditRoomState extends Equatable {
  const EditRoomState();

  @override
  List<Object> get props => [];
}

class EditRoomInitial extends EditRoomState {}

class EditRoomLoading extends EditRoomState {}

class EditRoomSuccess extends EditRoomState {}

class EditRoomError extends EditRoomState {
  final String message;

  const EditRoomError(this.message);

  @override
  List<Object> get props => [message];
}
