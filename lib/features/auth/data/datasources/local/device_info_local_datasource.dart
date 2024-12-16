// lib/features/auth/data/datasources/local/device_info_data_source.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/features/auth/data/models/device_info_model.dart';

abstract class DeviceInfoDataSource {
  Future<DeviceInfoModel> getDeviceInfo();
}

class DeviceInfoDataSourceImpl implements DeviceInfoDataSource {
  final DeviceInfoPlugin deviceInfo;

  DeviceInfoDataSourceImpl({required this.deviceInfo});

  @override
  Future<DeviceInfoModel> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return DeviceInfoModel(
          deviceName: androidInfo.model,
          deviceType: 'Android',
          manufacturer: androidInfo.manufacturer,
          version: androidInfo.version.release,
          model: androidInfo.model,
        );
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return DeviceInfoModel(
          deviceName: iosInfo.name,
          deviceType: 'iOS',
          manufacturer: 'Apple',
          version: iosInfo.systemVersion,
          model: iosInfo.model,
        );
      }
      throw UnsupportedError('Unsupported platform');
    } catch (e) {
      throw PlatformException('Error getting device info: $e');
    }
  }
}
