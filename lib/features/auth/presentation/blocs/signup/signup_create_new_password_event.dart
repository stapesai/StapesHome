import 'package:equatable/equatable.dart';

abstract class SignUpCreateNewPasswordEvent extends Equatable {
  const SignUpCreateNewPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SignUpNewPasswordSubmitted extends SignUpCreateNewPasswordEvent {
  final String password;
  final String confirmPassword;
  final String transactionId;
  final String email;

  const SignUpNewPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [password, confirmPassword, transactionId, email];
}
