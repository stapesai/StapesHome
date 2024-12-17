class FloorModel {
  final String? id;
  final int level;
  final String name;

  FloorModel({required this.id, required this.level, required this.name});

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    return FloorModel(
      id: json['id'],
      level: json['level'],
      name: json['name'],
    );
  }

  // Object toJson() {
  //   return jsonEncode({
  //     'id': id,
  //     'level': level,
  //     'name': name,
  //   });
  // }

  FloorModel copyWith({
    String? id,
    int? level,
    String? name,
  }) {
    return FloorModel(
      id: id ?? this.id,
      level: level ?? this.level,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'name': name,
    };
  }
}
