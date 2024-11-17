import 'dart:convert';
import 'package:stapes_home/core/models/floor_model.dart';

class CreateFloorParams {
  final String name;
  final int level;

  CreateFloorParams({
    required this.name,
    required this.level,
  });

  Object toJson() {
    return jsonEncode({
      'name': name,
      'level': level,
    });
  }
}

class CreateFloorResponse {
  final FloorModel floor;

  CreateFloorResponse({required this.floor});

  factory CreateFloorResponse.fromJson(Map<String, dynamic> json) {
    return CreateFloorResponse(
      floor: FloorModel.fromJson(json),
    );
  }
}
