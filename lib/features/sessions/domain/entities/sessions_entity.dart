class SessionEntity {
  final String sessionId;
  final String userId;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  const SessionEntity({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    required this.lastActiveAt,
  });
}
