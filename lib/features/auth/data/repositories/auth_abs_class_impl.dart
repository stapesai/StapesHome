import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Login
  @override
  Future<Either> requestLogin(RequestLoginParams requestLoginParams) {
    return serviceLocator<AuthRemoteDataSource>().requestLoginService(requestLoginParams);
  }

  @override
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams completeLoginParams) async {
    return serviceLocator<AuthRemoteDataSource>().completeLogin(completeLoginParams);
  }

  // SignUp
  @override
  Future<Either> requestSignUp(RequestSignUpParams requestSignupParams) {
    return serviceLocator<AuthRemoteDataSource>().requestSignUp(requestSignupParams);
  }

  @override
  Future<Either> completeSignUp(CompleteSignUpParams completeSignupParams) {
    return serviceLocator<AuthRemoteDataSource>().completeSignUp(completeSignupParams);
  }

  // Forgot Password
  @override
  Future<Either> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams) {
    return serviceLocator<AuthRemoteDataSource>().requestPasswordReset(requestPasswordResetParams);
  }

  @override
  Future<Either> completePasswordReset(CompletePasswordResetParams completePasswordResetParams) {
    return serviceLocator<AuthRemoteDataSource>().completePasswordReset(completePasswordResetParams);
  }

  // OTP Verification
  @override
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams) {
    return serviceLocator<AuthRemoteDataSource>().verifyOtp(otpVerificationParams);
  }
}
