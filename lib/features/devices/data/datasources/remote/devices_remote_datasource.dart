import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/devices/data/models/create_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/update_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/data/models/delete_device_api_param.dart';

abstract class DevicesRemoteDataSource {
  Future<GetDevicesResponse> getAllDevices();
  Future<GetDevicesResponse> getDevicesByNodeId(GetDevicesByNodeIdParams params);
  Future<GetDevicesResponse> getDevicesByRoomId(GetDevicesByRoomIdParams params);
  Future<CreateDevicesResponse> createDevice(CreateDevicesParams params);
  Future<UpdateDevicesResponse> updateDevice(UpdateDevicesParams params);
  Future<DeleteDevicesResponse> deleteDevice(DeleteDevicesParams params);
}

class DevicesRemoteDataSourceImpl implements DevicesRemoteDataSource {
  final HttpClient httpClient;

  DevicesRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<GetDevicesResponse> getAllDevices() {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getAllDevices,
        headers: {
          'accept': 'application/json',
        },
      );
      return GetDevicesResponse.fromJson(response);
    });
  }

  @override
  Future<GetDevicesResponse> getDevicesByNodeId(GetDevicesByNodeIdParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getDevicesByNodeId(params.nodeId),
        headers: {
          'accept': 'application/json',
        },
      );
      return GetDevicesResponse.fromJson(response);
    });
  }

  @override
  Future<GetDevicesResponse> getDevicesByRoomId(GetDevicesByRoomIdParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getDevicesByRoomId(params.roomId),
        headers: {
          'accept': 'application/json',
        },
      );
      return GetDevicesResponse.fromJson(response);
    });
  }

  @override
  Future<CreateDevicesResponse> createDevice(CreateDevicesParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createEntity,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateDevicesResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateDevicesResponse> updateDevice(UpdateDevicesParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateEntity(params.device.id!),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateDevicesResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteDevicesResponse> deleteDevice(DeleteDevicesParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteEntity(params.entityId),
        headers: {
          'accept': 'application/json',
        },
      );
      return DeleteDevicesResponse();
    });
  }
}
