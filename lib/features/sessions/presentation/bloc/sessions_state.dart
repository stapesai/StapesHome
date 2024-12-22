import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';

abstract class SessionsState {}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<SessionEntity> sessions;
  SessionsLoaded(this.sessions);
}

class SessionsError extends SessionsState {
  final String message;
  SessionsError(this.message);
}

class SessionsRevokeSuccess extends SessionsState {}