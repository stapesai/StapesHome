class DeviceModel {
  final String nodeId;
  final String name;
  final String type;
  final int channelId;
  final String id;
  bool state;

  DeviceModel({
    required this.nodeId,
    required this.name,
    required this.type,
    required this.channelId,
    required this.id,
    this.state = false,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      nodeId: json['node_id'],
      name: json['name'],
      type: json['type'],
      channelId: json['channel_id'],
      id: json['id'],
      state: json['state'] ?? false,
    );
  }

  // DeviceModel copyWith({bool? state}) {
  //   return DeviceModel(
  //     nodeId: nodeId,
  //     name: name,
  //     type: type,
  //     channelId: channelId,
  //     id: id,
  //     state: state ?? this.state,
  //   );
  // }

  // Object toJson() {
  //   return jsonEncode({
  //     'node_id': nodeId,
  //     'name': name,
  //     'type': type,
  //     'channel_id': channelId,
  //     'id': id,
  //     'state': state,
  //   });
  // }
}
