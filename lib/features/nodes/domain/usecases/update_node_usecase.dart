import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class UpdateNodeUseCase implements UseCase<UpdateNodeParams, UpdateNodeResponse> {
  @override
  Future<Either<Failure, UpdateNodeResponse>> call(UpdateNodeParams params) async {
    return serviceLocator<NodeRepository>().updateNode(params);
  }
}
