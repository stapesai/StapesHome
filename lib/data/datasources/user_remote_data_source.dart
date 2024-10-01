// File: lib/data/datasources/user_remote_data_source.dart
// Description: This file contains the UserRemoteDataSource class, which handles all API calls related to user operations.

import 'dart:convert';
import '../../core/error/exceptions.dart';
import '../../core/network/http_client.dart';
import '../models/user_model.dart';
import '../../core/api/api_routes.dart';

/// Abstract class defining the contract for the user remote data source
abstract class UserRemoteDataSource {
  /// Fetches the current user's data from the API
  Future<UserModel> getCurrentUser();

  /// Updates the user's profile information
  Future<bool> updateUserProfile(UserModel user);

  /// Changes the user's password
  Future<bool> changePassword(String currentPassword, String newPassword);

  /// Logs out the current user
  Future<bool> logout();
}

/// Implementation of [UserRemoteDataSource]
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final HttpClient client;

  /// Creates a new [UserRemoteDataSourceImpl] instance
  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await client.get(
      AuthRoutes.getCurrentSession,
      headers: {'Content-Type': 'application/json'},
    );

    if (response['user'] != null) {
      return UserModel.fromJson(response['user']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> updateUserProfile(UserModel user) async {
    throw UnimplementedError();
    // final response = await client.put(
    //   BackendRoutes.updateUser(user.id),
    //   body: json.encode(user.toJson()),
    //   headers: {'Content-Type': 'application/json'},
    // );

    // if (response['success'] == true) {
    //   return true;
    // } else {
    //   throw ServerException();
    // }
  }

  @override
  Future<bool> changePassword(String currentPassword, String newPassword) async {
    throw UnimplementedError();
    // final response = await client.post(
    //   AuthRoutes.changePassword,
    //   body: json.encode({
    //     'current_password': currentPassword,
    //     'new_password': newPassword,
    //   }),
    //   headers: {'Content-Type': 'application/json'},
    // );

    // if (response['success'] == true) {
    //   return true;
    // } else if (response['error'] == 'invalid_credentials') {
    //   throw UnauthorizedException();
    // } else {
    //   throw ServerException();
    // }
  }

  @override
  Future<bool> logout() async {
    final response = await client.post(
      AuthRoutes.logoutUser,
      headers: {'Content-Type': 'application/json'},
    );

    if (response['success'] == true) {
      return true;
    } else {
      throw ServerException();
    }
  }
}
