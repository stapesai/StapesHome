import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_event.dart';
import 'package:stapes_home/features/sessions/presentation/bloc/sessions_state.dart';
import 'package:stapes_home/features/sessions/domain/usecases/get_all_sessions.dart';
import 'package:stapes_home/features/sessions/domain/usecases/revoke_sessions.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final GetAllSessions getAllSessions;
  final RevokeSession revokeSession;

  SessionsBloc({
    required this.getAllSessions,
    required this.revokeSession,
  }) : super(SessionsInitial()) {
    on<LoadSessionsEvent>((event, emit) async {
      emit(SessionsLoading());
      try {
        final sessions = await getAllSessions(
          userId: event.userId,
          currentSessionId: event.currentSessionId,
        );
        emit(SessionsLoaded(sessions));
      } catch (e) {
        emit(SessionsError(e.toString()));
      }
    });

    on<RevokeSessionEvent>((event, emit) async {
      emit(SessionsLoading());
      try {
        await revokeSession(
          userId: event.userId,
          sessionId: event.sessionId,
        );
        emit(SessionsRevokeSuccess());
      } catch (e) {
        emit(SessionsError(e.toString()));
      }
    });
  }
}