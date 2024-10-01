// File: lib/domain/usecases/verify_otp.dart
// Description: This file contains the VerifyOtp use case.

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp implements UseCase<void, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.transactionId, params.otp);
  }
}

class VerifyOtpParams {
  final String transactionId;
  final String otp;

  VerifyOtpParams({required this.transactionId, required this.otp});
}
