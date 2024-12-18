import 'dart:convert';

enum WebsocketIncommingMessageType {
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

class WebsocketIncommingMessage {
  final WebsocketIncommingMessageType type;
  final dynamic payload;

  WebsocketIncommingMessage({
    required this.type,
    required this.payload,
  });

  factory WebsocketIncommingMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final payload = json['payload'];

    switch (type) {
      case 'node_status_update':
        return WebsocketIncommingMessage(
          type: WebsocketIncommingMessageType.nodeStatusUpdate,
          payload: WebsocketNodeStatusUpdate.fromJson(payload),
        );
      case 'entity_status_update':
        return WebsocketIncommingMessage(
          type: WebsocketIncommingMessageType.deviceStatusUpdate,
          payload: WebsocketDeviceStatusUpdate.fromJson(payload),
        );
      case 'error':
        return WebsocketIncommingMessage(
          type: WebsocketIncommingMessageType.error,
          payload: WebsocketErrorMessage.fromJson(payload),
        );
      default:
        return WebsocketIncommingMessage(
          type: WebsocketIncommingMessageType.error,
          payload: WebsocketErrorMessage(details: 'Unknown message type - $type'),
        );
    }
  }

  @override
  String toString() {
    return 'WebsocketIncommingMessage{type: $type, payload: $payload}';
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
