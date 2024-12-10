import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/home/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/home/domain/repositories/fav_device_repository.dart';
import 'package:stapes_home/service_locator.dart';

class RemoveFavDeviceUseCase implements UseCase<DeleteFavDeviceParams, DeleteFavDeviceResponse> {
  final FavDeviceRepository repository = serviceLocator<FavDeviceRepository>();

  @override
  Future<Either<Failure, DeleteFavDeviceResponse>> call(DeleteFavDeviceParams params) async {
    return repository.deleteFavDevice(params);
  }
}
