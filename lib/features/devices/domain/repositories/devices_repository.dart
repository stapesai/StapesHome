import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/devices/data/models/create_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/delete_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/data/models/update_device_api_param.dart';

abstract class DevicesRepository {
  Future<Either<Failure, GetDevicesResponse>> getAllDevices({bool refresh = false});
  Future<Either<Failure, GetDevicesResponse>> getDevicesByNodeId(GetDevicesByNodeIdParams params,
      {bool refresh = false});
  Future<Either<Failure, GetDevicesResponse>> getDevicesByRoomId(GetDevicesByRoomIdParams params,
      {bool refresh = false});
  Future<Either<Failure, CreateDevicesResponse>> createDevice(CreateDevicesParams params);
  Future<Either<Failure, UpdateDevicesResponse>> updateDevice(UpdateDevicesParams params);
  Future<Either<Failure, DeleteDevicesResponse>> deleteDevice(DeleteDevicesParams params);
}
