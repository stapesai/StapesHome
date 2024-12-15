// lib/features/iot_provisioning/domain/usecase/iot_provisioning_ble_pair_node.dart
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';

class PairBleNodeUseCase {
  final IotProvisioningRepository iotProvisioningRepository;

  PairBleNodeUseCase({required this.iotProvisioningRepository});

  Future<
      (
        bool success,
        String? failureReason,
        BluetoothDevice? device,
        BluetoothCharacteristic? configChar,
        BluetoothCharacteristic? hwVersionChar,
        BluetoothCharacteristic? checkWiFiCredentialsChar
      )> call(IotQrModel qrData) {
    return iotProvisioningRepository.pairBleNode(qrData);
  }
}
