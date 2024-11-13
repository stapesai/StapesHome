import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'forgot_password_email_input_event.dart';
import 'forgot_password_email_input_state.dart';

class ForgotPasswordEmailInputBloc extends Bloc<ForgotPasswordEmailInputEvent, ForgotPasswordEmailInputState> {
  final RequestPasswordResetUseCase requestPasswordResetUseCase;

  ForgotPasswordEmailInputBloc({required this.requestPasswordResetUseCase}) : super(ForgotPasswordEmailInputInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);
  }

  Future<void> _onEmailSubmitted(
      ForgotPasswordEmailSubmitted event, Emitter<ForgotPasswordEmailInputState> emit) async {
    emit(ForgotPasswordEmailInputLoading());

    final result = await requestPasswordResetUseCase(
      RequestPasswordResetParams(email: event.email),
    );

    result.fold(
      (failure) => emit(ForgotPasswordEmailInputError(message: failure.toString())),
      (response) => emit(
        ForgotPasswordEmailInputOtpSent(
          transactionId: response.transactionId,
          expiryTime: DateTime.parse(response.otpExpiresAt),
        ),
      ),
    );
  }
}
