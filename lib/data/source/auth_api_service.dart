// Path: lib/data/source/auth_api_service.dart
// Description: This file contains code to interact with the API for authentication. We'll register this service in the service locator. Then in the AuthRepositoryImpl, we'll call the methods to make the API calls.

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/data/models/auth/login_req_parms.dart';
import 'package:stapes_home/service_locator.dart';

abstract class AuthApiService {
  // Login
  Future<Either> requestLoginService(RequestLoginParams requestLoginParams);
  Future<Either> completeLogin(CompleteLoginParams completeLoginParams);

  // OTP Verification
  // Future<Either> verifyOtp(String transactionId, String otp);
}

class AuthApiServiceImpl implements AuthApiService {
  // Login
  @override
  Future<Either> requestLoginService(RequestLoginParams requestLoginParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.requestLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestLoginParams.toJson(),
      );

      return Right(response);
    } on AppException catch (e) {
      // TODO: show error messages from server
      return Left(e);
    }
  }

  @override
  Future<Either> completeLogin(CompleteLoginParams completeLoginParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.completeLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completeLoginParams.toJson(),
      );

      return Right(response);
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
