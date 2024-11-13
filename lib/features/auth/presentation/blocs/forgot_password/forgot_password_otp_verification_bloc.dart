import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'forgot_password_otp_verification_event.dart';
import 'forgot_password_otp_verification_state.dart';

class ForgotPasswordOtpVerificationBloc
    extends Bloc<ForgotPasswordOtpVerificationEvent, ForgotPasswordOtpVerificationState> {
  final OtpVerificationUsecase verifyOtpUseCase;

  ForgotPasswordOtpVerificationBloc({required this.verifyOtpUseCase}) : super(ForgotPasswordOtpVerificationInitial()) {
    on<ForgotPasswordOtpSubmitted>(_onOtpSubmitted);
    // on<ForgotPasswordResendOtpRequested>(_onResendOtpRequested);
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

  Future<void> _onOtpSubmitted(
      ForgotPasswordOtpSubmitted event, Emitter<ForgotPasswordOtpVerificationState> emit) async {
    emit(ForgotPasswordOtpVerificationLoading());

    final result = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(ForgotPasswordOtpVerificationError(_mapFailureToMessage(failure))),
      (response) => emit(
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
