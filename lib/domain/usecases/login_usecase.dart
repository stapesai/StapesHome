// Path: lib/domain/usecases/login_usecase.dart
// Description: This file contains the use case for the login feature.

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/data/models/auth/login_req_parms.dart';
import 'package:stapes_home/domain/repository/auth_abs_class.dart';
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
