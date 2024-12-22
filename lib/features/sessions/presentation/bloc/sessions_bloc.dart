import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/sessions/domain/usecases/get_all_sessions.dart';
import 'package:stapes_home/features/sessions/domain/usecases/revoke_sessions.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_event.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final GetAllSessions getAllSessions;
  final RevokeSession revokeSession;

  SessionsBloc({
    required this.getAllSessions,
    required this.revokeSession,
  }) : super(SessionsInitial()) {
    on<LoadSessionsEvent>(_onLoadSessions);
    on<RevokeSessionEvent>(_onRevokeSession);
  }

  Future<void> _onLoadSessions(
    LoadSessionsEvent event,
    Emitter<SessionsState> emit,
  ) async {
    emit(SessionsLoading());
    try {
      final sessions = await getAllSessions(
        userId: event.userId,
        sessionId: event.sessionId,
      );
      emit(SessionsLoaded(sessions));
    } catch (e) {
      emit(SessionsError(e.toString()));
    }
  }

  Future<void> _onRevokeSession(
    RevokeSessionEvent event,
    Emitter<SessionsState> emit,
  ) async {
    emit(SessionsLoading());
    try {
      await revokeSession(
        userId: event.userId,
        sessionId: event.sessionId,
      );
      emit(SessionsRevokeSuccess());
      
      // Reload sessions after successful revoke
      final sessions = await getAllSessions(
        userId: event.userId,
        sessionId: event.sessionId,
      );
      emit(SessionsLoaded(sessions));
    } catch (e) {
      emit(SessionsError(e.toString()));
    }
  }
}