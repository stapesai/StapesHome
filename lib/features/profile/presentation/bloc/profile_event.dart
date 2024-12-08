// lib/features/profile/presentation/bloc/profile_event.dart

import 'package:stapes_home/features/profile/domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfile profile;

  UpdateUserProfileEvent(this.profile);
}

class LogoutUserEvent extends ProfileEvent {}