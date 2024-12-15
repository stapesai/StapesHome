import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/floors/data/models/delete_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteFloorUseCase implements UseCase<DeleteFloorParams, DeleteFloorResponse> {
  @override
  Future<Either<Failure, DeleteFloorResponse>> call(DeleteFloorParams params) async {
    return serviceLocator<FloorRepository>().deleteFloor(params);
  }
}
