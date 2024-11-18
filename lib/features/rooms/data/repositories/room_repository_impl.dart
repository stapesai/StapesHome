import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/rooms/data/datasources/remote/rooms_remote_datasource.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';

class RoomRepositoryImpl with RepositoryHelper implements RoomRepository {
  final RoomsRemoteDataSource remoteDataSource;
  // TODO: add support for is network available, and show custom screen if internet is not available.
  final NetworkInfo networkInfo;

  RoomRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateRoomResponse>> createRoom(CreateRoomParams params) {
    return handleEither(() async {
      final room = await remoteDataSource.createRoom(params);
      return CreateRoomResponse(room: room);
    });
  }

  @override
  Future<Either<Failure, DeleteRoomResponse>> deleteRoom(DeleteRoomParams params) {
    return handleEither(() async {
      await remoteDataSource.deleteRoom(params);
      return DeleteRoomResponse();
    });
  }

  @override
  Future<Either<Failure, GetRoomsResponse>> getRooms(GetRoomsParams params) {
    return handleEither(() async {
      final rooms = await remoteDataSource.getRooms(params);
      return GetRoomsResponse(rooms: rooms);
    });
  }

  @override
  Future<Either<Failure, UpdateRoomResponse>> updateRoom(UpdateRoomParams params) {
    return handleEither(() async {
      final room = await remoteDataSource.updateRoom(params);
      return UpdateRoomResponse(room: room);
    });
  }
}
