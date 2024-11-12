import 'dart:convert';

class UserSessionModel {
  final String sessionId;
  final String userId;
  final String createdAt;
  final String lastActiveAt;

  UserSessionModel({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    required this.lastActiveAt,
  });

  Object toJson() {
    return jsonEncode({
      'session_id': sessionId,
      'user_id': userId,
      'created_at': createdAt,
      'last_active_at': lastActiveAt,
    });
  }

  factory UserSessionModel.fromJson(Map<String, dynamic> response) {
    return UserSessionModel(
      sessionId: response['session_id'],
      userId: response['user_id'],
      createdAt: response['created_at'],
      lastActiveAt: response['last_active_at'],
    );
  }
}
