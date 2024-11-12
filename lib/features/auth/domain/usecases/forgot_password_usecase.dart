import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class RequestPasswordResetUseCase implements UseCase<Either, RequestPasswordResetParams> {
  @override
  Future<Either> call(RequestPasswordResetParams params) async {
    return serviceLocator<AuthRepository>().requestPasswordReset(params);
  }
}

class CompletePasswordResetUseCase implements UseCase<Either, CompletePasswordResetParams> {
  @override
  Future<Either> call(CompletePasswordResetParams params) async {
    return serviceLocator<AuthRepository>().completePasswordReset(params);
  }
}