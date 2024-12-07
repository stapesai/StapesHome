import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/update_floor_usecase.dart';
import 'edit_floor_event.dart';
import 'edit_floor_state.dart';

class EditFloorBloc extends Bloc<EditFloorEvent, EditFloorState> {
  final UpdateFloorUseCase updateFloorUseCase;

  EditFloorBloc({required this.updateFloorUseCase}) : super(EditFloorInitial()) {
    on<EditFloorSubmitted>(_onEditFloorSubmitted);
  }

  Future<void> _onEditFloorSubmitted(
    EditFloorSubmitted event,
    Emitter<EditFloorState> emit,
  ) async {
    emit(EditFloorLoading());

    final params = UpdateFloorParams(
      floorId: event.floor.id!,
      floor: event.floor,
    );

    final result = await updateFloorUseCase(params);

    result.fold(
      (failure) => emit(EditFloorError(failure.message)),
      (response) => emit(EditFloorSuccess()),
    );
  }
}
