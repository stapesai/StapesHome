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
        return 'auth.stapesai.in';
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get backendBaseUrl {
    switch (Config.environment) {
      case Environment.development:
        return '192.168.0.253:8001';
      case Environment.production:
        return 'backend.stapesai.in';
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get protocol {
    switch (Config.environment) {
      case Environment.development:
        return 'http';
      case Environment.production:
        return 'https';
      default:
        throw UnsupportedError('Environment not supported');
    }
  }

  static String get webSocketUrl {
    switch (Config.environment) {
      case Environment.development:
        return 'ws://192.168.0.253:8002/ws';
      case Environment.production:
        throw UnsupportedError('WebSocket not supported in production');
      default:
        throw UnsupportedError('Environment not supported');
    }
  }
}

/// Defines all authentication-related API routes
class AuthRoutes {
  static final String baseUrl = BaseUrls.authBaseUrl;

  // Signup
  static final Uri requestSignup = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/signup/request-signup');
  static final Uri completeSignup = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/signup/complete-signup');

  // Login
  static final Uri requestLogin = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/login/request-login');
  static final Uri completeLogin = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/login/complete-login');

  // Reset Password
  static final Uri requestResetPassword =
      Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/reset-password/request-reset');
  static final Uri completeResetPassword =
      Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/reset-password/complete-reset');

  // OTP
  static final Uri verifyOtp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/otp/verify');
  static final Uri resendOtp = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/otp/resend');

  // Logout
  static final Uri logoutUser = Uri.parse('${BaseUrls.protocol}://$baseUrl/auth/logout');

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
  static final Uri createNode = Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes');
  static Uri getNodesByRoomId(String roomId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$roomId');
  static Uri updateNode(String nodeId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$nodeId');
  static Uri deleteNode(String nodeId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/nodes/$nodeId');

  // Entity routes
  static final Uri createEntity = Uri.parse('${BaseUrls.protocol}://$baseUrl/entities');
  static final Uri getAllEntities = Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/all');
  static Uri getEntitiesByNodeId(String nodeId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/by_node_id/$nodeId');
  static Uri getEntitiesByRoomId(String roomId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/by_room_id/$roomId');
  static Uri updateEntity(String entityId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/$entityId');
  static Uri deleteEntity(String entityId) => Uri.parse('${BaseUrls.protocol}://$baseUrl/entities/$entityId');

  // MQTT routes
  static final Uri mqttInfo = Uri.parse('${BaseUrls.protocol}://$baseUrl/mqtt/info');

  // Favorite Device routes
  static final Uri addFavoriteDevice = Uri.parse('${BaseUrls.protocol}://$baseUrl/favdev');
  static final Uri getFavoriteDevices = Uri.parse('${BaseUrls.protocol}://$baseUrl/favdev');
  static Uri removeFavoriteDevice(String favoriteDeviceId) =>
      Uri.parse('${BaseUrls.protocol}://$baseUrl/favdev/$favoriteDeviceId');
}

/// Defines WebSocket-related routes
class WebSocketRoutes {
  static Uri getWebSocketUrl() => Uri.parse(BaseUrls.webSocketUrl);
}
