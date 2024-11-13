import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_create_new_password_event.dart';
import 'signup_create_new_password_state.dart';

class SignUpCreateNewPasswordBloc extends Bloc<SignUpCreateNewPasswordEvent, SignUpCreatePasswordState> {
  SignUpCreateNewPasswordBloc() : super(SignUpCreatePasswordInitial()) {
    on<SignUpNewPasswordSubmitted>(_onPasswordSubmitted);
  }

  // String _mapFailureToMessage(Failure failure) {
  //   if (failure is ServerFailure) {
  //     return failure.message ?? 'Server error occurred.';
  //   } else if (failure is NetworkFailure) {
  //     return 'Please check your internet connection.';
  //   } else {
  //     return 'An unexpected error occurred.';
  //   }
  // }

  Future<void> _onPasswordSubmitted(SignUpNewPasswordSubmitted event, Emitter<SignUpCreatePasswordState> emit) async {
    emit(SignUpCreatePasswordLoading());

    if (event.password != event.confirmPassword) {
      emit(SignUpCreatePasswordError('Passwords do not match'));
      return;
    }

    emit(SignUpCreatePasswordSuccess(
      transactionId: event.transactionId,
      email: event.email,
      password: event.password,
    ));
  }
}
