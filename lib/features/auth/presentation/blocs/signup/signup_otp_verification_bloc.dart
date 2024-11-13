import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'signup_otp_verification_event.dart';
import 'signup_otp_verification_state.dart';

class SignUpOtpVerificationBloc extends Bloc<SignUpOtpVerificationEvent, SignUpOtpVerificationState> {
  final OtpVerificationUsecase verifyOtpUseCase;

  SignUpOtpVerificationBloc({required this.verifyOtpUseCase}) : super(SignUpOtpVerificationInitial()) {
    on<SignUpOtpSubmittedEvent>(_onOtpSubmitted);
    // on<ResendOtpRequested>(_onResendOtpRequested);
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message ?? 'Server error occurred.';
    } else if (failure is NetworkFailure) {
      return 'Please check your internet connection.';
    } else {
      return 'An unexpected error occurred.';
    }
  }

  Future<void> _onOtpSubmitted(SignUpOtpSubmittedEvent event, Emitter<SignUpOtpVerificationState> emit) async {
    emit(SignUpOtpVerificationLoading());

    final otpResult = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    await otpResult.fold(
      (failure) async => emit(SignUpOtpVerificationError(_mapFailureToMessage(failure))),
      (response) async => emit(
        SignUpOtpVerificationSuccess(
          transactionId: event.transactionId,
          email: event.email,
        ),
      ),
    );
  }

  // Future<void> _onResendOtpRequested(ResendOtpRequested event, Emitter<SignUpOtpVerificationState> emit) async {}
}
