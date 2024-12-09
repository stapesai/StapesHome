// lib/features/devices/presentation/bloc/devices_state.dart
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';

abstract class DevicesState {}

class DevicesInitial extends DevicesState {}

class DevicesLoading extends DevicesState {}

class DevicesLoaded extends DevicesState {
  final GetDevicesResponse devices;

  DevicesLoaded({required this.devices});
}

class DevicesError extends DevicesState {
  final String message;

  DevicesError({required this.message});
}