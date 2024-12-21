import 'package:stapes_home/core/models/device_model.dart';

class GetDevicesByNodeIdParams {
  final String nodeId;

  GetDevicesByNodeIdParams({required this.nodeId});
}

class GetDevicesByRoomIdParams {
  final String roomId;

  GetDevicesByRoomIdParams({required this.roomId});
}

class GetAllDevicesParams {}

class GetDevicesResponse {
  final List<DeviceModel> entities;

  GetDevicesResponse({required this.entities});

  factory GetDevicesResponse.fromJson(Map<String, dynamic> json) {
    return GetDevicesResponse(entities: List<DeviceModel>.from(json['entities'].map((x) => DeviceModel.fromJson(x))));
  }
}
