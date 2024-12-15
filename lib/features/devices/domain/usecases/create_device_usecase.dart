import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/devices/data/models/create_device_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/service_locator.dart';

class CreateDeviceUseCase implements UseCase<CreateDevicesParams, CreateDevicesResponse> {
  @override
  Future<Either<Failure, CreateDevicesResponse>> call(CreateDevicesParams params) async {
    return serviceLocator<DevicesRepository>().createDevice(params);
  }
}
