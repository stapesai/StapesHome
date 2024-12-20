import 'dart:convert';

enum WebsocketIncomingMessageType {
  nodeStatusUpdate,
  deviceStatusUpdate,
  error,
}

enum WebsocketOutgoingMessageType {
  controlDevice,
}

class WebsocketNodeStatusUpdate {
  final String nodeId;
  final bool isOnline;
  final DateTime? lastSeen;

  WebsocketNodeStatusUpdate({
    required this.nodeId,
    required this.isOnline,
    this.lastSeen,
  });

  factory WebsocketNodeStatusUpdate.fromJson(Map<String, dynamic> json) {
    return WebsocketNodeStatusUpdate(
      nodeId: json['node_id'],
      isOnline: json['is_online'],
      lastSeen: json['last_keepalive'] != null ? DateTime.parse(json['last_keepalive']) : null,
    );
  }

  get nodes => null;

  @override
  String toString() {
    return 'WebsocketNodeStatusUpdate{nodeId: $nodeId, isOnline: $isOnline, lastSeen: $lastSeen}';
  }
}

class WebsocketDeviceStatusUpdate {
  final String deviceId;
  final bool state;

  WebsocketDeviceStatusUpdate({
    required this.deviceId,
    required this.state,
  });

  factory WebsocketDeviceStatusUpdate.fromJson(Map<String, dynamic> json) {
    return WebsocketDeviceStatusUpdate(
      deviceId: json['entity_id'],
      state: json['state'],
    );
  }

  get devices => null;

  @override
  String toString() {
    return 'WebsocketDeviceStatusUpdate{deviceId: $deviceId, state: $state}';
  }
}

class WebsocketErrorMessage {
  final String details;

  WebsocketErrorMessage({required this.details});

  factory WebsocketErrorMessage.fromJson(Map<String, dynamic> json) {
    return WebsocketErrorMessage(
      details: json['details'],
    );
  }

  @override
  String toString() {
    return 'WebsocketErrorMessage{details: $details}';
  }
}

class WebsocketIncomingMessage {
  final WebsocketIncomingMessageType type;
  final dynamic payload;

  WebsocketIncomingMessage({
    required this.type,
    required this.payload,
  });

  factory WebsocketIncomingMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final payload = json['payload'];

    switch (type) {
      case 'node_status_update':
        return WebsocketIncomingMessage(
          type: WebsocketIncomingMessageType.nodeStatusUpdate,
          payload: WebsocketNodeStatusUpdate.fromJson(payload),
        );
      case 'entity_status_update':
        return WebsocketIncomingMessage(
          type: WebsocketIncomingMessageType.deviceStatusUpdate,
          payload: WebsocketDeviceStatusUpdate.fromJson(payload),
        );
      case 'error':
        return WebsocketIncomingMessage(
          type: WebsocketIncomingMessageType.error,
          payload: WebsocketErrorMessage.fromJson(payload),
        );
      default:
        return WebsocketIncomingMessage(
          type: WebsocketIncomingMessageType.error,
          payload: WebsocketErrorMessage(details: 'Unknown message type - $type'),
        );
    }
  }

  @override
  String toString() {
    return 'WebsocketIncomingMessage{type: $type, payload: $payload}';
  }
}

class WebsocketDeviceControlMessage {
  final String deviceId;
  final bool state;

  WebsocketDeviceControlMessage({
    required this.deviceId,
    required this.state,
  });

  Object toJson() {
    return jsonEncode({
      'entity_id': deviceId,
      'state': state,
    });
  }

  @override
  String toString() {
    return 'WebsocketDeviceControlMessage{deviceId: $deviceId, state: $state}';
  }
}

class WebsocketOutgoingMessage {
  final WebsocketOutgoingMessageType type;
  String? typeString;
  final dynamic payload;

  WebsocketOutgoingMessage({
    required this.type,
    required this.payload,
  }) {
    if (type == WebsocketOutgoingMessageType.controlDevice) {
      typeString = 'control_entity';
    }
  }

  Object toJson() {
    return jsonEncode({
      'type': typeString,
      'payload': payload,
    });
  }

  @override
  String toString() {
    return 'WebsocketOutgoingMessage{type: $type, payload: $payload}';
  }
}
