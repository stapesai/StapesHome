// File: lib\features\rooms\presentation\bloc\create_room_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/create_room_usecase.dart';
import 'create_room_event.dart';
import 'create_room_state.dart';

class CreateRoomBloc extends Bloc<CreateRoomEvent, CreateRoomState> {
  final CreateRoomUseCase createRoomUseCase;

  CreateRoomBloc({required this.createRoomUseCase}) : super(CreateRoomInitial()) {
    on<CreateRoomSubmitted>(_onCreateRoomSubmitted);
  }

  Future<void> _onCreateRoomSubmitted(
    CreateRoomSubmitted event,
    Emitter<CreateRoomState> emit,
  ) async {
    emit(CreateRoomLoading());

    final params = CreateRoomParams(
      room: RoomModel(
        id: null,
        floorId: event.floorId,
        name: event.name,
        type: event.type,
      ),
    );

    final result = await createRoomUseCase(params);

    result.fold(
      (failure) => emit(CreateRoomError(failure.message)),
      (response) => emit(CreateRoomSuccess()),
    );
  }
}
