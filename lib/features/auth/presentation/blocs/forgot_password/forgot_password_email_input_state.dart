import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEmailInputState extends Equatable {
  const ForgotPasswordEmailInputState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailInputInitial extends ForgotPasswordEmailInputState {}

class ForgotPasswordEmailInputLoading extends ForgotPasswordEmailInputState {}

class ForgotPasswordEmailInputOtpSent extends ForgotPasswordEmailInputState {
  final String transactionId;
  final DateTime expiryTime;

  const ForgotPasswordEmailInputOtpSent({
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  List<Object?> get props => [transactionId, expiryTime];
}

class ForgotPasswordEmailInputError extends ForgotPasswordEmailInputState {
  final String message;

  const ForgotPasswordEmailInputError({required this.message});

  @override
  List<Object?> get props => [message];
}
