import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class OtpVerificationUsecase implements UseCase<Either, OtpVerificationParams> {
  @override
  Future<Either> call(OtpVerificationParams params) async {
    return serviceLocator<AuthRepository>().verifyOtp(params);
  }
}
