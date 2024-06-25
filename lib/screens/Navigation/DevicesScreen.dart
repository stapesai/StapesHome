import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jarvis/Cache/sessions_model.dart';
import 'package:jarvis/Cache/HiveService.dart';
import 'package:jarvis/screens/Additional/AddNewDevice.dart';

class DeviceScreen extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
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
  }

  void setActiveRoom(int roomIndex) {
    setState(() {
      activeRoomIndex = roomIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.primaryColour, // Adjust this color to match your theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Devices',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              SizedBox(height: 24),
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
              SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    DeviceButton(label: 'Bedroom Light'),
                    DeviceButton(label: 'Bedroom Light'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: AddDeviceButton(),
              ),
            ],
          ),
        ),
      ),
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

class DeviceButton extends StatefulWidget {
  final String label;

  const DeviceButton({required this.label});

  @override
  _DeviceButtonState createState() => _DeviceButtonState();
}

class _DeviceButtonState extends State<DeviceButton> {
  bool isActive = false;

  void toggleButton() {
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleButton,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF343450), Color(0xFF161622)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? Colors.orange.shade200
                  : Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 3,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 6),
              blurRadius: 10,
              spreadRadius: -3,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 63,
              height: 63,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isActive
                      ? [Colors.orange.shade700, Colors.orange.shade400]
                      : [Color(0xFF2A2A40), Color(0xFF1C1C2B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(widget.label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class AddDeviceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddNewDevice()),
        );
      },
      child: CustomPaint(
        painter: DashedBorderPainter(),
        child: Container(
          width: 396,
          height: 56,
          decoration: BoxDecoration(
            color: Color(0xFF1C1C2B),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.orange, size: 24),
                SizedBox(height: 4),
                Text(
                  'Add device',
                  style: TextStyle(color: Colors.orange, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5;
    final double dashSpace = 5;
    double startX = 0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(16)));
    final dashPath = Path();
    final pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      final double length = pathMetric.length;
      double distance = 0.0;
      while (distance < length) {
        final double nextDistance = distance + dashWidth;
        dashPath.addPath(
            pathMetric.extractPath(distance, nextDistance), Offset.zero);
        distance = nextDistance + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
