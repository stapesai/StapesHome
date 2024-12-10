// lib/features/floor_room_sel/presentation/bloc/floor_room_sel_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/floor_room_sel_state.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';

class FloorRoomSelBloc extends Bloc<FloorRoomSelEvent, FloorRoomSelState> {
  final GetFloorsUseCase getFloorsUseCase;
  final GetRoomsUseCase getRoomsUseCase;
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;

  FloorRoomSelBloc({
    required this.getFloorsUseCase,
    required this.getRoomsUseCase,
    required this.onFloorSelected,
    required this.onRoomSelected,
  }) : super(FloorRoomSelInitial()) {
    on<LoadFloors>(_onLoadFloors);
    on<LoadRooms>(_onLoadRooms);
    on<SelectFloor>(_onSelectFloor);
    on<SelectRoom>(_onSelectRoom);
    on<DeleteFloor>(_onDeleteFloor);
    on<DeleteRoom>(_onDeleteRoom);
    on<RefreshData>(_onRefreshData);
  }

  Future<void> _onLoadFloors(LoadFloors event, Emitter<FloorRoomSelState> emit) async {
    // Show loading state
    emit(FloorsLoading());
    // await Future.delayed(const Duration(seconds: 10));
    emit(RoomsLoading());
    // await Future.delayed(const Duration(seconds: 10));

    try {
      // Fetch floors
      final floors = await _fetchFloors();

      // If no floors are available, show empty state
      if (floors.isEmpty) {
        emit(FloorsLoadedEmpty());
        emit(RoomsLoadedEmpty());
        return;
      }

      // Set the first floor as active
      String newActiveFloorId = floors.isNotEmpty ? floors[0].id! : '';
      emit(FloorsLoaded(floors: floors, activeFloorId: newActiveFloorId));
      // add(SelectFloor(floorId: newActiveFloorId));

      // Fetch rooms for the first floor
      // if (newActiveFloorId.isNotEmpty) {
      //   add(LoadRooms(floorId: newActiveFloorId));
      // }
    } catch (e) {
      emit(FloorsLoadingError(e.toString()));
    }
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<FloorRoomSelState> emit) async {
    emit(RoomsLoading());
    try {
      final rooms = await _fetchRooms(event.floorId);

      // If no rooms are available, show empty state
      if (rooms.isEmpty) {
        emit(RoomsLoadedEmpty());
        return;
      }

      // Set the first room as active
      String newActiveRoomId = rooms[0].id!;
      emit(RoomsLoaded(rooms: rooms, activeRoomId: newActiveRoomId));
      add(SelectRoom(roomId: newActiveRoomId));
    } catch (e) {
      emit(RoomsLoadingError(e.toString()));
    }
  }

  void _onSelectFloor(SelectFloor event, Emitter<FloorRoomSelState> emit) {
    onFloorSelected(event.floorId);
    add(LoadRooms(floorId: event.floorId));
  }

  void _onSelectRoom(SelectRoom event, Emitter<FloorRoomSelState> emit) {
    onRoomSelected(event.roomId);
  }

  Future<void> _onRefreshData(RefreshData event, Emitter<FloorRoomSelState> emit) async {
    add(LoadFloors());
  }

  Future<void> _onDeleteFloor(DeleteFloor event, Emitter<FloorRoomSelState> emit) async {
    add(LoadFloors());
  }

  Future<void> _onDeleteRoom(DeleteRoom event, Emitter<FloorRoomSelState> emit) async {
    add(LoadRooms(floorId: event.floorId));
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

  Future<List<RoomModel>> _fetchRooms(String floorId) async {
    final List<RoomModel> rooms = [];
    final result = await getRoomsUseCase(GetRoomsParams(floorId: floorId));
    result.fold(
      (failure) => throw Exception(failure.message),
      (roomsData) => rooms.addAll(roomsData.rooms),
    );
    return rooms;
  }
}
