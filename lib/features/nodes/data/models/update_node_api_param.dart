import 'package:stapes_home/core/models/node_model.dart';

class UpdateNodeParams {
  final String nodeId;
  final NodeModel node;

  UpdateNodeParams({
    required this.nodeId,
    required this.node,
  });

  Object toJson() {
    return node.toJson();
  }
}

class UpdateNodeResponse {
  final NodeModel node;

  UpdateNodeResponse({required this.node});

  factory UpdateNodeResponse.fromJson(Map<String, dynamic> json) {
    return UpdateNodeResponse(
      node: NodeModel.fromJson(json),
    );
  }
}
