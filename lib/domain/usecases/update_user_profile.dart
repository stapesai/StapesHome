// File: lib/domain/usecases/update_user_profile.dart
// Description: This file contains the UpdateUserProfile use case, which encapsulates the logic for updating a user's profile information.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for updating a user's profile information
class UpdateUserProfile implements UseCase<bool, UpdateUserProfileParams> {
  final UserRepository repository;

  /// Creates a new [UpdateUserProfile] instance
  UpdateUserProfile(this.repository);

  /// Executes the use case
  ///
  /// Parameters:
  /// - params: The parameters for updating the user profile
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [Failure] or a [bool] indicating success
  @override
  Future<Either<Failure, bool>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(params.user);
  }
}

/// Parameters for the [UpdateUserProfile] use case
class UpdateUserProfileParams extends Equatable {
  final User user;

  /// Creates a new [UpdateUserProfileParams] instance
  const UpdateUserProfileParams({required this.user});

  @override
  List<Object> get props => [user];
}
