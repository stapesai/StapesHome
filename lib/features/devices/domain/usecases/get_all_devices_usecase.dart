import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetAllDevicesUseCase implements UseCase<GetAllDevicesParams, GetDevicesResponse> {
  @override
  Future<Either<Failure, GetDevicesResponse>> call(GetAllDevicesParams params, {bool refresh = false}) async {
    return serviceLocator<DevicesRepository>().getAllDevices(refresh: refresh);
  }
}
