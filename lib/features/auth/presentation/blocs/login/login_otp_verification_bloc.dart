import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'login_otp_verification_event.dart';
import 'login_otp_verification_state.dart';

class LoginOtpVerificationBloc extends Bloc<LoginOtpVerificationEvent, LoginOtpVerificationState> {
  final OtpVerificationUsecase verifyOtpUseCase;

  // Emits initial state and listens for incoming events
  LoginOtpVerificationBloc({required this.verifyOtpUseCase}) : super(LoginOtpVerificationInitial()) {
    on<LoginOtpSubmitted>(_onOtpSubmitted);
    // on<LoginResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onOtpSubmitted(LoginOtpSubmitted event, Emitter<LoginOtpVerificationState> emit) async {
    // Sets state to loading - CustomButton listens to this state and shows loading spinner
    emit(LoginOtpVerificationLoading());

    final result = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(LoginOtpVerificationError(message: failure.toString())),
      (response) => emit(
        LoginOtpVerificationSuccess(
          transactionId: event.transactionId,
        ),
      ),
    );
  }

  // Future<void> _onResendOtpRequested(LoginResendOtpRequested event, Emitter<LoginOtpVerificationState> emit) async {
  //   Implement resend OTP logic here
  // }
}
