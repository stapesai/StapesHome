// Path: lib/domain/usecases/otp_verification_usecase.dart
// Description: This file contains the use case for the OTP verification feature.

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/data/models/auth/otp_veri_parms.dart';
import 'package:stapes_home/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class OtpVerificationUsecase implements UseCase<Either, OtpVerificationParams> {
  @override
  Future<Either> call(OtpVerificationParams params) async {
    return serviceLocator<AuthRepository>().verifyOtp(params);
  }
}
