import 'package:stapes_home/core/models/room_model.dart';

class GetRoomsParams {
  final String floorId;

  GetRoomsParams({
    required this.floorId,
  });
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
