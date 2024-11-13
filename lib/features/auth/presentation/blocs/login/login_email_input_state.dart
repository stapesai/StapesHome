import 'package:equatable/equatable.dart';

abstract class LoginEmailInputState extends Equatable {
  const LoginEmailInputState();

  @override
  List<Object> get props => [];
}

class LoginEmailInputInitial extends LoginEmailInputState {}

class LoginEmailInputLoading extends LoginEmailInputState {}

class LoginEmailInputOtpRequired extends LoginEmailInputState {
  final String transactionId;
  final DateTime expiryTime;

  const LoginEmailInputOtpRequired({
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class LoginEmailInputError extends LoginEmailInputState {
  final String message;

  const LoginEmailInputError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginEmailInputSuccess extends LoginEmailInputState {
  final String message;

  const LoginEmailInputSuccess(this.message);

  @override
  List<Object> get props => [message];
}
