// File: lib/core/config/config.dart
// Description: This file contains application-wide configuration settings and constants.

/// Defines the possible environments for the application
enum Environment { development, production }

/// Provides configuration settings for the application
class Config {
  /// The current environment of the application
  // Works in development when server (devel-container)is working and connected to twingate.
  // Works in production every time but websockets are not forwarded yet.
  static const Environment environment = Environment.production;

  /// The current version of the application
  static const String appVersion = '1.0.0';

  /// The maximum number of retry attempts for network requests
  static const int maxRetryAttempts = 3;

  /// The timeout duration for network requests in seconds
  static const int networkTimeoutSeconds = 30;

  /// Delay between retry attempts in milliseconds
  static const int retryDelayMilliseconds = 1000;

  /// Websocket reconnection interval in seconds
  static const int websocketReconnectInterval = 5;

  /// Returns whether detailed logging is enabled based on the current environment
  static bool get enableDetailedLogs {
    switch (environment) {
      case Environment.development:
        return true;
      case Environment.production:
        return false;
    }
  }
}
