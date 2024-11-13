import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'sign_up_email_input_event.dart';
import 'sign_up_email_input_state.dart';

class SignUpEmailInputBloc extends Bloc<SignUpEmailInputEvent, SignUpEmailInputState> {
  final RequestSignUpUseCase requestSignUpUseCase;
  // final OtpVerificationUsecase verifyOtpUseCase;
  // final CompleteSignUpUseCase completeSignUpUseCase;

  SignUpEmailInputBloc({
    required this.requestSignUpUseCase,
    // required this.verifyOtpUseCase,
    // required this.completeSignUpUseCase,
  }) : super(SignUpEmailInputInitial()) {
    on<RequestSignUpEvent>(_onRequestSignUp);
    // on<SignUpVerifyOtpEvent>(_onVerifyOtp);
    // on<SubmitUserDetailsEvent>(_onSubmitUserDetails);
  }

  Future<void> _onRequestSignUp(RequestSignUpEvent event, Emitter<SignUpEmailInputState> emit) async {
    emit(SignUpEmailInputLoading());

    final result = await requestSignUpUseCase(RequestSignUpParams(email: event.email));

    result.fold(
      (failure) => emit(SignUpEmailInputError(failure.message)),
      (response) => emit(
        SignUpEmailInputOtpRequired(
          transactionId: response.transactionId,
          expiryTime: DateTime.parse(response.otpExpiresAt),
          email: event.email,
        ),
      ),
    );
  }
}
