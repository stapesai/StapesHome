import 'package:equatable/equatable.dart';

abstract class SignUpCreatePasswordState extends Equatable {
  const SignUpCreatePasswordState();

  @override
  List<Object?> get props => [];
}

class SignUpCreatePasswordInitial extends SignUpCreatePasswordState {}

class SignUpCreatePasswordLoading extends SignUpCreatePasswordState {}

class SignUpCreatePasswordSuccess extends SignUpCreatePasswordState {
  final String transactionId;
  final String email;
  final String password;

  const SignUpCreatePasswordSuccess({
    required this.transactionId,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [transactionId, email, password];
}

class SignUpCreatePasswordError extends SignUpCreatePasswordState {
  final String message;

  const SignUpCreatePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
