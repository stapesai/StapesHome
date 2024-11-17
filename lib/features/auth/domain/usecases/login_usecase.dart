import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class RequestLoginUseCase implements UseCase<RequestLoginParams, RequestLoginResponse> {
  @override
  Future<Either<Failure, RequestLoginResponse>> call(RequestLoginParams params) async {
    return serviceLocator<AuthRepository>().requestLogin(params);
  }
}

class CompleteLoginUseCase implements UseCase<CompleteLoginParams, CompleteLoginResponse> {
  @override
  Future<Either<Failure, CompleteLoginResponse>> call(CompleteLoginParams params) async {
    return serviceLocator<AuthRepository>().completeLogin(params);
  }
}
