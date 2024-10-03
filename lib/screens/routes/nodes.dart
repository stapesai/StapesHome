import 'dart:convert';
import 'package:stapes_home/screens/views/nodes/scanner/qr_scanner.dart';
import 'package:stapes_home/services/websocket_service.dart';
import 'package:stapes_home/widgets/iot/node.dart';
import 'package:stapes_home/widgets/scan_node_add_device_btn.dart';
import 'package:stapes_home/widgets/skeletons/node.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/common/models.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/widgets/floor_room_sel.dart';
import 'package:provider/provider.dart';

class NodesScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const NodesScreen({
    super.key,
    required this.sessionId,
    required this.userId,
  });

  @override
  createState() => _NodesScreenState();
}

class _NodesScreenState extends State<NodesScreen> {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Node> nodes = [];
  bool isLoading = true;
  String? errorMessage;
  final GlobalKey<FloorRoomSelectorState> _floorRoomSelectorKey = GlobalKey();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = Provider.of<WebSocketService>(context, listen: false);
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    _webSocketService.messageStream.listen((message) {
      if (message['type'] == 'node_status_update') {
        _updateNodeState(NodeStatusUpdate.fromJson(message['data']));
      }
    });
  }

  void _updateNodeState(NodeStatusUpdate nodeUpdateData) {
    setState(() {
      final index = nodes.indexWhere((n) => n.id == nodeUpdateData.nodeId);
      if (index != -1) {
        print('Node with name ${nodes[index].name} updated to ${nodeUpdateData.isOnline}');
        // nodes[index].status = nodeUpdateData.status;
      }
    });
  }

  void handleFloorSelected(String floorId) {
    if (mounted) {
      setState(() {
        activeFloorId = floorId;
      });
    }
  }

  void handleRoomSelected(String roomId) {
    if (mounted) {
      setState(() {
        activeRoomId = roomId;
      });
      if (activeRoomId.isNotEmpty) {
        _fetchNodes(roomId);
      } else {
        setState(() {
          nodes = [];
          errorMessage = 'Active room ID is empty';
        });
      }
    }
  }

  Future<void> _fetchNodes(String roomId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getNodesByRoomId(roomId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> nodesData = json.decode(response.body);
        print(nodesData);
        nodes = nodesData.map<Node>((node) => Node.fromJson(node)).toList();
      } else {
        throw Exception('Failed to load nodes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching nodes: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _floorRoomSelectorKey.currentState?.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColor.whiteColor,
            backgroundColor: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: AppPadding.pagePadding(context),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenSize.height * 0.05),
                            Text(
                              'Linked Nodes',
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: AppFontSizes.pageHeading,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            FloorRoomSelector(
                              key: _floorRoomSelectorKey,
                              context: context,
                              onFloorSelected: handleFloorSelected,
                              onRoomSelected: handleRoomSelected,
                              sessionId: widget.sessionId,
                              userId: widget.userId,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            if (isLoading)
                              Column(
                                children: List.generate(3, (index) => NodeComponentSkeleton()),
                              )
                            else if (errorMessage != null)
                              Text(errorMessage!, style: TextStyle(color: Colors.red))
                            else
                              Column(
                                children: nodes.map((node) => NodeComponent(node: node)).toList(),
                              ),
                            SizedBox(height: screenSize.height * 0.1),
                          ],
                        ),
                      ),
                    ),
                    ScanNodeorAddDeviceButton(
                      text: 'Scan a new node',
                      onPressed: () {
                        if (activeRoomId == '') {
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QrScannerScreen(
                                    roomId: activeRoomId, userId: widget.userId, sessionId: widget.sessionId)),
                          );
                        }
                      },
                      icon: 'assets/icons/nodes/qr.svg',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
