import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/rooms/data/models/update_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/service_locator.dart';

class UpdateRoomUseCase implements UseCase<UpdateRoomParams, UpdateRoomResponse> {
  @override
  Future<Either<Failure, UpdateRoomResponse>> call(UpdateRoomParams params) async {
    return serviceLocator<RoomRepository>().updateRoom(params);
  }
}
