// File: lib/domain/usecases/request_signup.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/otp_info.dart';
import '../repositories/auth_repository.dart';

class RequestSignup implements UseCase<OtpInfo, RequestSignupParams> {
  final AuthRepository repository;

  RequestSignup(this.repository);

  @override
  Future<Either<Failure, OtpInfo>> call(RequestSignupParams params) async {
    return await repository.requestSignup(params.email);
  }
}

class RequestSignupParams {
  final String email;

  RequestSignupParams({required this.email});
}
