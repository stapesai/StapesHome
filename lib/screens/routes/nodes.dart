import 'package:flutter/material.dart';
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
  int activeRoomIndex = -1;

  @override
  bool get wantKeepAlive => true;

  void handleFloorSelected(String floorId) {
    if (mounted) {
      setState(() {
        activeFloorId = floorId;
      });
    }
  }

  void handleRoomSelected(int roomIndex) {
    if (mounted) {
      setState(() {
        activeRoomIndex = roomIndex;
      });
    }
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
          body: SafeArea(
            child: Padding(
              padding: AppPadding.pagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenSize.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Linked Nodes',
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
                    context: context,
                    onFloorSelected: handleFloorSelected,
                    onRoomSelected: handleRoomSelected,
                    sessionId: widget.sessionId,
                    userId: widget.userId,
                    activeFloorId: activeFloorId,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
