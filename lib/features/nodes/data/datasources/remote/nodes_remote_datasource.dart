import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/nodes/data/models/create_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';

abstract class NodesRemoteDataSource {
  Future<GetNodesByRoomIdResponse> getNodesByRoomId(GetNodesByRoomIdParams params);
  Future<CreateNodeResponse> createNode(CreateNodeParams params);
  Future<UpdateNodeResponse> updateNode(UpdateNodeParams params);
  Future<DeleteNodeResponse> deleteNode(DeleteNodeParams params);
}

class NodesRemoteDataSourceImpl implements NodesRemoteDataSource {
  final HttpClient httpClient;

  NodesRemoteDataSourceImpl({
    required this.httpClient,
  });

  @override
  Future<GetNodesByRoomIdResponse> getNodesByRoomId(GetNodesByRoomIdParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.get(
        BackendRoutes.getNodesByRoomId(params.roomId),
        headers: {
          'accept': 'application/json',
        },
      );
      return GetNodesByRoomIdResponse.fromJson(response);
    });
  }

  @override
  Future<CreateNodeResponse> createNode(CreateNodeParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        BackendRoutes.createNode,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return CreateNodeResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateNodeResponse> updateNode(UpdateNodeParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.put(
        BackendRoutes.updateNode(params.nodeId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: params.toJson(),
      );
      return UpdateNodeResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteNodeResponse> deleteNode(DeleteNodeParams params) {
    return httpClient.handleRequest(() async {
      await httpClient.delete(
        BackendRoutes.deleteNode(params.nodeId),
        headers: {
          'accept': 'application/json',
        },
      );
      return DeleteNodeResponse();
    });
  }
}
