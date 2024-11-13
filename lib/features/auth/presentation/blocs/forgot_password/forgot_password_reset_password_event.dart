import 'package:equatable/equatable.dart';

abstract class ForgotPasswordResetPasswordEvent extends Equatable {
  const ForgotPasswordResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordNewPasswordSubmitted extends ForgotPasswordResetPasswordEvent {
  final String password;
  final String confirmPassword;
  final String email;
  final String transactionId;

  const ForgotPasswordNewPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
    required this.email,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [password, confirmPassword, email, transactionId];
}
