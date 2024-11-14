// import 'package:stapes_home/data/models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:stapes_home/utils/hive.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/screens/routes/devices.dart';
// import 'package:stapes_home/screens/routes/home.dart';
// import 'package:stapes_home/screens/routes/nodes.dart';
// import 'package:stapes_home/screens/routes/profile.dart';
// import 'package:provider/provider.dart';
// import 'package:stapes_home/core/network/websocket_service.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;
//   final HiveService hiveService = HiveService();
//   String sessionId = '';
//   String userId = '';
//   bool _isLoading = true;

//   List<Widget> _screens = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadSessionData();
//   }

//   Future<void> _loadSessionData() async {
//     var sessions = await hiveService.getSessionData();
//     if (sessions.isNotEmpty && mounted) {
//       var session = sessions.first;
//       setState(() {
//         sessionId = session.sessionId;
//         userId = session.userId;
//         _screens = [
//           HomeScreen(key: UniqueKey(), sessionId: sessionId, userId: userId),
//           DevicesScreen(key: UniqueKey(), sessionId: sessionId, userId: userId),
//           NodesScreen(key: UniqueKey(), sessionId: sessionId, userId: userId),
//           const ProfileScreen(key: ValueKey('profile')),
//         ];
//         _isLoading = false;
//       });
//     } else {
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });

//         // Set up WebSocket message handling
//         final webSocketService = Provider.of<WebSocketService?>(context, listen: false);
//         if (webSocketService != null) {
//           webSocketService.messageStream.listen((message) {
//             _handleWebSocketErrorMessage(message);
//           });
//         }
//       }
//     }
//   }

//   void _handleWebSocketErrorMessage(Map<String, dynamic> message) {
//     switch (message['type']) {
//       // case 'entity_status_update':
//       //   try {
//       //     var data = DeviceStatusUpdate.fromJson(message['data']);
//       //     _updateDeviceState(data);
//       //   } catch (e) {
//       //     print('Error parsing device status update: $e');
//       //     return;
//       //   }
//       //   break;

//       // case 'node_status_update':
//       //   try {
//       //     var data = NodeStatusUpdate.fromJson(message['data']);
//       //     _updateNodeState(data);
//       //   } catch (e) {
//       //     print('Error parsing node status update: $e');
//       //     return;
//       //   }
//       //   break;

//       case 'error':
//         print('Error: ${message['detail']}');
//         break;
//       default:
//         print('Unknown message type: ${message['type']}');
//     }
//   }

//   void _onItemTapped(int index) {
//     if (mounted) {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: AppColor.backgroundColorgradient,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         resizeToAvoidBottomInset: false,
//         body: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : _screens.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No session data available',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )
//                 : IndexedStack(
//                     index: _selectedIndex,
//                     children: _screens,
//                   ),
//         bottomNavigationBar: _isLoading || _screens.isEmpty
//             ? null
//             : Theme(
//                 data: Theme.of(context).copyWith(
//                   canvasColor: Colors.transparent,
//                 ),
//                 child: BottomNavigationBar(
//                   elevation: 0,
//                   type: BottomNavigationBarType.fixed,
//                   items: [
//                     _buildBottomNavigationBarItem(
//                       activeIcon: 'assets/icons/navbar/home-active.svg',
//                       inactiveIcon: 'assets/icons/navbar/home.svg',
//                       label: 'Home',
//                       isActive: _selectedIndex == 0,
//                     ),
//                     _buildBottomNavigationBarItem(
//                       activeIcon: 'assets/icons/navbar/devices-active.svg',
//                       inactiveIcon: 'assets/icons/navbar/devices.svg',
//                       label: 'Devices',
//                       isActive: _selectedIndex == 1,
//                     ),
//                     _buildBottomNavigationBarItem(
//                       activeIcon: 'assets/icons/navbar/nodes-active.svg',
//                       inactiveIcon: 'assets/icons/navbar/nodes.svg',
//                       label: 'Nodes',
//                       isActive: _selectedIndex == 2,
//                     ),
//                     _buildBottomNavigationBarItem(
//                       activeIcon: 'assets/icons/navbar/profile-active.svg',
//                       inactiveIcon: 'assets/icons/navbar/profile.svg',
//                       label: 'Settings',
//                       isActive: _selectedIndex == 3,
//                     ),
//                   ],
//                   currentIndex: _selectedIndex,
//                   selectedItemColor: Colors.amber[800],
//                   backgroundColor: Colors.transparent,
//                   unselectedItemColor: AppColor.whiteColor,
//                   onTap: _onItemTapped,
//                 ),
//               ),
//       ),
//     );
//   }

//   BottomNavigationBarItem _buildBottomNavigationBarItem({
//     required String activeIcon,
//     required String inactiveIcon,
//     required String label,
//     required bool isActive,
//   }) {
//     return BottomNavigationBarItem(
//       icon: SvgPicture.asset(
//         isActive ? activeIcon : inactiveIcon,
//         height: 43,
//         width: 43,
//       ),
//       label: label,
//     );
//   }
// }
