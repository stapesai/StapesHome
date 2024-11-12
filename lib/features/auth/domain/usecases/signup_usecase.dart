import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class RequestSignUpUseCase implements UseCase<Either, RequestSignUpParams> {
  @override
  Future<Either> call(RequestSignUpParams params) async {
    return serviceLocator<AuthRepository>().requestSignUp(params);
  }
}

class CompleteSignUpUseCase implements UseCase<Either, CompleteSignUpParams> {
  @override
  Future<Either> call(CompleteSignUpParams params) async {
    return serviceLocator<AuthRepository>().completeSignUp(params);
  }
}
