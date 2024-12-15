import 'dart:convert';
import 'package:stapes_home/core/models/device_model.dart';

class UpdateDevicesParams {
  final DeviceModel device;

  UpdateDevicesParams({
    required this.device,
  });

  Object toJson() {
    return jsonEncode({
      'node_id': device.nodeId,
      'name': device.name,
      'type': device.type,
      'channel_id': device.channelId,
    });
  }
}

class UpdateDevicesResponse {
  final DeviceModel device;

  UpdateDevicesResponse({required this.device});

  factory UpdateDevicesResponse.fromJson(Map<String, dynamic> json) {
    return UpdateDevicesResponse(device: DeviceModel.fromJson(json));
  }
}
