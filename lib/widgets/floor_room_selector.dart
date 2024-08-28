import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    Key? key,
    required this.context,
    required this.onFloorSelected,
    required this.onRoomSelected,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

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
          // setActiveFloor(floors.first.id);
          setActiveFloor(activeFloorId);
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
          // setActiveRoom(rooms.first.id);
          setActiveRoom(activeRoomId);
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
      return const CircularProgressIndicator();
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
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRoomList(double maxWidth) {
    if (isRoomsLoading) {
      return const CircularProgressIndicator();
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PlusButton extends StatelessWidget {
  final VoidCallback onPressed;

  const PlusButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3E3E62),
        ),
        child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
      ),
    );
  }
}

class FloorRoomNameButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloorRoomNameButton({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
