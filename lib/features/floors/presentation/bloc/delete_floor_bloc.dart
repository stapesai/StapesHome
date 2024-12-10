import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'delete_floor_event.dart';
import 'delete_floor_state.dart';

class DeleteFloorBloc extends Bloc<DeleteFloorEvent, DeleteFloorState> {
  final DeleteFloorUseCase deleteFloorUseCase;

  DeleteFloorBloc({required this.deleteFloorUseCase}) : super(DeleteFloorInitial()) {
    on<DeleteFloorSubmitted>(_onDeleteFloorSubmitted);
  }

  Future<void> _onDeleteFloorSubmitted(
    DeleteFloorSubmitted event,
    Emitter<DeleteFloorState> emit,
  ) async {
    emit(DeleteFloorLoading());

    final params = DeleteFloorParams(floorId: event.floorId);
    final result = await deleteFloorUseCase(params);

    result.fold(
      (failure) => emit(DeleteFloorError(failure.message)),
      (response) => emit(DeleteFloorSuccess()),
    );
  }
}