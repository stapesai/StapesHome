import 'package:equatable/equatable.dart';
import 'package:stapes_home/features/auth/data/models/user_model.dart';

abstract class SignUpDetailsFormEvent extends Equatable {
  const SignUpDetailsFormEvent();

  @override
  List<Object?> get props => [];
}

class SignUpDetailsSubmitted extends SignUpDetailsFormEvent {
  final String transactionId;
  final UserModel user;
  final String password;

  const SignUpDetailsSubmitted({
    required this.transactionId,
    required this.user,
    required this.password,
  });

  @override
  List<Object?> get props => [transactionId, user, password];
}
