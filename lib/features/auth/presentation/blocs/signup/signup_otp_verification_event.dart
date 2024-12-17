import 'package:equatable/equatable.dart';

abstract class SignUpOtpVerificationEvent extends Equatable {
  const SignUpOtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class SignUpOtpSubmittedEvent extends SignUpOtpVerificationEvent {
  final String transactionId;
  final String otp;
  final String email;

  const SignUpOtpSubmittedEvent({
    required this.transactionId,
    required this.otp,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, otp, email];
}

// class ResendOtpRequested extends SignUpOtpVerificationEvent {
//   final String email;

//   const ResendOtpRequested({required this.email});

//   @override
//   List<Object?> get props => [email];
// }
