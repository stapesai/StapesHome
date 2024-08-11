import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/text_field.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

class CreateFloorPage extends StatelessWidget {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final String sessionId;
  final String userId;

  CreateFloorPage({super.key, required this.sessionId, required this.userId});

  Future<void> _createFloor(BuildContext context) async {
    final String alias = aliasController.text;
    final int? level = int.tryParse(levelController.text);

    if (alias.isEmpty || level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid floor details')),
      );
      return;
    }

    final url = Uri.https('backend.jarvishome.in', '/floors');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'X-User-Id': userId,
        'X-Session-Id': sessionId,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'alias': alias,
        'level': level,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Floor created successfully')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create floor')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C2B),
      appBar: AppBar(
        title: const Text('Create a new floor'),
        backgroundColor: const Color(0xFF1C1C2B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              hintText: 'Eg: Parent’s Floor',
              controller: aliasController,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: levelController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C1C2B),
                labelText: 'Floor level',
                labelStyle: const TextStyle(color: Color(0xFFFF9F1C)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF9F1C),
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF9F1C),
                    width: 2.0,
                  ),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create',
              onPressed: () => _createFloor(context),
            ),
          ],
        ),
      ),
    );
  }
}
