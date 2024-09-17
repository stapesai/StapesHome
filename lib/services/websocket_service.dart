// File: services/websocket_service.dart
// Description: WebSocket service to connect to the server and send/receive messages.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';

class WebSocketService {
  WebSocket? _socket;
  final Uri _url;
  final String _userId;
  final String _sessionId;
  final Uuid _uuid = Uuid();

  final StreamController<Map<String, dynamic>> _messageController = StreamController<Map<String, dynamic>>.broadcast();

  WebSocketService(this._url, this._userId, this._sessionId);

  // Stream getter for the message stream
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  void connect() async {
    try {
      _socket = await WebSocket.connect(
        _url.toString(),
        headers: {
          'X-User-Id': _userId,
          'X-Session-Id': _sessionId,
        },
      );

      _socket!.listen(
        (message) {
          try {
            if (message is String) {
              // TODO: Fix this decoding logic later
              final decodedMessage = json.decode(json.decode(message));
              print('Received message: $decodedMessage');
              if (decodedMessage is Map<String, dynamic> && decodedMessage['command'] != 'control_device') {
                _messageController.add(decodedMessage);
                print('Message added to stream');
              } else {
                print('Error: Decoded message is not a Map<String, dynamic>');
              }
            } else {
              print('Error: WebSocket message is not a String');
            }
          } catch (e) {
            print('Error decoding message: $e');
          }
        },
        onError: (error) {
          print('WebSocket Error: $error');
          // Implement reconnection logic here
          // TODO: show a snackbar to the user that the connection is closed and try to reconnect
        },
        onDone: () {
          print('WebSocket connection closed');
          // Implement reconnection logic here
          // TODO: show a snackbar to the user that the connection is closed and try to reconnect
        },
      );
    } catch (e) {
      print('Failed to connect: $e');
      // Handle connection errors here
    }
  }

  void _sendMessage(String message) {
    if (_socket != null && _socket!.readyState == WebSocket.open) {
      print('Sending message: $message');
      _socket!.add(message);
    }
  }

  void deviceStateUpdate(String deviceId, bool state) {
    final message = json.encode({
      'id': _uuid.v4(),
      'command': 'control_device',
      'entity_id': deviceId,
      'state': state,
    });
    _sendMessage(message);
  }

  void close() {
    _socket?.close();
    _messageController.close();
  }
}
