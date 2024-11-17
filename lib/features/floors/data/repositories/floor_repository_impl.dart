import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/floors/data/datasources/remote/floors_remote_datasource.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';

class FloorRepositoryImpl with RepositoryHelper implements FloorRepository {
  final FloorsRemoteDataSource remoteDataSource;

  FloorRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CreateFloorResponse>> createFloor(CreateFloorParams params) {
    return handleEither(() async {
      final floor = await remoteDataSource.createFloor(params);
      return CreateFloorResponse(floor: floor);
    });
  }

  @override
  Future<Either<Failure, DeleteFloorResponse>> deleteFloor(DeleteFloorParams params) {
    return handleEither(() async {
      await remoteDataSource.deleteFloor(params);
      return DeleteFloorResponse();
    });
  }

  @override
  Future<Either<Failure, GetFloorsResponse>> getFloors(GetFloorsParams params) {
    return handleEither(() async {
      final floors = await remoteDataSource.getFloors(params);
      return GetFloorsResponse(floors: floors);
    });
  }

  @override
  Future<Either<Failure, UpdateFloorResponse>> updateFloor(UpdateFloorParams params) {
    return handleEither(() async {
      final floor = await remoteDataSource.updateFloor(params);
      return UpdateFloorResponse(floor: floor);
    });
  }
}
