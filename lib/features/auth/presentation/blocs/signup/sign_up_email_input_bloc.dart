import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'sign_up_email_input_event.dart';
import 'sign_up_email_input_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final RequestSignUpUseCase requestSignUpUseCase;
  final OtpVerificationUsecase verifyOtpUseCase;
  final CompleteSignUpUseCase completeSignUpUseCase;

  SignUpBloc({
    required this.requestSignUpUseCase,
    required this.verifyOtpUseCase,
    required this.completeSignUpUseCase,
  }) : super(SignUpInitial()) {
    on<RequestSignUpEvent>(_onRequestSignUp);
    on<SignUpVerifyOtpEvent>(_onVerifyOtp);
    on<SubmitUserDetailsEvent>(_onSubmitUserDetails);
  }

  Future<void> _onRequestSignUp(RequestSignUpEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    final result = await requestSignUpUseCase(RequestSignUpParams(email: event.email));

    result.fold(
      (failure) => emit(SignUpError(message: failure.toString())),
      (response) => emit(
        SignUpOtpRequired(
          transactionId: response.transactionId,
          expiryTime: DateTime.parse(response.otpExpiresAt),
          email: event.email,
        ),
      ),
    );
  }

  Future<void> _onVerifyOtp(SignUpVerifyOtpEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    final result = await verifyOtpUseCase(
      OtpVerificationParams(transactionId: event.transactionId, otp: event.otp),
    );

    result.fold(
      (failure) => emit(SignUpError(message: failure.toString())),
      (_) => emit(SignUpOtpVerified(transactionId: event.transactionId)),
    );
  }

  Future<void> _onCreatePassword(CreatePasswordEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    if (event.password != event.confirmPassword) {
      emit(SignUpError(message: 'Passwords do not match'));
      return;
    }

    // Implement CreatePasswordUseCase or handle password creation logic here
    // After successful password creation, emit SignUpPasswordCreated
    emit(SignUpPasswordCreated(
      transactionId: event.transactionId,
      email: event.email,
      password: event.password,
    ));
  }

  Future<void> _onSubmitUserDetails(SubmitUserDetailsEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoading());

    final params = CompleteSignUpParams(
      transactionId: event.transactionId,
      user: event.user,
      password: event.password,
    );

    final result = await completeSignUpUseCase(params);

    result.fold(
      (failure) => emit(SignUpError(message: failure.toString())),
      (response) => emit(SignUpSuccess()),
    );
  }
}
