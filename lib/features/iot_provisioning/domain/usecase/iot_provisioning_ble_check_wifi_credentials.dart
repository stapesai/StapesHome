// lib/features/iot_provisioning/domain/usecase/iot_provisioning_ble_check_wifi_credentials.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';

class CheckWifiCredentialsUseCase {
  final IotProvisioningRepository repository;

  CheckWifiCredentialsUseCase(this.repository);

  Future<bool> call(BluetoothCharacteristic char, String ssid, String password) {
    return repository.checkWiFiCredentialsOnNode(char, ssid, password);
  }
}
