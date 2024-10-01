import 'dart:convert';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/input/textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:StapesHome/core/api/api_routes.dart';
import 'package:StapesHome/widgets/button.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';

class CreateFloorPage extends StatefulWidget {
  final String sessionId;
  final String userId;

  const CreateFloorPage({super.key, required this.sessionId, required this.userId});

  @override
  _CreateFloorPageState createState() => _CreateFloorPageState();
}

class _CreateFloorPageState extends State<CreateFloorPage> {
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  bool _isLoading = false;

  Future<void> _createFloor(BuildContext context) async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });

    final String alias = aliasController.text;
    final int? level = int.tryParse(levelController.text);

    if (alias.isEmpty || level == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid floor details')),
      );
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
      return;
    }

    final response = await http.post(
      BackendRoutes.createFloor,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'X-User-Id': widget.userId,
        'X-Session-Id': widget.sessionId,
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
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFF353841), Color(0xFF141414)],
          ),
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
                        Text(
                          'Create a new floor',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: AppFontSizes.pageHeading,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Enter the details for creating a new floor.',
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: AppFontSizes.pageSubHeading,
                            fontFamily: 'Ubuntu',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        NTextField(
                          hintText: 'Floor Name',
                          controller: aliasController,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        NTextField(
                          hintText: 'Floor Level',
                          controller: levelController,
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
                              text: 'Create',
                              onPressed: () => _createFloor(context),
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
