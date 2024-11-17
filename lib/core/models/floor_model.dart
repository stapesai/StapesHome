import 'dart:convert';

class FloorModel {
  final String id;
  final int level;
  final String alias;

  FloorModel({required this.id, required this.level, required this.alias});

  factory FloorModel.fromJson(Map<String, dynamic> json) {
    return FloorModel(
      id: json['id'],
      level: json['level'],
      alias: json['alias'],
    );
  }

  Object toJson() {
    return jsonEncode({
      'id': id,
      'level': level,
      'alias': alias,
    });
  }
}
