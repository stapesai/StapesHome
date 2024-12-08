import 'package:stapes_home/features/profile/domain/entities/sessions.dart';
import 'package:stapes_home/features/profile/domain/repositories/sessions_repo.dart';

class GetSessions {
  final SessionRepository repository;

  GetSessions(this.repository);


  Future<List<Session>> call() async {
    return await repository.getSessions();
  }
}
