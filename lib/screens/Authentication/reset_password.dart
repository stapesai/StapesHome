import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/TextField.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

import 'ErrorScreens/otp_verify_error.dart';
import 'otp_verify.dart'; // Import the OTP verification screen
import 'SuccessScreens/otp_verify_success.dart'; // Import the OTP success screen

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
    return Scaffold(
      backgroundColor: const Color(0xFF161622),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40.0),
            const Text(
              'Reset Your Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            CustomTextField(
              hintText: 'New Password',
              icon: Icons.lock,
              controller: passWord,
            ),
            const SizedBox(height: 20.0),
            CustomTextField(
              hintText: 'Confirm Password',
              icon: Icons.lock,
              controller: confirmPassWord,
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Continue',
              onPressed: () async {
                var url = Uri.https(
                    'auth.jarvishome.in', '/auth/reset-password/request-reset');
                var response = await http.post(
                  url,
                  headers: {
                    'Content-Type': 'application/json',
                    'accept': 'application/json'
                  },
                  body: jsonEncode({
                    'email': email,
                  }),
                );
                // print(response.body);
                if (response.statusCode == 200 &&
                    passWord.text == confirmPassWord.text) {
                  var responseBody = json.decode(response.body);
                  String transactionId = responseBody['transaction_id'];
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpVerificationScreen(
                          transactionId: transactionId,
                          time: DateTime.parse(responseBody["otp_expires_at"]),
                          onSuccess: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtpVerificationSuccessScreen(
                                  transactionId: transactionId,
                                ),
                              ),
                            );
                          },
                          onError: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OtpVerificationErrorScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                } else if (passWord.text != confirmPassWord.text ||
                    passWord.text.isEmpty ||
                    confirmPassWord.text.isEmpty) {

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Passwords do not match')),
                    );
                    Navigator.pop(context, true);
                  }
                } else {

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to reset password: ${response.statusCode}")),
                    );
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
