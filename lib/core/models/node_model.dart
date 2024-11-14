class NodeModel {
  final String roomId;
  final String name;
  final String hardwareChip;
  final String hardwareVersion;
  final String hardwareMacAddress;
  final String firmwareVersion;
  final String id;
  final int numEntities;

  NodeModel({
    required this.roomId,
    required this.name,
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.hardwareMacAddress,
    required this.firmwareVersion,
    required this.id,
    required this.numEntities,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      roomId: json['room_id'],
      name: json['name'],
      hardwareChip: json['hardware_chip'],
      hardwareVersion: json['hardware_version'],
      hardwareMacAddress: json['hardware_mac_address'],
      firmwareVersion: json['firmware_version'],
      id: json['id'],
      numEntities: json['num_entities'],
    );
  }
}