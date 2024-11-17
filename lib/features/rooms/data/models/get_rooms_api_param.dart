import 'dart:convert';

import 'package:stapes_home/core/models/floor_model.dart';
import 'package:stapes_home/core/models/room_model.dart';

class GetRoomsParams {
  final FloorModel floor;

  GetRoomsParams({
    required this.floor,
  });

  Object toJson() {
    return jsonEncode({
      'floor': floor.toJson(),
    });
  }
}

class GetRoomsResponse {
  final List<RoomModel> rooms;

  GetRoomsResponse({required this.rooms});

  factory GetRoomsResponse.fromJson(Map<String, dynamic> json) {
    return GetRoomsResponse(
      rooms: List<RoomModel>.from(json['rooms'].map((x) => RoomModel.fromJson(x))),
    );
  }
}
