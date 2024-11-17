import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'forgot_password_otp_verification_event.dart';
import 'forgot_password_otp_verification_state.dart';

class ForgotPasswordOtpVerificationBloc
    extends Bloc<ForgotPasswordOtpVerificationEvent, ForgotPasswordOtpVerificationState> {
  final OtpVerificationUseCase verifyOtpUseCase;

  ForgotPasswordOtpVerificationBloc({required this.verifyOtpUseCase}) : super(ForgotPasswordOtpVerificationInitial()) {
    on<ForgotPasswordOtpSubmitted>(_onOtpSubmitted);
    // on<ForgotPasswordResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onOtpSubmitted(
      ForgotPasswordOtpSubmitted event, Emitter<ForgotPasswordOtpVerificationState> emit) async {
    emit(ForgotPasswordOtpVerificationLoading());

    final otpResult = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    await otpResult.fold(
      (failure) async => emit(ForgotPasswordOtpVerificationError(failure.message)),
      (response) async => emit(
        ForgotPasswordOtpVerificationSuccess(
          transactionId: event.transactionId,
          email: event.email,
        ),
      ),
    );
  }

  // Future<void> _onResendOtpRequested(
  //     ForgotPasswordResendOtpRequested event, Emitter<ForgotPasswordOtpVerificationState> emit) async {
  // }
}
