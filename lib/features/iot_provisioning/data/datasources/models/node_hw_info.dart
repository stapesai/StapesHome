// lib/features/iot_provisioning/data/datasources/models/node_hw_info.dart

class NodeHwInfo {
  final String hardwareChip;
  final String hardwareVersion;
  final String firmwareVersion;

  NodeHwInfo({
    required this.hardwareChip,
    required this.hardwareVersion,
    required this.firmwareVersion,
  });

  factory NodeHwInfo.fromBleString(String bleData) {
    // Format: <hardware_chip>;<hardware_version>;<firmware_version>
    final parts = bleData.split(';');

    if (parts.length != 3) {
      throw Exception('Invalid BLE data');
    }

    return NodeHwInfo(
      hardwareChip: parts[0],
      hardwareVersion: parts[1],
      firmwareVersion: parts[2],
    );
  }
}
