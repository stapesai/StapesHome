import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';

abstract class RoomRepository {
  Future<Either<Failure, CreateRoomResponse>> createRoom(CreateRoomParams params);
  Future<Either<Failure, DeleteRoomResponse>> deleteRoom(DeleteRoomParams params);
  Future<Either<Failure, GetRoomsResponse>> getRooms(GetRoomsParams params, {bool refresh = false});
  Future<Either<Failure, UpdateRoomResponse>> updateRoom(UpdateRoomParams params);
}
