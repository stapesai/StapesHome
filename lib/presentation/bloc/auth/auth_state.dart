part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginOtpSent extends AuthState {
  final String transactionId;
  final DateTime expiryTime;

  const LoginOtpSent(this.transactionId, this.expiryTime);

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class SignupOtpSent extends AuthState {
  final String transactionId;
  final DateTime expiryTime;

  const SignupOtpSent(this.transactionId, this.expiryTime);

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class PasswordResetOtpSent extends AuthState {
  final String transactionId;
  final DateTime expiryTime;

  const PasswordResetOtpSent(this.transactionId, this.expiryTime);

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class OtpVerified extends AuthState {}

class PasswordResetComplete extends AuthState {}
