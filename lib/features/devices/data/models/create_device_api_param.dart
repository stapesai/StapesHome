import 'dart:convert';

import 'package:stapes_home/core/models/device_model.dart';

class CreateDevicesParams {
  final DeviceModel device;

  CreateDevicesParams({
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

class CreateDevicesResponse {
  final DeviceModel device;

  CreateDevicesResponse({required this.device});

  factory CreateDevicesResponse.fromJson(Map<String, dynamic> json) {
    return CreateDevicesResponse(device: DeviceModel.fromJson(json));
  }
}
