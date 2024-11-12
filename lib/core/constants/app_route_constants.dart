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
  // Splash screen
  static final splash = _RouteConfig(
    routePath: '/',
    routeName: 'SplashPage',
  );

  // Login screen
  static final login = _RouteConfig(
    routePath: '/auth/login',
    routeName: 'LoginPage',
  );

  // Login Otp Verification screen
  static final loginOtpVerification = _RouteConfig(
    routePath: '/auth/login-otp-verification/:transactionId/:expiryTime',
    routeName: 'OtpVerificationPage',
  );
  static String getOtpVerificationPagePath(String transactionId, DateTime expiryTime) {
    return '/auth/login-otp-verification/$transactionId/${expiryTime.toIso8601String()}';
  }

  // Forgot password screen
  static final forgotPassword = _RouteConfig(
    routePath: '/auth/forgot-password',
    routeName: 'ForgotPasswordPage',
  );

  // Forgot Password Otp Verification screen
  static final forgotPasswordOtpVerification = _RouteConfig(
    routePath: '/auth/forgot-password-otp-verification/:transactionId/:expiryTime',
    routeName: 'OtpVerificationPage',
  );
  static String getForgotPasswordOtpVerificationPagePath(String email, String transactionId, DateTime expiryTime) {
    return '/auth/forgot-password-otp-verification/$email/$transactionId/${expiryTime.toIso8601String()}';
  }

  // Forgot Password Reset password screen
  static final forgotPasswordResetPassword = _RouteConfig(
    routePath: '/auth/forgot-password-reset-password/:email/:transactionId',
    routeName: 'ForgotPasswordResetPasswordPage',
  );
  static String getForgotPasswordResetPasswordPagePath(String email, String transactionId) {
    return '/auth/forgot-password-reset-password/$email/$transactionId';
  }

  // Development Page (temporary)
  static final devPage = _RouteConfig(
    routePath: '/dev',
    routeName: 'DevPage',
  );
}
