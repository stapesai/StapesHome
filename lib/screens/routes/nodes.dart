import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/screens/views/common/floor_room_selector.dart';
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/utils/hive.dart';
// import 'package:StapesHome/screens/views/nodes/qr_scanner.dart';

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
  int activeRoomIndex = -1;
  final HiveService hiveService = HiveService();

  @override
  void initState() {
    super.initState();
  }

  void handleFloorSelected(String floorId) {
    setState(() {
      activeFloorId = floorId;
    });
  }

  void handleRoomSelected(int roomIndex) {
    setState(() {
      activeRoomIndex = roomIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
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



// class NodeButton extends StatefulWidget {
//   final String label;

//   const NodeButton({super.key, required this.label});

//   @override
//   createState() => _NodeButtonState();
// }

// class _NodeButtonState extends State<NodeButton> {
//   bool isActive = false;

//   void toggleButton() {
//     if (mounted) {
//       setState(() {
//         isActive = !isActive;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleButton,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.orange, width: 4),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               blurRadius: 10,
//               spreadRadius: 3,
//             ),
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               offset: const Offset(0, 6),
//               blurRadius: 10,
//               spreadRadius: -3,
//             ),
//           ],
//         ),
//         child: Center(
//           child: Text(
//             widget.label,
//             style: const TextStyle(color: AppColor.whiteColor, fontSize: 24),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ScanNodeButton extends StatelessWidget {
//   const ScanNodeButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: DashedBorderPainter(),
//       child: Container(
//         width: double.infinity,
//         height: 70,
//         decoration: BoxDecoration(
//           color: const Color(0xFF1D1D1D),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.5),
//               offset: const Offset(4, 4),
//               blurRadius: 10,
//             ),
//           ],
//         ),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.qr_code_scanner, color: AppColor.whiteColor, size: 24),
//               SizedBox(height: 4),
//               Text(
//                 'Scan a new node',
//                 style: TextStyle(color: AppColor.whiteColor, fontSize: 18, fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DashedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.orange
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     const double dashWidth = 5;
//     const double dashSpace = 5;
//     final path = Path()
//       ..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(16)));
//     final dashPath = Path();
//     final pathMetrics = path.computeMetrics();
//     for (var pathMetric in pathMetrics) {
//       final double length = pathMetric.length;
//       double distance = 0.0;
//       while (distance < length) {
//         final double nextDistance = distance + dashWidth;
//         dashPath.addPath(pathMetric.extractPath(distance, nextDistance), Offset.zero);
//         distance = nextDistance + dashSpace;
//       }
//     }
//     canvas.drawPath(dashPath, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }
