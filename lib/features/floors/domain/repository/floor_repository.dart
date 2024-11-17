import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';

abstract class FloorRepository {
  Future<Either<Failure, CreateFloorResponse>> createFloor(CreateFloorParams params);
  Future<Either<Failure, DeleteFloorResponse>> deleteFloor(DeleteFloorParams params);
  Future<Either<Failure, GetFloorsResponse>> getFloors(GetFloorsParams params);
  Future<Either<Failure, UpdateFloorResponse>> updateFloor(UpdateFloorParams params);
}
