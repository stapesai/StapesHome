// class DeviceButton extends StatefulWidget {
//   final String label;

//   const DeviceButton({super.key, required this.label});

//   @override
//   createState() => _DeviceButtonState();
// }

// class _DeviceButtonState extends State<DeviceButton> {
//   bool isActive = false;

//   void toggleButton() {
//     setState(() {
//       isActive = !isActive;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: toggleButton,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF343450), Color(0xFF161622)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: isActive ? Colors.orange.shade200 : Colors.black.withOpacity(0.5),
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
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 63,
//               height: 63,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: isActive
//                       ? [Colors.orange.shade700, Colors.orange.shade400]
//                       : [const Color(0xFF2A2A40), const Color(0xFF1C1C2B)],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.lightbulb_outline,
//                   color: AppColor.whiteColor,
//                   size: 30,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(widget.label, style: const TextStyle(color: Colors.white)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddDeviceButton extends StatelessWidget {
//   const AddDeviceButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const AddNewDevice()),
//         );
//       },
//       child: CustomPaint(
//         painter: DashedBorderPainter(),
//         child: Container(
//           width: 396,
//           height: 70,
//           decoration: BoxDecoration(
//             color: const Color(0xFF1C1C2B),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.5),
//                 offset: const Offset(4, 4),
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: const Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.add, color: Colors.orange, size: 24),
//                 SizedBox(height: 4),
//                 Text(
//                   'Add device',
//                   style: TextStyle(color: Colors.orange, fontSize: 18),
//                 ),
//               ],
//             ),
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





























// Widget _buildDeviceCard(String deviceName, bool isActive) {
//     return Container(
//       width: 150,
//       height: 150,
//       decoration: BoxDecoration(
//         color: Color(0xFF1D1D1D),
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: isActive ? Color(0xCCFF9F1C) : Color(0x3F000000),
//             blurRadius: 16,
//             offset: Offset(8, 7),
//             spreadRadius: -3,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 62.58,
//             height: 63,
//             decoration: BoxDecoration(
//               color: isActive ? Color(0xFFFF9F1C) : Colors.white.withOpacity(0.5),
//               shape: BoxShape.circle,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             deviceName,
//             style: TextStyle(
//               color: AppColor.whiteColor,
//               fontSize: AppFontSizes.bodyText,
//               fontFamily: 'Ubuntu',
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }