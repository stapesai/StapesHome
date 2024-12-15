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
// class CacheException extends AppException {
//   CacheException([super.message = 'A cache error occurred']);
// }

/// Exception thrown when authentication fails
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = 'Unauthorized access']);
}

/// Exception thrown when user input is invalid
class ValidationException extends AppException {
  ValidationException([super.message = 'Input validation failed']);
}

/// Exception thrown when a requested resource is not found
class NotFoundException extends AppException {
  NotFoundException([super.message = 'Requested resource not found']);
}

/// Exception thrown when an operation times out
class TimeoutException extends AppException {
  TimeoutException([super.message = 'Request timeout']);
}

/// Exception thrown when an unexpected error occurs
class UnexpectedException extends AppException {
  UnexpectedException([super.message = 'An unexpected error occurred']);
}

class WebsocketConnectionException extends AppException {
  WebsocketConnectionException([super.message = 'Failed to connect to Websocket server']);
}

class WebsocketMessageException extends AppException {
  WebsocketMessageException([super.message = 'Failed to process Websocket message']);
}

class SQLiteException extends AppException {
  SQLiteException([super.message = 'A database error occurred']);
}

// class NoInternetException extends AppException {
//   NoInternetException([super.message = 'No internet connection']);
// }

class PlatformException extends AppException {
  PlatformException([super.message = 'Platform error']);
}
