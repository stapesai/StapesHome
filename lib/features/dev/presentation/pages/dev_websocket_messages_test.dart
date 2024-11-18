import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';
import 'package:stapes_home/features/dev/presentation/widgets/websocket_message.dart';

class WebsocketMessageViewModel {
  final Key key;
  final Widget widget;

  const WebsocketMessageViewModel({required this.key, required this.widget});
}

class DevTestWebsocketMessagesPage extends StatefulWidget {
  const DevTestWebsocketMessagesPage({super.key});

  @override
  State<DevTestWebsocketMessagesPage> createState() => _DevTestMessagesPageState();
}

class _DevTestMessagesPageState extends State<DevTestWebsocketMessagesPage> {
  // static const int _pageSize = 20;
  final List<WebsocketMessageViewModel> _messages = [];

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<WebsocketBloc>(context).add(GetWebsocketMessageHistory());
  }

  @override
  void dispose() {
    _messages.clear();
    super.dispose();
  }

  WebsocketMessageViewModel _createMessageViewModel(WebsocketState state) {
    if (state is WebsocketDeviceStatusUpdateMessageState) {
      return WebsocketMessageViewModel(
        key: ValueKey('device_${state.update.deviceId}_${DateTime.now().millisecondsSinceEpoch}'),
        widget: RepaintBoundary(
          child: DeviceStatusUpdateWidget(
            data: state.update,
            animation: const AlwaysStoppedAnimation(1),
          ),
        ),
      );
    } else if (state is WebsocketNodeStatusUpdateMessageState) {
      return WebsocketMessageViewModel(
        key: ValueKey('node_${state.update.nodeId}_${DateTime.now().millisecondsSinceEpoch}'),
        widget: RepaintBoundary(
          child: NodeStatusUpdateWidget(
            data: state.update,
            animation: const AlwaysStoppedAnimation(1),
          ),
        ),
      );
    } else if (state is WebsocketErrorMessageState) {
      return WebsocketMessageViewModel(
        key: ValueKey('error_${DateTime.now().millisecondsSinceEpoch}'),
        widget: RepaintBoundary(
          child: ErrorMessageWidget(
            data: state.error,
            animation: const AlwaysStoppedAnimation(1),
          ),
        ),
      );
    }
    throw Exception('Unknown websocket state');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Received Websocket Messages',
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        // IconButton(
        //   icon: const Icon(Icons.refresh, color: Colors.white),
        //   onPressed: () => setState(() {}),
        // ),
        // ],
      ),
      body: BlocBuilder<WebsocketBloc, WebsocketState>(
        builder: (context, state) {
          if (state is WebsocketInitial) {
            return const Center(child: Text('No messages yet'));
          }

          if (state is WebsocketConnecting) {
            return const Center(child: Text('Connecting...'));
          }

          if (state is WebsocketConnected) {
            return const Center(child: Text('Connected'));
          }

          if (state is WebsocketDisconnected) {
            return const Center(child: Text('Disconnected'));
          }

          if (state is WebsocketErrorOccurredState) {
            return Center(child: Text('Error: ${state.error}'));
          }

          if (state is WebsocketDeviceStatusUpdateMessageState ||
              state is WebsocketNodeStatusUpdateMessageState ||
              state is WebsocketErrorMessageState) {
            try {
              final messageVM = _createMessageViewModel(state);
              _messages.insert(0, messageVM);
              if (_messages.length > 100) {
                _messages.removeLast();
              }
            } catch (e) {
              debugPrint('Error creating message view model: $e');
            }
          }
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _messages[index].widget;
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
