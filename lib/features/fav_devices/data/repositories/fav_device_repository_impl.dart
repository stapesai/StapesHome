// File: lib/features/fav_devices/data/repositories/fav_device_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/fav_devices/data/datasources/remote/fav_device_remote_datasource.dart';
import 'package:stapes_home/features/fav_devices/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/get_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/domain/repositories/fav_device_repository.dart';

class FavDeviceRepositoryImpl with RepositoryHelper implements FavDeviceRepository {
  final FavDevicesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FavDeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateFavDeviceResponse>> createFavDevice(CreateFavDeviceParams params) async {
    return handleEither(() => remoteDataSource.createFavDevice(params), networkInfo);
  }

  @override
  Future<Either<Failure, GetFavDeviceResponse>> getFavDevices(GetFavDeviceParams params) async {
    return handleEither(() => remoteDataSource.getFavDevices(params), networkInfo);
  }

  @override
  Future<Either<Failure, void>> deleteFavDevice(RemoveFavDeviceParams params) async {
    return handleEither(() => remoteDataSource.deleteFavDevice(params), networkInfo);
  }
}
