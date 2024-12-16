import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
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
  final AuthLocalDataSource authLocalDataSource;

  FavDevicesRemoteDataSourceImpl({required this.httpClient, required this.authLocalDataSource});

  @override
  Future<GetFavDeviceResponse> getFavDevices(GetFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.get(
        BackendRoutes.getFavouriteDevices,
        headers: {
          'Accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return GetFavDeviceResponse.fromJson(response);
    });
  }

  @override
  Future<CreateFavDeviceResponse> createFavDevice(CreateFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.post(
        BackendRoutes.addFavouriteDevice,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return CreateFavDeviceResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteFavDeviceResponse> deleteFavDevice(DeleteFavDeviceParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      await httpClient.delete(
        BackendRoutes.removeFavouriteDevice(params.entityId),
        headers: {
          'Accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return DeleteFavDeviceResponse();
    });
  }
}
