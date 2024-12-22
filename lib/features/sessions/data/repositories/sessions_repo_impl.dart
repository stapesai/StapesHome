// // ...existing code...
// import 'package:stapes_home/features/sessions/data/datasources/remote/sessions_remote_datasources.dart';
// import 'package:stapes_home/features/sessions/data/datasources/sessions_remote_datasource.dart';
// import 'package:stapes_home/features/sessions/domain/entities/session_entity.dart';
// import 'package:stapes_home/features/sessions/domain/entities/sessions_entity.dart';
// import 'package:stapes_home/features/sessions/domain/repositories/sessions_repository.dart';
// import 'package:stapes_home/core/models/user_session_model.dart';

// class SessionsRepositoryImpl implements SessionsRepository {
//   final SessionsRemoteDataSource remoteDataSource;

//   SessionsRepositoryImpl(this.remoteDataSource);

//   @override
//   Future<List<SessionEntity>> getAllSessions({
//     required String userId,
//     required String currentSessionId,
//   }) async {
//     final RemoteDataSource.getAllSessions(userId, currentSessionId);
//     return userSessions
//         .map(
//           (u) => SessionEntity(
//             sessionId: u.sessionId,
//             userId: u.userId,
//             deviceId: ,
//             deviceName: ,
//             lastActiveAt: u.lastActiveAt,
//           ),
//         )
//         .toList();
//   }

//   @override
//   Future<void> revokeSession({
//     required String userId,
//     required String sessionId,
//   }) {
//     return remoteDataSource.revokeSession(userId, sessionId);
//   }
// }