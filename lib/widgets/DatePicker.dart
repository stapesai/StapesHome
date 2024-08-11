import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
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

    // if (pickedFile != null) {
    //   File?? croppedFile = await ImageCropper().cropImage(
    //     sourcePath: pickedFile.path,
    //     aspectRatioPresets: [
    //       CropAspectRatioPreset.square,
    //     ],
    //     androidUiSettings: const AndroidUiSettings(
    //       toolbarTitle: 'Crop Image',
    //       toolbarColor: Colors.deepOrange,
    //       toolbarWidgetColor: Colors.white,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: true,
    //     ),
    //     iosUiSettings: const IOSUiSettings(
    //       minimumAspectRatio: 1.0,
    //     ),
    //   );

    //   if (croppedFile != null) {
    //     setState(() {
    //       _image = croppedFile;
    //     });
    //   }
    // }
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
            bottom: 4, // Adjust the position as needed
            right: 4, // Adjust the position as needed
            child: InkWell(
              onTap: _pickImage,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white, // Background color of the circle
                child: Icon(
                  Icons.edit,
                  color: Colors.orange,
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
