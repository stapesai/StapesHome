import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
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
  final AuthLocalDataSource authLocalDataSource;

  NodesRemoteDataSourceImpl({
    required this.httpClient,
    required this.authLocalDataSource,
  });

  @override
  Future<GetNodesByRoomIdResponse> getNodesByRoomId(GetNodesByRoomIdParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.get(
        BackendRoutes.getNodesByRoomId(params.roomId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return GetNodesByRoomIdResponse.fromJson(response);
    });
  }

  @override
  Future<CreateNodeResponse> createNode(CreateNodeParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.post(
        BackendRoutes.createNode,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return CreateNodeResponse.fromJson(response);
    });
  }

  @override
  Future<UpdateNodeResponse> updateNode(UpdateNodeParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      final response = await httpClient.put(
        BackendRoutes.updateNode(params.nodeId),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
        body: params.toJson(),
      );
      return UpdateNodeResponse.fromJson(response);
    });
  }

  @override
  Future<DeleteNodeResponse> deleteNode(DeleteNodeParams params) {
    return httpClient.handleRequest(() async {
      UserSessionModel? session = await authLocalDataSource.getUserSession();
      await httpClient.delete(
        BackendRoutes.deleteNode(params.nodeId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': session?.userId ?? 'not_found',
          'X-Session-Id': session?.sessionId ?? 'not_found',
        },
      );
      return DeleteNodeResponse();
    });
  }
}
