import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';
import 'package:stapes_home/core/websocket/websocket_service.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  final WebSocketService _webSocketService;
  StreamSubscription<dynamic>? _messageSubscription;

  WebsocketBloc(this._webSocketService) : super(WebsocketInitial()) {
    on<ConnectWebsocket>(_onConnect);
    on<DisconnectWebsocket>(_onDisconnect);
    on<WebsocketMessageReceived>(_onMessageReceived);
    on<WebsocketErrorOccurred>(_onErrorOccurred);
  }

  Future<void> _onConnect(ConnectWebsocket event, Emitter<WebsocketState> emit) async {
    emit(WebsocketConnecting());
    try {
      await _webSocketService.connect();
      emit(WebsocketConnected());
      _messageSubscription = _webSocketService.messageStream.listen(
        (message) {
          // Map<String, dynamic> messageMap = jsonDecode(message);
          // var websocketMessage = WebsocketIncommingMessage.fromJson(messageMap);
          add(WebsocketMessageReceived(message));
        },
        onError: (error) {
          add(WebsocketErrorOccurred(error.toString()));
        },
      );
    } catch (e) {
      emit(WebsocketError(e.toString()));
    }
  }

  Future<void> _onDisconnect(DisconnectWebsocket event, Emitter<WebsocketState> emit) async {
    await _messageSubscription?.cancel();
    await _webSocketService.disconnect();
    emit(WebsocketDisconnected());
  }

  void _onMessageReceived(WebsocketMessageReceived event, Emitter<WebsocketState> emit) {
    emit(WebsocketMessageState(event.message));
  }

  void _onErrorOccurred(WebsocketErrorOccurred event, Emitter<WebsocketState> emit) {
    emit(WebsocketError(event.error));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }
}
