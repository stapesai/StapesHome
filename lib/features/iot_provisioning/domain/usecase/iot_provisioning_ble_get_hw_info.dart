import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:stapes_home/features/iot_provisioning/data/models/node_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';

class GetHwInfoUseCase {
  final IotProvisioningRepository repository;

  GetHwInfoUseCase(this.repository);

  Future<NodeHwInfo> call(BluetoothCharacteristic hwVersionChar) {
    return repository.getHwInfo(hwVersionChar);
  }
}
