import 'package:equatable/equatable.dart';

abstract class SignUpCreatePasswordEvent extends Equatable {
  const SignUpCreatePasswordEvent();

  @override
  List<Object?> get props => [];
}

class SignUpPasswordSubmitted extends SignUpCreatePasswordEvent {
  final String password;
  final String confirmPassword;
  final String transactionId;
  final String email;

  const SignUpPasswordSubmitted({
    required this.password,
    required this.confirmPassword,
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [password, confirmPassword, transactionId, email];
}
