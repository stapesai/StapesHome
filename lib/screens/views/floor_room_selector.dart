import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/constants/api_routes.dart';
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/screens/views/create_floor_page.dart';
import 'package:jarvis/screens/views/create_room_page.dart';

class FloorRoomSelector extends StatefulWidget {
  final BuildContext context;
  final Function(String) onFloorSelected;
  final Function(int) onRoomSelected;
  final String sessionId;
  final String userId;
  final String activeFloorId;

  const FloorRoomSelector({
    super.key,
    required this.context,
    required this.onFloorSelected,
    required this.onRoomSelected,
    required this.sessionId,
    required this.userId,
    required this.activeFloorId,
  });

  @override
  createState() => _FloorRoomSelectorState();
}

class _FloorRoomSelectorState extends State<FloorRoomSelector> {
  int activeRoomIndex = -1;
  List<Map<String, dynamic>> floors = [];
  List<String> rooms = [];

  @override
  void initState() {
    super.initState();
    _fetchFloors();
  }

  Future<void> _fetchFloors() async {
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
        if (mounted) {
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
        }

        // Fetch rooms for the initially active floor
        if (floors.isNotEmpty) {
          if (mounted) {
            setActiveFloor(floors.first['id']);
          }
        }
      } else {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load floors: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      // Handle network errors or other exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching floors: $e')),
        );
      }
    }
  }

  Future<void> _fetchRooms(String floorId) async {
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
        setState(() {
          rooms = roomsData.map((room) => room['name'] as String).toList();
        });
      } else {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load rooms: ${response.statusCode}')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching rooms : $e')),
        );
      }
    }
  }

  Future<void> _deleteFloor(String floorId) async {
    try {
      final response = await http.delete(
        BackendRoutes.deleteFloor(floorId),
        headers: {
          'accept': '*/*',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floor deleted successfully')),
          );
          _fetchFloors();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete floor')),
          );
        }
      }
    } catch (e) {
      // Handle network errors or other exceptions
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting floor: $e')),
        );
      }
    }
  }

  void setActiveFloor(String floorId) {
    setState(() {
      widget.onFloorSelected(floorId);
      widget.onRoomSelected(-1); // Reset active room when a new floor is selected
      rooms = [];
    });

    _fetchRooms(floorId);
  }

  void setActiveRoom(int roomIndex) {
    setState(() {
      activeRoomIndex = roomIndex;
    });
    widget.onRoomSelected(roomIndex);
  }

  void navigateToCreateRoom(BuildContext context) {
    if (widget.activeFloorId.isEmpty) {
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
          floorId: widget.activeFloorId,
        ),
      ),
    ).then((_) {
      // Refresh rooms after navigating back
      _fetchRooms(widget.activeFloorId);
    });
  }

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
            AddCircleButton(
              onPressed: () => navigateToCreateFloor(context),
            ),
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
                    isActive: widget.activeFloorId == floor['id'],
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
            AddCircleButton(
              onPressed: () => navigateToCreateFloor(context),
            ),
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
      onTap: () {
        onPressed();
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF3F3F63),
        ),
        child: const Icon(Icons.add, color: AppColor.whiteColor, size: 14),
      ),
    );
  }
}

class FloorRoomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloorRoomButton({
    super.key,
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
                color: AppColor.whiteColor,
              ),
            ),
        ],
      ),
    );
  }
}
