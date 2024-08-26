import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jarvis/utils/hive.dart';
import 'package:jarvis/utils/sessions_model.dart';

import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/constants/colors.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/constants/api_routes.dart';
import 'package:jarvis/screens/routes/main.dart';

class SignupForm extends StatefulWidget {
  final String passWord;
  final String email;
  final TextEditingController first_name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final String transaction_id;
  SignupForm({
    super.key,
    required this.passWord,
    required this.transaction_id,
    required this.email,
  });

  @override
  createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _isLoading = false;
  final HiveService hiveService = HiveService();

  Future<void> handleSignup(
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
          "password": widget.passWord,
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
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColor.whiteColor,
              ))
            : Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                    child: Stack(
                  children: [
                    Positioned(
                        left: 10,
                        top: 90,
                        right: 0,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(horizontal: 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 44,
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 380,
                                          child: Text(
                                            'Please enter your personal details..',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.w400,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.1 / 2),
                                        NTextField(
                                          hintText: 'First Name',
                                          controller: widget.first_name,
                                        ),
                                        SizedBox(height: 20),
                                        NTextField(
                                          hintText: 'Last Name',
                                          controller: widget.last_name,
                                        ),
                                        SizedBox(height: 20),
                                        NTextField(
                                          hintText: 'Date of Birth',
                                          controller: widget.dob,
                                        ),
                                        SizedBox(height: 20),
                                        NTextField(
                                          hintText: 'Gender',
                                          controller: widget.gender,
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                                        CustomButton(
                                            text: "Done",
                                            onPressed: () {
                                              handleSignup(context, widget.email, widget.first_name.text,
                                                  widget.last_name.text, widget.dob.text, widget.gender.text);
                                            }),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ))
                  ],
                ))));
  }
}
