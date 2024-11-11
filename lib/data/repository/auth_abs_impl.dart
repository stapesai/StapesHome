// Path: lib/domain/repository/auth.dart
// Description:

import 'package:dartz/dartz.dart';
import 'package:stapes_home/data/models/auth/login_req_parms.dart';
import 'package:stapes_home/data/models/auth/otp_veri_parms.dart';
import 'package:stapes_home/data/source/auth_api_service.dart';
import 'package:stapes_home/domain/repository/auth_abs_class.dart';
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

  // OTP Verification
  @override
  Future<Either> verifyOtp(OtpVerificationParams otpVerificationParams) {
    return serviceLocator<AuthApiService>().verifyOtp(otpVerificationParams);
  }
}
