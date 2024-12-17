import 'package:stapes_home/core/models/fav_devices_model.dart';

class GetFavDeviceParams {}

class GetFavDeviceResponse {
  final List<FavDevicesModel> favouriteDevices;

  GetFavDeviceResponse({required this.favouriteDevices});

  factory GetFavDeviceResponse.fromJson(Map<String, dynamic> json) {
    return GetFavDeviceResponse(
      favouriteDevices: List<FavDevicesModel>.from(
        json['favourite_devices'].map((x) => FavDevicesModel.fromJson(x)),
      ),
    );
  }
}
