// lib/core/network/websocket_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:uuid/uuid.dart';
import 'package:stapes_home/core/error/exceptions.dart';

enum ConnectionState { connected, disconnected, error }

class WebSocketService {
  WebSocket? _socket;
  final Uri url = WebSocketRoutes.getWebSocketUrl();
  final UserSessionModel userSession;
  final Uuid _uuid = Uuid();
  bool _isConnected = false;
  Timer? _reconnectTimer;
  static const _reconnectInterval = Duration(seconds: 5);

  final StreamController<Map<String, dynamic>> _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<ConnectionState> _connectionStateController = StreamController<ConnectionState>.broadcast();

  WebSocketService({
    required this.userSession,
  });

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<ConnectionState> get connectionState => _connectionStateController.stream;
  bool get isConnected => _isConnected;

  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _socket = await WebSocket.connect(
        url.toString(),
        headers: {
          'X-User-Id': userSession.userId,
          'X-Session-Id': userSession.sessionId,
        },
      );

      _isConnected = true;
      _connectionStateController.add(ConnectionState.connected);
      _setupSocketListeners();
    } on WebSocketException catch (e) {
      _handleConnectionError(WebSocketConnectionException(e.message));
    } catch (e) {
      _handleConnectionError(UnexpectedException(e.toString()));
    }
  }

  void _setupSocketListeners() {
    _socket?.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDisconnection,
      cancelOnError: false,
    );
  }

  void _handleMessage(dynamic message) {
    try {
      if (message is! String) {
        throw WebSocketMessageException('Invalid message format');
      }

      final decodedMessage = json.decode(json.decode(message));
      if (decodedMessage is! Map<String, dynamic>) {
        throw WebSocketMessageException('Invalid message structure');
      }

      if (decodedMessage['command'] != 'control_device') {
        _messageController.add(decodedMessage);
      }
    } catch (e) {
      _handleError(WebSocketMessageException(e.toString()));
    }
  }

  void _handleError(dynamic error) {
    print('WebSocket Error: $error');
    _connectionStateController.add(ConnectionState.error);
  }

  void _handleDisconnection() {
    _isConnected = false;
    _connectionStateController.add(ConnectionState.disconnected);
    _scheduleReconnection();
  }

  void _handleConnectionError(AppException error) {
    print('Connection Error: ${error.message}');
    _connectionStateController.add(ConnectionState.error);
    _scheduleReconnection();
  }

  void _scheduleReconnection() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectInterval, connect);
  }

  void sendDeviceStateUpdate(String deviceId, bool state) {
    if (!_isConnected) {
      throw WebSocketConnectionException('Not connected to server');
    }

    final message = json.encode({
      'id': _uuid.v4(),
      'command': 'control_device',
      'entity_id': deviceId,
      'state': state,
    });

    _socket?.add(message);
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    await _socket?.close();
    await _messageController.close();
    await _connectionStateController.close();
    _isConnected = false;
  }
}
