import 'package:stapes_home/core/models/device_model.dart';

class GetDevicesByNodeIdParams {
  final String nodeId;

  GetDevicesByNodeIdParams({required this.nodeId});
}

class GetDevicesByRoomIdParams {
  final String roomId;

  GetDevicesByRoomIdParams({required this.roomId});
}

class GetAllEntitiesParams {}

class GetDevicesResponse {
  final List<DeviceModel> entities;

  GetDevicesResponse({required this.entities});

  factory GetDevicesResponse.fromJson(Map<String, dynamic> json) {
    return GetDevicesResponse(
        entities: List<DeviceModel>.from(
            json['entities'].map((x) => DeviceModel.fromJson(x))));
  }
}

// devices
// ├── data
// │   ├── datasources
// │   │   ├── local
// │   │   │   └── devices_local_datasource.dart
// │   │   └── remote
// │   │       └── devices_remote_datasource.dart
// │   └── repositories
// │       └── devices_repository_impl.dart
// └── domain
//     ├── repository
//     │   └── devices_repository.dart
//     └── usecases
//         ├── create_device_usecase.dart
//         ├── delete_device_usecase.dart
//         ├── get_devices_by_room_id_usecase.dart
//         ├── get_devices_by_node_id_usecase.dart
//         └── update_device_usecase.dart
