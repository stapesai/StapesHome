import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class RequestLoginEvent extends LoginEvent {
  final String email;
  final String password;

  const RequestLoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class CompleteLoginEvent extends LoginEvent {
  final String transactionId;

  const CompleteLoginEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}