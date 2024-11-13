import 'dart:convert';
import 'package:hive/hive.dart';

part 'user_session_model.g.dart';

// dart run build_runner build
@HiveType(typeId: 1)
class UserSessionModel {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime lastActiveAt;

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
