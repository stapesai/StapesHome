import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widgets/TextField.dart'; // Import the CustomTextField widget
import '../../Widgets/Button.dart'; // Import the CustomButton widget

class CreateRoomPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final String sessionId;
  final String userId;
  final String floorId;

  CreateRoomPage({
    required this.sessionId,
    required this.userId,
    required this.floorId,
  });

  Future<void> _createRoom(BuildContext context) async {
    final String name = nameController.text;
    final String type = typeController.text;

    if (name.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide valid room details')),
      );
      return;
    }

    final url = Uri.https('backend.jarvishome.in', '/rooms');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'X-User-Id': userId,
        'X-Session-Id': sessionId,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'floor_id': floorId,
        'name': name,
        'type': type,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room created successfully')),
      );
      Navigator.pop(context, true); // Return true to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C2B),
      appBar: AppBar(
        title: Text('Create a new room'),
        backgroundColor: Color(0xFF1C1C2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Eg: Parent’s room',
              controller: nameController,
            ),
            SizedBox(height: 16),
            CustomTextField(
              hintText: 'Room type',
              controller: typeController,
            ),
            SizedBox(height: 24),
            CustomButton(
              text: 'Create',
              onPressed: () => _createRoom(context),
            ),
          ],
        ),
      ),
    );
  }
}
