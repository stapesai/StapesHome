import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Widgets/TextField.dart'; // Import the CustomTextField widget
import '../../Widgets/Button.dart'; // Import the CustomButton widget
import 'package:jarvis/Cache/sessions_model.dart';
import 'package:jarvis/Cache/HiveService.dart';

class AddNewDevice extends StatefulWidget {
  @override
  _AddNewDeviceState createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  String? _selectedType;
  String? _selectedFloor;
  String? _selectedRoom;

  final List<String> _types = ['Type 1', 'Type 2', 'Type 3'];
  List<String> _floors = [];
  final List<String> _rooms = ['Room 1', 'Room 2', 'Room 3'];

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
        _floors = floorsData.map((floor) => 'Floor ${floor['level']}').toList();
      });
    } else {
      // Handle error
      print('Failed to load floors: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Add new device',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_right_alt,
                  size: 40,
                  color: Color(0xFFFFA500),
                ),
              ],
            ),
            SizedBox(height: 32),
            CustomTextField(
              hintText: 'Name',
            ),
            SizedBox(height: 16),
            CustomTextField(
              hintText: 'Channel Id',
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
                labelStyle: TextStyle(
                  color: Color(0xFFFFA500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedType,
              items: _types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue;
                });
              },
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Floor',
                labelStyle: TextStyle(
                  color: Color(0xFFFFA500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedFloor,
              items: _floors.map((String floor) {
                return DropdownMenuItem<String>(
                  value: floor,
                  child: Text(floor),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedFloor = newValue;
                });
              },
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Room',
                labelStyle: TextStyle(
                  color: Color(0xFFFFA500),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFA500),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              value: _selectedRoom,
              items: _rooms.map((String room) {
                return DropdownMenuItem<String>(
                  value: room,
                  child: Text(room),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedRoom = newValue;
                });
              },
              style: TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
            ),
            SizedBox(height: 32),
            CustomButton(
              text: 'Create',
              onPressed: () {
                // Handle button press
              },
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Need Help?',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
