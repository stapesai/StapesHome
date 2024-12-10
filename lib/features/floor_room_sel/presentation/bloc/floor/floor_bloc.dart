// lib/features/floor_room_sel/presentation/bloc/floor/floor_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor/floor_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor/floor_state.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';

class FloorBloc extends Bloc<FloorEvent, FloorState> {
  final GetFloorsUseCase getFloorsUseCase;
  final Function(String) onFloorSelected;

  FloorBloc({
    required this.getFloorsUseCase,
    required this.onFloorSelected,
  }) : super(const FloorState()) {
    on<LoadFloors>(_onLoadFloors);
    on<SelectFloor>(_onSelectFloor);
    on<DeleteFloor>(_onDeleteFloor);
  }

  Future<void> _onLoadFloors(LoadFloors event, Emitter<FloorState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final floors = await _fetchFloors();
      final newActiveFloorId = floors.isNotEmpty ? floors[0].id : null;
      emit(state.copyWith(
        isLoading: false,
        floors: floors,
        activeFloorId: newActiveFloorId,
      ));
      if (newActiveFloorId != null) {
        add(SelectFloor(newActiveFloorId));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSelectFloor(SelectFloor event, Emitter<FloorState> emit) {
    emit(state.copyWith(activeFloorId: event.floorId));
    onFloorSelected(event.floorId);
  }

  Future<void> _onDeleteFloor(DeleteFloor event, Emitter<FloorState> emit) async {
    add(LoadFloors());
  }

  Future<List<FloorModel>> _fetchFloors() async {
    final List<FloorModel> floors = [];
    final result = await getFloorsUseCase(GetFloorsParams());
    result.fold(
      (failure) => throw Exception(failure.message),
      (floorsData) => floors.addAll(floorsData.floors),
    );
    return floors;
  }
}
