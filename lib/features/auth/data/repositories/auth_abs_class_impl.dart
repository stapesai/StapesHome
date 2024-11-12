import 'package:dartz/dartz.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_api_datasource.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Login
  @override
  Future<Either> requestLogin(RequestLoginParams requestLoginParams) {
    return serviceLocator<AuthApiService>().requestLoginService(requestLoginParams);
  }

  @override
  Future<Either> completeLogin(CompleteLoginParams completeLoginParams) {
    return serviceLocator<AuthApiService>().completeLogin(completeLoginParams);
  }

  // SignUp
  @override
  Future<Either> requestSignUp(RequestSignUpParams requestSignupParams) {
    return serviceLocator<AuthApiService>().requestSignUp(requestSignupParams);
  }

  @override
  Future<Either> completeSignUp(CompleteSignUpParams completeSignupParams) {
    return serviceLocator<AuthApiService>().completeSignUp(completeSignupParams);
  }

  // Forgot Password
  @override
  Future<Either> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams) {
    return serviceLocator<AuthApiService>().requestPasswordReset(requestPasswordResetParams);
  }

  @override
  Future<Either> completePasswordReset(CompletePasswordResetParams completePasswordResetParams) {
    return serviceLocator<AuthApiService>().completePasswordReset(completePasswordResetParams);
  }

  // OTP Verification
  @override
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams) {
    return serviceLocator<AuthApiService>().verifyOtp(otpVerificationParams);
  }
}
