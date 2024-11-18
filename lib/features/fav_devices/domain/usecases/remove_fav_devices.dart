import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/fav_devices/data/models/delete_fav_devices_api_params.dart';
import '../repositories/fav_device_repository.dart';
import 'package:stapes_home/service_locator.dart';

class RemoveFavDeviceUseCase implements UseCase<RemoveFavDeviceParams, void> {
  final FavDeviceRepository repository = serviceLocator<FavDeviceRepository>();

  @override
  Future<Either<Failure, void>> call(RemoveFavDeviceParams params) async {
    return repository.deleteFavDevice(params);
  }
}