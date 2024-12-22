import 'package:equatable/equatable.dart';
import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';

abstract class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

class SessionsInitial extends SessionsState {}

class SessionsLoading extends SessionsState {}

class SessionsLoaded extends SessionsState {
  final List<SessionEntity> sessions;

  const SessionsLoaded(this.sessions);

  @override
  List<Object> get props => [sessions];

  SessionsLoaded copyWith({
    List<SessionEntity>? sessions,
  }) {
    return SessionsLoaded(
      sessions ?? this.sessions,
    );
  }
}

class SessionsRevokeSuccess extends SessionsState {}

class SessionsError extends SessionsState {
  final String message;

  const SessionsError(this.message);

  @override
  List<Object> get props => [message];
}