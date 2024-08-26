import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/input_fields.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

class CreateRoomPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final String sessionId;
  final String userId;
  final String floorId;

  CreateRoomPage({
    super.key,
    required this.sessionId,
    required this.userId,
    required this.floorId,
  });

  Future<void> _createRoom(BuildContext context) async {
    final String name = nameController.text;
    final String type = typeController.text;

    if (name.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid room details')),
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room created successfully')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create room')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2B),
      appBar: AppBar(
        title: const Text('Create a new room'),
        backgroundColor: const Color(0xFF1C1C2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NTextField(
              hintText: 'Eg: Parent’s room',
              controller: nameController,
            ),
            const SizedBox(height: 16),
            NTextField(
              hintText: 'Room type',
              controller: typeController,
            ),
            const SizedBox(height: 24),
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
