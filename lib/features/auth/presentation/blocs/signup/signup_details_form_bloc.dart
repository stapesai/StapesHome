import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'signup_details_form_event.dart';
import 'signup_details_form_state.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';

class SignUpDetailsFormBloc extends Bloc<SignUpDetailsFormEvent, SignUpDetailsFormState> {
  final CompleteSignUpUseCase completeSignUpUseCase;

  SignUpDetailsFormBloc({required this.completeSignUpUseCase}) : super(SignUpDetailsFormInitial()) {
    on<SignUpDetailsFormSubmittedEvent>(_onDetailsSubmitted);
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

  Future<void> _onDetailsSubmitted(SignUpDetailsFormSubmittedEvent event, Emitter<SignUpDetailsFormState> emit) async {
    emit(SignUpDetailsFormLoading());

    final params = CompleteSignUpParams(
      transactionId: event.transactionId,
      user: event.user,
      password: event.password,
    );

    final result = await completeSignUpUseCase(params);

    result.fold(
      (success) => emit(SignUpDetailsFormSuccess()),
      (failure) => emit(SignUpDetailsFormError(_mapFailureToMessage(failure))),
    );
  }
}
