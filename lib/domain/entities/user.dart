// File: lib/domain/entities/user.dart
// Description: This file contains the User entity class, which represents the core user data in the application.

import 'package:equatable/equatable.dart';

/// Represents a user entity in the application
class User extends Equatable {
  /// The unique identifier of the user
  final String id;

  /// The email address of the user
  final String email;

  /// The first name of the user
  final String firstName;

  /// The last name of the user
  final String lastName;

  /// The date of birth of the user (optional)
  final String? dateOfBirth;

  /// The gender of the user (optional)
  final String? gender;

  /// Creates a new User instance
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.dateOfBirth,
    this.gender,
  });

  /// Returns the full name of the user
  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [id, email, firstName, lastName, dateOfBirth, gender];

  @override
  String toString() {
    return 'User(id: $id, email: $email, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender)';
  }
}
