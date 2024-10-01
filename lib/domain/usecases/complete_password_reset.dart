// File: lib/domain/usecases/complete_password_reset.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class CompletePasswordReset implements UseCase<void, CompletePasswordResetParams> {
  final AuthRepository repository;

  CompletePasswordReset(this.repository);

  @override
  Future<Either<Failure, void>> call(CompletePasswordResetParams params) async {
    return await repository.completePasswordReset(params.transactionId, params.newPassword);
  }
}

class CompletePasswordResetParams {
  final String transactionId;
  final String newPassword;

  CompletePasswordResetParams({
    required this.transactionId,
    required this.newPassword,
  });
}
