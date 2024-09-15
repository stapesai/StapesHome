// Path: constants/config.dart

enum Environment { development, production }

class Config {
  static const Environment environment = Environment.production;

  // Base URLs for different services
  static String get authBaseUrl {
    switch (environment) {
      case Environment.development:
        return '192.168.0.253:8000'; // Dev Auth base URL
      case Environment.production:
        return 'auth.jarvishome.in'; // Prod Auth base URL
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get backendBaseUrl {
    switch (environment) {
      case Environment.development:
        return '192.168.0.253:8001'; // Dev Backend base URL
      case Environment.production:
        return 'backend.jarvishome.in'; // Prod Backend base URL
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get protocol {
    switch (environment) {
      case Environment.development:
        return 'http';
      case Environment.production:
        return 'https';
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get webSocketUrl {
    switch (environment) {
      case Environment.development:
        return 'ws://192.168.0.253:8003/ws'; // Dev WebSocket URL
      case Environment.production:
        // return 'wss://backend.jarvishome.in/ws'; // Prod WebSocket URL
        throw UnsupportedError('WebSocket not supported in production');
      default:
        throw UnsupportedError('Environment not supported');
    }
  }
}
