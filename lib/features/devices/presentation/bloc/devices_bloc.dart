// lib/features/devices/presentation/bloc/devices_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/domain/usecases/get_devices_by_room_id_usecase.dart';
import 'devices_event.dart';
import 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final GetDevicesByRoomIdUseCase getDevicesByRoomIdUseCase;

  DevicesBloc({required this.getDevicesByRoomIdUseCase}) : super(DevicesInitial()) {
    on<FetchDevices>(_onFetchDevices);
  }

  Future<void> _onFetchDevices(
      FetchDevices event, Emitter<DevicesState> emit) async {
    emit(DevicesLoading());
    final params = GetDevicesByRoomIdParams(roomId: event.roomId);
    final result = await getDevicesByRoomIdUseCase(params);

    result.fold(
      (failure) {
        emit(DevicesError(message: _mapFailureToMessage(failure)));
      },
      (devices) {
        emit(DevicesLoaded(devices: devices));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    // Map different failures to user-friendly messages
    if (failure is ServerFailure) {
      return 'Server Error: Please try again later.';
    } else if (failure is NetworkFailure) {
      return 'No Internet Connection.';
    } else {
      return 'Unexpected Error.';
    }
  }
}