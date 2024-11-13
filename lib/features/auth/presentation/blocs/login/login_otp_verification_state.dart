import 'package:equatable/equatable.dart';
import 'package:stapes_home/features/auth/data/models/user_model.dart';
import 'package:stapes_home/features/auth/data/models/user_session_model.dart';

abstract class LoginOtpVerificationState extends Equatable {
  const LoginOtpVerificationState();

  @override
  List<Object?> get props => [];
}

// Initial state - Emits when the login OTP verification screen is loaded.
class LoginOtpVerificationInitial extends LoginOtpVerificationState {}

// When any event is being processed - Emits when the user submits their OTP.
// CustomButton listens to this state and shows a loading spinner.
class LoginOtpVerificationLoading extends LoginOtpVerificationState {}

// When VerifyOtpUseCase returns success with response containing user and user session models.
// This state is emitted, then presenation layer will navigate to Home screen.
class LoginOtpVerificationSuccess extends LoginOtpVerificationState {
  final String transactionId;

  const LoginOtpVerificationSuccess({
    required this.transactionId,
  });

  @override
  List<Object?> get props => [transactionId];
}

// When VerifyOtpUseCase returns failure with error message.
// This state is emitted, then UI layer will listen to this state and show an error message, returned from server.
class LoginOtpVerificationError extends LoginOtpVerificationState {
  final String message;

  const LoginOtpVerificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
