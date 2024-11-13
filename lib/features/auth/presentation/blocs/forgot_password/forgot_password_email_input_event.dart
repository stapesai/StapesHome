import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEmailInputEvent extends Equatable {
  const ForgotPasswordEmailInputEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordEmailSubmitted extends ForgotPasswordEmailInputEvent {
  final String email;

  const ForgotPasswordEmailSubmitted({required this.email});

  @override
  List<Object?> get props => [email];
}
