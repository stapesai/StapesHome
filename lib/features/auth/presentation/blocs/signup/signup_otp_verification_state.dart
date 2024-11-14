import 'package:equatable/equatable.dart';

abstract class SignUpOtpVerificationState extends Equatable {
  const SignUpOtpVerificationState();

  @override
  List<Object?> get props => [];
}

class SignUpOtpVerificationInitial extends SignUpOtpVerificationState {}

class SignUpOtpVerificationLoading extends SignUpOtpVerificationState {}

class SignUpOtpVerificationSuccess extends SignUpOtpVerificationState {
  final String transactionId;
  final String email;

  const SignUpOtpVerificationSuccess({
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object> get props => [transactionId, email];
}

class SignUpOtpVerificationError extends SignUpOtpVerificationState {
  final String message;

  const SignUpOtpVerificationError(this.message);

  @override
  List<Object> get props => [message];
}
