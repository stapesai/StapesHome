// TODO: @gauransh415

class UserSession {
  final String sessionId;
  final String userId;
  final String createdAt;
  final String lastActiveAt;

  UserSession({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    required this.lastActiveAt,
  });

  Object toJson() {
    return { //
      'session_id': sessionId,
      'user_id': userId,
      'created_at': createdAt,
      'last_active_at': lastActiveAt,
    };
  }

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      sessionId: json['session_id'],
      userId: json['user_id'],
      createdAt: json['created_at'],
      lastActiveAt: json['last_active_at'],
    );
  }
}