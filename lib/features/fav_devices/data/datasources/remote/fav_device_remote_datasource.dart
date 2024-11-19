import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/fav_devices/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/get_fav_devices_api_params.dart';

abstract class FavDevicesRemoteDataSource {
  Future<GetFavDeviceResponse> getFavDevices(GetFavDeviceParams params);
  Future<CreateFavDeviceResponse> createFavDevice(CreateFavDeviceParams params);
  Future<DeleteFavDeviceResponse> deleteFavDevice(DeleteFavDeviceParams params);
}

class FavDevicesRemoteDataSourceImpl implements FavDevicesRemoteDataSource {
  final HttpClient httpClient;

  FavDevicesRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<GetFavDeviceResponse> getFavDevices(GetFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getFavouriteDevices,
        headers: {'accept': 'application/json'},
      );
      return GetFavDeviceResponse.fromJson(response);
    });
  }

  @override
  Future<CreateFavDeviceResponse> createFavDevice(CreateFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.addFavouriteDevice,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateFavDeviceResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteFavDeviceResponse> deleteFavDevice(DeleteFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.removeFavouriteDevice(params.entityId),
        headers: {'accept': 'application/json'},
      );
      return DeleteFavDeviceResponse();
    });
  }
}
