import 'config.dart';

class AuthRoutes {
  static final String baseUrl = Config.authBaseUrl;

  // Signup
  static final Uri requestSignup = Uri.parse('${Config.protocol}://$baseUrl/auth/signup/request-signup');
  static final Uri completeSignup = Uri.parse('${Config.protocol}://$baseUrl/auth/signup/complete-signup');

  // Login
  static final Uri requestLogin = Uri.parse('${Config.protocol}://$baseUrl/auth/login/request-login');
  static final Uri completeLogin = Uri.parse('${Config.protocol}://$baseUrl/auth/login/complete-login');

  // Reset Password
  static final Uri requestResetPassword = Uri.parse('${Config.protocol}://$baseUrl/auth/reset-password/request-reset');
  static final Uri completeResetPassword = Uri.parse('${Config.protocol}://$baseUrl/auth/reset-password/complete-reset');

  // Verify OTP
  static final Uri verifyOtp = Uri.parse('${Config.protocol}://$baseUrl/auth/verify_otp');

  // Logout
  static final Uri logoutUser = Uri.parse('${Config.protocol}://$baseUrl/auth/logout');

  // Session Management
  static final Uri getCurrentSession = Uri.parse('${Config.protocol}://$baseUrl/sessions/current');
  static final Uri getAllSessions = Uri.parse('${Config.protocol}://$baseUrl/sessions/all');
  static final Uri revokeSession = Uri.parse('${Config.protocol}://$baseUrl/sessions/revoke');

  // Signup Checks
  static Uri checkEmail(String email) {
    return Uri.parse('${Config.protocol}://$baseUrl/check/email?email=$email');
  }

  static Uri checkPassword(String password) {
    return Uri.parse('${Config.protocol}://$baseUrl/check/password?password=$password');
  }
}

class BackendRoutes {
  static final String baseUrl = Config.backendBaseUrl;

  // Floor routes
  static final Uri createFloor = Uri.parse('${Config.protocol}://$baseUrl/floors');
  static final Uri getFloors = Uri.parse('${Config.protocol}://$baseUrl/floors');
  static Uri updateFloor(String floorId) => Uri.parse('${Config.protocol}://$baseUrl/floors/$floorId');
  static Uri deleteFloor(String floorId) => Uri.parse('${Config.protocol}://$baseUrl/floors/$floorId');

  // Room routes
  static final Uri createRoom = Uri.parse('${Config.protocol}://$baseUrl/rooms');
  static Uri getRoomsByFloorId(String floorId) => Uri.parse('${Config.protocol}://$baseUrl/rooms/$floorId');
  static Uri updateRoom(String roomId) => Uri.parse('${Config.protocol}://$baseUrl/rooms/$roomId');
  static Uri deleteRoom(String roomId) => Uri.parse('${Config.protocol}://$baseUrl/rooms/$roomId');

  // Node routes
  static final Uri createNode = Uri.parse('${Config.protocol}://$baseUrl/nodes');
  static Uri getNodesByRoomId(String roomId) => Uri.parse('${Config.protocol}://$baseUrl/nodes/$roomId');
  static Uri updateNode(String nodeId) => Uri.parse('${Config.protocol}://$baseUrl/nodes/$nodeId');
  static Uri deleteNode(String nodeId) => Uri.parse('${Config.protocol}://$baseUrl/nodes/$nodeId');

  // Entity routes
  static final Uri createEntity = Uri.parse('${Config.protocol}://$baseUrl/entities');
  static final Uri getAllEntities = Uri.parse('${Config.protocol}://$baseUrl/entities/all');
  static Uri getEntitiesByNodeId(String nodeId) => Uri.parse('${Config.protocol}://$baseUrl/entities/by_node_id/$nodeId');
  static Uri getEntitiesByRoomId(String roomId) => Uri.parse('${Config.protocol}://$baseUrl/entities/by_room_id/$roomId');
  static Uri updateEntity(String entityId) => Uri.parse('${Config.protocol}://$baseUrl/entities/$entityId');
  static Uri deleteEntity(String entityId) => Uri.parse('${Config.protocol}://$baseUrl/entities/$entityId');

  // MQTT routes
  static final Uri mqttInfo = Uri.parse('${Config.protocol}://$baseUrl/mqtt/info');

  // Favorite Device routes
  static final Uri addFavoriteDevice = Uri.parse('${Config.protocol}://$baseUrl/favdev');
  static final Uri getFavoriteDevices = Uri.parse('${Config.protocol}://$baseUrl/favdev');
  static Uri removeFavoriteDevice(String favoriteDeviceId) => Uri.parse('${Config.protocol}://$baseUrl/favdev/$favoriteDeviceId');
}
