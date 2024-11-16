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
