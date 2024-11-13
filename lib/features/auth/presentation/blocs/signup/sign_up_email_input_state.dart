import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpOtpRequired extends SignUpState {
  final String transactionId;
  final DateTime expiryTime;
  final String email;

  const SignUpOtpRequired({
    required this.transactionId,
    required this.expiryTime,
    required this.email,
  });

  @override
  List<Object?> get props => [transactionId, expiryTime, email];
}

class SignUpOtpVerified extends SignUpState {
  final String transactionId;

  const SignUpOtpVerified({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class SignUpPasswordCreated extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError({required this.message});

  @override
  List<Object?> get props => [message];
}
