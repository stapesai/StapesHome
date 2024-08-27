import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/screens/views/common/create_floor_page.dart';
import 'package:StapesHome/screens/views/common/create_room_page.dart';

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
  FloorRoomSelectorState  createState() => FloorRoomSelectorState();
}

class FloorRoomSelectorState extends State<FloorRoomSelector> {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Floor> floors = [];
  List<Room> rooms = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFloors();
  }

  Future<void> refreshData() async {
    await _fetchFloors();
  }

  // Fetch floors from the API
  Future<void> _fetchFloors() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
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
        floors = floorsData
            .map((floor) => Floor(
                  id: floor['id'],
                  level: floor['level'],
                  alias: floor['alias'],
                ))
            .toList();

        // Fetch rooms for the initially active floor
        if (floors.isNotEmpty) {
          setActiveFloor(floors.first.id);
        }
      } else {
        throw Exception('Failed to load floors: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching floors: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch rooms for a specific floor
  Future<void> _fetchRooms(String floorId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
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
        rooms = roomsData
            .map((room) => Room(
                  id: room['id'],
                  floorId: room['floor_id'],
                  name: room['name'],
                  type: room['type'],
                ))
            .toList();
      } else {
        throw Exception('Failed to load rooms: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching rooms: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Set the active floor and fetch its rooms
  void setActiveFloor(String floorId) {
    widget.onFloorSelected(floorId);
    setState(() {
      activeFloorId = floorId;
    });
    widget.onRoomSelected('');
    rooms = [];
    _fetchRooms(floorId);
  }

  // Set the active room by ID
  void setActiveRoom(String roomId) {
    setState(() {
      activeRoomId = roomId;
    });
    widget.onRoomSelected(roomId);
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
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (errorMessage != null) {
      return Text(errorMessage!, style: const TextStyle(color: Colors.red));
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
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (errorMessage != null) {
      return Text(errorMessage!, style: const TextStyle(color: Colors.red));
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
