import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/home/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/home/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/home/data/models/get_fav_devices_api_params.dart';

abstract class FavDeviceRepository {
  Future<Either<Failure, CreateFavDeviceResponse>> createFavDevice(CreateFavDeviceParams params);
  Future<Either<Failure, GetFavDeviceResponse>> getFavDevices(GetFavDeviceParams params, {bool refresh = false});
  Future<Either<Failure, DeleteFavDeviceResponse>> deleteFavDevice(DeleteFavDeviceParams params);
}
