// import 'package:flutter/material.dart';
// import 'package:stapes_home/data/models/models.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class LightComponent extends StatelessWidget {
//   final Device device;
//   final Function(bool) onToggle;

//   const LightComponent({super.key, required this.device, required this.onToggle});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => onToggle(!device.state),
//       child: Container(
//         width: 150,
//         height: 150,
//         decoration: BoxDecoration(
//           color: Color(0xFF1D1D1D),
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: device.state ? Color(0xCCFF9F1C) : Colors.transparent,
//               blurRadius: 16,
//               offset: Offset(8, 7),
//               spreadRadius: -3,
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 68,
//               height: 68,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: device.state ? Color(0xFFFFA52D) : Colors.white.withOpacity(0.5),
//               ),
//               child: Center(
//                 child: SvgPicture.asset(
//                   'assets/icons/devices/light.svg',
//                   width: 30,
//                   height: 30,
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Text(
//               device.name,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontFamily: 'Ubuntu',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
