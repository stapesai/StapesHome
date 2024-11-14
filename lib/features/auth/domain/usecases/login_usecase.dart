import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class RequestLoginUseCase implements UseCase<Either, RequestLoginParams> {
  @override
  Future<Either> call(RequestLoginParams params) async {
    return serviceLocator<AuthRepository>().requestLogin(params);
  }
}

class CompleteLoginUseCase implements UseCase<Either, CompleteLoginParams> {
  @override
  Future<Either> call(CompleteLoginParams params) async {
    return serviceLocator<AuthRepository>().completeLogin(params);
  }
}
