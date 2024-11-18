import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
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

  FloorsRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<GetFloorsResponse> getFloors(GetFloorsParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getFloors,
        headers: {'accept': 'application/json'},
      );
      return GetFloorsResponse.fromJson(response);
    });
  }

  @override
  Future<CreateFloorResponse> createFloor(CreateFloorParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createFloor,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateFloorResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateFloorResponse> updateFloor(UpdateFloorParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateFloor(params.floorId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateFloorResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteFloorResponse> deleteFloor(DeleteFloorParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteFloor(params.floorId),
        headers: {'accept': 'application/json'},
      );
      return DeleteFloorResponse();
    });
  }
}
