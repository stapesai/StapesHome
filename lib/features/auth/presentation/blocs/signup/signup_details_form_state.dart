import 'package:equatable/equatable.dart';

abstract class SignUpDetailsFormState extends Equatable {
  const SignUpDetailsFormState();

  @override
  List<Object?> get props => [];
}

class SignUpDetailsFormInitial extends SignUpDetailsFormState {}

class SignUpDetailsFormLoading extends SignUpDetailsFormState {}

class SignUpDetailsFormSuccess extends SignUpDetailsFormState {}

class SignUpDetailsFormError extends SignUpDetailsFormState {
  final String message;

  const SignUpDetailsFormError({required this.message});

  @override
  List<Object?> get props => [message];
}
