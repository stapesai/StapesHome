import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/rooms/data/models/get_rooms_api_param.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/service_locator.dart';

class GetRoomsUseCase implements UseCase<GetRoomsParams, GetRoomsResponse> {
  @override
  Future<Either<Failure, GetRoomsResponse>> call(GetRoomsParams params, {bool refresh = false}) async {
    return serviceLocator<RoomRepository>().getRooms(params, refresh: refresh);
  }
}
