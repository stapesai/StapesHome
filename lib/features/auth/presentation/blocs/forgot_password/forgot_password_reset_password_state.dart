import 'package:equatable/equatable.dart';

abstract class ForgotPasswordResetPasswordState extends Equatable {
  const ForgotPasswordResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordResetPasswordInitial extends ForgotPasswordResetPasswordState {}

class ForgotPasswordResetPasswordLoading extends ForgotPasswordResetPasswordState {}

class ForgotPasswordResetPasswordSuccess extends ForgotPasswordResetPasswordState {
  final String message;

  const ForgotPasswordResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ForgotPasswordResetPasswordError extends ForgotPasswordResetPasswordState {
  final String message;

  const ForgotPasswordResetPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
