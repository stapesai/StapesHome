import 'dart:convert';
import 'package:stapes_home/core/models/node_model.dart';

class CreateNodeParams {
  final NodeModel node;

  CreateNodeParams({
    required this.node,
  });

  Object toJson() {
    return jsonEncode({
      'room_id': node.roomId,
      'name': node.name,
      'hardware_chip': node.hardwareChip,
      'hardware_version': node.hardwareVersion,
      'hardware_mac_address': node.hardwareMacAddress,
      'firmware_version': node.firmwareVersion,
    });
  }
}

class CreateNodeResponse {
  final NodeModel node;

  CreateNodeResponse({required this.node});

  factory CreateNodeResponse.fromJson(Map<String, dynamic> json) {
    return CreateNodeResponse(
      node: NodeModel.fromJson(json),
    );
  }
}
