import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/nodes/data/datasources/remote/nodes_remote_datasource.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';

class NodeRepositoryImpl with RepositoryHelper implements NodeRepository {
  final NodesRemoteDataSource remoteDataSource;
  // final NodesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NodeRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateNodeResponse>> createNode(CreateNodeParams params) {
    return handleEither(() async {
      final node = await remoteDataSource.createNode(params);
      return CreateNodeResponse(node: node);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteNodeResponse>> deleteNode(DeleteNodeParams params) {
    return handleEither(() async {
      await remoteDataSource.deleteNode(params);
      return DeleteNodeResponse();
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetNodesByRoomIdResponse>> getNodesByRoomId(GetNodesByRoomIdParams params) {
    return handleEither(() async {
      final nodes = await remoteDataSource.getNodesByRoomId(params);
      return GetNodesByRoomIdResponse(nodes: nodes);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, UpdateNodeResponse>> updateNode(UpdateNodeParams params) {
    return handleEither(() async {
      final node = await remoteDataSource.updateNode(params);
      return UpdateNodeResponse(node: node);
    }, networkInfo);
  }

  // @override
  // Future<Either<Failure, List<NodeModel>>> getCachedNodes() {
  //   return handleEither(() => localDataSource.getAllNodes());
  // }

  // @override
  // Future<Either<Failure, void>> cacheNode(NodeModel node) {
  // return handleEither(() => localDataSource.saveNode(node));
  // }

  // @override
  // Future<Either<Failure, void>> cacheNodes(List<NodeModel> nodes) {
  //   return handleEither(() async {
  //     for (var node in nodes) {
  //       await localDataSource.saveNode(node);
  //     }
  //   });
  // }

  // @override
  // Future<Either<Failure, void>> deleteCachedNode(String nodeId) {
  //   return handleEither(() => localDataSource.deleteNode(nodeId));
  // }

  // @override
  // Future<Either<Failure, void>> deleteCachedNodes() {
  //   return handleEither(() async {
  //     final nodes = await localDataSource.getAllNodes();
  //     for (var node in nodes) {
  //       await localDataSource.deleteNode(node.id);
  //     }
  //   });
  // }
}
