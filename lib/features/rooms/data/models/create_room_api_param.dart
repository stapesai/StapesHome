import 'dart:convert';
import 'package:stapes_home/core/models/room_model.dart';

class CreateRoomParams {
  final RoomModel room;

  CreateRoomParams({required this.room});

  Object toJson() {
    return jsonEncode({
      'room': {
        'floor_id': room.floorId,
        'name': room.name,
        'type': room.type,
      }
    });
  }
}

class CreateRoomResponse {
  final RoomModel room;

  CreateRoomResponse({required this.room});

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) {
    return CreateRoomResponse(
      room: RoomModel.fromJson(json),
    );
  }
}
