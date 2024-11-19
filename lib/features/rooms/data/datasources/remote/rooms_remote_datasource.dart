import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';

abstract class RoomsRemoteDataSource {
  Future<GetRoomsResponse> getRooms(GetRoomsParams params);
  Future<CreateRoomResponse> createRoom(CreateRoomParams params);
  Future<UpdateRoomResponse> updateRoom(UpdateRoomParams params);
  Future<DeleteRoomResponse> deleteRoom(DeleteRoomParams params);
}

class RoomsRemoteDataSourceImpl implements RoomsRemoteDataSource {
  final HttpClient httpClient;

  RoomsRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<GetRoomsResponse> getRooms(GetRoomsParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getRoomsByFloorId(params.floorId),
        headers: {'accept': 'application/json'},
      );
      return GetRoomsResponse.fromJson(response);
    });
  }

  @override
  Future<CreateRoomResponse> createRoom(CreateRoomParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createRoom,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateRoomResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateRoomResponse> updateRoom(UpdateRoomParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateRoom(params.roomId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateRoomResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteRoomResponse> deleteRoom(DeleteRoomParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteRoom(params.roomId),
        headers: {'accept': 'application/json'},
      );
      return DeleteRoomResponse();
    });
  }
}
