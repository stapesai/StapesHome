import 'package:equatable/equatable.dart';

abstract class WebsocketEvent extends Equatable {
  const WebsocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebsocket extends WebsocketEvent {}

class DisconnectWebsocket extends WebsocketEvent {}

class WebsocketMessageReceived extends WebsocketEvent {
  final dynamic message;

  const WebsocketMessageReceived(this.message);

  @override
  List<Object> get props => [message];
}

class WebsocketErrorOccurred extends WebsocketEvent {
  final String error;

  const WebsocketErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}
