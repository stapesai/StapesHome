import 'package:stapes_home/features/sessions/domain/repositories/sessions_repository.dart';

class RevokeSession {
  final SessionsRepository repository;
  RevokeSession(this.repository);

  Future<void> call({
    required String userId,
    required String sessionId,
  }) async {
    return await repository.revokeSession(
      userId: userId,
      sessionId: sessionId,
    );
  }
}