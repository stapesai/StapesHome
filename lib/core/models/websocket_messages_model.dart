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
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
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
