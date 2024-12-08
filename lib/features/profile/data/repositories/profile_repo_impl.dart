// lib/features/profile/data/repositories/profile_repository_impl.dart

import 'dart:async';
import 'package:stapes_home/features/profile/domain/entities/user_profile.dart';
import 'package:stapes_home/features/profile/domain/repositories/profile_repo.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  // Simulated data source
  UserProfile _userProfile = UserProfile(
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    dateOfBirth: DateTime(1990, 1, 1),
    avatarUrl: '', // Placeholder
  );

  @override
  Future<UserProfile> getUserProfile() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _userProfile;
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    _userProfile = profile;
  }

  @override
  Future<void> logoutUser() async {
    // Simulate logout operation
    await Future.delayed(const Duration(seconds: 1));
  }
}