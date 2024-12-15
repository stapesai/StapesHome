import 'dart:convert';

import 'package:stapes_home/core/models/floor_model.dart';

class UpdateFloorParams {
  final String floorId;
  final FloorModel floor;

  UpdateFloorParams({
    required this.floorId,
    required this.floor,
  });

  Object toJson() {
    return jsonEncode({
      'alias': floor.alias,
      'level': floor.level,
    });
  }
}

class UpdateFloorResponse {
  final FloorModel floor;

  UpdateFloorResponse({required this.floor});

  factory UpdateFloorResponse.fromJson(Map<String, dynamic> json) {
    return UpdateFloorResponse(
      floor: FloorModel.fromJson(json),
    );
  }
}
