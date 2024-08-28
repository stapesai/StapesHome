import 'dart:convert';
import 'package:StapesHome/widgets/iot/node.dart';
import 'package:StapesHome/widgets/scan_node_or_add_device_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/screens/views/common/floor_room_selector.dart';

class NodesScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const NodesScreen({
    Key? key,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  createState() => _NodesScreenState();
}

class _NodesScreenState extends State<NodesScreen> with AutomaticKeepAliveClientMixin {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Node> nodes = [];
  bool isLoading = true;
  String? errorMessage;
  final GlobalKey<FloorRoomSelectorState> _floorRoomSelectorKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

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
        nodes = nodesData
            .map((node) => Node(
                  id: node['id'],
                  roomId: node['room_id'],
                  name: node['name'],
                  hardwareChip: node['hardware_chip'],
                  hardwareVersion: node['hardware_version'],
                  hardwareMacAddress: node['hardware_mac_address'],
                  firmwareVersion: node['firmware_version'],
                ))
            .toList();
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
    super.build(context);
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
                              Center(child: CircularProgressIndicator())
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
                      onPressed: () {},
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
