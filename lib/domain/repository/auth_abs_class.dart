// File: lib/domain/repository/auth.dart
// Description:

import 'package:dartz/dartz.dart';
import 'package:stapes_home/data/models/auth/login_req_parms.dart';

abstract class AuthRepository {
  // Login
  Future<Either> requestLogin(RequestLoginParams requestLoginParams);
  Future<Either> completeLogin(CompleteLoginParams completeLoginParams);

  // SignUp
  // Future<Map<String, dynamic>> requestSignUp(String email);
  // Future<Map<String, dynamic>> completeSignUp();

  // Forgot Password
  // Future<Map<String, dynamic>> requestResetPassword(String email);
  // Future<Map<String, dynamic>> verifyOtp(String transactionId, String otp);

  // OTP Verification
  // Future<Either> verifyOtp();
}
