// lib/features/auth/data/datasources/local/device_info_data_source.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:stapes_home/core/error/exceptions.dart';

abstract class DeviceInfoDataSource {
  Future<Map<String, dynamic>> getDeviceInfo();
}

class DeviceInfoDataSourceImpl implements DeviceInfoDataSource {
  final DeviceInfoPlugin deviceInfo;

  DeviceInfoDataSourceImpl({required this.deviceInfo});

  @override
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return {
          'deviceName': androidInfo.model,
          'deviceType': 'Android',
          'manufacturer': androidInfo.manufacturer,
          'version': androidInfo.version.release,
          'model': androidInfo.model,
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return {
          'deviceName': iosInfo.name,
          'deviceType': 'iOS',
          'manufacturer': 'Apple',
          'model': iosInfo.model,
          'systemVersion': iosInfo.systemVersion,
        };
      }
      throw UnsupportedError('Unsupported platform');
    } catch (e) {
      throw PlatformException('Error getting device info: $e');
    }
  }
}
