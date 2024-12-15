import 'package:hive/hive.dart';
import 'package:stapes_home/core/models/user_model.dart';
import 'package:stapes_home/core/models/user_session_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserSession(UserSessionModel session);
  Future<UserSessionModel?> getUserSession();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _sessionBoxName = 'sessionBox';
  static const String _userBoxName = 'userBox';

  final HiveInterface hive;
  Box<UserSessionModel>? _sessionBox;
  Box<UserModel>? _userBox;

  AuthLocalDataSourceImpl({required this.hive});

  Future<void> _initBoxes() async {
    _sessionBox ??= await hive.openBox<UserSessionModel>(_sessionBoxName);
    _userBox ??= await hive.openBox<UserModel>(_userBoxName);
  }

  // User Session
  @override
  Future<void> cacheUserSession(UserSessionModel session) async {
    await _initBoxes();
    await _sessionBox?.put('session', session);
  }

  @override
  Future<UserSessionModel?> getUserSession() async {
    await _initBoxes();
    return _sessionBox?.get('session');
  }

  // User
  @override
  Future<void> cacheUser(UserModel user) async {
    await _initBoxes();
    await _userBox?.put('user', user);
  }

  @override
  Future<UserModel?> getUser() async {
    await _initBoxes();
    return _userBox?.get('user');
  }

  // Clear Session
  @override
  Future<void> clearSession() async {
    await _initBoxes();
    await _sessionBox?.clear();
    await _userBox?.clear();
    await _closeBoxes();
  }

  Future<void> _closeBoxes() async {
    await _sessionBox?.close();
    await _userBox?.close();
    _sessionBox = null;
    _userBox = null;
  }
}

// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final SQLiteService sqliteService;

//   AuthLocalDataSourceImpl({required this.sqliteService});

//   @override
//   Future<void> cacheUserSession(UserSessionModel session) async {
//     try {
//       final db = await sqliteService.database;
//       await db.transaction((txn) async {
//         await txn.delete('user_session');
//         await txn.insert('user_session', {
//           'access_token': session.accessToken,
//           'refresh_token': session.refreshToken,
//           'expires_at': session.expiresAt.millisecondsSinceEpoch,
//         });
//       });
//     } on StateError catch (e) {
//       throw SQLiteException('Database not initialized: ${e.message}');
//     } on DatabaseException catch (e) {
//       throw SQLiteException('Database error while caching session: ${e.toString()}');
//     } catch (e) {
//       throw UnexpectedException('Unexpected error while caching session: ${e.toString()}');
//     }
//   }

//   @override
//   Future<UserSessionModel?> getUserSession() async {
//     try {
//       final db = await sqliteService.database;
//       final List<Map<String, dynamic>> result = await db.query('user_session');

//       if (result.isEmpty) return null;

//       return UserSessionModel.fromJson({
//         ...result.first,
//         'expires_at': DateTime.fromMillisecondsSinceEpoch(result.first['expires_at']),
//       });
//     } on StateError catch (e) {
//       throw SQLiteException('Database not initialized: ${e.message}');
//     } on DatabaseException catch (e) {
//       throw SQLiteException('Database error while getting session: ${e.toString()}');
//     } catch (e) {
//       throw UnexpectedException('Unexpected error while getting session: ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> cacheUser(UserModel user) async {
//     try {
//       final db = await sqliteService.database;
//       await db.transaction((txn) async {
//         await txn.delete('user');
//         await txn.insert('user', {
//           'email': user.email,
//           'first_name': user.firstName,
//           'last_name': user.lastName,
//           'dob': user.dob,
//           'gender': user.gender
//         });
//       });
//     } on StateError catch (e) {
//       throw SQLiteException('Database not initialized: ${e.message}');
//     } on DatabaseException catch (e) {
//       throw SQLiteException('Database error while caching user: ${e.toString()}');
//     } catch (e) {
//       throw UnexpectedException('Unexpected error while caching user: ${e.toString()}');
//     }
//   }

//   @override
//   Future<UserModel?> getUser() async {
//     try {
//       final db = await sqliteService.database;
//       final List<Map<String, dynamic>> result = await db.query('user');

//       if (result.isEmpty) return null;

//       return UserModel.fromJson(result.first);
//     } on StateError catch (e) {
//       throw SQLiteException('Database not initialized: ${e.message}');
//     } on DatabaseException catch (e) {
//       throw SQLiteException('Database error while getting user: ${e.toString()}');
//     } catch (e) {
//       throw UnexpectedException('Unexpected error while getting user: ${e.toString()}');
//     }
//   }

//   @override
//   Future<void> clearSession() async {
//     try {
//       final db = await sqliteService.database;
//       await db.transaction((txn) async {
//         await txn.delete('user_session');
//         await txn.delete('user');
//       });
//     } on StateError catch (e) {
//       throw SQLiteException('Database not initialized: ${e.message}');
//     } on DatabaseException catch (e) {
//       throw SQLiteException('Database error while clearing session: ${e.toString()}');
//     } catch (e) {
//       throw UnexpectedException('Unexpected error while clearing session: ${e.toString()}');
//     }
//   }
// }
