// Path: lib/presentation/auth/bloc/otp_verification_state.dart
// Description: This file contains the state for the OTP verification feature.

import 'package:equatable/equatable.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object> get props => [];
}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {
  final String message;

  const OtpVerificationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class OtpVerificationError extends OtpVerificationState {
  final String message;

  const OtpVerificationError(this.message);

  @override
  List<Object> get props => [message];
}
