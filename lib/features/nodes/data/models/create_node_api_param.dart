import 'dart:convert';
import 'package:stapes_home/core/models/node_model.dart';

class CreateNodeParam {
  final String roomId;
  final String name;
  final String hardwareChip;
  final String hardwareVersion;
  final String hardwareMacAddress;
  final String firmwareVersion;

  CreateNodeParam({
    required this.roomId,
    required this.name,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.hardwareMacAddress,
    required this.firmwareVersion,
  });

  Object toJson() {
    return jsonEncode({
      'room_id': roomId,
      'name': name,
      'hardware_chip': hardwareChip,
      'hardware_version': hardwareVersion,
      'hardware_mac_address': hardwareMacAddress,
      'firmware_version': firmwareVersion,
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
