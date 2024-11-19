import 'dart:convert';
import 'package:stapes_home/core/models/fav_devices_model.dart';

class CreateFavDeviceParams {
  final String entityId;

  CreateFavDeviceParams({required this.entityId});

  Object toJson() {
    return jsonEncode({
      'entity_id': entityId,
    });
  }
}

class CreateFavDeviceResponse {
  final FavDevicesModel favouriteDevice;

  CreateFavDeviceResponse({required this.favouriteDevice});

  factory CreateFavDeviceResponse.fromJson(Map<String, dynamic> json) {
    return CreateFavDeviceResponse(
      favouriteDevice: FavDevicesModel.fromJson(json),
    );
  }
}
