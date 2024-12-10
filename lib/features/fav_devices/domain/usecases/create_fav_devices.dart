import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/fav_devices/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/domain/repositories/fav_device_repository.dart';
import 'package:stapes_home/service_locator.dart';

class CreateFavDeviceUseCase implements UseCase<CreateFavDeviceParams, CreateFavDeviceResponse> {
  final FavDeviceRepository repository = serviceLocator<FavDeviceRepository>();

  @override
  Future<Either<Failure, CreateFavDeviceResponse>> call(CreateFavDeviceParams params) async {
    return repository.createFavDevice(params);
  }
}
