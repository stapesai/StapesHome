// File: lib/widgets/floor_room_sel.dart

import 'dart:convert';
import 'package:stapes_home/widgets/hold_bottom_sheet.dart';
import 'package:stapes_home/widgets/skeletons/floor_room_name.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:stapes_home/widgets/popup.dart';
import 'package:stapes_home/core/constants/api_routes.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/common/models.dart';
import 'package:stapes_home/screens/views/floor_room_selector/create_floor_page.dart';
import 'package:stapes_home/screens/views/floor_room_selector/create_room_page.dart';

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

  // Edit floor using API
  void _editFloor(Floor floor) {
    // Implement edit floor functionality
    print('Edit floor: ${floor.alias}');
  }

  // Edit room using API
  void _editRoom(Room room) {
    // Implement edit room functionality
    print('Edit room: ${room.name}');
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, String itemType, String itemId, String itemName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $itemType'),
          content: Text('Are you sure you want to delete $itemName?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
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

  void _showFloorOptions(Floor floor) {
    List<HoldBottomSheet> options = [
      HoldBottomSheet(
        icon: Icons.edit,
        text: 'Edit Floor',
        onTap: () => _editFloor(floor),
      ),
      HoldBottomSheet(
        icon: Icons.delete,
        text: 'Delete Floor',
        onTap: () => _showDeleteConfirmationDialog(
            context, 'Floor', floor.id, floor.alias),
      ),
    ];

    showCustomBottomSheet(context, options);
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
      return Text(errorMessageFloors!,
          style: const TextStyle(color: Colors.red));
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
              // onLongPress: () => _showDeleteConfirmationDialog(context, 'Floor', floor.id, floor.alias),
              onLongPress: () => _showFloorOptions(floor),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showRoomOptions(Room room) {
    List<HoldBottomSheet> options = [
      HoldBottomSheet(
        icon: Icons.edit,
        text: 'Edit Room',
        onTap: () => _editRoom(room),
      ),
      HoldBottomSheet(
        icon: Icons.delete,
        text: 'Delete Room',
        onTap: () =>
            _showDeleteConfirmationDialog(context, 'Room', room.id, room.name),
      ),
    ];

    showCustomBottomSheet(context, options);
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
      return Text(errorMessageRooms!,
          style: const TextStyle(color: Colors.red));
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
              // onLongPress: () => _showDeleteConfirmationDialog(context, 'Room', room.id, room.name),
              onLongPress: () => _showRoomOptions(room),
            ),
          );
        }).toList(),
      ),
    );
  }
}
