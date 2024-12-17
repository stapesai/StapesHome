import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/devices/data/models/update_device_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/service_locator.dart';

class UpdateDeviceUseCase implements UseCase<UpdateDevicesParams, UpdateDevicesResponse> {
  @override
  Future<Either<Failure, UpdateDevicesResponse>> call(UpdateDevicesParams params) async {
    return serviceLocator<DevicesRepository>().updateDevice(params);
  }
}
