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
    routePath: '/',
    routeName: 'SplashPage',
  );
  static final login = _RouteConfig(
    routePath: '/auth/login',
    routeName: 'LoginPage',
  );
  static final otpVerification = _RouteConfig(
    routePath: '/auth/otp-verification/:transactionId/:expiryTime',
    routeName: 'OtpVerificationPage',
  );
}
