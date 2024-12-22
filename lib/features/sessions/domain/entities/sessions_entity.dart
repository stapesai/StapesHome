class SessionEntity {
  final String sessionId;
  final String deviceName;
  final String lastActive;

  const SessionEntity({
    required this.sessionId,
    required this.deviceName,
    required this.lastActive,
  });
}