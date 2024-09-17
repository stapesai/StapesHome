import 'package:hive/hive.dart';

part 'sessions_model.g.dart';

@HiveType(typeId: 0)
class SessionsModel extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String userId;

  SessionsModel({
    required this.sessionId,
    required this.userId,
  });
}
