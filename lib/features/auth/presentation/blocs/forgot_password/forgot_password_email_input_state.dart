import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEmailInputState extends Equatable {
  const ForgotPasswordEmailInputState();

  @override
  List<Object?> get props => [];
}

// Initial state - when the screen is first loaded
class ForgotPasswordEmailInputInitial extends ForgotPasswordEmailInputState {}

// When any event is being processed - Emits when the user submits their email and password.
// CustomButton listens to this state and shows a loading spinner.
class ForgotPasswordEmailInputLoading extends ForgotPasswordEmailInputState {}

// When the OTP is sent to the user's email
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

// When there is an error in sending the OTP
class ForgotPasswordErrorInSendingOtp extends ForgotPasswordEmailInputState {
  final String message;

  const ForgotPasswordErrorInSendingOtp(this.message);

  @override
  List<Object> get props => [message];
}
