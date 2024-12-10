// File: lib/features/nodes/data/models/request_node_pairing_api_param.dart

import 'dart:convert';
import 'package:stapes_home/core/models/node_model.dart';

class RequestNodePairingParams {
  final NodeModel node;

  RequestNodePairingParams({required this.node});

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

class RequestNodePairingResponse {
  final String transactionId;
  final String mqttUsername;
  final String mqttPassword;
  final DateTime transactionExpiresAt;

  RequestNodePairingResponse({
    required this.transactionId,
    required this.mqttUsername,
    required this.mqttPassword,
    required this.transactionExpiresAt,
  });

  factory RequestNodePairingResponse.fromJson(Map<String, dynamic> json) {
    return RequestNodePairingResponse(
      transactionId: json['transaction_id'],
      mqttUsername: json['mqtt_username'],
      mqttPassword: json['mqtt_password'],
      transactionExpiresAt: DateTime.parse(json['transaction_expires_at']),
    );
  }
}
