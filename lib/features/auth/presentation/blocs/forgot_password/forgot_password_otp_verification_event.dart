import 'package:equatable/equatable.dart';

abstract class ForgotPasswordOtpVerificationEvent extends Equatable {
  const ForgotPasswordOtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordOtpSubmitted extends ForgotPasswordOtpVerificationEvent {
  final String transactionId;
  final String otp;
  final String email;

  const ForgotPasswordOtpSubmitted({
    required this.transactionId,
    required this.otp,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, otp, email];
}

class ForgotPasswordResendOtpRequested extends ForgotPasswordOtpVerificationEvent {
  final String email;

  const ForgotPasswordResendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
