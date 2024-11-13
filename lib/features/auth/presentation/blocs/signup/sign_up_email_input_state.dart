import 'package:equatable/equatable.dart';

abstract class SignUpEmailInputState extends Equatable {
  const SignUpEmailInputState();

  @override
  List<Object?> get props => [];
}

class SignUpEmailInputInitial extends SignUpEmailInputState {}

class SignUpEmailInputLoading extends SignUpEmailInputState {}

class SignUpEmailInputOtpRequired extends SignUpEmailInputState {
  final String transactionId;
  final DateTime expiryTime;
  final String email;

  const SignUpEmailInputOtpRequired({
    required this.transactionId,
    required this.expiryTime,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, expiryTime, email];
}

class SignUpEmailInputError extends SignUpEmailInputState {
  final String message;

  const SignUpEmailInputError(this.message);

  @override
  List<Object> get props => [message];
}
