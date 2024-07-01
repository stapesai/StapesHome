import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/TextField.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

import 'ErrorScreens/OtpVerificationErrorScreen.dart';
import 'OtpVerification.dart'; // Import the OTP verification screen
import 'SuccessScreens/OtpVerificationSuccessScreen.dart'; // Import the OTP success screen

class EmailSignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  EmailSignUp({super.key});

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
              'Enter your email to send the verification code.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            CustomTextField(
              hintText: 'Eg: abc@gmail.com',
              icon: Icons.email,
              controller: emailController,
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Continue',
              onPressed: () async {
                var url = Uri.https(
                    'auth.jarvishome.in', '/auth/signup/request-signup');
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
                  // tes
                } else {
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
            ),
          ],
        ),
      ),
    );
  }
}
