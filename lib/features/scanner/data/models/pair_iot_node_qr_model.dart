// lib/features/scanner/data/models/pair_iot_node_qr_model.dart
/* Sample Data: "IOT-NODE;Stapes_Development_Device;0xFFF0;0xFFF1;0xFFF2;0xFFF3"
Description:
  DEVICE_NAME "Stapes_Development_Device"
  PRIMARY_SERVICE_UUID 0xFFF0
  UPLOAD_CONFIG_CHAR_UUID 0xFFF1
  GET_DEVICE_INFO_CHAR_UUID 0xFFF2
  CHECK_WIFI_CREDENTIALS_CHAR_UUID 0xFFF3
*/

class IotQrModel {
  final String deviceName;
  final String serviceUuid;
  final String configCharacteristicUuid;
  final String versionCharacteristicUuid;
  final String checkWiFiCredentialsCharacteristicUuid;

  IotQrModel({
    required this.deviceName,
    required this.serviceUuid,
    required this.configCharacteristicUuid,
    required this.versionCharacteristicUuid,
    required this.checkWiFiCredentialsCharacteristicUuid,
  });
}
