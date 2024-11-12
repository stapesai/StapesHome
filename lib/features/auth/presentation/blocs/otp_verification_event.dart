import 'package:equatable/equatable.dart';

abstract class OtpVerificationEvent extends Equatable {
  const OtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class OtpSubmitted extends OtpVerificationEvent {
  final String transactionId;
  final String otp;
  final String email;

  const OtpSubmitted({
    required this.transactionId,
    required this.otp,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, otp, email];
}

class ResendOtpRequested extends OtpVerificationEvent {
  final String email;

  const ResendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
