class NodeModel {
  final String? id;
  final String roomId;
  final String name;

  NodeModel({
    required this.id,
    required this.roomId,
    required this.name,
  });

  factory NodeModel.fromJson(Map<String, dynamic> json) {
    return NodeModel(
      id: json['id'],
      roomId: json['room_id'],
      name: json['name'],
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
