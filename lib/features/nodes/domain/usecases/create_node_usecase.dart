import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class CreateNodeUseCase implements UseCase<CreateNodeParams, CreateNodeResponse> {
  @override
  Future<Either<Failure, CreateNodeResponse>> call(CreateNodeParams params) async {
    return serviceLocator<NodeRepository>().createNode(params);
  }
}
