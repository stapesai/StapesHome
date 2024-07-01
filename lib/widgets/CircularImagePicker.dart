import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CircularImagePicker extends StatefulWidget {
  const CircularImagePicker({super.key});

  @override
  createState() => _CircularImagePickerState();
}

class _CircularImagePickerState extends State<CircularImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 86.5, // Half of 173
            backgroundColor: Colors.grey[300],
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? const Icon(Icons.person, size: 86.5, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 20, // Adjust the position as needed
            right: 8, // Adjust the position as needed
            child: InkWell(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 11,
                backgroundColor:
                    Color(0xFFBABABA), // Background color of the circle
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20.0, // Adjust the size as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
