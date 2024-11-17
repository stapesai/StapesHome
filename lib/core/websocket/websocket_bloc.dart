import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';
import 'package:stapes_home/core/websocket/websocket_service.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  // FIXME: We have to do this as there was an issue in the app that only the home page was being loaded by default,
  // so only that page is receiving web socket events by default, until user opens the other pages, they don't receive the events.
  // For now, we can solve this issue by keeping the history of the messages and emitting them to all the pages.
  // But, this is not a good solution. We have to find a better solution for this.
  final List<WebsocketIncommingMessage> messagesHistory = [];
  final WebsocketService _webSocketService;
  StreamSubscription<dynamic>? _messageSubscription;

  WebsocketBloc(this._webSocketService) : super(WebsocketInitial()) {
    on<ConnectWebsocketEvent>(_onConnect);
    on<DisconnectWebsocketEvent>(_onDisconnect);
    on<WebsocketMessageReceivedEvent>(_onMessageReceived);
    on<WebsocketErrorOccurredEvent>(_onErrorOccurred);
    on<GetWebsocketMessageHistory>(_onGetMessageHistory);
    // TODO: implement a event for user logout so that service can stop reconnecting.
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

  void _emitProperStateForIncommingWebsocketMessage(
      WebsocketIncommingMessage websocketMessage, Emitter<WebsocketState> emit) {
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

  void _onMessageReceived(WebsocketMessageReceivedEvent event, Emitter<WebsocketState> emit) {
    Map<String, dynamic> messageMap = json.decode(json.decode(event.message));
    WebsocketIncommingMessage websocketMessage = WebsocketIncommingMessage.fromJson(messageMap);
    messagesHistory.add(websocketMessage);
    print('Received message in WS bloc: ${websocketMessage.toString()}');

    _emitProperStateForIncommingWebsocketMessage(websocketMessage, emit);
  }

  void _onGetMessageHistory(GetWebsocketMessageHistory event, Emitter<WebsocketState> emit) {
    for (var message in messagesHistory) {
      _emitProperStateForIncommingWebsocketMessage(message, emit);
    }
  }

  void _onErrorOccurred(WebsocketErrorOccurredEvent event, Emitter<WebsocketState> emit) {
    emit(WebsocketErrorOccurredState(event.error));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _webSocketService.disconnect();
    // FIXME: We have not disposed controllers anywhere. If we dispose them here, we can't reconnect.
    // If we dont dispose them, we will have memory leaks and we'll get repeated websocket messages after hot reload.
    // _webSocketService.closeControllers();
    return super.close();
  }
}
