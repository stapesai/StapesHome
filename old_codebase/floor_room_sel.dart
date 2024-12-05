// import 'package:stapes_home/core/models/floor_model.dart';
// import 'package:stapes_home/core/models/room_model.dart';
// import 'package:stapes_home/features/rooms/presentation/pages/create_room_page.dart';
// import 'widgets/hold_bottom_sheet.dart';
// import 'package:stapes_home/features/home/presentation/skeletons/floor_room_name_skel.dart';
// import 'package:flutter/material.dart';
// import 'package:stapes_home/core/theme/app_colors.dart';
// import 'package:stapes_home/features/floors/presentation/pages/create_floor_page.dart';

// class FloorRoomSelector extends StatefulWidget {
//   final BuildContext context;
//   final Function(String) onFloorSelected;
//   final Function(String) onRoomSelected;
//   final String sessionId;
//   final String userId;

//   const FloorRoomSelector({
//     super.key,
//     required this.context,
//     required this.onFloorSelected,
//     required this.onRoomSelected,
//     required this.sessionId,
//     required this.userId,
//   });

//   @override
//   FloorRoomSelectorState createState() => FloorRoomSelectorState();
// }

// class FloorRoomSelectorState extends State<FloorRoomSelector> {
//   String activeFloorId = '';
//   String activeRoomId = '';
//   List<FloorModel> floors = [];
//   List<RoomModel> rooms = [];
//   bool isFloorsLoading = true;
//   bool isRoomsLoading = true;
//   String? errorMessageFloors;
//   String? errorMessageRooms;

//   @override
//   void initState() {
//     super.initState();
//     // fetch floors on init
//     _fetchFloors();
//   }

//   Future<void> refreshData() async {
//     await _fetchFloors();
//   }

//   // Set the active floor and fetch its rooms
//   void setActiveFloor(String floorId) {
//     // callback to parent widget
//     widget.onFloorSelected(floorId);
//     widget.onRoomSelected('');

//     // set the active floor
//     setState(() {
//       activeFloorId = floorId;
//     });
//     rooms = [];
//     _fetchRooms(floorId);
//   }

//   // Set the active room by ID
//   void setActiveRoom(String roomId) {
//     // callback to parent widget
//     widget.onRoomSelected(roomId);

//     // set the active room
//     setState(() {
//       activeRoomId = roomId;
//     });
//   }

//   // Navigate to create floor page
//   void navigateToCreateFloor(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateFloorPage(
//           sessionId: widget.sessionId,
//           userId: widget.userId,
//         ),
//       ),
//     ).then((result) {
//       if (result == true) {
//         _fetchFloors();
//       }
//     });
//   }

//   // Navigate to create room page
//   void navigateToCreateRoom(BuildContext context) {
//     if (activeFloorId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a floor first')),
//       );
//       return;
//     }
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CreateRoomPage(
//           floorId: activeFloorId,
//         ),
//       ),
//     ).then((_) => _fetchRooms(activeFloorId));
//   }

//   // Show delete confirmation dialog
//   void _showDeleteConfirmationDialog(BuildContext context, String itemType, String itemId, String itemName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete $itemType'),
//           content: Text('Are you sure you want to delete $itemName?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: const Text('Delete'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (itemType == 'Floor') {
//                   _deleteFloor(itemId);
//                 } else if (itemType == 'Room') {
//                   _deleteRoom(itemId);
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader('Floors', () => navigateToCreateFloor(context)),
//             const SizedBox(height: 8),
//             _buildFloorList(constraints.maxWidth),
//             const SizedBox(height: 24),
//             _buildSectionHeader('Rooms', () => navigateToCreateRoom(context)),
//             const SizedBox(height: 8),
//             _buildRoomList(constraints.maxWidth),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildSectionHeader(String title, VoidCallback onAddPressed) {
//     return Row(
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.w700,
//             color: AppColor.whiteColor,
//             fontFamily: 'Ubuntu',
//           ),
//         ),
//         const SizedBox(width: 30),
//         PlusButton(onPressed: onAddPressed),
//       ],
//     );
//   }

//   void _showFloorOptions(Floor floor) {
//     List<HoldBottomSheet> options = [
//       HoldBottomSheet(
//         icon: Icons.edit,
//         text: 'Edit Floor',
//         onTap: () => _editFloor(floor),
//       ),
//       HoldBottomSheet(
//         icon: Icons.delete,
//         text: 'Delete Floor',
//         onTap: () => _showDeleteConfirmationDialog(context, 'Floor', floor.id, floor.alias),
//       ),
//     ];

//     showCustomBottomSheet(context, options);
//   }

//   Widget _buildFloorList(double maxWidth) {
//     if (isFloorsLoading) {
//       return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               4,
//               (index) => Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
//               ),
//             ),
//           ));
//     }
//     if (errorMessageFloors != null) {
//       return Text(errorMessageFloors!, style: const TextStyle(color: Colors.red));
//     }
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: floors.map((floor) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: FloorRoomNameButton(
//               label: floor.alias,
//               isActive: activeFloorId == floor.id,
//               onTap: () => setActiveFloor(floor.id),
//               // onLongPress: () => _showDeleteConfirmationDialog(context, 'Floor', floor.id, floor.alias),
//               onLongPress: () => _showFloorOptions(floor),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   void _showRoomOptions(Room room) {
//     List<HoldBottomSheet> options = [
//       HoldBottomSheet(
//         icon: Icons.edit,
//         text: 'Edit Room',
//         onTap: () => _editRoom(room),
//       ),
//       HoldBottomSheet(
//         icon: Icons.delete,
//         text: 'Delete Room',
//         onTap: () => _showDeleteConfirmationDialog(context, 'Room', room.id, room.name),
//       ),
//     ];

//     showCustomBottomSheet(context, options);
//   }

//   Widget _buildRoomList(double maxWidth) {
//     if (isRoomsLoading) {
//       return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: List.generate(
//               4,
//               (index) => Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
//               ),
//             ),
//           ));
//     }

//     if (errorMessageRooms != null) {
//       return Text(errorMessageRooms!, style: const TextStyle(color: Colors.red));
//     }
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: rooms.map((room) {
//           return Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: FloorRoomNameButton(
//               label: room.name,
//               isActive: activeRoomId == room.id,
//               onTap: () => setActiveRoom(room.id),
//               // onLongPress: () => _showDeleteConfirmationDialog(context, 'Room', room.id, room.name),
//               onLongPress: () => _showRoomOptions(room),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

// class PlusButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   const PlusButton({super.key, required this.onPressed});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       behavior: HitTestBehavior.opaque,
//       child: Container(
//         width: 44,
//         height: 44,
//         padding: EdgeInsets.all(12),
//         child: Container(
//           width: 25,
//           height: 25,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Color(0xFF3E3E62),
//           ),
//           child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
//         ),
//       ),
//     );
//   }
// }

// class FloorRoomNameButton extends StatelessWidget {
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;
//   final VoidCallback onLongPress;

//   const FloorRoomNameButton({
//     super.key,
//     required this.label,
//     required this.isActive,
//     required this.onTap,
//     required this.onLongPress,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       onLongPress: onLongPress,
//       child: Column(
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: isActive ? AppColor.whiteColor : AppColor.whiteColor50,
//               fontSize: 16,
//               fontFamily: 'Ubuntu',
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           if (isActive)
//             Container(
//               width: 6,
//               height: 6,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: AppColor.whiteColor,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
