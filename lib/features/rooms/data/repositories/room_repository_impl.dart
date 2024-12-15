import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/rooms/data/datasources/local/rooms_local_datasource.dart';
import 'package:stapes_home/features/rooms/data/datasources/remote/rooms_remote_datasource.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';

class RoomRepositoryImpl with RepositoryHelper implements RoomRepository {
  final RoomsRemoteDataSource remoteDataSource;
  final RoomsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RoomRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CreateRoomResponse>> createRoom(CreateRoomParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.createRoom(params);
      await localDataSource.createRoom(response.room);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, DeleteRoomResponse>> deleteRoom(DeleteRoomParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.deleteRoom(params);
      await localDataSource.deleteRoom(params.roomId);
      return response;
    }, networkInfo);
  }

  @override
  Future<Either<Failure, GetRoomsResponse>> getRooms(GetRoomsParams params, {bool refresh = false}) async {
    // If refresh requested, fetch from network and cache
    if (refresh) {
      return await handleEither(() async {
        final response = await remoteDataSource.getRooms(params);
        // Cache the fetched rooms
        await localDataSource.updateCachedRooms(response.rooms);
        return response;
      }, networkInfo);
    }

    // Get rooms from local storage
    return await handleEither(() async {
      final rooms = await localDataSource.getRooms();
      return GetRoomsResponse(rooms: rooms);
    }, networkInfo);
  }

  @override
  Future<Either<Failure, UpdateRoomResponse>> updateRoom(UpdateRoomParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.updateRoom(params);
      await localDataSource.updateRoom(params.roomId, response.room);
      return response;
    }, networkInfo);
  }
}
