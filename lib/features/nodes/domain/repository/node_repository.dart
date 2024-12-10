import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/nodes/data/models/complete_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/delete_node_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/request_node_pairing_api_param.dart';
import 'package:stapes_home/features/nodes/data/models/update_node_api_param.dart';

abstract class NodeRepository {
  Future<Either<Failure, RequestNodePairingResponse>> requestNodePairing(RequestNodePairingParams params);
  Future<Either<Failure, CompleteNodePairingResponse>> completeNodePairing(CompleteNodePairingParams params);
  Future<Either<Failure, DeleteNodeResponse>> deleteNode(DeleteNodeParams params);
  Future<Either<Failure, GetNodesByRoomIdResponse>> getNodesByRoomId(GetNodesByRoomIdParams params,
      {bool refresh = false});
  Future<Either<Failure, UpdateNodeResponse>> updateNode(UpdateNodeParams params);
}
