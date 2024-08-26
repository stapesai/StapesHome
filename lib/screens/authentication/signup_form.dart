import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/constants/colors.dart';

class SignupForm extends StatelessWidget {
  final TextEditingController first_name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController gender = TextEditingController();

  SignupForm({
    super.key,
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
                                          color: AppColor.whiteColor,
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
                                          color: AppColor.whiteColor,
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
                                      controller: first_name,
                                    ),
                                    SizedBox(height: 20),
                                    NTextField(
                                      hintText: 'Last Name',
                                      controller: last_name,
                                    ),
                                    SizedBox(height: 20),
                                    NTextField(
                                      hintText: 'Date of Birth',
                                      controller: dob,
                                    ),
                                    SizedBox(height: 20),
                                    NTextField(
                                      hintText: 'Gender',
                                      controller: gender,
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                                    CustomButton(
                                        text: "Done",
                                        onPressed: () {
                                          // handleSignup(context);
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
