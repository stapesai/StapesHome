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

  const SignUpCreatePasswordSuccess({
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, email];
}

class SignUpCreatePasswordError extends SignUpCreatePasswordState {
  final String message;

  const SignUpCreatePasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
