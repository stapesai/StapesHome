// File: lib/core/error/failures.dart
// Description: This file contains the definition of various failure types that can occur in the application.

import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  /// Creates a new [Failure] instance
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

/// Represents a failure due to a server error
class ServerFailure extends Failure {
  /// Creates a new [ServerFailure] instance
  const ServerFailure();
}

/// Represents a failure due to a cache error
class CacheFailure extends Failure {
  /// Creates a new [CacheFailure] instance
  const CacheFailure();
}

/// Represents a failure due to a network error
class NetworkFailure extends Failure {
  /// Creates a new [NetworkFailure] instance
  const NetworkFailure();
}

/// Represents a failure due to invalid input or data
class ValidationFailure extends Failure {
  /// The error message associated with the validation failure
  final String message;

  /// Creates a new [ValidationFailure] instance
  const ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure due to authentication issues
class AuthenticationFailure extends Failure {
  /// Creates a new [AuthenticationFailure] instance
  const AuthenticationFailure();
}

/// Represents a failure due to unauthorized access
class UnauthorizedFailure extends Failure {
  /// Creates a new [UnauthorizedFailure] instance
  const UnauthorizedFailure();
}

/// Represents a failure due to a not found error
class NotFoundFailure extends Failure {
  /// Creates a new [NotFoundFailure] instance
  const NotFoundFailure();
}

/// Represents an unexpected failure
class UnexpectedFailure extends Failure {
  /// The error message associated with the unexpected failure
  final String message;

  /// Creates a new [UnexpectedFailure] instance
  const UnexpectedFailure(this.message);

  @override
  List<Object> get props => [message];
}
