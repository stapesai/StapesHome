import 'dart:convert';
import 'package:stapes_home/core/models/floor_model.dart';

class CreateFloorParams {
  final FloorModel floor;

  CreateFloorParams({
    required this.floor,
  });

  Object toJson() {
    return jsonEncode({
      'alias': floor.alias,
      'level': floor.level,
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
