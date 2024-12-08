// lib/features/sessions/domain/repositories/session_repository.dart
import 'package:stapes_home/features/profile/domain/entities/sessions.dart';

abstract class SessionRepository {
  Future<List<Session>> getSessions();
  Future<void> logoutSession(Session session);
}