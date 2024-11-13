import 'package:equatable/equatable.dart';

abstract class LoginOtpVerificationState extends Equatable {
  const LoginOtpVerificationState();

  @override
  List<Object?> get props => [];
}

class LoginOtpVerificationInitial extends LoginOtpVerificationState {}

class LoginOtpVerificationLoading extends LoginOtpVerificationState {}

class LoginOtpVerificationSuccess extends LoginOtpVerificationState {
  final String transactionId;
  final String email;

  const LoginOtpVerificationSuccess({
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, email];
}

class LoginOtpVerificationError extends LoginOtpVerificationState {
  final String message;

  const LoginOtpVerificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
