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
  final String? id;
  final WebsocketIncommingMessageType type;
  final dynamic payload;

  WebsocketIncommingMessage({
    this.id,
    required this.type,
    required this.payload,
  });

  factory WebsocketIncommingMessage.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final type = json['type'];
    final payload = json['payload'];

    switch (type) {
      case 'node_status_update':
        return WebsocketIncommingMessage(
          id: id,
          type: WebsocketIncommingMessageType.nodeStatusUpdate,
          payload: WebsocketNodeStatusUpdate.fromJson(payload),
        );
      case 'entity_status_update':
        return WebsocketIncommingMessage(
          id: id,
          type: WebsocketIncommingMessageType.deviceStatusUpdate,
          payload: WebsocketDeviceStatusUpdate.fromJson(payload),
        );
      case 'error':
        return WebsocketIncommingMessage(
          id: id,
          type: WebsocketIncommingMessageType.error,
          payload: WebsocketErrorMessage.fromJson(payload),
        );
      default:
        return WebsocketIncommingMessage(
          id: id,
          type: WebsocketIncommingMessageType.error,
          payload: WebsocketErrorMessage(details: 'Unknown message type - $type'),
        );
    }
  }

  @override
  String toString() {
    return 'WebsocketIncommingMessage{id: $id, type: $type, payload: $payload}';
  }
}
