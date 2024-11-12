import 'package:equatable/equatable.dart';

abstract class OtpVerificationState extends Equatable {
  const OtpVerificationState();

  @override
  List<Object?> get props => [];
}

class OtpVerificationInitial extends OtpVerificationState {}

class OtpVerificationLoading extends OtpVerificationState {}

class OtpVerificationSuccess extends OtpVerificationState {
  final String transactionId;
  final String email;

  const OtpVerificationSuccess({
    required this.transactionId,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, email];
}

class OtpVerificationError extends OtpVerificationState {
  final String message;

  const OtpVerificationError({required this.message});

  @override
  List<Object?> get props => [message];
}
