class NodeModel {
  final String? id;
  final String roomId;
  final String name;
  final String hardwareChip;
  final String hardwareVersion;
  final String firmwareVersion;

  NodeModel({
    required this.id,
    required this.roomId,
    required this.name,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.firmwareVersion,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      id: json['id'],
      roomId: json['room_id'],
      name: json['name'],
      hardwareChip: json['hardware_chip'],
      hardwareVersion: json['hardware_version'],
      firmwareVersion: json['firmware_version'],
    );
  }

  // Object toJson() {
  //   return jsonEncode({
  //     'id': id,
  //     'room_id': roomId,
  //     'name': name,
  //   });
  // }
}
