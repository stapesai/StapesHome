import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';

abstract class FloorsRemoteDataSource {
  Future<GetFloorsResponse> getFloors(GetFloorsParams params);
  Future<CreateFloorResponse> createFloor(CreateFloorParams params);
  Future<UpdateFloorResponse> updateFloor(UpdateFloorParams params);
  Future<DeleteFloorResponse> deleteFloor(DeleteFloorParams params);
}

class FloorsRemoteDataSourceImpl implements FloorsRemoteDataSource {
  final HttpClient httpClient;
  final AuthLocalDataSource authLocalDataSource;

  FloorsRemoteDataSourceImpl({required this.httpClient, required this.authLocalDataSource});

  @override
  Future<GetFloorsResponse> getFloors(GetFloorsParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.get(
        BackendRoutes.getFloors,
        headers: {
          'accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return GetFloorsResponse.fromJson(response);
    });
  }

  @override
  Future<CreateFloorResponse> createFloor(CreateFloorParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.post(
        BackendRoutes.createFloor,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return CreateFloorResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateFloorResponse> updateFloor(UpdateFloorParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.put(
        BackendRoutes.updateFloor(params.floorId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return UpdateFloorResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteFloorResponse> deleteFloor(DeleteFloorParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      await httpClient.delete(
        BackendRoutes.deleteFloor(params.floorId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return DeleteFloorResponse();
    });
  }
}
