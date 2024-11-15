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

  static final loginOtpVerification = _RouteConfig(
    routePath: '/auth/login-otp-verification/:email/:transactionId/:expiryTime',
    routeName: 'LoginOtpVerificationPage',
  );
  static String getLoginOtpVerificationPagePath({
    required String email,
    required String transactionId,
    required DateTime expiryTime,
  }) {
    return '/auth/login-otp-verification/$email/$transactionId/${expiryTime.toIso8601String()}';
  }

  static final signUpEmailInput = _RouteConfig(
    routePath: '/auth/signup',
    routeName: 'SignUpEmailInputPage',
  );

  static final signUpOtpVerification = _RouteConfig(
    routePath: '/auth/signup-otp-verification/:email/:transactionId/:expiryTime',
    routeName: 'SignUpOtpVerificationPage',
  );
  static String getSignUpOtpVerificationPagePath({
    required String email,
    required String transactionId,
    required DateTime expiryTime,
  }) {
    return '/auth/signup-otp-verification/$email/$transactionId/${expiryTime.toIso8601String()}';
  }

  static final signUpCreatePassword = _RouteConfig(
    routePath: '/auth/signup-create-password/:email/:transactionId',
    routeName: 'SignUpCreatePasswordPage',
  );
  static String getSignUpCreatePasswordPagePath({
    required String email,
    required String transactionId,
  }) {
    return '/auth/signup-create-password/$email/$transactionId';
  }

  static final signUpDetailsForm = _RouteConfig(
    routePath: '/auth/signup-details-form/:email/:transactionId/:password',
    routeName: 'SignUpDetailsFormPage',
  );
  static String getSignUpDetailsFormPagePath({
    required String email,
    required String transactionId,
    required String password,
  }) {
    return '/auth/signup-details-form/$email/$transactionId/$password';
  }

  static final forgotPassword = _RouteConfig(
    routePath: '/auth/forgot-password',
    routeName: 'ForgotPasswordPage',
  );

  static final forgotPasswordOtpVerification = _RouteConfig(
    routePath: '/auth/forgot-password-otp-verification/:email/:transactionId/:expiryTime',
    routeName: 'ForgotPasswordOtpVerificationPage',
  );
  static String getForgotPasswordOtpVerificationPagePath({
    required String email,
    required String transactionId,
    required DateTime expiryTime,
  }) {
    return '/auth/forgot-password-otp-verification/$email/$transactionId/${expiryTime.toIso8601String()}';
  }

  static final forgotPasswordResetPassword = _RouteConfig(
    routePath: '/auth/forgot-password-reset-password/:email/:transactionId',
    routeName: 'ForgotPasswordResetPasswordPage',
  );
  static String getForgotPasswordResetPasswordPagePath({
    required String email,
    required String transactionId,
  }) {
    return '/auth/forgot-password-reset-password/$email/$transactionId';
  }

  static final home = _RouteConfig(
    routePath: '/home',
    routeName: 'HomePage',
  );

  static final nodes = _RouteConfig(
    routePath: '/nodes',
    routeName: 'NodesPage',
  );

  static final devices = _RouteConfig(
    routePath: '/devices',
    routeName: 'DevicesPage',
  );

  static final settings = _RouteConfig(
    routePath: '/settings',
    routeName: 'SettingsPage',
  );

  static final devPageUserDetailsShow = _RouteConfig(
    routePath: '/dev-user-details-show',
    routeName: 'DevPage-UserDetailsShow',
  );

  static final devPageTest = _RouteConfig(
    routePath: '/dev-test/:text',
    routeName: 'DevPage-Test',
  );
  static String getDevPageTestPath({
    required String text,
  }) {
    return '/dev-test/$text';
  }
}
