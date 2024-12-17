import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetDevicesByNodeIdUseCase implements UseCase<GetDevicesByNodeIdParams, GetDevicesResponse> {
  @override
  Future<Either<Failure, GetDevicesResponse>> call(GetDevicesByNodeIdParams params, {bool refresh = false}) async {
    return serviceLocator<DevicesRepository>().getDevicesByNodeId(params, refresh: refresh);
  }
}
