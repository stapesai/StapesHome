import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/fav_devices/data/datasources/local/fav_device_local_datasource.dart';
import 'package:stapes_home/features/fav_devices/data/datasources/remote/fav_device_remote_datasource.dart';
import 'package:stapes_home/features/fav_devices/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/get_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/domain/repositories/fav_device_repository.dart';

class FavDeviceRepositoryImpl with RepositoryHelper implements FavDeviceRepository {
  final FavDevicesRemoteDataSource remoteDataSource;
  final FavDevicesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FavDeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateFavDeviceResponse>> createFavDevice(CreateFavDeviceParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.createFavDevice(params);
      await localDataSource.createFavDevice(response.favouriteDevice);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetFavDeviceResponse>> getFavDevices(GetFavDeviceParams params, {bool refresh = false}) async {
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getFavDevices(params);
        await localDataSource.updateCachedFavDevices(response.favouriteDevices);
        return response;
      }, networkInfo);
    }

    return await handleEither(() async {
      final devices = await localDataSource.getFavDevices();
      return GetFavDeviceResponse(favouriteDevices: devices);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteFavDeviceResponse>> deleteFavDevice(DeleteFavDeviceParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.deleteFavDevice(params);
      await localDataSource.deleteFavDevice(params.entityId);
      return response;
    }, networkInfo);
  }
}
