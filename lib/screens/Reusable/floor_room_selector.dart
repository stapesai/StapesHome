import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jarvis/screens/Reusable/create_room_page.dart'; // Import CreateRoomPage
import 'package:jarvis/screens/Reusable/create_floor_page.dart'; // Import CreateFloorPage

class FloorRoomSelector extends StatefulWidget {
  final Function(String) onFloorSelected;
  final Function(int) onRoomSelected;
  final VoidCallback onAddFloor;
  final String sessionId;
  final String userId;
  final String activeFloorId;

  const FloorRoomSelector({super.key, 
    required this.onFloorSelected,
    required this.onRoomSelected,
    required this.onAddFloor,
    required this.sessionId,
    required this.userId,
    required this.activeFloorId,
  });

  @override
  _FloorRoomSelectorState createState() => _FloorRoomSelectorState(
        sessionId: sessionId,
        userId: userId,
        activeFloorId: activeFloorId,
      );
}

class _FloorRoomSelectorState extends State<FloorRoomSelector> {
  String activeFloorId;
  int activeRoomIndex = -1;
  List<Map<String, dynamic>> floors = [];
  List<String> rooms = [];
  final String sessionId;
  final String userId;

  _FloorRoomSelectorState({
    required this.sessionId,
    required this.userId,
    required this.activeFloorId,
  });

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    _fetchFloors();
  }

  Future<void> _fetchFloors() async {
    final url = Uri.https('backend.jarvishome.in', '/floors');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'X-User-Id': userId,
        'X-Session-Id': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> floorsData = json.decode(response.body);
      setState(() {
        floors = floorsData
            .map((floor) => {
                  'id': floor['id'],
                  'label': floor['alias'] != null && floor['alias'].isNotEmpty
                      ? floor['alias']
                      : 'Floor ${floor['level']}'
                })
            .toList();
      });
    } else {
      // Handle error
      print('Failed to load floors: ${response.statusCode}');
    }
  }

  Future<void> _fetchRooms(String floorId) async {
    final url = Uri.https('backend.jarvishome.in', '/rooms/$floorId');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'X-User-Id': userId,
        'X-Session-Id': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> roomsData = json.decode(response.body);
      setState(() {
        rooms = roomsData.map((room) => room['name'] as String).toList();
      });
    } else {
      // Handle error
      print('Failed to load rooms: ${response.statusCode}');
    }
  }

  Future<void> _deleteFloor(String floorId) async {
    print(floorId);
    final url = Uri.https('backend.jarvishome.in', '/floors/$floorId');
    final response = await http.delete(
      url,
      headers: {
        'accept': '*/*',
        'X-User-Id': userId,
        'X-Session-Id': sessionId,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Floor deleted successfully')),
      );
      _fetchFloors();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete floor')),
      );
    }
    print(response.body);
  }

  void setActiveFloor(String floorId) {
    setState(() {
      activeFloorId = floorId;
      activeRoomIndex = -1; // Reset active room when a new floor is selected
      rooms = [];
    });
    _fetchRooms(floorId);
    widget.onFloorSelected(floorId);
  }

  void setActiveRoom(int roomIndex) {
    setState(() {
      activeRoomIndex = roomIndex;
    });
    widget.onRoomSelected(roomIndex);
  }

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
          sessionId: sessionId,
          userId: userId,
          floorId: activeFloorId,
        ),
      ),
    ).then((_) {
      // Refresh rooms after navigating back
      _fetchRooms(activeFloorId);
    });
  }

  void navigateToCreateFloor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateFloorPage(
          sessionId: sessionId,
          userId: userId,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh floors after navigating back if a floor was added
        _fetchFloors();
      }
    });
  }

  void showDeleteDialog(BuildContext context, String floorId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Floor"),
          content: const Text("Are you sure you want to delete this floor?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFloor(floorId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Floors',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            AddCircleButton(onPressed: () => navigateToCreateFloor(context)),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: floors.map((floor) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onLongPress: () => showDeleteDialog(context, floor['id']),
                  child: FloorRoomButton(
                    label: floor['label'],
                    isActive: activeFloorId == floor['id'],
                    onTap: () => setActiveFloor(floor['id']),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text(
              'Rooms',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            AddCircleButton(onPressed: () => navigateToCreateRoom(context)),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: rooms.asMap().entries.map((entry) {
              int idx = entry.key;
              String room = entry.value;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FloorRoomButton(
                  label: room,
                  isActive: activeRoomIndex == idx,
                  onTap: () => setActiveRoom(idx),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class AddCircleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AddCircleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3F3F63),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 14),
      ),
    );
  }
}

class FloorRoomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloorRoomButton({super.key, 
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
          if (isActive)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
