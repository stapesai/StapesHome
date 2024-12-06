// lib/features/provisioning/domain/usecases/pair_bluetooth_device.dart
import 'package:stapes_home/features/pair-new-node/domain/repository/pair_new_node_repo.dart';

class PairBluetoothDeviceUseCase {
  final PairNewNodeRepository repository;

  PairBluetoothDeviceUseCase(this.repository);

  Future<void> call(String deviceName, String serviceUuid) {
    return repository.pairBluetoothDevice(deviceName, serviceUuid);
  }
}