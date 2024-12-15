import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/floors/data/models/create_floor_api_param.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/service_locator.dart';

class CreateFloorUseCase implements UseCase<CreateFloorParams, CreateFloorResponse> {
  @override
  Future<Either<Failure, CreateFloorResponse>> call(CreateFloorParams params) async {
    return serviceLocator<FloorRepository>().createFloor(params);
  }
}
