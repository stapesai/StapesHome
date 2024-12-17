import 'dart:convert';

import 'package:stapes_home/core/models/node_model.dart';

class UpdateNodeParams {
  final String nodeId;
  final NodeModel node;

  UpdateNodeParams({
    required this.nodeId,
    required this.node,
  });

  Object toJson() {
    return jsonEncode({
      'room_id': node.roomId,
      'name': node.name,
      // 'hardware_chip': node.hardwareChip,
      // 'hardware_version': node.hardwareVersion,
      // 'hardware_mac_address': node.hardwareMacAddress,
      // 'firmware_version': node.firmwareVersion,
    });
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
