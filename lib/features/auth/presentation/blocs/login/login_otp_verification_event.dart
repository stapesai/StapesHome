import 'package:equatable/equatable.dart';

abstract class LoginOtpVerificationEvent extends Equatable {
  const LoginOtpVerificationEvent();

  @override
  List<Object?> get props => [];
}

class LoginOtpSubmitted extends LoginOtpVerificationEvent {
  final String transactionId;
  final String otp;
  final String email;

  const LoginOtpSubmitted({
    required this.transactionId,
    required this.otp,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, otp, email];
}

// class LoginResendOtpRequested extends LoginOtpVerificationEvent {
//   final String email;

//   const LoginResendOtpRequested({required this.email});

//   @override
//   List<Object?> get props => [email];
// }
