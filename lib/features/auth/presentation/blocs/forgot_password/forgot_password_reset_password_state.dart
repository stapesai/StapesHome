import 'package:equatable/equatable.dart';

abstract class ForgotPasswordResetPasswordState extends Equatable {
  const ForgotPasswordResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordResetPasswordInitial
    extends ForgotPasswordResetPasswordState {}

class ForgotPasswordResetPasswordLoading
    extends ForgotPasswordResetPasswordState {}

// When ResetPasswordUsecase returns success
class ForgotPasswordResetPasswordSuccess
    extends ForgotPasswordResetPasswordState {
  final String message;

  const ForgotPasswordResetPasswordSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// When ResetPasswordUsecase returns error
// There can be some internal server error here. error message is being returned from server and shown to user
class ForgotPasswordResetPasswordError
    extends ForgotPasswordResetPasswordState {
  final String message;

  const ForgotPasswordResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
