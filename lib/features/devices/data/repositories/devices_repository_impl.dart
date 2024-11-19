import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/devices/data/datasources/local/devices_local_datasource.dart';
import 'package:stapes_home/features/devices/data/datasources/remote/devices_remote_datasource.dart';
import 'package:stapes_home/features/devices/data/models/create_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/delete_device_api_param.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/data/models/update_device_api_param.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';

class DevicesRepositoryImpl with RepositoryHelper implements DevicesRepository {
  final DevicesRemoteDataSource remoteDataSource;
  final DevicesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  DevicesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, GetDevicesResponse>> getAllDevices({bool refresh = false}) async {
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getAllDevices();
        await localDataSource.updateCachedDevices(response.entities);
        return response;
      }, networkInfo);
    }

    return await handleEither(() async {
      final devices = await localDataSource.getAllDevices();
      return GetDevicesResponse(entities: devices);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetDevicesResponse>> getDevicesByNodeId(
    GetDevicesByNodeIdParams params, {
    bool refresh = false,
  }) async {
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getDevicesByNodeId(params);
        await localDataSource.updateCachedDevices(response.entities);
        return response;
      }, networkInfo);
    }

    return await handleEither(() async {
      final devices = await localDataSource.getDevicesByNodeId(params.nodeId);
      return GetDevicesResponse(entities: devices);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetDevicesResponse>> getDevicesByRoomId(
    GetDevicesByRoomIdParams params, {
    bool refresh = false,
  }) async {
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getDevicesByRoomId(params);
        await localDataSource.updateCachedDevices(response.entities);
        return response;
      }, networkInfo);
    }

    return await handleEither(() async {
      final devices = await localDataSource.getDevicesByRoomId(params.roomId);
      return GetDevicesResponse(entities: devices);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, CreateDevicesResponse>> createDevice(CreateDevicesParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.createDevice(params);
      await localDataSource.createDevice(response.device);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, UpdateDevicesResponse>> updateDevice(UpdateDevicesParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.updateDevice(params);
      await localDataSource.updateDevice(params.device.id!, response.device);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteDevicesResponse>> deleteDevice(DeleteDevicesParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.deleteDevice(params);
      await localDataSource.deleteDevice(params.entityId);
      return response;
    }, networkInfo);
  }
}
