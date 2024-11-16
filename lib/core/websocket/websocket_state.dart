import 'package:equatable/equatable.dart';

abstract class WebsocketState extends Equatable {
  const WebsocketState();

  @override
  List<Object> get props => [];
}

class WebsocketInitial extends WebsocketState {}

class WebsocketConnecting extends WebsocketState {}

class WebsocketConnected extends WebsocketState {}

class WebsocketDisconnected extends WebsocketState {}

class WebsocketError extends WebsocketState {
  final String error;

  const WebsocketError(this.error);

  @override
  List<Object> get props => [error];
}

class WebsocketMessageState extends WebsocketState {
  final dynamic message;

  const WebsocketMessageState(this.message);

  @override
  List<Object> get props => [message];
}
