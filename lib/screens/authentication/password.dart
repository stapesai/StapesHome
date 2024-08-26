import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/screens/authentication/signup/details_form.dart';
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/constants/colors.dart';

class PasswordScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget nextScreen;
  final String email;
  final String transaction_id;
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassWord = TextEditingController();

  PasswordScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.email,
    required this.transaction_id,
    required this.nextScreen,
  });

  @override
  createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool _isLoading = false;
  Future<void> checkPassword(String password, BuildContext context, Widget nextScreen) async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.https('auth.jarvishome.in', '/check/password', {
      'password': password,
    });
    var response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen,
          ),
        );
      }
    } else {
      var responseBody = json.decode(response.body);
      String errorMessage = responseBody['detail'] ?? 'Unknown error occurred';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $errorMessage'),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
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
          ? Center(child: CircularProgressIndicator(color: AppColor.whiteColor))
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
                                        widget.title,
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
                                        widget.subtitle,
                                        style: TextStyle(
                                          color: AppColor.whiteColor,
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
                                      controller: widget.passWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 20),
                                    PasswordTextField(
                                      hintText: 'Confirm Password',
                                      controller: widget.confirmPassWord,
                                      icon: Icons.remove_red_eye_outlined,
                                    ),
                                    SizedBox(height: 330),
                                    CustomButton(
                                      text: "Continue",
                                      onPressed: () {
                                        if (widget.passWord.text == widget.confirmPassWord.text) {
                                          checkPassword(
                                              widget.passWord.text,
                                              context,
                                              SignupForm(
                                                passWord: widget.passWord.text,
                                                transaction_id: widget.transaction_id,
                                                email: widget.email,
                                              ));
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
