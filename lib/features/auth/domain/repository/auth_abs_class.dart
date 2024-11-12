import 'package:dartz/dartz.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';

abstract class AuthRepository {
  // Login
  Future<Either> requestLogin(RequestLoginParams requestLoginParams);
  Future<Either> completeLogin(CompleteLoginParams completeLoginParams);

  // SignUp
  Future<Either> requestSignUp(RequestSignUpParams requestSignupParams);
  Future<Either> completeSignUp(CompleteSignUpParams completeSignupParams);

  // Forgot Password
  Future<Either> requestPasswordReset(RequestPasswordResetParams requestPasswordResetParams);
  Future<Either> completePasswordReset(CompletePasswordResetParams completePasswordResetParams);

  // OTP
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams);
  // Future<Either> resendOtp();

  // Logout
  // Future<Either> logout();
}
