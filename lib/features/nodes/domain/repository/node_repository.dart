import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/models/node_model.dart';

abstract class NodeRepository {
  // -------------Remote-------------
  Future<Either<Failure, List<NodeModel>>> getNodesByRoomId(String roomId);
  Future<Either<Failure, NodeModel>> createNode(NodeModel node);
  Future<Either<Failure, NodeModel>> updateNode(String nodeId, NodeModel node);
  Future<Either<Failure, void>> deleteNode(String nodeId);

  // -------------Local-------------
  Future<Either<Failure, List<NodeModel>>> getCachedNodes();
  Future<Either<Failure, void>> cacheNode(NodeModel node);
  Future<Either<Failure, void>> cacheNodes(List<NodeModel> nodes);
  Future<Either<Failure, void>> deleteCachedNode(String nodeId);
  Future<Either<Failure, void>> deleteCachedNodes();
}
