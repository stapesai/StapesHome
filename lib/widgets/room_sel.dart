import 'dart:convert';
import 'package:StapesHome/widgets/skeletons/floor_room_name.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:StapesHome/widgets/popup.dart';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/screens/views/floor_room_selector/create_floor_page.dart';
import 'package:StapesHome/screens/views/floor_room_selector/create_room_page.dart';

class FloorRoomSelector extends StatefulWidget {
  final BuildContext context;
  final Function(String) onFloorSelected;
  final Function(String) onRoomSelected;
  final String sessionId;
  final String userId;

  const FloorRoomSelector({
    super.key,
    required this.context,
    required this.onFloorSelected,
    required this.onRoomSelected,
    required this.sessionId,
    required this.userId,
  });

  @override
  FloorRoomSelectorState createState() => FloorRoomSelectorState();
}

class FloorRoomSelectorState extends State<FloorRoomSelector> {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Floor> floors = [];
  List<Room> rooms = [];
  bool isFloorsLoading = true;
  bool isRoomsLoading = true;
  String? errorMessageFloors;
  String? errorMessageRooms;

  @override
  void initState() {
    super.initState();
    // fetch floors on init
    _fetchFloors();
  }

  Future<void> refreshData() async {
    await _fetchFloors();
  }

  // Fetch floors from the API
  Future<void> _fetchFloors() async {
    setState(() {
      // set loading states
      isFloorsLoading = true;
      isRoomsLoading = true;
      errorMessageFloors = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getFloors,
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> floorsData = json.decode(response.body);
        floors = floorsData.map((floors) => Floor.fromJson(floors)).toList();

        // Fetch rooms for the initially active floor
        if (floors.isNotEmpty) {
          setState(() {
            isFloorsLoading = false;
          });
          setActiveFloor(floors.first.id);
          // setActiveFloor(activeFloorId);
        }
      } else {
        setState(() {
          isFloorsLoading = false;
        });
        throw Exception('Failed to load floors: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessageFloors = 'Error fetching floors: $e';
      });
    } finally {}
  }

  // Fetch rooms for a specific floor
  Future<void> _fetchRooms(String floorId) async {
    setState(() {
      isRoomsLoading = true;
      errorMessageRooms = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getRoomsByFloorId(floorId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> roomsData = json.decode(response.body);
        rooms = roomsData.map((rooms) => Room.fromJson(rooms)).toList();

        // Fetch devices for the initially active room
        if (rooms.isNotEmpty) {
          setState(() {
            isRoomsLoading = false;
          });
          setActiveRoom(rooms.first.id);
          // setActiveRoom(activeRoomId);
        }
      } else {
        setState(() {
          isRoomsLoading = false;
        });
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessageRooms = 'Error fetching rooms: $e';
      });
    } finally {}
  }

  // Set the active floor and fetch its rooms
  void setActiveFloor(String floorId) {
    // callback to parent widget
    widget.onFloorSelected(floorId);
    widget.onRoomSelected('');

    // set the active floor
    setState(() {
      activeFloorId = floorId;
    });
    rooms = [];
    _fetchRooms(floorId);
  }

  // Set the active room by ID
  void setActiveRoom(String roomId) {
    // callback to parent widget
    widget.onRoomSelected(roomId);

    // set the active room
    setState(() {
      activeRoomId = roomId;
    });
  }

  // Navigate to create floor page
  void navigateToCreateFloor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateFloorPage(
          sessionId: widget.sessionId,
          userId: widget.userId,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _fetchFloors();
      }
    });
  }

  // Navigate to create room page
  void navigateToCreateRoom(BuildContext context) {
    if (activeFloorId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a floor first')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoomPage(
          sessionId: widget.sessionId,
          userId: widget.userId,
          floorId: activeFloorId,
        ),
      ),
    ).then((_) => _fetchRooms(activeFloorId));
  }

  // Delete floor using API
  Future<void> _deleteFloor(String floorId) async {
    try {
      final response = await http.delete(
        BackendRoutes.deleteFloor(floorId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          floors.removeWhere((floor) => floor.id == floorId);
          if (activeFloorId == floorId) {
            activeFloorId = '';
            rooms = [];
            activeRoomId = '';
          }
        });
        if (floors.isNotEmpty) {
          setActiveFloor(floors.first.id);
        }
      } else {
        throw Exception('Failed to delete floor: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error (e.g., show an error message to the user)
      print('Error deleting floor: $e');
    }
  }

  // Delete room using API
  Future<void> _deleteRoom(String roomId) async {
    try {
      final response = await http.delete(
        BackendRoutes.deleteRoom(roomId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 204) {
        setState(() {
          rooms.removeWhere((room) => room.id == roomId);
          if (activeRoomId == roomId) {
            activeRoomId = '';
          }
        });
        if (rooms.isNotEmpty) {
          setActiveRoom(rooms.first.id);
        }
      } else {
        throw Exception('Failed to delete room: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error (e.g., show an error message to the user)
      print('Error deleting room: $e');
    }
  }

  void _showOptionsSheet(BuildContext context, String itemType, String itemId, String itemName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context); // This will close the bottom sheet when tapping outside
          },
          behavior: HitTestBehavior.opaque, // Ensure it detects taps outside the bottom sheet
          child: DraggableScrollableSheet(
            initialChildSize: 0.3, // Use a percentage of the screen height
            minChildSize: 0.2, // Minimum size is 20% of the screen height
            maxChildSize: 0.5, // Maximum size is 50% of the screen height
            builder: (BuildContext context, ScrollController scrollController) {
              final screenHeight = MediaQuery.of(context).size.height;
              final fontSize = screenHeight * 0.025; // 2.5% of the screen height
              return Container(
                decoration: BoxDecoration(
                  color: AppColor.instructionPanelColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.015), // 1.5% of the screen height
                    Center(
                      child: Container(
                        width: screenHeight * 0.05, // 5% of the screen height
                        height: screenHeight * 0.00625, // 0.625% of the screen height
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(screenHeight * 0.003125), // 0.3125% of the screen height
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025), // 2.5% of the screen height
                    Text(
                      'Options for $itemName',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.025), // 2.5% of the screen height
                    // ListTile(
                    //   leading: Icon(Icons.edit, color: const Color.fromARGB(255, 159, 189, 223), size: fontSize * 1.5), // 1.5x the font size
                    //   title: Text('Rename', style: TextStyle(fontSize: fontSize, color: const Color.fromARGB(255, 159, 189, 223))),
                    //   onTap: () {
                    //     Navigator.pop(context);
                    //     _showRenameDialog(context, itemType, itemId, itemName);
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.red, size: fontSize * 1.5), // 1.5x the font size
                      title: Text('Delete', style: TextStyle(fontSize: fontSize, color: Colors.red)),
                      onTap: () {
                        Navigator.pop(context);
                        _showDeleteConfirmationDialog(context, itemType, itemId, itemName);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

// void _showDeleteBottomSheet(BuildContext context, String itemType, String itemId, String itemName) {
//   showModalBottomSheet(
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       final screenHeight = MediaQuery.of(context).size.height;
//       final fontSize = screenHeight * 0.025; // 2.5% of the screen height
//       return DraggableScrollableSheet(
//         initialChildSize: 0.3,
//         minChildSize: 0.2,
//         maxChildSize: 0.5,
//         builder: (BuildContext context, ScrollController scrollController) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             padding: EdgeInsets.all(screenHeight * 0.02),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "Are you sure you want to delete $itemName?",
//                   style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.black),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: screenHeight * 0.025), // 2.5% of the screen height
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text("Cancel", style: TextStyle(fontSize: fontSize, color: Colors.black)),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _showDeleteConfirmationDialog(context, itemType, itemId, itemName);
//                       },
//                       child: Text("Delete", style: TextStyle(fontSize: fontSize, color: Colors.red)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// void _showRenameDialog(BuildContext context, String itemType, String itemId, String itemName) {
//   TextEditingController _controller = TextEditingController();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Enter the new name for the $itemType"),
//         content: TextField(
//           controller: _controller,
//           decoration: InputDecoration(hintText: "New name"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               String newName = _controller.text;
//               // Handle renaming logic here
//               Navigator.pop(context);
//               // Show confirmation or proceed with name change
//             },
//             child: Text("Change"),
//           ),
//         ],
//       );
//     },
//   );
// }
  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String itemType, String itemId, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $itemType'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                if (itemType == 'Floor') {
                  _deleteFloor(itemId);
                } else if (itemType == 'Room') {
                  _deleteRoom(itemId);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Floors', () => navigateToCreateFloor(context)),
            const SizedBox(height: 8),
            _buildFloorList(constraints.maxWidth),
            const SizedBox(height: 24),
            _buildSectionHeader('Rooms', () => navigateToCreateRoom(context)),
            const SizedBox(height: 8),
            _buildRoomList(constraints.maxWidth),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAddPressed) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
            fontFamily: 'Ubuntu',
          ),
        ),
        const SizedBox(width: 30),
        PlusButton(onPressed: onAddPressed),
      ],
    );
  }

  Widget _buildFloorList(double maxWidth) {
    if (isFloorsLoading) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
              ),
            ),
          ));
    }
    if (errorMessageFloors != null) {
      return Text(errorMessageFloors!, style: const TextStyle(color: Colors.red));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: floors.map((floor) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FloorRoomNameButton(
              label: floor.alias,
              isActive: activeFloorId == floor.id,
              onTap: () => setActiveFloor(floor.id),
              onLongPress: () => _showOptionsSheet(context, 'Floor', floor.id, floor.alias),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoomList(double maxWidth) {
    if (isRoomsLoading) {
      return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              4,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: FloorRoomNameButtonSkeleton(width: 80, height: 30),
              ),
            ),
          ));
    }

    if (errorMessageRooms != null) {
      return Text(errorMessageRooms!, style: const TextStyle(color: Colors.red));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rooms.map((room) {
          return Padding(
            padding: const EdgeInsets.only(right: 15),
            child: FloorRoomNameButton(
              label: room.name,
              isActive: activeRoomId == room.id,
              onTap: () => setActiveRoom(room.id),
              onLongPress: () => _showOptionsSheet(context, 'Room', room.id, room.name),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;
  const PlusButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        padding: EdgeInsets.all(12),
        child: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF3E3E62),
          ),
          child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
        ),
      ),
    );
  }
}

class FloorRoomNameButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const FloorRoomNameButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColor.whiteColor : AppColor.whiteColor50,
              fontSize: 16,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isActive)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor,
              ),
            ),
        ],
      ),
    );
  }
}
