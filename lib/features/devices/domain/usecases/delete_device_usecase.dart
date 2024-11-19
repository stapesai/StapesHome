import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/devices/data/models/delete_device_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteDeviceUseCase implements UseCase<DeleteDevicesParams, DeleteDevicesResponse> {
  @override
  Future<Either<Failure, DeleteDevicesResponse>> call(DeleteDevicesParams params) async {
    return serviceLocator<DevicesRepository>().deleteDevice(params);
  }
}
