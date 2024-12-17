import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class RequestPasswordResetUseCase implements UseCase<RequestPasswordResetParams, RequestPasswordResetResponse> {
  @override
  Future<Either<Failure, RequestPasswordResetResponse>> call(RequestPasswordResetParams params) async {
    return serviceLocator<AuthRepository>().requestPasswordReset(params);
  }
}

class CompletePasswordResetUseCase implements UseCase<CompletePasswordResetParams, CompletePasswordResetResponse> {
  @override
  Future<Either<Failure, CompletePasswordResetResponse>> call(CompletePasswordResetParams params) async {
    return serviceLocator<AuthRepository>().completePasswordReset(params);
  }
}
