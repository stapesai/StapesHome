import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_messages_models.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';
import 'package:stapes_home/features/dev/presentation/widgets/websocket_message.dart';

class DevWebsocketMessage {
  final WebsocketIncommingMessageType type;
  // final WebsocketIncommingMessage data;
  final dynamic data;

  DevWebsocketMessage({required this.type, required this.data});
}

class DevTestWebsocketMessagesPage extends StatefulWidget {
  const DevTestWebsocketMessagesPage({super.key});

  @override
  State<DevTestWebsocketMessagesPage> createState() => _DevTestMessagesPageState();
}

class _DevTestMessagesPageState extends State<DevTestWebsocketMessagesPage> {
  final List<DevWebsocketMessage> _messages = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<WebsocketBloc>(context).add(GetWebsocketMessageHistory());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Received Websocket Messages', style: TextStyle(color: Colors.white)),
        // actions: [
        // IconButton(
        //   icon: const Icon(Icons.refresh, color: Colors.white),
        //   onPressed: () => setState(() {}),
        // ),
        // ],
      ),
      body: BlocListener<WebsocketBloc, WebsocketState>(
        listener: (context, state) {
          DevWebsocketMessage? message;
          if (state is WebsocketDeviceStatusUpdateMessageState) {
            message = DevWebsocketMessage(type: WebsocketIncommingMessageType.deviceStatusUpdate, data: state.update);
          } else if (state is WebsocketNodeStatusUpdateMessageState) {
            message = DevWebsocketMessage(type: WebsocketIncommingMessageType.nodeStatusUpdate, data: state.update);
          } else if (state is WebsocketErrorMessageState) {
            message = DevWebsocketMessage(type: WebsocketIncommingMessageType.error, data: state.error);
          }

          if (message != null) {
            setState(() {
              _messages.insert(0, message!);
              _listKey.currentState?.insertItem(0);
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedList(
            key: _listKey,
            initialItemCount: _messages.length,
            itemBuilder: (context, index, animation) {
              final message = _messages[index];
              switch (message.type) {
                case WebsocketIncommingMessageType.deviceStatusUpdate:
                  return DeviceStatusUpdateWidget(data: message.data, animation: animation);
                case WebsocketIncommingMessageType.nodeStatusUpdate:
                  return NodeStatusUpdateWidget(data: message.data, animation: animation);
                case WebsocketIncommingMessageType.error:
                  return ErrorMessageWidget(data: message.data, animation: animation);
              }
            },
          ),
        ),
      ),
    );
  }
}
