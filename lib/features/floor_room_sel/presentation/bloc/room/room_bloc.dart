// File: lib/features/floor_room_sel/presentation/bloc/room/room_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/room/room_event.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/bloc/room/room_state.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRoomsUseCase getRoomsUseCase;
  final Function(String) onRoomSelected;

  RoomBloc({
    required this.getRoomsUseCase,
    required this.onRoomSelected,
  }) : super(const RoomState()) {
    on<LoadRooms>(_onLoadRooms);
    on<SelectRoom>(_onSelectRoom);
    on<DeleteRoom>(_onDeleteRoom);
  }

  Future<void> _onLoadRooms(LoadRooms event, Emitter<RoomState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final rooms = await _fetchRooms(event.floorId);
      final newActiveRoomId = rooms.isNotEmpty ? rooms[0].id : null;
      emit(state.copyWith(
        isLoading: false,
        rooms: rooms,
        activeRoomId: newActiveRoomId,
      ));
      if (newActiveRoomId != null) {
        add(SelectRoom(newActiveRoomId));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onSelectRoom(SelectRoom event, Emitter<RoomState> emit) {
    emit(state.copyWith(activeRoomId: event.roomId));
    onRoomSelected(event.roomId);
  }

  Future<void> _onDeleteRoom(DeleteRoom event, Emitter<RoomState> emit) async {
    // Refresh rooms after deletion
    if (state.rooms.isNotEmpty) {
      add(LoadRooms(state.rooms.first.floorId));
    }
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
