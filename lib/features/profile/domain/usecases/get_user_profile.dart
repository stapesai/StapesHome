// lib/features/profile/domain/usecases/get_user_profile.dart
import 'package:stapes_home/features/profile/domain/entities/user_profile.dart';
import 'package:stapes_home/features/profile/domain/repositories/profile_repo.dart';


class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserProfile> execute() {
    return repository.getUserProfile();
  }
}