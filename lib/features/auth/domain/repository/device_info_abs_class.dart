// lib/features/auth/domain/repository/device_info_abs_class.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/device_info_model.dart';

abstract class DeviceInfoRepository {
  Future<Either<Failure, DeviceInfoModel>> getDeviceInfo();
}
