// lib/features/devices/presentation/bloc/devices_event.dart

abstract class DevicesEvent {}

class FetchDevices extends DevicesEvent {
  final String roomId;

  FetchDevices({required this.roomId});
}