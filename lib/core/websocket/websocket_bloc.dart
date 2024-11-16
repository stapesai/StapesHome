import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';
import 'package:stapes_home/core/websocket/websocket_service.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  final WebsocketService _webSocketService;
  StreamSubscription<dynamic>? _messageSubscription;

  WebsocketBloc(this._webSocketService) : super(WebsocketInitial()) {
    on<ConnectWebsocketEvent>(_onConnect);
    on<DisconnectWebsocketEvent>(_onDisconnect);
    on<WebsocketMessageReceivedEvent>(_onMessageReceived);
    on<WebsocketErrorOccurredEvent>(_onErrorOccurred);
  }

  Future<void> _onConnect(ConnectWebsocketEvent event, Emitter<WebsocketState> emit) async {
    emit(WebsocketConnecting());
    try {
      await _webSocketService.connect();
      emit(WebsocketConnected());

      _messageSubscription = _webSocketService.messageStream.listen(
        (message) {
          add(WebsocketMessageReceivedEvent(message));
        },
        onError: (error) {
          add(WebsocketErrorOccurredEvent(error.toString()));
        },
      );

      _webSocketService.connectionState.listen((state) {
        if (state == WebsocketConnectionState.disconnected) {
          add(DisconnectWebsocketEvent());
        }
      });
    } catch (e) {
      add(WebsocketErrorOccurredEvent(e.toString()));
    }
  }

  Future<void> _onDisconnect(DisconnectWebsocketEvent event, Emitter<WebsocketState> emit) async {
    await _messageSubscription?.cancel();
    await _webSocketService.disconnect();
    emit(WebsocketDisconnected());
  }

  void _onMessageReceived(WebsocketMessageReceivedEvent event, Emitter<WebsocketState> emit) {
    Map<String, dynamic> messageMap = json.decode(json.decode(event.message));
    WebsocketIncommingMessage websocketMessage = WebsocketIncommingMessage.fromJson(messageMap);
    print('Received message in WS bloc: ${websocketMessage.toString()}');

    switch (websocketMessage.type) {
      case WebsocketIncommingMessageType.nodeStatusUpdate:
        emit(WebsocketNodeStatusUpdateMessageState(websocketMessage.payload));
        break;
      case WebsocketIncommingMessageType.deviceStatusUpdate:
        emit(WebsocketDeviceStatusUpdateMessageState(websocketMessage.payload));
        break;
      case WebsocketIncommingMessageType.error:
        emit(WebsocketErrorMessageState(websocketMessage.payload));
        break;
    }
  }

  void _onErrorOccurred(WebsocketErrorOccurredEvent event, Emitter<WebsocketState> emit) {
    emit(WebsocketErrorOccurredState(event.error));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _webSocketService.disconnect();
    _webSocketService.closeControllers();
    return super.close();
  }
}
