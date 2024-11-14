import 'package:equatable/equatable.dart';

abstract class SignUpEmailInputEvent extends Equatable {
  const SignUpEmailInputEvent();

  @override
  List<Object?> get props => [];
}

//
class RequestSignUpEvent extends SignUpEmailInputEvent {
  final String email;

  const RequestSignUpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}
