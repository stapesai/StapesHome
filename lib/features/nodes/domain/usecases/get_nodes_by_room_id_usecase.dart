import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetNodesByRoomIdUseCase implements UseCase<GetNodesByRoomIdParams, GetNodesByRoomIdResponse> {
  @override
  Future<Either<Failure, GetNodesByRoomIdResponse>> call(GetNodesByRoomIdParams params) async {
    return serviceLocator<NodeRepository>().getNodesByRoomId(params);
  }
}
