import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/config/config.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';
import 'package:stapes_home/core/websocket/websocket_service.dart';
import 'websocket_event.dart';
import 'websocket_state.dart';

class WebsocketBloc extends Bloc<WebsocketEvent, WebsocketState> {
  // FIXME: We have to do this as there was an issue in the app that only the home page was being loaded by default,
  // so only that page is receiving web socket events by default, until user opens the other pages, they don't receive the events.
  // For now, we can solve this issue by keeping the history of the messages and emitting them to all the pages.
  // But, this is not a good solution. We have to find a better solution for this.
  // final List<WebsocketIncommingMessage> messagesHistory = [];
  Timer? _connectionMonitor;
  // static const connectionMonitorInterval = Duration(seconds: 10);
  final WebsocketService _webSocketService = WebsocketService();
  StreamSubscription<dynamic>? _messageSubscription;
  StreamSubscription<WebsocketConnectionState>? _connectionStateSubscription;

  WebsocketBloc() : super(WebsocketInitial()) {
    on<ConnectWebsocketEvent>(_onConnect);
    on<DisconnectWebsocketEvent>(_onDisconnect);
    on<WebsocketMessageReceivedEvent>(_onMessageReceived);
    on<WebsocketSendDeviceControlRequest>(_onSendDeviceControlRequest);
    on<WebsocketErrorOccurredEvent>((event, emit) => emit(WebsocketErrorOccurredState(event.error)));
    on<WebsocketConnectedEvent>((event, emit) => emit(WebsocketConnected()));
    on<WebsocketConnectingEvent>((event, emit) => emit(WebsocketConnecting()));
    on<WebsocketDisconnectedEvent>((event, emit) => emit(WebsocketDisconnected()));
    // on<GetWebsocketMessageHistory>(_onGetMessageHistory);
    // TODO: implement a event for user logout so that service can stop reconnecting.
    _startConnectionMonitoring();
    print('WebsocketBloc created');
  }

  @override
  Future<void> close() {
    print('WebsocketBloc closed');
    _messageSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _connectionMonitor?.cancel();
    _webSocketService.disconnect();
    _webSocketService.closeControllers();
    return super.close();
  }

  void _startConnectionMonitoring() {
    _connectionMonitor?.cancel();
    _connectionMonitor = Timer.periodic(Duration(seconds: Config.websocketReconnectInterval), (_) {
      if (!_webSocketService.isConnected) {
        add(ConnectWebsocketEvent());
      }
    });
  }

  Future<void> _onConnect(ConnectWebsocketEvent event, Emitter<WebsocketState> emit) async {
    if (state is WebsocketConnecting) return;

    emit(WebsocketConnecting());
    try {
      // Setup connection state subscription
      _connectionStateSubscription?.cancel();
      _connectionStateSubscription = _webSocketService.connectionState.listen(
        (connectionState) {
          switch (connectionState) {
            case WebsocketConnectionState.connected:
              print('WebsocketBloc: Websocket connected');
              add(WebsocketConnectedEvent());
              break;
            case WebsocketConnectionState.connecting:
              print('WebsocketBloc: Websocket connecting');
              add(WebsocketConnectingEvent());
              break;
            case WebsocketConnectionState.disconnected:
              print('WebsocketBloc: Websocket disconnected');
              add(WebsocketDisconnectedEvent());
              break;
            case WebsocketConnectionState.error:
              print('WebsocketBloc: Websocket error');
              add(WebsocketErrorOccurredEvent("Unable to connect to websocket server"));
              break;
          }
        },
        onError: (error) => add(WebsocketErrorOccurredEvent(error.toString())),
      );

      // Connect to websocket server
      await _webSocketService.connect();

      // Setup message subscription
      _messageSubscription?.cancel();
      _messageSubscription = _webSocketService.messageStream.listen(
        (message) => add(WebsocketMessageReceivedEvent(message)),
        onError: (error) => add(WebsocketErrorOccurredEvent(error.toString())),
      );
    } catch (e) {
      print('Unhandled exception in WebsocketBloc: $e');
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
    // messagesHistory.add(websocketMessage);
    print('Received message in WS bloc: ${websocketMessage.toString()}');

    _emitProperStateForIncommingWebsocketMessage(websocketMessage, emit);
  }

  // void _onGetMessageHistory(GetWebsocketMessageHistory event, Emitter<WebsocketState> emit) {
  //   for (var message in messagesHistory) {
  //     _emitProperStateForIncommingWebsocketMessage(message, emit);
  //   }
  // }

  // void _onErrorOccurred(WebsocketErrorOccurredEvent event, Emitter<WebsocketState> emit) {
  //   emit(WebsocketErrorOccurredState(event.error));
  // }

  void _onSendDeviceControlRequest(WebsocketSendDeviceControlRequest event, Emitter<WebsocketState> emit) {
    print('Sending device control request: ${event.deviceId} - ${event.state}');
    WebsocketOutgoingMessage message = WebsocketOutgoingMessage(
      type: WebsocketOutgoingMessageType.controlDevice,
      payload: WebsocketDeviceControlMessage(
        deviceId: event.deviceId,
        state: event.state,
      ),
    );

    _webSocketService.sendMessage(message.toJson());
  }
}
