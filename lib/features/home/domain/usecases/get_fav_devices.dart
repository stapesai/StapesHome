import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/home/data/models/get_fav_devices_api_params.dart';
import 'package:stapes_home/features/home/domain/repositories/fav_device_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetFavDevicesUseCase implements UseCase<GetFavDeviceParams, GetFavDeviceResponse> {
  final FavDeviceRepository repository = serviceLocator<FavDeviceRepository>();

  @override
  Future<Either<Failure, GetFavDeviceResponse>> call(GetFavDeviceParams params, {bool refresh = false}) async {
    return repository.getFavDevices(params, refresh: refresh);
  }
}
