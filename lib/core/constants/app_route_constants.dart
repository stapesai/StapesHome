// Path: lib/core/constants/app_route_constants.dart
// Description: This file contains the route constants for the application. We'll use these constants to navigate between screens.

class _RouteConfig {
  final String routePath;
  final String routeName;

  const _RouteConfig({
    required this.routePath,
    required this.routeName,
  });
}

class AppRouteConstants {
  static final splash = _RouteConfig(
    // Splash screen
    routePath: '/',
    routeName: 'SplashPage',
  );

  // Login screen
  static final login = _RouteConfig(
    routePath: '/auth/login',
    routeName: 'LoginPage',
  );

  // Otp verification screen
  static final otpVerification = _RouteConfig(
    routePath: '/auth/otp-verification/:transactionId/:expiryTime',
    routeName: 'OtpVerificationPage',
  );
  static String getOtpVerificationPagePath(String transactionId, DateTime expiryTime) {
    return '/auth/otp-verification/$transactionId/${expiryTime.toIso8601String()}';
  }

  // Forgot password screen
  static final forgotPassword = _RouteConfig(
    routePath: '/auth/forgot-password',
    routeName: 'ForgotPasswordPage',
  );

  // Create password screen
  static final createPassword = _RouteConfig(
    routePath: '/auth/create-password/:title/:subtitle/:email/:transactionId',
    routeName: 'CreatePasswordPage',
  );
  static String getCreatePasswordPagePath(String title, String subtitle, String email, String transactionId) {
    return '/auth/create-password/$title/$subtitle/$email/$transactionId';
  }

  // Development Page (temporary)
  static final devPage = _RouteConfig(
    routePath: '/dev',
    routeName: 'DevPage',
  );
}
