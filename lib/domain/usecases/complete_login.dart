// File: lib/domain/usecases/complete_login.dart
// Description: This file contains the use case to complete the login process.

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CompleteLogin implements UseCase<User, CompleteLoginParams> {
  final AuthRepository repository;

  CompleteLogin(this.repository);

  @override
  Future<Either<Failure, User>> call(CompleteLoginParams params) async {
    return await repository.completeLogin(params.transactionId);
  }
}

class CompleteLoginParams {
  final String transactionId;

  CompleteLoginParams({required this.transactionId});
}
