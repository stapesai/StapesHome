import 'package:equatable/equatable.dart';

abstract class LoginEmailInputEvent extends Equatable {
  const LoginEmailInputEvent();

  @override
  List<Object?> get props => [];
}

// Triggered when the user submits their email and password for login.
// Bloc listens to this event and emits LoginEmailInputLoading state.
// Then, RequestLoginUseCase is called to process the login request.
// If the request is successful, LoginEmailInputOtpRequired state is emitted.
// If the request fails, LoginEmailInputError state is emitted.
class RequestLoginEvent extends LoginEmailInputEvent {
  final String email;
  final String password;

  const RequestLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

// Triggered when the OTP verification is successful.
// Emitted from LoginOtpVerificationScreen.
class CompleteLoginEvent extends LoginEmailInputEvent {
  final String transactionId;

  const CompleteLoginEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
