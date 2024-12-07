import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'floor_room_sel_event.dart';
import 'floor_room_sel_state.dart';

class FloorRoomSelBloc extends Bloc<FloorRoomSelEvent, FloorRoomSelState> {
  final DeleteFloorUseCase deleteFloorUseCase;
  final DeleteRoomUseCase deleteRoomUseCase;
  final GetFloorsUseCase getFloorsUseCase;
  final GetRoomsUseCase getRoomsUseCase;

  FloorRoomSelBloc({
    required this.deleteFloorUseCase,
    required this.deleteRoomUseCase,
    required this.getFloorsUseCase,
    required this.getRoomsUseCase,
  }) : super(FloorRoomSelInitial()) {
    on<LoadFloors>(_onLoadFloors);
    on<LoadRooms>(_onLoadRooms);
    on<SelectFloor>(_onSelectFloor);
    on<SelectRoom>(_onSelectRoom);
    on<RefreshData>(_onRefreshData);
    on<DeleteFloor>(_onDeleteFloor);
    on<DeleteRoom>(_onDeleteRoom);
  }

  Future<void> _onLoadFloors(LoadFloors event, Emitter<FloorRoomSelState> emit) async {
    emit(FloorRoomSelLoaded(
      floors: const [],
      rooms: const [],
      activeFloorId: '',
      activeRoomId: '',
      isLoadingFloors: true,
      isLoadingRooms: false,
    ));
    try {
      List<FloorModel> floors = await fetchFloors();
      String newActiveFloorId = floors.isNotEmpty ? floors[0].id! : '';
      emit(FloorRoomSelLoaded(
        floors: floors,
        rooms: const [],
        activeFloorId: newActiveFloorId,
        activeRoomId: '',
        isLoadingFloors: false,
        isLoadingRooms: false,
      ));
      if (newActiveFloorId.isNotEmpty) {
        add(LoadRooms(floorId: newActiveFloorId));
      }
    } catch (e) {
      emit(FloorRoomSelError(e.toString()));
    }
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<FloorRoomSelState> emit) async {
    final currentState = state;
    if (currentState is FloorRoomSelLoaded) {
      emit(currentState.copyWith(isLoadingRooms: true));
      try {
        List<RoomModel> rooms = await fetchRooms(event.floorId);
        String newActiveRoomId = rooms.isNotEmpty ? rooms[0].id! : '';
        emit(currentState.copyWith(
          rooms: rooms,
          activeFloorId: event.floorId,
          activeRoomId: newActiveRoomId,
          isLoadingRooms: false,
        ));
      } catch (e) {
        emit(FloorRoomSelError(e.toString()));
      }
    }
  }

  void _onSelectFloor(SelectFloor event, Emitter<FloorRoomSelState> emit) {
    add(LoadRooms(floorId: event.floorId));
  }

  void _onSelectRoom(SelectRoom event, Emitter<FloorRoomSelState> emit) {
    final currentState = state;
    if (currentState is FloorRoomSelLoaded) {
      emit(currentState.copyWith(activeRoomId: event.roomId));
    }
  }

  Future<void> _onRefreshData(RefreshData event, Emitter<FloorRoomSelState> emit) async {
    add(LoadFloors());
  }

  Future<List<FloorModel>> fetchFloors() async {
    final List<FloorModel> floors = [];
    final result = await getFloorsUseCase(GetFloorsParams());
    result.fold(
      (failure) => throw Exception(failure.message),
      (floorsData) => floors.addAll(floorsData.floors),
    );
    return floors;
  }

  Future<List<RoomModel>> fetchRooms(String floorId) async {
    final List<RoomModel> rooms = [];
    final result = await getRoomsUseCase(GetRoomsParams(floorId: floorId));
    result.fold(
      (failure) => throw Exception(failure.message),
      (roomsData) => rooms.addAll(roomsData.rooms),
    );
    return rooms;
  }

  Future<void> _onDeleteFloor(DeleteFloor event, Emitter<FloorRoomSelState> emit) async {
    final currentState = state;
    if (currentState is FloorRoomSelLoaded) {
      emit(currentState.copyWith(isLoadingFloors: true));
      try {
        final result = await deleteFloorUseCase(DeleteFloorParams(floorId: event.floorId));
        result.fold(
          (failure) => emit(FloorRoomSelError(failure.message)),
          (_) => add(RefreshData()),
        );
      } catch (e) {
        emit(FloorRoomSelError(e.toString()));
      }
    }
  }

  Future<void> _onDeleteRoom(DeleteRoom event, Emitter<FloorRoomSelState> emit) async {
    final currentState = state;
    if (currentState is FloorRoomSelLoaded) {
      emit(currentState.copyWith(isLoadingRooms: true));
      try {
        final result = await deleteRoomUseCase(DeleteRoomParams(roomId: event.roomId));
        result.fold(
          (failure) => emit(FloorRoomSelError(failure.message)),
          (_) => add(LoadRooms(floorId: currentState.activeFloorId)),
        );
      } catch (e) {
        emit(FloorRoomSelError(e.toString()));
      }
    }
  }
}
