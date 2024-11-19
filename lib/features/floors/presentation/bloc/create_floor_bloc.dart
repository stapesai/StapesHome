import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/create_floor_usecase.dart';
import 'create_floor_event.dart';
import 'create_floor_state.dart';

class CreateFloorBloc extends Bloc<CreateFloorEvent, CreateFloorState> {
  final CreateFloorUseCase createFloorUseCase;

  CreateFloorBloc({required this.createFloorUseCase}) : super(CreateFloorInitial()) {
    on<CreateFloorSubmitted>(_onCreateFloorSubmitted);
  }

  Future<void> _onCreateFloorSubmitted(
    CreateFloorSubmitted event,
    Emitter<CreateFloorState> emit,
  ) async {
    emit(CreateFloorLoading());

    final params = CreateFloorParams(
      floor: FloorModel(
        id: null,
        alias: event.alias,
        level: int.tryParse(event.level) ?? 0,
      ),
    );

    final result = await createFloorUseCase(params);

    result.fold(
      (failure) => emit(CreateFloorError(failure.message)),
      (response) => emit(CreateFloorSuccess()),
    );
  }
}
