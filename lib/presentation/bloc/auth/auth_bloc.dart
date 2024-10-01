// File: lib/presentation/bloc/auth/auth_bloc.dart
// Description: This file contains the AuthBloc which manages the authentication state of the application.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/signup.dart';
import '../../../domain/usecases/logout.dart';
import '../../../domain/usecases/verify_otp.dart';
import '../../../domain/usecases/request_password_reset.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/user.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignupEvent extends AuthEvent {
  final String email;
  final String password;

  const SignupEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutEvent extends AuthEvent {}

class VerifyOtpEvent extends AuthEvent {
  final String transactionId;
  final String otp;

  const VerifyOtpEvent({required this.transactionId, required this.otp});

  @override
  List<Object> get props => [transactionId, otp];
}

class RequestPasswordResetEvent extends AuthEvent {
  final String email;

  const RequestPasswordResetEvent({required this.email});

  @override
  List<Object> get props => [email];
}

// States
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

class OtpSent extends AuthState {
  final String transactionId;
  final DateTime expiryTime;

  const OtpSent(this.transactionId, this.expiryTime);

  @override
  List<Object> get props => [transactionId, expiryTime];
}

class OtpVerified extends AuthState {}

class PasswordResetRequested extends AuthState {}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  final Signup signup;
  final Logout logout;
  final VerifyOtp verifyOtp;
  final RequestPasswordReset requestPasswordReset;

  AuthBloc({
    required this.login,
    required this.signup,
    required this.logout,
    required this.verifyOtp,
    required this.requestPasswordReset,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<LogoutEvent>(_onLogout);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<RequestPasswordResetEvent>(_onRequestPasswordReset);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await login(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signup(SignupParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (otpInfo) => emit(OtpSent(otpInfo.transactionId, otpInfo.expiryTime)),
    );
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logout(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(VerifyOtpParams(transactionId: event.transactionId, otp: event.otp));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(OtpVerified()),
    );
  }

  void _onRequestPasswordReset(RequestPasswordResetEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await requestPasswordReset(RequestPasswordResetParams(email: event.email));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (otpInfo) => emit(OtpSent(otpInfo.transactionId, otpInfo.expiryTime)),
    );
  }
}
