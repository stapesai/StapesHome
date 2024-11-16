import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:stapes_home/core/config/config.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/models/user_session_model.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/service_locator.dart';
import 'package:uuid/uuid.dart';
import 'package:stapes_home/core/error/exceptions.dart';

enum WebsocketConnectionState { connected, disconnected, error }

class WebsocketService {
  // Socket connection
  Websocket? _socket;
  // URL of the Websocket server
  final Uri url = WebsocketRoutes.getWebsocketUrl();
  // User session (can be null), fetched from the local data source later
  late UserSessionModel? _userSession;
  // Used to generate unique message IDs
  final Uuid _uuid = Uuid();
  // Reconnection timer, used to reconnect to the server after disconnection
  Timer? _reconnectTimer;

  // final StreamController<Map<String, dynamic>> _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _messageController = StreamController<String>.broadcast();
  final StreamController<WebsocketConnectionState> _connectionStateController =
      StreamController<WebsocketConnectionState>.broadcast();

  // Getters for the streams
  // Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<String> get messageStream => _messageController.stream;
  Stream<WebsocketConnectionState> get connectionState => _connectionStateController.stream;

  bool get isConnected =>
      _connectionStateController.hasListener &&
      _connectionStateController.stream.last == WebsocketConnectionState.connected;

  WebsocketService();

  Future<void> connect() async {
    if (isConnected) {
      print('Already connected to Websocket server');
      return;
    }

    try {
      // Fetch the user session from the local data source
      _userSession = await serviceLocator<AuthLocalDataSource>().getUserSession();
      if (_userSession == null) {
        throw WebsocketConnectionException('No user session available');
      }

      // Connect to the Websocket server
      print('Connecting to Websocket server at ${url.toString()}');
      print('User ID: ${_userSession!.userId}');
      print('Session ID: ${_userSession!.sessionId}');
      _socket = await Websocket.connect(
        url.toString(),
        headers: {
          'X-User-Id': _userSession!.userId,
          'X-Session-Id': _userSession!.userId,
        },
      );
      _connectionStateController.add(WebsocketConnectionState.connected);
      _setupSocketListeners();
    } on WebsocketException catch (e) {
      _handleConnectionError(WebsocketConnectionException(e.message));
    } catch (e) {
      _handleConnectionError(UnexpectedException(e.toString()));
    }
  }

  void _handleMessage(dynamic message) {
    try {
      // print(message);
      _messageController.add(message);
      // if (message is! String) {
      //   throw WebsocketMessageException('Invalid message format');
      // }

      // final decodedMessage = json.decode(json.decode(message));
      // if (decodedMessage is! Map<String, dynamic>) {
      //   throw WebsocketMessageException('Invalid message structure');
      // }

      // if (decodedMessage['command'] != 'control_device') {
      //   _messageController.add(decodedMessage);
      // }
    } catch (e) {
      _handleError(WebsocketMessageException(e.toString()));
    }
  }

  // void sendDeviceStateUpdate(String deviceId, bool state) {
  //   if (!isConnected) {
  //     throw WebsocketConnectionException('Not connected to server');
  //   }

  //   final message = json.encode({
  //     'id': _uuid.v4(),
  //     'command': 'control_device',
  //     'entity_id': deviceId,
  //     'state': state,
  //   });

  //   _socket?.add(message);
  // }

  void _setupSocketListeners() {
    _socket?.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDisconnection,
      cancelOnError: false,
    );
  }

  void _handleError(dynamic error) {
    print('Websocket Error: $error');
    _connectionStateController.add(WebsocketConnectionState.error);
  }

  void _handleDisconnection() {
    print('Disconnected from Websocket server');
    _connectionStateController.add(WebsocketConnectionState.disconnected);
    _scheduleReconnection();
  }

  void _handleConnectionError(AppException error) {
    print('Connection Error: ${error.message}');
    _connectionStateController.add(WebsocketConnectionState.error);
    _scheduleReconnection();
  }

  void _scheduleReconnection() {
    print('Reconnecting in ${Config.websocketReconnectInterval} seconds');
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: Config.websocketReconnectInterval), connect);
  }

  Future<void> disconnect() async {
    print('Disconnecting from Websocket server');
    _reconnectTimer?.cancel();
    await _socket?.close();
    await _messageController.close();
    await _connectionStateController.close();
  }
}
