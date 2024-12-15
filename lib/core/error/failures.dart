import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure due to a server error
class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message);
}

/// Represents a failure due to a network error
class NetworkFailure extends Failure {
  const NetworkFailure({required message}) : super(message);
}

/// Represents a failure due to a cache error
// class CacheFailure extends Failure {
//   const CacheFailure({required message}) : super(message);
// }

/// Represents a failure due to invalid input or data
class ValidationFailure extends Failure {
  const ValidationFailure({required message}) : super(message);
}

/// Represents a failure due to authentication issues
// class AuthenticationFailure extends Failure {
//   const AuthenticationFailure({required message}) : super(message);
// }

/// Represents a failure due to unauthorized access
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required message}) : super(message);
}

/// Represents a failure due to a not found error
class NotFoundFailure extends Failure {
  const NotFoundFailure({required message}) : super(message);
}

/// Represents a failure due to a timeout error
class TimeoutFailure extends Failure {
  const TimeoutFailure({required message}) : super(message);
}

/// Represents an unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required message}) : super(message);
}

/// No websocket related failures are required yet.

/// Represents a sqlite database failure
class SQLiteFailure extends Failure {
  const SQLiteFailure({required message}) : super(message);
}
