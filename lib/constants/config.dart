// config.dart

enum Environment { development, production }

class Config {
  static const Environment environment = Environment.development;

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
}
