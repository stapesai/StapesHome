// Path: lib/features/nodes/presentation/pages/nodes.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/node_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/node_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/skeletons/node_skel.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/features/nodes/data/models/get_nodes_by_room_id_api_param.dart';
import 'package:stapes_home/features/nodes/domain/usecases/get_nodes_by_room_id_usecase.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';
import 'package:stapes_home/service_locator.dart';

class NodesPage extends StatefulWidget {
  const NodesPage({super.key});

  @override
  State<NodesPage> createState() => _NodesPageState();
}

class _NodesPageState extends State<NodesPage> {
  final Map<String, bool> _nodeOnlineStatus = {};
  List<NodeModel> _nodes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Listen to websocket updates
    context.read<WebsocketBloc>().stream.listen((state) {
      _handleNodeStatusUpdate(state);
    });
  }

  void _handleNodeStatusUpdate(WebsocketState state) {
    print('Node status update: $state');
    if (state is WebsocketNodeStatusUpdateMessageState) {
      final nodeId = state.update.nodeId;
      // if (_nodeOnlineStatus.containsKey(nodeId)) {
      setState(() {
        _nodeOnlineStatus[nodeId] = state.update.isOnline;
      });
      // }
    } else if (state is WebsocketConnecting) {
      // Reset online status when websocket reconnects
      setState(() {
        _nodeOnlineStatus.clear();
      });
    }
  }

  Future<void> _fetchNodes(String roomId) async {
    if (roomId.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final result = await serviceLocator<GetNodesByRoomIdUseCase>()(
      GetNodesByRoomIdParams(roomId: roomId),
      refresh: true,
    );

    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        if (context.mounted) {
          CustomSnackbar(context, failure.message, type: SnackbarType.error);
        }
      },
      (response) {
        setState(() {
          _nodes = response.nodes;
          // Initialize online status for all nodes
          for (var node in _nodes) {
            if (node.id != null) {
              _nodeOnlineStatus[node.id!] = false; // Default to offline
            }
          }
          _isLoading = false;
        });
      },
    );
  }

  void _onFloorSelected(String floorId) {
    // Clear nodes when floor changes
    setState(() {
      _nodes = [];
      // _nodeOnlineStatus.clear();
    });
  }

  void _onRoomSelected(String roomId) {
    // Clear nodes when room changes (btw when floor changes, room is also changed automatically)
    // This is handled in floor_room_sel_widget.dart
    setState(() {
      _nodes = [];
      // _nodeOnlineStatus.clear();
    });
    _fetchNodes(roomId);
  }

  Widget _buildNodesList() {
    if (_isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return const NodeComponentSkeleton();
        },
      );
    }

    if (_nodes.isEmpty) {
      return Center(
        child: Text(
          'No nodes found in this room',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16.sp,
            fontFamily: 'Ubuntu',
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _nodes.length,
      itemBuilder: (context, index) {
        final node = _nodes[index];
        final isOnline = _nodeOnlineStatus[node.id] ?? false;
        return NodeComponentWidget(
          key: ValueKey(node.id), // Important for efficient updates
          node: node,
          isOnline: isOnline,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height * 0.05),
         Text(
          'Linked Nodes',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 40.sp,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: screenSize.height * 0.05),
        FloorRoomSelector(
          onFloorSelected: _onFloorSelected,
          onRoomSelected: _onRoomSelected,
        ),
        // SizedBox(height: screenSize.height * 0.03),
        Expanded(
          child: _buildNodesList(),
        ),
      ],
    );
  }
}
