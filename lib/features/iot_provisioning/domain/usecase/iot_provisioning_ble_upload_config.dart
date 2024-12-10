import 'package:stapes_home/features/iot_provisioning/data/models/node_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';

class SendConfigToNodeUseCase {
  final IotProvisioningRepository repository;

  SendConfigToNodeUseCase(this.repository);

  Future<bool> call(SendConfigToNode configData) {
    return repository.sendConfigToNode(configData);
  }
}
