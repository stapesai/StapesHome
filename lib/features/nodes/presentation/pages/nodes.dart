import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/node_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/skeletons/node_skel.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';

class NodesScreen extends StatelessWidget {
  const NodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocProvider<WebsocketBloc>(
      create: (context) => WebsocketBloc()..add(ConnectWebsocketEvent()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<WebsocketBloc, WebsocketState>(
          listener: (context, state) {
            if (state is WebsocketErrorOccurredState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.05),
                Padding(
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Linked Nodes',
                        style: const TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: AppFontSizes.pageHeading,
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Replaced const SizedBox with dynamic height
                      SizedBox(height: screenSize.height * 0.05),
                      // Floor Room Selector
                      FloorRoomSelector(
                        onFloorSelected: (floorId) {},
                        onRoomSelected: (roomId) {
                          // Handle room selection
                        },
                      ),
                    ],
                  ),
                ),
                // Replaced const SizedBox with dynamic height
                SizedBox(height: screenSize.height * 0.05),
                // Node Components
                Expanded(
                  child: BlocBuilder<WebsocketBloc, WebsocketState>(
                    builder: (context, state) {
                      if (state is WebsocketNodeStatusUpdateMessageState) {
                        final nodes = state.update.nodes;
                        return ListView.builder(
                          itemCount: nodes.length,
                          itemBuilder: (context, index) {
                            return NodeComponentWidget(
                              node: nodes[index],
                            );
                          },
                        );
                      } else if (state is WebsocketConnecting) {
                        // Show skeletons while loading
                        return ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return const NodeComponentSkeleton();
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'No nodes available',
                            style: TextStyle(color: AppColor.whiteColor),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
