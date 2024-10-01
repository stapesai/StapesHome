// File: lib/domain/usecases/complete_signup.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CompleteSignup implements UseCase<User, CompleteSignupParams> {
  final AuthRepository repository;

  CompleteSignup(this.repository);

  @override
  Future<Either<Failure, User>> call(CompleteSignupParams params) async {
    return await repository.completeSignup(
      params.transactionId,
      params.password,
      params.firstName,
      params.lastName,
      params.dob,
      params.gender,
    );
  }
}

class CompleteSignupParams {
  final String transactionId;
  final String password;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;

  CompleteSignupParams({
    required this.transactionId,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
  });
}
