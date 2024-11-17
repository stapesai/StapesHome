import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/floors/data/models/get_floors_api_param.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetFloorsUseCase implements UseCase<GetFloorsParams, GetFloorsResponse> {
  @override
  Future<Either<Failure, GetFloorsResponse>> call(GetFloorsParams params) async {
    return serviceLocator<FloorRepository>().getFloors(params);
  }
}
