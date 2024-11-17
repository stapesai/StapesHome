import 'dart:convert';
import 'package:stapes_home/core/models/room_model.dart';

class CreateRoomParams {
  final String name;
  final String description;

  CreateRoomParams({
    required this.name,
    required this.description,
  });

  Object toJson() {
    return jsonEncode({
      'name': name,
      'description': description,
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
