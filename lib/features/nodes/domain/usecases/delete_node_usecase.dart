import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteNodeUseCase implements UseCase<DeleteNodeParams, DeleteNodeResponse> {
  @override
  Future<Either<Failure, DeleteNodeResponse>> call(DeleteNodeParams params) async {
    return serviceLocator<NodeRepository>().deleteNode(params);
  }
}
