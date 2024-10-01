// File: lib/data/models/user_model.dart
// Description: This file contains the User model class, which represents user data in the application.

import '../../domain/entities/user.dart';

/// Represents a user in the application
class UserModel extends User {
  /// Creates a new UserModel instance
  const UserModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.dateOfBirth,
    super.gender,
  });

  /// Creates a UserModel instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
    );
  }

  /// Converts the UserModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'date_of_birth': dateOfBirth,
      'gender': gender,
    };
  }

  /// Creates a copy of the UserModel instance with optional property changes
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
    );
  }
}
