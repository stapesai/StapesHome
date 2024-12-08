// lib/features/profile/domain/entities/user_profile.dart

class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime dateOfBirth;
  final String avatarUrl;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.avatarUrl,
  });
}