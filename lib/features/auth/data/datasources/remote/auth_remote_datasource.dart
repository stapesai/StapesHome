// lib/features/auth/data/datasources/remote/auth_remote_datasource.dart

import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';

abstract class AuthRemoteDataSource {
  Future<RequestLoginResponse> requestLoginService(RequestLoginParams params);
  Future<CompleteLoginResponse> completeLogin(CompleteLoginParams params);
  Future<RequestSignUpResponse> requestSignUp(RequestSignUpParams params);
  Future<CompleteSignUpResponse> completeSignUp(CompleteSignUpParams params);
  Future<RequestPasswordResetResponse> requestPasswordReset(RequestPasswordResetParams params);
  Future<CompletePasswordResetResponse> completePasswordReset(CompletePasswordResetParams params);
  Future<OtpVerificationResponse> verifyOtp(OtpVerificationParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<RequestLoginResponse> requestLoginService(RequestLoginParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.requestLogin,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return RequestLoginResponse.fromJson(response);
    });
  }

  @override
  Future<CompleteLoginResponse> completeLogin(CompleteLoginParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.completeLogin,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return CompleteLoginResponse.fromJson(response);
    });
  }

  @override
  Future<RequestSignUpResponse> requestSignUp(RequestSignUpParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.requestSignUp,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return RequestSignUpResponse.fromJson(response);
    });
  }

  @override
  Future<CompleteSignUpResponse> completeSignUp(CompleteSignUpParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.completeSignUp,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return CompleteSignUpResponse.fromJson(response);
    });
  }

  @override
  Future<RequestPasswordResetResponse> requestPasswordReset(RequestPasswordResetParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.requestPasswordReset,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return RequestPasswordResetResponse.fromJson(response);
    });
  }

  @override
  Future<CompletePasswordResetResponse> completePasswordReset(CompletePasswordResetParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.completePasswordReset,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return CompletePasswordResetResponse.fromJson(response);
    });
  }

  @override
  Future<OtpVerificationResponse> verifyOtp(OtpVerificationParams params) {
    return httpClient.handleRequest(() async {
      final response = await httpClient.post(
        AuthRoutes.verifyOtp,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: params.toJson(),
      );
      return OtpVerificationResponse.fromJson(response);
    });
  }
}
