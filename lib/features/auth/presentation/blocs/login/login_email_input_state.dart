import 'package:equatable/equatable.dart';

// Base class for all login email input states.
abstract class LoginEmailInputState extends Equatable {
  const LoginEmailInputState();

  @override
  List<Object> get props => [];
}

// Initial state - Emits when the login screen is loaded.
class LoginEmailInputInitial extends LoginEmailInputState {}

// When any event is being processed - Emits when the user submits their email and password.
// CustomButton listens to this state and shows a loading spinner.
class LoginEmailInputLoading extends LoginEmailInputState {}

// When RequestLoginUseCase returns success with response containing transaction ID and OTP expiry time.
// This state is emitted, then presenation layer will navigate to Login OTP verification screen.
class LoginEmailInputOtpRequired extends LoginEmailInputState {
  final String email;
  final String transactionId;
  final DateTime expiryTime;

  const LoginEmailInputOtpRequired({
    required this.email,
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  List<Object> get props => [transactionId, expiryTime];
}

// When RequestLoginUseCase returns failure with error message.
// This state is emitted, then UI layer will listen to this state and show an error message, returned from server.
class LoginEmailInputError extends LoginEmailInputState {
  final String message;

  const LoginEmailInputError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginEmailInputSuccess extends LoginEmailInputState {
  final String message;

  const LoginEmailInputSuccess(this.message);

  @override
  List<Object> get props => [message];
}
