import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/screens/views/common/floor_room_selector.dart';

class DevicesScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const DevicesScreen({
    Key? key,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> with AutomaticKeepAliveClientMixin {
  String activeFloorId = '';
  String activeRoomId = '';
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
    }
  }

  Future<void> _refreshData() async {
    // Refresh the FloorRoomSelector
    await _floorRoomSelectorKey.currentState?.refreshData();
    
    // Add any additional refresh logic here
    await Future.delayed(Duration(seconds: 1)); // Simulating additional network request
    setState(() {
      // Update your state with the new data if needed
    });
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
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  // height: screenSize.height - MediaQuery.of(context).padding.top,
                  padding: AppPadding.pagePadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'All Devices',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: AppFontSizes.pageHeading,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w700,
                          ),
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
