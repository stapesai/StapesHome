import 'package:stapes_home/features/pair-new-node/domain/repository/pair_new_node_repo.dart';

class SendWifiCredentialsUseCase {
  final PairNewNodeRepository repository;

  SendWifiCredentialsUseCase(this.repository);

  Future<void> call(String ssid, String password) {
    return repository.sendWifiCredentials(ssid, password);
  }
}