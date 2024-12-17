import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';
import 'package:wifi_scan/wifi_scan.dart';

class GetAvailableWifiNetworksUseCase {
  final IotProvisioningRepository repository;

  GetAvailableWifiNetworksUseCase(this.repository);

  Future<List<WiFiAccessPoint>> call() {
    return repository.getAvailableWifiNetworks();
  }
}
