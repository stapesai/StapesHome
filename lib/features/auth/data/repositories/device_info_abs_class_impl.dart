// lib/features/auth/data/repositories/device_info_abs_class_impl.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/datasources/local/device_info_local_datasource.dart';
import 'package:stapes_home/features/auth/data/models/device_info_model.dart';
import 'package:stapes_home/features/auth/domain/repository/device_info_abs_class.dart';

class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DeviceInfoDataSource dataSource;

  DeviceInfoRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, DeviceInfoModel>> getDeviceInfo() async {
    try {
      final deviceData = await dataSource.getDeviceInfo();
      return Right(deviceData);
    } catch (e) {
      return Left(PlatformFailure(message: e.toString()));
    }
  }
}
