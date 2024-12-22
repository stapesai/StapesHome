class SessionEntity {
  final String sessionId;
  final String _userId;
  final DateTime _lastActiveAt;

  const SessionEntity({
    required this.sessionId,
    required String userId,
    required DateTime lastActiveAt,
  })  : _userId = userId,
        _lastActiveAt = lastActiveAt;

  String get userId => _userId;
  String get lastActive => _lastActiveAt.toIso8601String();
  
}