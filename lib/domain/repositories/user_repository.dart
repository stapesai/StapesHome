// File: lib/domain/repositories/user_repository.dart
// Description: This file contains the UserRepository interface, which defines the contract for user-related operations.

import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

/// Defines the contract for user-related operations
abstract class UserRepository {
  /// Retrieves the current user
  ///
  /// Returns:
  /// A Future that resolves to an Either containing a Failure or a User entity
  Future<Either<Failure, User>> getCurrentUser();

  /// Updates the user's profile information
  ///
  /// Parameters:
  /// - user: The updated User entity
  ///
  /// Returns:
  /// A Future that resolves to an Either containing a Failure or a boolean indicating success
  Future<Either<Failure, bool>> updateUserProfile(User user);

  /// Changes the user's password
  ///
  /// Parameters:
  /// - currentPassword: The user's current password
  /// - newPassword: The new password to set
  ///
  /// Returns:
  /// A Future that resolves to an Either containing a Failure or a boolean indicating success
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword);

  /// Logs out the current user
  ///
  /// Returns:
  /// A Future that resolves to an Either containing a Failure or a boolean indicating success
  Future<Either<Failure, bool>> logout();
}
