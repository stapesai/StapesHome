import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/screens/authentication/signup_form.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/constants/colors.dart';

class CreatePassword extends StatelessWidget {
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassWord = TextEditingController();

  CreatePassword({
    super.key,
  });

  Future<void> checkPassword(String password, BuildContext context) async {
    var url = Uri.https('auth.jarvishome.in', '/check/password');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupForm(),
          ),
        );
      }
    } else {
      // Password is incorrect, show SnackBar with the error message
      var responseBody = json.decode(response.body);

      String errorMessage = responseBody['detail'] ?? 'Unknown error occurred';

      // Show the error message in a SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
          ),
        );
      }
    }
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
                                        'Create Password',
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
                                        'Let’s create a password to secure your account.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    PasswordTextField(
                                      hintText: 'Password',
                                      controller: passWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 20),
                                    PasswordTextField(
                                      hintText: 'Confirm Password',
                                      controller: confirmPassWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 330),
                                    CustomButton(
                                      text: "Continue",
                                      onPressed: () {
                                        if (passWord.text == confirmPassWord.text) {
                                          checkPassword(passWord.text, context);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Passwords do not match'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
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

// Reset Password

class ResetPassword extends StatelessWidget {
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassWord = TextEditingController();

  ResetPassword({
    super.key,
  });

  Future<void> checkPassword(String password, BuildContext context) async {
    var url = Uri.https('auth.jarvishome.in', '/check/password');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
      body: jsonEncode({
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignupForm(),
          ),
        );
      }
    } else {
      // Password is incorrect, show SnackBar with the error message
      var responseBody = json.decode(response.body);

      String errorMessage = responseBody['detail'] ?? 'Unknown error occurred';

      // Show the error message in a SnackBar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
          ),
        );
      }
    }
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
                                        'Reset Password',
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
                                        'Enter your email to receive verification code.',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    PasswordTextField(
                                      hintText: 'Password',
                                      controller: passWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 20),
                                    PasswordTextField(
                                      hintText: 'Confirm Password',
                                      controller: confirmPassWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 330),
                                    CustomButton(
                                      text: "Continue",
                                      onPressed: () {
                                        if (passWord.text == confirmPassWord.text) {
                                          checkPassword(passWord.text, context);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Passwords do not match'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
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
