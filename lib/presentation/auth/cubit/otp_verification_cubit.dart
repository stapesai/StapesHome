// Path: lib/presentation/auth/bloc/otp_verification_cubit.dart
// Description: This file contains the cubit for the OTP verification feature.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/presentation/auth/states/otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  final OtpVerificationUsecase otpVerificationUsecase;

  OtpVerificationCubit({
    required this.otpVerificationUsecase,
  }) : super(OtpVerificationInitial());

  Future<void> verifyOtp({
    required String transactionId,
    required String otp,
  }) async {
    emit(OtpVerificationLoading());

    final result = await otpVerificationUsecase(
      OtpVerificationParams(
        transactionId: transactionId,
        otp: otp,
      ),
    );

    result.fold(
      (failure) => emit(OtpVerificationError(failure.toString())),
      (response) => emit(OtpVerificationSuccess(response.detail)),
    );
  }
}
