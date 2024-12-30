// File: lib/core/constants/api_routes.dart
// Description: This file contains all the API route definitions used in the application.

import 'package:stapes_home/core/config/config.dart';

/// Defines the base URLs for different environments
class BaseUrls {
  static String get authBaseUrl {
    switch (Config.environment) {
      case Environment.development:
        return '192.168.0.253:8000';
      case Environment.production:
        return 'auth.stapesai.com';
    }
  }

  static String get backendBaseUrl {
    switch (Config.environment) {
      case Environment.development:
        return '192.168.0.253:8001';
      case Environment.production:
        return 'backend.stapesai.com';
    }
  }

  static String get protocol {
    switch (Config.environment) {
      case Environment.development:
        return 'http';
      case Environment.production:
        return 'https';
    }
  }

  static String get webSocketUrl {
    switch (Config.environment) {
      case Environment.development:
        return 'ws://192.168.0.253:8002/ws';
      case Environment.production:
        return 'wss://ws.stapesai.com/ws';
    }
  }
}

/// Defines all authentication-related API routes
class AuthRoutes {
  static final String baseUrl = BaseUrls.authBaseUrl;

  // Signup
  static final Uri requestSignUp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/signup/request-signup');
  static final Uri completeSignUp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/signup/complete-signup');

  // Login
  static final Uri requestLogin = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/login/request-login');
  static final Uri completeLogin = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/login/complete-login');

  // Reset Password
  static final Uri requestPasswordReset =
      Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/reset-password/request-reset');
  static final Uri completePasswordReset =
      Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/reset-password/complete-reset');

  // OTP
  static final Uri verifyOtp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/otp/verify');
  static final Uri resendOtp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/otp/resend');

  // Logout
  static final Uri logoutUser = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/logout');

  // FCM Token
  static final Uri updateFCMToken = Uri.parse('${BaseUrls.protocol}://$baseUrl/update-fcm-token');

  // Session Management
  static final Uri getCurrentSession = Uri.parse('${BaseUrls.protocol}://$baseUrl/sessions/current');
  static final Uri getAllSessions = Uri.parse('${BaseUrls.protocol}://$baseUrl/sessions/all');
  static final Uri revokeSession = Uri.parse('${BaseUrls.protocol}://$baseUrl/sessions/revoke');

  // Signup Checks
  static Uri checkEmail(String email) => Uri.parse('${BaseUrls.protocol}://$baseUrl/check/email?email=$email');
  static Uri checkPassword(String password) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/check/password?password=$password');
}

/// Defines all backend-related API routes
class BackendRoutes {
  static final String baseUrl = BaseUrls.backendBaseUrl;

  // Floor routes
  static final Uri createFloor = Uri.parse('${BaseUrls.protocol}://$baseUrl/floors');
  static final Uri getFloors = Uri.parse('${BaseUrls.protocol}://$baseUrl/floors');
  static Uri updateFloor(String floorId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/floors/$floorId');
  static Uri deleteFloor(String floorId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/floors/$floorId');

  // Room routes
  static final Uri createRoom = Uri.parse('${BaseUrls.protocol}://$baseUrl/rooms');
  static Uri getRoomsByFloorId(String floorId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/rooms/$floorId');
  static Uri updateRoom(String roomId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/rooms/$roomId');
  static Uri deleteRoom(String roomId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/rooms/$roomId');

  // Node routes
  static final Uri requestNodePairing = Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/request-pairing');
  static final Uri completeNodePairing = Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/complete-pairing');
  static Uri getNodesByRoomId(String roomId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$roomId');
  static Uri updateNode(String nodeId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$nodeId');
  static Uri deleteNode(String nodeId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$nodeId');

  // Entity routes
  static final Uri createEntity = Uri.parse('${BaseUrls.protocol}://$baseUrl/entities');
  static final Uri getAllDevices = Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/all');
  static Uri getDevicesByNodeId(String nodeId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/by_node_id/$nodeId');
  static Uri getDevicesByRoomId(String roomId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/by_room_id/$roomId');
  static Uri updateEntity(String entityId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/$entityId');
  static Uri deleteEntity(String entityId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/$entityId');

  // MQTT routes
  static final Uri mqttInfo = Uri.parse('${BaseUrls.protocol}://$baseUrl/mqtt/info');

  // Favorite Device routes
  static final Uri addFavouriteDevice = Uri.parse('${BaseUrls.protocol}://$baseUrl/fav_devices');
  static final Uri getFavouriteDevices = Uri.parse('${BaseUrls.protocol}://$baseUrl/fav_devices');
  static Uri removeFavouriteDevice(String favoriteDeviceId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/fav_devices/$favoriteDeviceId');
}

/// Defines Websocket-related routes
class WebsocketRoutes {
  static Uri getWebsocketUrl() => Uri.parse(BaseUrls.webSocketUrl);
}
