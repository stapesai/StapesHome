import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_email_input_event.dart';
import 'package:stapes_home/features/auth/presentation/blocs/forgot_password/forgot_password_email_input_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestPasswordResetUseCase requestPasswordResetUseCase;

  ForgotPasswordBloc({required this.requestPasswordResetUseCase}) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEmailSubmitted>(_onEmailSubmitted);
  }

  Future<void> _onEmailSubmitted(ForgotPasswordEmailSubmitted event, Emitter<ForgotPasswordState> emit) async {
    emit(ForgotPasswordLoading());

    final result = await requestPasswordResetUseCase(
      RequestPasswordResetParams(email: event.email),
    );

    result.fold(
      (failure) => emit(ForgotPasswordError(message: failure.toString())),
      (response) => emit(
        ForgotPasswordOtpSent(
          transactionId: response.transactionId,
          expiryTime: DateTime.parse(response.otpExpiresAt),
        ),
      ),
    );
  }
}
