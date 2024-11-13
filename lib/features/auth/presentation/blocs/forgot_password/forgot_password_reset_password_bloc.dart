import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'forgot_password_reset_password_event.dart';
import 'forgot_password_reset_password_state.dart';

class ForgotPasswordResetPasswordBloc extends Bloc<ForgotPasswordResetPasswordEvent, ForgotPasswordResetPasswordState> {
  final CompletePasswordResetUseCase completePasswordResetUseCase;

  ForgotPasswordResetPasswordBloc({required this.completePasswordResetUseCase})
      : super(ForgotPasswordResetPasswordInitial()) {
    on<ForgotPasswordNewPasswordSubmitted>(_onNewPasswordSubmitted);
  }

  Future<void> _onNewPasswordSubmitted(
      ForgotPasswordNewPasswordSubmitted event, Emitter<ForgotPasswordResetPasswordState> emit) async {
    if (event.password != event.confirmPassword) {
      emit(ForgotPasswordResetPasswordError('Passwords do not match'));
      return;
    }

    emit(ForgotPasswordResetPasswordLoading());

    final result = await completePasswordResetUseCase(
      CompletePasswordResetParams(
        email: event.email,
        password: event.password,
        transactionId: event.transactionId,
      ),
    );

    result.fold(
      (failure) => emit(ForgotPasswordResetPasswordError(failure.message)),
      (response) => emit(ForgotPasswordResetPasswordSuccess(response.detail)),
    );
  }
}
