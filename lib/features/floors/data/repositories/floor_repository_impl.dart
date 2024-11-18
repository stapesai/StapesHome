import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/floors/data/datasources/remote/floors_remote_datasource.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';

class FloorRepositoryImpl with RepositoryHelper implements FloorRepository {
  final FloorsRemoteDataSource remoteDataSource;
  // TODO: add support for is network available, and show custom screen if internet is not available.
  final NetworkInfo networkInfo;

  FloorRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateFloorResponse>> createFloor(CreateFloorParams params) {
    return handleEither(() => remoteDataSource.createFloor(params));
  }

  @override
  Future<Either<Failure, DeleteFloorResponse>> deleteFloor(DeleteFloorParams params) {
    return handleEither(() => remoteDataSource.deleteFloor(params));
  }

  @override
  Future<Either<Failure, GetFloorsResponse>> getFloors(GetFloorsParams params) {
    return handleEither(() => remoteDataSource.getFloors(params));
  }

  @override
  Future<Either<Failure, UpdateFloorResponse>> updateFloor(UpdateFloorParams params) {
    return handleEither(() => remoteDataSource.updateFloor(params));
  }
}
