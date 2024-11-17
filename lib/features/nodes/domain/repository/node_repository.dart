import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';

abstract class NodeRepository {
  // -------------Remote-------------
  Future<Either<Failure, CreateNodeResponse>> createNode(CreateNodeParams params);
  Future<Either<Failure, DeleteNodeResponse>> deleteNode(DeleteNodeParams params);
  Future<Either<Failure, GetNodesByRoomIdResponse>> getNodesByRoomId(GetNodesByRoomIdParams params);
  Future<Either<Failure, UpdateNodeResponse>> updateNode(UpdateNodeParams params);

  // -------------Local-------------
  // Future<Either<Failure, List<NodeModel>>> getCachedNodes();
  // Future<Either<Failure, void>> cacheNode(NodeModel node);
  // Future<Either<Failure, void>> cacheNodes(List<NodeModel> nodes);
  // Future<Either<Failure, void>> deleteCachedNode(String nodeId);
  // Future<Either<Failure, void>> deleteCachedNodes();
}
