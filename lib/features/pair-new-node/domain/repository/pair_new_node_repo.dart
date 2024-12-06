// lib/features/provisioning/domain/repositories/provisioning_repository.dart
abstract class PairNewNodeRepository {
  Future<void> pairBluetoothDevice(String deviceName, String serviceUuid);
  Future<void> sendWifiCredentials(String ssid, String password);
  Future<void> createNode(String roomId, String nodeName, Map<String, String> hardwareData);
  Future<Map<String, String>> getMqttDetails();
  Future<Map<String, String>> getHardwareInfo();
}