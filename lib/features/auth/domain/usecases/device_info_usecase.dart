// lib/features/auth/domain/usecases/device_info_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/models/no_params.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/device_info_model.dart';
import 'package:stapes_home/features/auth/domain/repository/device_info_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class GetDeviceInfoUseCase implements UseCase<NoParams, DeviceInfoModel> {
  @override
  Future<Either<Failure, DeviceInfoModel>> call(NoParams params) {
    return serviceLocator<DeviceInfoRepository>().getDeviceInfo();
  }
}
