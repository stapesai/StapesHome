import 'package:equatable/equatable.dart';

abstract class ForgotPasswordOtpVerificationState extends Equatable {
  const ForgotPasswordOtpVerificationState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordOtpVerificationInitial
    extends ForgotPasswordOtpVerificationState {}

class ForgotPasswordOtpVerificationLoading
    extends ForgotPasswordOtpVerificationState {}

// When VerifyOtpUsecase returns success
class ForgotPasswordOtpVerificationSuccess
    extends ForgotPasswordOtpVerificationState {
  final String transactionId;
  final String email;

  const ForgotPasswordOtpVerificationSuccess({
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, email];
}

// When VerifyOtpUsecase returns error
class ForgotPasswordOtpVerificationError
    extends ForgotPasswordOtpVerificationState {
  final String message;

  const ForgotPasswordOtpVerificationError(this.message);

  @override
  List<Object?> get props => [message];
}
