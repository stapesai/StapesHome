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


class BackendRoutes {
  static const String baseUrl = 'backend.jarvishome.in';

  // Floor routes
  static final Uri createFloor = Uri.https(baseUrl, '/floors');
  static final Uri getFloors = Uri.https(baseUrl, '/floors');
  static Uri updateFloor(String floorId) => Uri.https(baseUrl, '/floors/$floorId');
  static Uri deleteFloor(String floorId) => Uri.https(baseUrl, '/floors/$floorId');

  // Room routes
  static final Uri createRoom = Uri.https(baseUrl, '/rooms');
  static Uri getRoomsByFloorId(String floorId) => Uri.https(baseUrl, '/rooms/$floorId');
  static Uri updateRoom(String roomId) => Uri.https(baseUrl, '/rooms/$roomId');
  static Uri deleteRoom(String roomId) => Uri.https(baseUrl, '/rooms/$roomId');

  // Node routes
  static final Uri createNode = Uri.https(baseUrl, '/nodes');
  static Uri getNodesByRoomId(String roomId) => Uri.https(baseUrl, '/nodes/$roomId');
  static Uri updateNode(String nodeId) => Uri.https(baseUrl, '/nodes/$nodeId');
  static Uri deleteNode(String nodeId) => Uri.https(baseUrl, '/nodes/$nodeId');

  // Entity routes
  static final Uri createEntity = Uri.https(baseUrl, '/entities');
  static final Uri getAllEntities = Uri.https(baseUrl, '/entities/all');
  static Uri getEntitiesByNodeId(String nodeId) => Uri.https(baseUrl, '/entities/$nodeId');
  static Uri updateEntity(String entityId) => Uri.https(baseUrl, '/entities/$entityId');
  static Uri deleteEntity(String entityId) => Uri.https(baseUrl, '/entities/$entityId');

  // MQTT routes
  static final Uri mqttInfo = Uri.https(baseUrl, '/mqtt/info');

  // Favorite Device routes
  static final Uri addFavoriteDevice = Uri.https(baseUrl, '/favdev');
  static final Uri getFavoriteDevices = Uri.https(baseUrl, '/favdev');
  static Uri removeFavoriteDevice(String favoriteDeviceId) => Uri.https(baseUrl, '/favdev/$favoriteDeviceId');
}
