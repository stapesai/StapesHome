import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
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
  final AuthLocalDataSource authLocalDataSource;

  RoomsRemoteDataSourceImpl({required this.httpClient, required this.authLocalDataSource});

  @override
  Future<GetRoomsResponse> getRooms(GetRoomsParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.get(
        BackendRoutes.getRoomsByFloorId(params.floorId),
        headers: {
          'Accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return GetRoomsResponse.fromJson(response);
    });
  }

  @override
  Future<CreateRoomResponse> createRoom(CreateRoomParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.post(
        BackendRoutes.createRoom,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return CreateRoomResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateRoomResponse> updateRoom(UpdateRoomParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.put(
        BackendRoutes.updateRoom(params.roomId),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return UpdateRoomResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteRoomResponse> deleteRoom(DeleteRoomParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      await httpClient.delete(
        BackendRoutes.deleteRoom(params.roomId),
        headers: {
          'Accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return DeleteRoomResponse();
    });
  }
}
