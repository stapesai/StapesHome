import 'package:equatable/equatable.dart';
import 'package:stapes_home/features/auth/data/models/user_model.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class RequestSignUpEvent extends SignUpEvent {
  final String email;

  const RequestSignUpEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyOtpEvent extends SignUpEvent {
  final String transactionId;
  final String otp;

  const VerifyOtpEvent({required this.transactionId, required this.otp});

  @override
  List<Object?> get props => [transactionId, otp];
}

class CreatePasswordEvent extends SignUpEvent {
  final String password;
  final String confirmPassword;

  const CreatePasswordEvent({required this.password, required this.confirmPassword});

  @override
  List<Object?> get props => [password, confirmPassword];
}

class SubmitUserDetailsEvent extends SignUpEvent {
  final String transactionId;
  final UserModel user;
  final String password;

  const SubmitUserDetailsEvent({required this.transactionId, required this.user, required this.password});

  @override
  List<Object?> get props => [transactionId, user, password];
}
