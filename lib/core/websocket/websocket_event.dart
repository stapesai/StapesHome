import 'package:equatable/equatable.dart';

abstract class WebsocketEvent extends Equatable {
  const WebsocketEvent();

  @override
  List<Object> get props => [];
}

class ConnectWebsocketEvent extends WebsocketEvent {}

class DisconnectWebsocketEvent extends WebsocketEvent {}

class WebsocketMessageReceivedEvent extends WebsocketEvent {
  final String message;

  const WebsocketMessageReceivedEvent(this.message);

  @override
  List<Object> get props => [message];
}

class WebsocketErrorOccurredEvent extends WebsocketEvent {
  final String error;

  const WebsocketErrorOccurredEvent(this.error);

  @override
  List<Object> get props => [error];
}

class WebsocketSendDeviceControlRequest extends WebsocketEvent {
  final String deviceId;
  final bool state;

  const WebsocketSendDeviceControlRequest({
    required this.deviceId,
    required this.state,
  });

  @override
  List<Object> get props => [deviceId, state];
}

class WebsocketConnectedEvent extends WebsocketEvent {}

class WebsocketConnectingEvent extends WebsocketEvent {}

class WebsocketDisconnectedEvent extends WebsocketEvent {}

// class GetWebsocketMessageHistory extends WebsocketEvent {}
