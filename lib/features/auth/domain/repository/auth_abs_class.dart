import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';

abstract class AuthRepository {
  // Login
  Future<Either<Failure, RequestLoginResponse>> requestLogin(RequestLoginParams requestLoginParams);
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams completeLoginParams);

  // SignUp
  Future<Either<Failure, RequestSignUpResponse>> requestSignUp(RequestSignUpParams requestSignupParams);
  Future<Either<Failure, CompleteSignUpResponse>> completeSignUp(CompleteSignUpParams completeSignupParams);

  // Forgot Password
  Future<Either<Failure, RequestPasswordResetResponse>> requestPasswordReset(
      RequestPasswordResetParams requestPasswordResetParams);
  Future<Either<Failure, CompletePasswordResetResponse>> completePasswordReset(
      CompletePasswordResetParams completePasswordResetParams);

  // OTP
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(OtpVerificationParams otpVerificationParams);
  // Future<Either> resendOtp();

  // Logout
  // Future<Either> logout();
}
