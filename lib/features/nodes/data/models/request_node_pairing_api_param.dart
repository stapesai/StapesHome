// File: lib/features/nodes/data/models/request_node_pairing_api_param.dart

import 'dart:convert';
import 'package:stapes_home/core/models/node_model.dart';

class RequestNodePairingParams {
  final NodeModel node;
  final String hardwareChip;
  final String hardwareVersion;
  final String manifactureId;
  final String firmwareVersion;

  RequestNodePairingParams({
    required this.node,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.manifactureId,
    required this.firmwareVersion,
  });

  Object toJson() {
    return jsonEncode({
      'room_id': node.roomId,
      'name': node.name,
      'hardware_chip': hardwareChip,
      'hardware_version': hardwareVersion,
      'hardware_manifacture_id': manifactureId,
      'firmware_version': firmwareVersion,
    });
  }
}

class RequestNodePairingResponse {
  final String transactionId;
  final String mqttHost;
  final String mqttPort;
  final String mqttUsername;
  final String mqttPassword;
  final DateTime transactionExpiresAt;

  RequestNodePairingResponse({
    required this.transactionId,
    required this.mqttHost,
    required this.mqttPort,
    required this.mqttUsername,
    required this.mqttPassword,
    required this.transactionExpiresAt,
  });

  factory RequestNodePairingResponse.fromJson(Map<String, dynamic> json) {
    return RequestNodePairingResponse(
      transactionId: json['transaction_id'],
      mqttHost: json['mqtt_host'],
      mqttPort: json['mqtt_port'],
      mqttUsername: json['mqtt_username'],
      mqttPassword: json['mqtt_password'],
      transactionExpiresAt: DateTime.parse(json['transaction_expires_at']),
    );
  }
}
