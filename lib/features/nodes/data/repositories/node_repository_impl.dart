import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/models/node_model.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/nodes/data/datasources/local/nodes_local_datasource.dart';
import 'package:stapes_home/features/nodes/data/datasources/remote/nodes_remote_datasource.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';

class NodeRepositoryImpl with RepositoryHelper implements NodeRepository {
  final NodesRemoteDataSource remoteDataSource;
  final NodesLocalDataSource localDataSource;

  NodeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<NodeModel>>> getNodesByRoomId(String roomId) {
    return handleEither(() async {
      final params = GetNodesByRoomIdParams(roomId: roomId);
      final nodes = await remoteDataSource.getNodesByRoomId(params);
      for (var node in nodes) {
        await localDataSource.saveNode(node);
      }
      return nodes;
    });
  }

  @override
  Future<Either<Failure, NodeModel>> createNode(NodeModel node) {
    return handleEither(() async {
      final params = CreateNodeParam(
        roomId: node.roomId,
        name: node.name,
        hardwareChip: node.hardwareChip,
        hardwareVersion: node.hardwareVersion,
        hardwareMacAddress: node.hardwareMacAddress,
        firmwareVersion: node.firmwareVersion,
      );
      final createdNode = await remoteDataSource.createNode(params);
      await localDataSource.saveNode(createdNode);
      return createdNode;
    });
  }

  @override
  Future<Either<Failure, NodeModel>> updateNode(String nodeId, NodeModel node) {
    return handleEither(() async {
      final params = UpdateNodeParams(nodeId: nodeId, node: node);
      final updatedNode = await remoteDataSource.updateNode(params);
      await localDataSource.updateNode(updatedNode);
      return updatedNode;
    });
  }

  @override
  Future<Either<Failure, void>> deleteNode(String nodeId) {
    return handleEither(() async {
      final params = DeleteNodeParams(nodeId: nodeId);
      await remoteDataSource.deleteNode(params);
      await localDataSource.deleteNode(nodeId);
    });
  }

  @override
  Future<Either<Failure, List<NodeModel>>> getCachedNodes() {
    return handleEither(() => localDataSource.getAllNodes());
  }

  @override
  Future<Either<Failure, void>> cacheNode(NodeModel node) {
    return handleEither(() => localDataSource.saveNode(node));
  }

  @override
  Future<Either<Failure, void>> cacheNodes(List<NodeModel> nodes) {
    return handleEither(() async {
      for (var node in nodes) {
        await localDataSource.saveNode(node);
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteCachedNode(String nodeId) {
    return handleEither(() => localDataSource.deleteNode(nodeId));
  }

  @override
  Future<Either<Failure, void>> deleteCachedNodes() {
    return handleEither(() async {
      final nodes = await localDataSource.getAllNodes();
      for (var node in nodes) {
        await localDataSource.deleteNode(node.id);
      }
    });
  }
}
