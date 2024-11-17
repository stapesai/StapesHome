import 'package:stapes_home/core/models/room_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';

abstract class RoomsRemoteDataSource {
  Future<List<RoomModel>> getRooms(GetRoomsParams params);
  Future<RoomModel> createRoom(CreateRoomParams params);
  Future<RoomModel> updateRoom(UpdateRoomParams params);
  Future<void> deleteRoom(DeleteRoomParams params);
}

class RoomsRemoteDataSourceImpl implements RoomsRemoteDataSource {
  final HttpClient httpClient;

  RoomsRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<List<RoomModel>> getRooms(GetRoomsParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getRoomsByFloorId(params.floor.id),
        headers: {'accept': 'application/json'},
      );
      return (response as List).map((room) => RoomModel.fromJson(room)).toList();
    });
  }

  @override
  Future<RoomModel> createRoom(CreateRoomParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createRoom,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateRoomResponse.fromJson(response).room;
    });
  }

  @override
  Future<RoomModel> updateRoom(UpdateRoomParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateRoom(params.roomId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateRoomResponse.fromJson(response).room;
    });
  }

  @override
  Future<void> deleteRoom(DeleteRoomParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteRoom(params.roomId),
        headers: {'accept': 'application/json'},
      );
    });
  }
}
