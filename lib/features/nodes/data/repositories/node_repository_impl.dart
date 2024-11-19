import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
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
  final NetworkInfo networkInfo;

  NodeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateNodeResponse>> createNode(CreateNodeParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.createNode(params);
      await localDataSource.createNode(response.node);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteNodeResponse>> deleteNode(DeleteNodeParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.deleteNode(params);
      await localDataSource.deleteNode(params.nodeId);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetNodesByRoomIdResponse>> getNodesByRoomId(GetNodesByRoomIdParams params,
      {bool refresh = false}) async {
    // If refresh requested, fetch from network and cache
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getNodesByRoomId(params);
        // Cache the fetched nodes
        await localDataSource.updateCachedNodes(response.nodes);
        return response;
      }, networkInfo);
    }

    // Get nodes from local storage
    return await handleEither(() async {
      final nodes = await localDataSource.getNodesByRoomId(params.roomId);
      return GetNodesByRoomIdResponse(nodes: nodes);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, UpdateNodeResponse>> updateNode(UpdateNodeParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.updateNode(params);
      await localDataSource.updateNode(params.nodeId, response.node);
      return response;
    }, networkInfo);
  }
}
