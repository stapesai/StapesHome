// lib/features/profile/domain/repositories/profile_repository.dart

import 'package:stapes_home/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<void> updateUserProfile(UserProfile profile);
  Future<void> logoutUser();
}