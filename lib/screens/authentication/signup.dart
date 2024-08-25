import 'dart:convert';
import 'package:jarvis/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/input_fields.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:jarvis/screens/authentication/password.dart';
import 'error_screens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP verification screen
import 'success_screens/otp_verify_success.dart'; // Import the OTP success screen

class EmailSignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  EmailSignUp({super.key});

  Future<void> handleSignup(BuildContext context) async {
    // setState(() {
    //   _isLoading = true; // Start loading indicator
    // });
    var url = Uri.https('auth.jarvishome.in', '/auth/signup/request-signup');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: jsonEncode({
        'email': emailController.text,
      }),
    );
    var responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      String transactionId = responseBody['transaction_id'];
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(
              transactionId: transactionId,
              time: DateTime.parse(responseBody["otp_expires_at"]),
              onSuccess: () async {
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(),
                    ),
                  );
                } else {
                  print('Error :  ${responseBody} ');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Error : ${response.statusCode} - ${responseBody["detail"]} '),
                      ),
                    );
                  }
                }
              },
              onError: () {
                print('Error :  ${responseBody["detail"]} ');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OtpVerificationErrorScreen(),
                  ),
                );
              },
            ),
          ),
        );
      }
    } else {
      if (context.mounted) {
        print('Error :  ${responseBody["detail"]} ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Error : ${response.statusCode} - ${responseBody["detail"]} '),
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
                                    SizedBox(height: 40),
                                    NTextField(
                                      hintText: 'Enter your email',
                                      controller: emailController,
                                      icon: Icons.email_rounded,
                                    ),
                                    SizedBox(height: 330),
                                    CustomButton(
                                        text: "Send Code",
                                        onPressed: () {
                                          handleSignup(context);
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
