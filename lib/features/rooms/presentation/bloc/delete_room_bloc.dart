// lib/features/rooms/presentation/bloc/delete_room_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'delete_room_event.dart';
import 'delete_room_state.dart';

class DeleteRoomBloc extends Bloc<DeleteRoomEvent, DeleteRoomState> {
  final DeleteRoomUseCase deleteRoomUseCase;

  DeleteRoomBloc({required this.deleteRoomUseCase}) : super(DeleteRoomInitial()) {
    on<DeleteRoomSubmitted>(_onDeleteRoomSubmitted);
  }

  Future<void> _onDeleteRoomSubmitted(
    DeleteRoomSubmitted event,
    Emitter<DeleteRoomState> emit,
  ) async {
    emit(DeleteRoomLoading());

    final params = DeleteRoomParams(roomId: event.roomId);
    final result = await deleteRoomUseCase(params);

    result.fold(
      (failure) => emit(DeleteRoomError(failure.message)),
      (response) => emit(DeleteRoomSuccess()),
    );
  }
}