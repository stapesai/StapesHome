import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
abstract class AuthRemoteDataSource {
  // Login
  Future<RequestLoginResponse> requestLoginService(RequestLoginParams requestLoginParams);
  Future<CompleteLoginResponse> completeLogin(CompleteLoginParams completeLoginParams);

  // SignUp
  Future<RequestSignUpResponse> requestSignUp(RequestSignUpParams requestSignupParams);
  Future<CompleteSignUpResponse> completeSignUp(CompleteSignUpParams completeSignupParams);

  // Forgot Password
  Future<RequestPasswordResetResponse> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams);
  Future<CompletePasswordResetResponse> completePasswordReset(CompletePasswordResetParams completePasswordResetParams);

  // OTP Verification
  Future<OtpVerificationResponse> verifyOtp(OtpVerificationParams otpVerificationParams);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSourceImpl({required this.httpClient});

  // Login
  @override
  Future<RequestLoginResponse> requestLoginService(RequestLoginParams requestLoginParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.requestLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestLoginParams.toJson(),
      );

      return RequestLoginResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CompleteLoginResponse> completeLogin(CompleteLoginParams completeLoginParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.completeLogin,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completeLoginParams.toJson(),
      );

      return CompleteLoginResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  // SignUp
  @override
  Future<RequestSignUpResponse> requestSignUp(RequestSignUpParams requestSignupParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.requestSignUp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestSignupParams.toJson(),
      );

      return RequestSignUpResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CompleteSignUpResponse> completeSignUp(CompleteSignUpParams completeSignupParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.completeSignUp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completeSignupParams.toJson(),
      );

      return CompleteSignUpResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  // Forgot Password
  @override
  Future<RequestPasswordResetResponse> requestPasswordReset(
      RequestPasswordResetParams requestPasswordResetParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.requestPasswordReset,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: requestPasswordResetParams.toJson(),
      );

      return RequestPasswordResetResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  @override
  Future<CompletePasswordResetResponse> completePasswordReset(
      CompletePasswordResetParams completePasswordResetParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.completePasswordReset,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: completePasswordResetParams.toJson(),
      );

      return CompletePasswordResetResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }

  // OTP Verification
  @override
  Future<OtpVerificationResponse> verifyOtp(OtpVerificationParams otpVerificationParams) async {
    try {
      var response = await httpClient.post(
        AuthRoutes.verifyOtp,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: otpVerificationParams.toJson(),
      );

      return OtpVerificationResponse.fromJson(response);
    } on ServerException catch (e) {
      throw ServerException(e.message);
    } on NetworkException {
      throw NetworkException();
    } catch (e) {
      throw UnexpectedException(e.toString());
    }
  }
}
