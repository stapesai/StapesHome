// Path: lib/data/source/auth_api_service.dart
// Description: This file contains code to interact with the API for authentication. We'll register this service in the service locator. Then in the AuthRepositoryImpl, we'll call the methods to make the API calls.

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/user_session_model.dart';
import 'package:stapes_home/service_locator.dart';

abstract class AuthRemoteDataSource {
  // Login
  Future<Either> requestLoginService(RequestLoginParams requestLoginParams);
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams completeLoginParams);

  // SignUp
  Future<Either> requestSignUp(RequestSignUpParams requestSignupParams);
  Future<Either> completeSignUp(CompleteSignUpParams completeSignupParams);

  // Forgot Password
  Future<Either> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams);
  Future<Either> completePasswordReset(CompletePasswordResetParams completePasswordResetParams);

  // OTP Verification
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Login
  @override
  Future<Either> requestLoginService(RequestLoginParams requestLoginParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.requestLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestLoginParams.toJson(),
      );

      return Right(RequestLoginResponse.fromJson(response));
    } on AppException catch (e) {
      // TODO: show error messages from server
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams completeLoginParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.completeLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completeLoginParams.toJson(),
      );

      return Right(CompleteLoginResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  // SignUp
  @override
  Future<Either> requestSignUp(RequestSignUpParams requestSignupParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.requestSignUp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestSignupParams.toJson(),
      );

      return Right(RequestSignUpResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> completeSignUp(CompleteSignUpParams completeSignupParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.completeSignUp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completeSignupParams.toJson(),
      );

      return Right(CompleteSignUpResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  // Forgot Password
  @override
  Future<Either> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.requestPasswordReset,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestPasswordResetParams.toJson(),
      );

      return Right(RequestPasswordResetResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> completePasswordReset(CompletePasswordResetParams completePasswordResetParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.completePasswordReset,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completePasswordResetParams.toJson(),
      );

      return Right(CompletePasswordResetResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }

  // OTP Verification
  @override
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams) async {
    try {
      var response = await serviceLocator<HttpClient>().post(
        AuthRoutes.verifyOtp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: otpVerificationParams.toJson(),
      );

      return Right(OtpVerificationResponse.fromJson(response));
    } on AppException catch (e) {
      return Left(e);
    }
  }
}
