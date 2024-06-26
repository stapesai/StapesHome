// floor_room_selector.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jarvis/Cache/sessions_model.dart';
import 'package:jarvis/Cache/HiveService.dart';

class FloorRoomSelector extends StatefulWidget {
  final Function(String) onFloorSelected;
  final Function(int) onRoomSelected;

  const FloorRoomSelector({
    required this.onFloorSelected,
    required this.onRoomSelected,
  });

  @override
  _FloorRoomSelectorState createState() => _FloorRoomSelectorState();
}

class _FloorRoomSelectorState extends State<FloorRoomSelector> {
  String activeFloorId = '';
  int activeRoomIndex = -1;
  List<Map<String, dynamic>> floors = [];
  List<String> rooms = [];

  final HiveService hiveService = HiveService();
  String sessionId = '';
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    var sessions = await hiveService.getBoxes<SessionsModel>("SessionBox");
    if (sessions.isNotEmpty) {
      var session = sessions.first;
      sessionId = session.sessionId;
      userId = session.userId;
      _fetchFloors();
    }
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
            SizedBox(width: 8),
            AddCircleButton(),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: floors.map((floor) {
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloorRoomButton(
                label: floor['label'],
                isActive: activeFloorId == floor['id'],
                onTap: () => setActiveFloor(floor['id']),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Text(
              'Rooms',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(width: 8),
            AddCircleButton(),
          ],
        ),
        SizedBox(height: 8),
        Row(
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
      ],
    );
  }
}

class AddCircleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF3F3F63),
      ),
      child: Icon(Icons.add, color: Colors.white, size: 14),
    );
  }
}

class FloorRoomButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const FloorRoomButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
