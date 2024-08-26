class AuthRoutes {
  // Base URL
  static const String baseUrl = 'auth.jarvishome.in';

  // Signup
  static final Uri requestSignup = Uri.https(baseUrl, '/auth/signup/request-signup');
  static final Uri completeSignup = Uri.https(baseUrl, '/auth/signup/complete-signup');

  // Login
  static final Uri requestLogin = Uri.https(baseUrl, '/auth/login/request-login');
  static final Uri completeLogin = Uri.https(baseUrl, '/auth/login/complete-login');

  // Reset Password
  static final Uri requestResetPassword = Uri.https(baseUrl, '/auth/reset-password/request-reset');
  static final Uri completeResetPassword = Uri.https(baseUrl, '/auth/reset-password/complete-reset');

  // Verify OTP
  static final Uri verifyOtp = Uri.https(baseUrl, '/auth/verify_otp');

  // Logout
  static final Uri logoutUser = Uri.https(baseUrl, '/auth/logout');

  // Session Management
  static final Uri getCurrentSession = Uri.https(baseUrl, '/sessions/current');
  static final Uri getAllSessions = Uri.https(baseUrl, '/sessions/all');
  static final Uri revokeSession = Uri.https(baseUrl, '/sessions/revoke');

  // Signup Checks
  static Uri checkEmail(String email) {
    return Uri.https(baseUrl, '/check/email', {'email': email});
  }

  static Uri checkPassword(String password) {
    return Uri.https(baseUrl, '/check/password', {'password': password});
  }
}


class ApiRoutes{
  static const String baseUrl = 'backend.jarvishome.in';
}