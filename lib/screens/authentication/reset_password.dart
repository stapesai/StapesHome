import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/text_field.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/constants/colors.dart';

import 'error_screens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP verification screen
import 'success_screens/otp_verify_success.dart'; // Import the OTP success screen

class ResetPassword extends StatelessWidget {
  final String email;
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassWord = TextEditingController();

  ResetPassword({
    super.key,
    required this.email,
  });

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
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                    child: Stack(children: [
                  Positioned(
                      left: 20,
                      top: 90,
                      right: 340,
                      child: Container(
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                                width: double.infinity,
                                
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'Create Password',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 44,
                                            fontFamily: 'Ubuntu',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      )
                                    ]))
                          ])))
                ])))));
  }
}
