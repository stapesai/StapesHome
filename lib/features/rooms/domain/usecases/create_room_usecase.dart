import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/rooms/data/models/create_room_api_param.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/service_locator.dart';

class CreateRoomUseCase implements UseCase<CreateRoomParams, CreateRoomResponse> {
  @override
  Future<Either<Failure, CreateRoomResponse>> call(CreateRoomParams params) async {
    return serviceLocator<RoomRepository>().createRoom(params);
  }
}
