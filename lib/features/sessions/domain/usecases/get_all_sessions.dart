import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';
import 'package:stapes_home/features/sessions/domain/repositories/sessions_repository.dart';

class GetAllSessions {
  final SessionsRepository repository;
  GetAllSessions(this.repository);

  Future<List<SessionEntity>> call({
    required String userId,
    required String currentSessionId,
  }) async {
    return await repository.getAllSessions(
      userId: userId,
      currentSessionId: currentSessionId,
    );
  }
}