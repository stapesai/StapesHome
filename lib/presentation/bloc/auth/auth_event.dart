part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RequestLoginEvent extends AuthEvent {
  final String email;

  const RequestLoginEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CompleteLoginEvent extends AuthEvent {
  final String transactionId;

  const CompleteLoginEvent({required this.transactionId});

  @override
  List<Object> get props => [transactionId];
}

class RequestSignupEvent extends AuthEvent {
  final String email;

  const RequestSignupEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CompleteSignupEvent extends AuthEvent {
  final String transactionId;
  final String password;
  final String firstName;
  final String lastName;
  final String dob;
  final String gender;

  const CompleteSignupEvent({
    required this.transactionId,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.gender,
  });

  @override
  List<Object> get props => [transactionId, password, firstName, lastName, dob, gender];
}

class RequestPasswordResetEvent extends AuthEvent {
  final String email;

  const RequestPasswordResetEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class CompletePasswordResetEvent extends AuthEvent {
  final String transactionId;
  final String newPassword;

  const CompletePasswordResetEvent({
    required this.transactionId,
    required this.newPassword,
  });

  @override
  List<Object> get props => [transactionId, newPassword];
}

class VerifyOtpEvent extends AuthEvent {
  final String transactionId;
  final String otp;

  const VerifyOtpEvent({
    required this.transactionId,
    required this.otp,
  });

  @override
  List<Object> get props => [transactionId, otp];
}

class LogoutEvent extends AuthEvent {}
