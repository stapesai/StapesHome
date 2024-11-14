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

  AuthLocalDataSourceImpl({required this.hive});

  // User Session
  @override
  Future<void> cacheUserSession(UserSessionModel session) async {
    final box = await hive.openBox<UserSessionModel>(_sessionBoxName);
    await box.put('session', session);
    await box.close();
  }

  @override
  Future<UserSessionModel?> getUserSession() async {
    final box = await hive.openBox<UserSessionModel>(_sessionBoxName);
    final session = box.get('session');
    await box.close();
    return session;
  }

  // User
  @override
  Future<void> cacheUser(UserModel user) async {
    final box = await hive.openBox<UserModel>(_userBoxName);
    await box.put('user', user);
    await box.close();
  }

  @override
  Future<UserModel?> getUser() async {
    final box = await hive.openBox<UserModel>(_userBoxName);
    final user = box.get('user');
    await box.close();
    return user;
  }

  // Clear Session
  @override
  Future<void> clearSession() async {
    final sessionBox = await hive.openBox<UserSessionModel>(_sessionBoxName);
    await sessionBox.clear();
    await sessionBox.close();

    final userBox = await hive.openBox<UserModel>(_userBoxName);
    await userBox.clear();
    await userBox.close();
  }
}
