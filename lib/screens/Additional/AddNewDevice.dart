import 'package:flutter/material.dart';
import 'package:jarvis/widgets/TextField.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

class AddNewDevice extends StatefulWidget {
  @override
  _AddNewDeviceState createState() => _AddNewDeviceState();
}

class _AddNewDeviceState extends State<AddNewDevice> {
  String? _selectedType;
  String? _selectedFloor;
  String? _selectedRoom;

  final List<String> _types = ['Type 1', 'Type 2', 'Type 3'];
  final List<String> _floors = ['Floor 1', 'Floor 2', 'Floor 3'];
  final List<String> _rooms = ['Room 1', 'Room 2', 'Room 3'];

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
