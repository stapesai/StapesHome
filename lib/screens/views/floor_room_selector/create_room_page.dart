import 'dart:convert';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/input/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/widgets/button.dart';

class CreateRoomPage extends StatefulWidget {
  final String sessionId;
  final String userId;
  final String floorId;

  const CreateRoomPage({
    super.key,
    required this.sessionId,
    required this.userId,
    required this.floorId,
  });

  @override
  createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  bool _isLoading = false;

  Future<void> _createRoom(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });

    final String name = nameController.text;
    final String type = typeController.text;

    if (name.isEmpty || type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid room details')),
      );
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
      return;
    }

    final response = await http.post(
      BackendRoutes.createRoom,
      headers: {
        'accept': 'application/json',
        'X-User-Id': widget.userId,
        'X-Session-Id': widget.sessionId,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'floor_id': widget.floorId,
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

    setState(() {
      _isLoading = false; // Stop loading indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ),
                )
              : SafeArea(
                  child: Padding(
                    padding: AppPadding.pagePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height * 0.05),
                        SizedBox(
                          child: Text(
                            'Create a new room',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: AppFontSizes.pageHeading,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        SizedBox(
                          child: Text(
                            'Enter the details for creating a new room.',
                            style: TextStyle(
                              color: AppColor.whiteColor,
                              fontSize: AppFontSizes.pageSubHeading,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        NTextField(
                          hintText: 'Room Name',
                          controller: nameController,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        NTextField(
                          hintText: 'Room type',
                          controller: typeController,
                        ),
                        const Spacer(),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          margin: EdgeInsets.only(
                            bottom: keyboardHeight > 0
                                ? keyboardHeight + screenSize.height * 0.02
                                : screenSize.height * 0.1,
                          ),
                          child: Center(
                            child: CustomButton(
                              text: "Create",
                              onPressed: () => _createRoom(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
