import 'package:hive/hive.dart';

part 'sessions_model.g.dart';

@HiveType(typeId: 0)
class SessionsModel extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String ipAddress;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime lastActiveAt;

  SessionsModel({
    required this.sessionId,
    required this.userId,
    required this.ipAddress,
    required this.createdAt,
    required this.lastActiveAt,
  });
}
