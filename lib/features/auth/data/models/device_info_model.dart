// lib/features/auth/data/models/device_info_model.dart

class DeviceInfoModel {
  final String deviceName;
  final String deviceType;
  final String manufacturer; // Optional for iOS
  final String version;
  final String model; // Optional for Android

  DeviceInfoModel({
    required this.deviceName,
    required this.deviceType,
    required this.manufacturer,
    required this.version,
    required this.model,
  });

  Object toJson() {
    return {
      'device_name': deviceName,
      'device_type': deviceType,
      'device_manufacturer': manufacturer,
      'device_model': model,
      'device_system_version': version,
    };
  }
}
