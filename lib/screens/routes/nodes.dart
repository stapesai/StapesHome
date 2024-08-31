import 'dart:convert';
import 'package:StapesHome/screens/views/nodes/scanner/qr_scanner.dart';
import 'package:StapesHome/widgets/iot/node.dart';
import 'package:StapesHome/widgets/scan_add_btn.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/room_sel.dart';

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QrScannerScreen(floorId: activeFloorId, roomId: activeRoomId, userId: widget.userId, sessionId: widget.sessionId)),
                        );
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


class NodeComponentSkeleton extends StatefulWidget {
  const NodeComponentSkeleton({super.key});

  @override
   createState() => _NodeComponentSkeletonState();
}

class _NodeComponentSkeletonState extends State<NodeComponentSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Color(0xFF2A2A2A),
      end: Color(0xFF3A3A3A),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 68.72,
          margin: EdgeInsets.only(bottom: 19.63),
          padding: EdgeInsets.symmetric(horizontal: 20.62, vertical: 2.95),
          decoration: ShapeDecoration(
            color: Color(0xFF1D1D1D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.45),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 39.27,
                    height: 39.27,
                    decoration: ShapeDecoration(
                      color: _colorAnimation.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(29.45),
                      ),
                    ),
                  ),
                  SizedBox(width: 9.82),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 19.63,
                        color: _colorAnimation.value,
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 9.82,
                        color: _colorAnimation.value,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: _colorAnimation.value,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}