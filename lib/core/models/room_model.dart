class RoomModel {
  final String? id;
  final String floorId;
  final String name;
  final String type;

  RoomModel({required this.id, required this.floorId, required this.name, required this.type});

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      floorId: json['floor_id'],
      name: json['name'],
      type: json['type'],
    );
  }

  // Object toJson() {
  //   return jsonEncode({
  //     'id': id,
  //     'floor_id': floorId,
  //     'name': name,
  //     'type': type,
  //   });
  // }

  RoomModel copyWith({
    String? id,
    String? floorId,
    String? name,
    String? type,
  }) {
    return RoomModel(
      id: id ?? this.id,
      floorId: floorId ?? this.floorId,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'floor_id': floorId,
      'name': name,
      'type': type,
    };
  }
}
