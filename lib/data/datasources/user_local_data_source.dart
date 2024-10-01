// File: lib/data/datasources/user_local_data_source.dart
// Description: This file contains the UserLocalDataSource class, which handles all local storage operations related to user data.

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

/// Abstract class defining the contract for the user local data source
abstract class UserLocalDataSource {
  /// Retrieves the last cached user
  Future<UserModel> getLastUser();

  /// Caches the user data
  Future<void> cacheUser(UserModel userToCache);

  /// Clears the cached user data
  Future<void> clearUser();
}

const CACHED_USER_KEY = 'CACHED_USER';

/// Implementation of [UserLocalDataSource]
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  /// Creates a new [UserLocalDataSourceImpl] instance
  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(CACHED_USER_KEY);
    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) {
    return sharedPreferences.setString(
      CACHED_USER_KEY,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<void> clearUser() {
    return sharedPreferences.remove(CACHED_USER_KEY);
  }
}
