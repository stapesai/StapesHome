import 'dart:convert';

import 'package:stapes_home/core/models/room_model.dart';

class UpdateRoomParams {
  final String roomId;
  final RoomModel room;

  UpdateRoomParams({
    required this.roomId,
    required this.room,
  });

  Object toJson() {
    return jsonEncode({
      'floor_id': room.floorId,
      'name': room.name,
      'type': room.type,
    });
  }
}

class UpdateRoomResponse {
  final RoomModel room;

  UpdateRoomResponse({required this.room});

  factory UpdateRoomResponse.fromJson(Map<String, dynamic> json) {
    return UpdateRoomResponse(
      room: RoomModel.fromJson(json),
    );
  }
}
