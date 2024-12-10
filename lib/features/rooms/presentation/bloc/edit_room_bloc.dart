// File: lib/features/rooms/presentation/bloc/edit_room_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/update_room_usecase.dart';
import 'edit_room_event.dart';
import 'edit_room_state.dart';

class EditRoomBloc extends Bloc<EditRoomEvent, EditRoomState> {
  final UpdateRoomUseCase updateRoomUseCase;

  EditRoomBloc({required this.updateRoomUseCase}) : super(EditRoomInitial()) {
    on<EditRoomSubmitted>(_onEditRoomSubmitted);
  }

  Future<void> _onEditRoomSubmitted(
    EditRoomSubmitted event,
    Emitter<EditRoomState> emit,
  ) async {
    emit(EditRoomLoading());

    final params = UpdateRoomParams(
      roomId: event.room.id!,
      room: event.room,
    );

    final result = await updateRoomUseCase(params);

    result.fold(
      (failure) => emit(EditRoomError(failure.message)),
      (response) => emit(EditRoomSuccess()),
    );
  }
}
