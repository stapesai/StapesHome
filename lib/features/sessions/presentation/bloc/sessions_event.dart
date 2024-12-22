abstract class SessionsEvent {}

class LoadSessionsEvent extends SessionsEvent {
  final String userId;
  final String currentSessionId;

  LoadSessionsEvent(this.userId, this.currentSessionId);
}

class RevokeSessionEvent extends SessionsEvent {
  final String userId;
  final String sessionId;

  RevokeSessionEvent(this.userId, this.sessionId);
}