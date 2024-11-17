import 'package:equatable/equatable.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';

class WebsocketState extends Equatable {
  // final List<WebsocketIncommingMessage> messagesHistory;
  const WebsocketState(
      // this.messagesHistory = const [],
      );

  @override
  List<Object> get props => [];
}

class WebsocketInitial extends WebsocketState {}

class WebsocketConnecting extends WebsocketState {}

class WebsocketConnected extends WebsocketState {}

class WebsocketDisconnected extends WebsocketState {}

class WebsocketNodeStatusUpdateMessageState extends WebsocketState {
  final WebsocketNodeStatusUpdate update;

  const WebsocketNodeStatusUpdateMessageState(this.update);

  @override
  List<Object> get props => [update];
}

class WebsocketDeviceStatusUpdateMessageState extends WebsocketState {
  final WebsocketDeviceStatusUpdate update;

  const WebsocketDeviceStatusUpdateMessageState(this.update);

  @override
  List<Object> get props => [update];
}

class WebsocketErrorMessageState extends WebsocketState {
  final WebsocketErrorMessage error;

  const WebsocketErrorMessageState(this.error);

  @override
  List<Object> get props => [error];
}

class WebsocketErrorOccurredState extends WebsocketState {
  final String error;

  const WebsocketErrorOccurredState(this.error);

  @override
  List<Object> get props => [error];
}
