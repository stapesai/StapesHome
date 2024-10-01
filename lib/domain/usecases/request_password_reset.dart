// File: lib/domain/usecases/request_password_reset.dart
// Description: This file contains the RequestPasswordReset use case.

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/otp_info.dart';
import '../repositories/auth_repository.dart';

class RequestPasswordReset implements UseCase<OtpInfo, RequestPasswordResetParams> {
  final AuthRepository repository;

  RequestPasswordReset(this.repository);

  @override
  Future<Either<Failure, OtpInfo>> call(RequestPasswordResetParams params) async {
    return await repository.requestPasswordReset(params.email);
  }
}

class RequestPasswordResetParams {
  final String email;

  RequestPasswordResetParams({required this.email});
}
