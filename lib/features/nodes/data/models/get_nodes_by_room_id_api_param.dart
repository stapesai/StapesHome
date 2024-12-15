import 'package:stapes_home/core/models/node_model.dart';

class GetNodesByRoomIdParams {
  final String roomId;

  GetNodesByRoomIdParams({
    required this.roomId,
  });
}

class GetNodesByRoomIdResponse {
  final List<NodeModel> nodes;

  GetNodesByRoomIdResponse({required this.nodes});

  factory GetNodesByRoomIdResponse.fromJson(Map<String, dynamic> json) {
    return GetNodesByRoomIdResponse(
      nodes: List<NodeModel>.from(json['nodes'].map((x) => NodeModel.fromJson(x))),
    );
  }
}
