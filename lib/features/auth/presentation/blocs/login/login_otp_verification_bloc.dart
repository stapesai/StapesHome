import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'login_otp_verification_event.dart';
import 'login_otp_verification_state.dart';

class LoginOtpVerificationBloc extends Bloc<LoginOtpVerificationEvent, LoginOtpVerificationState> {
  final OtpVerificationUsecase verifyOtpUseCase;
  final CompleteLoginUseCase completeLoginUseCase;

  // Emits initial state and listens for incoming events
  LoginOtpVerificationBloc({
    required this.verifyOtpUseCase,
    required this.completeLoginUseCase,
  }) : super(LoginOtpVerificationInitial()) {
    on<LoginOtpSubmitted>(_onOtpSubmitted);
    // on<LoginResendOtpRequested>(_onResendOtpRequested);
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

  Future<void> _onOtpSubmitted(LoginOtpSubmitted event, Emitter<LoginOtpVerificationState> emit) async {
    // Sets state to loading - CustomButton listens to this state and shows loading spinner
    emit(LoginOtpVerificationLoading());

    // First verify OTP
    final otpResult = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    otpResult.fold(
      (failure) => emit(LoginOtpVerificationError(message: _mapFailureToMessage(failure))),
      (response) async {
        // Complete login after OTP verification
        final completeLoginResult = await completeLoginUseCase(
          CompleteLoginParams(transactionId: event.transactionId),
        );

        completeLoginResult.fold(
          (failure) => emit(LoginOtpVerificationError(message: _mapFailureToMessage(failure))),
          (loginResponse) => emit(LoginOtpVerificationSuccess()),
        );
      },
    );
  }

  // Future<void> _onResendOtpRequested(LoginResendOtpRequested event, Emitter<LoginOtpVerificationState> emit) async {
  //   Implement resend OTP logic here
  // }
}
