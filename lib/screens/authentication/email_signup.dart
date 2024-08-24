import 'dart:convert';
import 'package:jarvis/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/text_field.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/screens/authentication/reset_password.dart';
import 'error_screens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP verification screen
import 'success_screens/otp_verify_success.dart'; // Import the OTP success screen

class EmailSignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  EmailSignUp({super.key});

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
        child: Scaffold(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1),
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
                                        'Please enter your personal details.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    CustomTextField(
                                        hintText: 'First Name',
                                        controller: emailController),
                                    SizedBox(height: 20),
                                    CustomTextField(
                                        hintText: 'Last Name',
                                        controller: emailController),
                                    SizedBox(height: 20),
                                    CustomTextField(
                                        hintText: 'Date of Birth',
                                        controller: emailController),
                                    SizedBox(height: 20),
                                    CustomTextField(
                                        hintText: 'Gender',
                                        controller: emailController),

                                    SizedBox(height: 40),
                                    CustomButton(text: "Next", onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ResetPassword(email: emailController.text,),
                                        ),
                                      );
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
