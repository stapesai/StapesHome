import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'signup_otp_verification_event.dart';
import 'signup_otp_verification_state.dart';

class OtpVerificationBloc extends Bloc<OtpVerificationEvent, OtpVerificationState> {
  final OtpVerificationUsecase verifyOtpUseCase;

  OtpVerificationBloc({required this.verifyOtpUseCase}) : super(OtpVerificationInitial()) {
    on<OtpSubmitted>(_onOtpSubmitted);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onOtpSubmitted(OtpSubmitted event, Emitter<OtpVerificationState> emit) async {
    emit(OtpVerificationLoading());

    final result = await verifyOtpUseCase(
      OtpVerificationParams(
        transactionId: event.transactionId,
        otp: event.otp,
      ),
    );

    result.fold(
      (failure) => emit(OtpVerificationError(message: failure.toString())),
      (response) => emit(
        OtpVerificationSuccess(
          transactionId: event.transactionId,
          email: event.email,
        ),
      ),
    );
  }

  Future<void> _onResendOtpRequested(ResendOtpRequested event, Emitter<OtpVerificationState> emit) async {}
}
