import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/utils/hive.dart';
import 'package:StapesHome/utils/sessions_model.dart';
import 'package:StapesHome/widgets/button.dart'; // Import the CustomButton widget
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/widgets/input_fields.dart';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/screens/routes/main.dart';

class SignupForm extends StatefulWidget {
  final String password;
  final String email;
  final TextEditingController first_name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final String transaction_id;
  SignupForm({
    super.key,
    required this.password,
    required this.transaction_id,
    required this.email,
  });

  @override
  createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isLoading = false;
  final HiveService hiveService = HiveService();

  Future<void> handleConfirmSignup(
      BuildContext context, String email, String first_name, String last_name, String dob, String gender) async {
    setState(() {
      _isLoading = true;
    });
    var check_email_response = await http.post(
      AuthRoutes.checkEmail(email),
      headers: {'accept': 'application/json'},
    );
    var check_email_responseBody = json.decode(check_email_response.body);

    if (check_email_response.statusCode == 200) {
      var response = await http.post(
        AuthRoutes.completeSignup,
        headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
        body: jsonEncode({
          "user": {
            "email": email,
            "first_name": first_name,
            "last_name": last_name,
            "dob": dob,
            "gender": gender,
          },
          "password": widget.password,
          "transaction_id": widget.transaction_id,
        }),
      );
      var responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        var sessionData = SessionsModel(
          sessionId: responseBody['session']['session_id'],
          userId: responseBody['session']['user_id'],
          createdAt: DateTime.parse(responseBody['session']['created_at']),
          lastActiveAt: DateTime.parse(responseBody['session']['last_active_at']),
        );

        await hiveService.addBoxes([sessionData], "SessionBox");
        if (context.mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error : ${response.statusCode} - ${responseBody["detail"]} '),
            ),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error : ${check_email_response.statusCode} - ${check_email_responseBody["detail"]} '),
          ),
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
        clipBehavior: Clip.antiAlias,
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
                    padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenSize.height * 0.08),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.pageHeading,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        SizedBox(
                          width: screenSize.width * 0.9,
                          child: Text(
                            'Please enter your personal details.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.pageSubHeading,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        NTextField(
                          hintText: 'First Name',
                          controller: widget.first_name,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        NTextField(
                          hintText: 'Last Name',
                          controller: widget.last_name,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        NTextField(
                          hintText: 'Date of Birth',
                          controller: widget.dob,
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        NTextField(
                          hintText: 'Gender',
                          controller: widget.gender,
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
                              text: "Done",
                              onPressed: () {
                                handleConfirmSignup(
                                  context,
                                  widget.email,
                                  widget.first_name.text,
                                  widget.last_name.text,
                                  widget.dob.text,
                                  widget.gender.text,
                                );
                              },
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
