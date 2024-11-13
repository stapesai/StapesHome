import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_create_new_password_event.dart';
import 'signup_create_new_password_state.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';

class SignUpCreatePasswordBloc extends Bloc<SignUpCreatePasswordEvent, SignUpCreatePasswordState> {
  final CreatePasswordUseCase createPasswordUseCase;

  SignUpCreatePasswordBloc({required this.createPasswordUseCase}) : super(SignUpCreatePasswordInitial()) {
    on<SignUpPasswordSubmitted>(_onPasswordSubmitted);
  }

  Future<void> _onPasswordSubmitted(SignUpPasswordSubmitted event, Emitter<SignUpCreatePasswordState> emit) async {
    if (event.password != event.confirmPassword) {
      emit(SignUpCreatePasswordError(message: 'Passwords do not match'));
      return;
    }

    emit(SignUpCreatePasswordLoading());

    final params = CreatePasswordParams(
      transactionId: event.transactionId,
      password: event.password,
    );

    final result = await createPasswordUseCase(params);

    result.fold(
      (failure) => emit(SignUpCreatePasswordError(message: failure.toString())),
      (_) => emit(SignUpCreatePasswordSuccess(
        transactionId: event.transactionId,
        email: event.email,
      )),
    );
  }
}
