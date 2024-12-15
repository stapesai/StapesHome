import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/floors/data/datasources/local/floors_local_datasource.dart';
import 'package:stapes_home/features/floors/data/datasources/remote/floors_remote_datasource.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';

class FloorRepositoryImpl with RepositoryHelper implements FloorRepository {
  final FloorsRemoteDataSource remoteDataSource;
  final FloorsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FloorRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateFloorResponse>> createFloor(CreateFloorParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.createFloor(params);
      await localDataSource.createFloor(response.floor);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteFloorResponse>> deleteFloor(DeleteFloorParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.deleteFloor(params);
      await localDataSource.deleteFloor(params.floorId);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetFloorsResponse>> getFloors(GetFloorsParams params, {bool refresh = false}) async {
    // If refresh requested, fetch from network and cache
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getFloors(params);
        // Cache the fetched floors
        await localDataSource.updateCachedFloors(response.floors);
        return response;
      }, networkInfo);
    }

    // Get floors from local storage
    return await handleEither(() async {
      final floors = await localDataSource.getFloors();
      return GetFloorsResponse(floors: floors);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, UpdateFloorResponse>> updateFloor(UpdateFloorParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.updateFloor(params);
      await localDataSource.updateFloor(params.floorId, response.floor);
      return response;
    }, networkInfo);
  }
}
