// import 'package:flutter/material.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/features/sessions/presentation/pages/sessions_page.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       clipBehavior: Clip.antiAlias,
//       decoration: ShapeDecoration(
//         gradient: AppColor.backgroundColorgradient,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('assets/icons/temp/demo.png'),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'John Doe',
//                     style: TextStyle(
//                       color: AppColor.whiteColor,
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'john@example.com',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const SessionsPage()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         side: const BorderSide(color: Colors.orange, width: 2),
//                       ),
//                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                     ),
//                     child: const Text(
//                       'Sessions',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }