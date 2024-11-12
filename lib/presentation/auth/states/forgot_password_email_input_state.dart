// // Path: lib/presentation/auth/bloc/forgot_password_state.dart
// // Description: This file contains the state for the forgot password feature.

// import 'package:equatable/equatable.dart';

// abstract class ForgotPasswordState extends Equatable {
//   const ForgotPasswordState();

//   @override
//   List<Object> get props => [];
// }

// class ForgotPasswordInitial extends ForgotPasswordState {}

// class ForgotPasswordLoading extends ForgotPasswordState {}

// class ForgotPasswordOtpRequired extends ForgotPasswordState {
//   final String transactionId;
//   final String expiryTime;

//   const ForgotPasswordOtpRequired({
//     required this.transactionId,
//     required this.expiryTime,
//   });

//   @override
//   List<Object> get props => [transactionId, expiryTime];
// }

// class ForgotPasswordSuccess extends ForgotPasswordState {
//   final String message;

//   const ForgotPasswordSuccess(this.message);

//   @override
//   List<Object> get props => [message];
// }

// class ForgotPasswordError extends ForgotPasswordState {
//   final String message;

//   const ForgotPasswordError(this.message);

//   @override
//   List<Object> get props => [message];
// }
