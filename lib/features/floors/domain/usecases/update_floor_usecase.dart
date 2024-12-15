import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/floors/data/models/update_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/service_locator.dart';

class UpdateFloorUseCase implements UseCase<UpdateFloorParams, UpdateFloorResponse> {
  @override
  Future<Either<Failure, UpdateFloorResponse>> call(UpdateFloorParams params) async {
    return serviceLocator<FloorRepository>().updateFloor(params);
  }
}
