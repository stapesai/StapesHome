// File: lib/core/error/exceptions.dart
// Description: This file contains custom exception classes used throughout the application for specific error scenarios.

/// Base class for custom exceptions in the application
abstract class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when a network request fails due to server error
class ServerException extends AppException {
  ServerException([super.message = 'An error occurred on the server']);
}

/// Exception thrown when a network request fails due to connection issues
class NetworkException extends AppException {
  NetworkException([super.message = 'A network error occurred']);
}

/// Exception thrown when a cache operation fails
class CacheException extends AppException {
  CacheException([super.message = 'A cache error occurred']);
}

/// Exception thrown when authentication fails
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Authentication failed']);
}

/// Exception thrown when a requested resource is not found
class NotFoundException extends AppException {
  NotFoundException([super.message = 'The requested resource was not found']);
}

/// Exception thrown when user input is invalid
class ValidationException extends AppException {
  ValidationException([super.message = 'Invalid input']);
}

/// Exception thrown when an operation times out
class TimeoutException extends AppException {
  TimeoutException([super.message = 'The operation timed out']);
}

/// Exception thrown when an unexpected error occurs
class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'An unexpected error occurred']);
}
