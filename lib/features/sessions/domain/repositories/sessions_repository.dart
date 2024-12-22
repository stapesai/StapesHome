import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';

abstract class SessionsRepository {
  Future<List<SessionEntity>> getAllSessions({
    required String userId,
    required String currentSessionId,
  });

  Future<void> revokeSession({
    required String userId,
    required String sessionId,
  });
}