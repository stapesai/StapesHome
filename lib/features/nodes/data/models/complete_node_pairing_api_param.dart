// File: lib/features/nodes/data/models/complete_node_pairing_api_param.dart

import 'dart:convert';

import 'package:stapes_home/core/models/node_model.dart';

class CompleteNodePairingParams {
  final String transactionId;

  CompleteNodePairingParams({required this.transactionId});

  Object toJson() {
    return jsonEncode({
      'transaction_id': transactionId,
    });
  }
}

class CompleteNodePairingResponse {
  final NodeModel node;

  CompleteNodePairingResponse({required this.node});

  factory CompleteNodePairingResponse.fromJson(Map<String, dynamic> json) {
    return CompleteNodePairingResponse(
      node: NodeModel.fromJson(json),
    );
  }
}
