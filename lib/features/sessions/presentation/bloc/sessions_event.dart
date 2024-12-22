import 'package:equatable/equatable.dart';

abstract class SessionsEvent extends Equatable {
  const SessionsEvent();

  @override
  List<Object> get props => [];
}

class LoadSessionsEvent extends SessionsEvent {
  final String userId;
  final String sessionId;

  const LoadSessionsEvent({
    required this.userId,
    required this.sessionId,
  });

  @override
  List<Object> get props => [userId, sessionId];
}

class RevokeSessionEvent extends SessionsEvent {
  final String userId;
  final String sessionId;

  const RevokeSessionEvent({
    required this.userId,
    required this.sessionId,
  });

  @override
  List<Object> get props => [userId, sessionId];
}