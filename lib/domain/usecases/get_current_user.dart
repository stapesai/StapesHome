// File: lib/domain/usecases/get_current_user.dart
// Description: This file contains the GetCurrentUser use case, which encapsulates the logic for retrieving the current user's information.

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for retrieving the current user's information
class GetCurrentUser implements UseCase<User, NoParams> {
  final UserRepository repository;

  /// Creates a new [GetCurrentUser] instance
  GetCurrentUser(this.repository);

  /// Executes the use case
  ///
  /// Returns a [Future] that resolves to an [Either] containing a [Failure] or a [User]
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
