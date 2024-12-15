import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/rooms/data/models/delete_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/service_locator.dart';

class DeleteRoomUseCase implements UseCase<DeleteRoomParams, DeleteRoomResponse> {
  @override
  Future<Either<Failure, DeleteRoomResponse>> call(DeleteRoomParams params) async {
    return serviceLocator<RoomRepository>().deleteRoom(params);
  }
}
