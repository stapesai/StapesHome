// File: lib/presentation/bloc/auth/auth_bloc.dart
// Description: This file contains the AuthBloc which manages the authentication state of the application.

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/request_login.dart';
import '../../../domain/usecases/complete_login.dart';
import '../../../domain/usecases/request_signup.dart';
import '../../../domain/usecases/complete_signup.dart';
import '../../../domain/usecases/request_password_reset.dart';
import '../../../domain/usecases/complete_password_reset.dart';
import '../../../domain/usecases/verify_otp.dart';
import '../../../domain/usecases/logout.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/entities/user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestLogin requestLogin;
  final CompleteLogin completeLogin;
  final RequestSignup requestSignup;
  final CompleteSignup completeSignup;
  final RequestPasswordReset requestPasswordReset;
  final CompletePasswordReset completePasswordReset;
  final VerifyOtp verifyOtp;
  final Logout logout;

  AuthBloc({
    required this.requestLogin,
    required this.completeLogin,
    required this.requestSignup,
    required this.completeSignup,
    required this.requestPasswordReset,
    required this.completePasswordReset,
    required this.verifyOtp,
    required this.logout,
  }) : super(AuthInitial()) {
    on<RequestLoginEvent>(_onRequestLogin);
    on<CompleteLoginEvent>(_onCompleteLogin);
    on<RequestSignupEvent>(_onRequestSignup);
    on<CompleteSignupEvent>(_onCompleteSignup);
    on<RequestPasswordResetEvent>(_onRequestPasswordReset);
    on<CompletePasswordResetEvent>(_onCompletePasswordReset);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<LogoutEvent>(_onLogout);
  }

  void _onRequestLogin(RequestLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await requestLogin(RequestLoginParams(email: event.email));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (otpInfo) => emit(LoginOtpSent(otpInfo.transactionId, otpInfo.expiryTime)),
    );
  }

  void _onCompleteLogin(CompleteLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await completeLogin(CompleteLoginParams(transactionId: event.transactionId));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void _onRequestSignup(RequestSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await requestSignup(RequestSignupParams(email: event.email));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (otpInfo) => emit(SignupOtpSent(otpInfo.transactionId, otpInfo.expiryTime)),
    );
  }

  void _onCompleteSignup(CompleteSignupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await completeSignup(CompleteSignupParams(
      transactionId: event.transactionId,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
      dob: event.dob,
      gender: event.gender,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void _onRequestPasswordReset(RequestPasswordResetEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await requestPasswordReset(RequestPasswordResetParams(email: event.email));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (otpInfo) => emit(PasswordResetOtpSent(otpInfo.transactionId, otpInfo.expiryTime)),
    );
  }

  void _onCompletePasswordReset(CompletePasswordResetEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await completePasswordReset(CompletePasswordResetParams(
      transactionId: event.transactionId,
      newPassword: event.newPassword,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(PasswordResetComplete()),
    );
  }

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await verifyOtp(VerifyOtpParams(
      transactionId: event.transactionId,
      otp: event.otp,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(OtpVerified()),
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
}
