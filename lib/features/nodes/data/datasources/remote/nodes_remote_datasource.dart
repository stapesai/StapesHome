import 'package:stapes_home/core/models/node_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';

abstract class NodesRemoteDataSource {
  Future<List<NodeModel>> getNodesByRoomId(GetNodesByRoomIdParams params);
  Future<NodeModel> createNode(CreateNodeParams params);
  Future<NodeModel> updateNode(UpdateNodeParams params);
  Future<void> deleteNode(DeleteNodeParams params);
}

class NodesRemoteDataSourceImpl implements NodesRemoteDataSource {
  final HttpClient httpClient;

  NodesRemoteDataSourceImpl({
    required this.httpClient,
  });

  @override
  Future<List<NodeModel>> getNodesByRoomId(GetNodesByRoomIdParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getNodesByRoomId(params.roomId),
        headers: {
          'accept': 'application/json',
        },
      );
      return (response as List).map((node) => NodeModel.fromJson(node)).toList();
    });
  }

  @override
  Future<NodeModel> createNode(CreateNodeParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createNode,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateNodeResponse.fromJson(response).node;
    });
  }

  @override
  Future<NodeModel> updateNode(UpdateNodeParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateNode(params.nodeId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateNodeResponse.fromJson(response).node;
    });
  }

  @override
  Future<void> deleteNode(DeleteNodeParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteNode(params.nodeId),
        headers: {
          'accept': 'application/json',
        },
      );
    });
  }
}
