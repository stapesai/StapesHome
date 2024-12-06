
class PairNewNodeEntity {
  final String deviceName;
  final String serviceUuid;
  final String configCharacteristicUuid;
  final String versionCharacteristicUuid;
  final String roomId;
  final String userId;
  final String sessionId;

  PairNewNodeEntity({
    required this.deviceName,
    required this.serviceUuid,
    required this.configCharacteristicUuid,
    required this.versionCharacteristicUuid,
    required this.roomId,
    required this.userId,
    required this.sessionId,
  });
}