import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginOtpRequired extends LoginState {
  final String transactionId;
  final DateTime expiryTime;

  const LoginOtpRequired({
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginSuccess extends LoginState {
  final String message;

  const LoginSuccess(this.message);

  @override
  List<Object> get props => [message];
}
