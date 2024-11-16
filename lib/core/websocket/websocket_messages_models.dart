enum WebsocketIncommingMessageType {
  nodeStatusUpdate,
  deviceStatusUpdate,
  error,
}

// enum WebsocketOutgoingMessageType {
//   controlEntity,
// }

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
      lastSeen: json['last_keepalive'] != null ? DateTime.parse(json['last_seen']) : null,
    );
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
}

class WebSocketErrorMessage {
  final String details;

  WebSocketErrorMessage({required this.details});

  factory WebSocketErrorMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketErrorMessage(
      details: json['details'],
    );
  }
}

class WebsocketIncommingMessage {
  final String? id;
  final WebsocketIncommingMessageType type;
  final dynamic payload;

  WebsocketIncommingMessage({
    this.id,
    required this.type,
    required this.payload,
  });

  factory WebsocketIncommingMessage.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    final payload = json['payload'];

    switch (type) {
      case 'node_status_update':
        return WebsocketIncommingMessage(
          id: json['id'],
          type: WebsocketIncommingMessageType.nodeStatusUpdate,
          payload: WebsocketNodeStatusUpdate.fromJson(payload),
        );
      case 'device_status_update':
        return WebsocketIncommingMessage(
          id: json['id'],
          type: WebsocketIncommingMessageType.deviceStatusUpdate,
          payload: WebsocketDeviceStatusUpdate.fromJson(payload),
        );
      case 'error':
        return WebsocketIncommingMessage(
          id: json['id'],
          type: WebsocketIncommingMessageType.error,
          payload: WebSocketErrorMessage.fromJson(payload),
        );
      default:
        throw WebSocketErrorMessage(details: 'Invalid message received. - $json');
    }
  }
}
