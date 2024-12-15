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

  factory DeviceInfoModel.fromMap(Map<String, dynamic> map) {
    return DeviceInfoModel(
      deviceName: map['deviceName'],
      deviceType: map['deviceType'],
      manufacturer: map['manufacturer'],
      version: map['version'],
      model: map['model'],
    );
  }
}
