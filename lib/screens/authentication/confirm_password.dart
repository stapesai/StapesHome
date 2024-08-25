import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/widgets/input_fields.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

import 'success_screens/signup_success.dart'; // Import the next screen

class ConfirmPasswordPage extends StatefulWidget {
  final String transactionId;
  final String firstName;
  final String lastName;
  final String dob;

  const ConfirmPasswordPage({
    super.key,
    required this.transactionId,
    required this.firstName,
    required this.lastName,
    required this.dob,
  });

  @override
  createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40.0),
            const Text(
              'Enter email and password',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            // Use CustomTextField
            const SizedBox(height: 20.0),
            PasswordTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ), // Use CustomTextField
            const SizedBox(height: 20.0),
            PasswordTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obscureText: true,
            ), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Sign Up',
              onPressed: () async {
                if (passwordController.text == confirmPasswordController.text) {
                  var url = Uri.parse(
                      'https://auth.jarvishome.in/auth/signup/complete-signup');
                  var response = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      'accept': 'application/json',
                    },
                    body: jsonEncode({
                      'user': {
                        'email': emailController.text,
                        'first_name': widget.firstName,
                        'last_name': widget.lastName,
                        'dob': widget.dob,
                        'gender': 'Male',
                        // Replace with actual gender from previous screen
                      },
                      'password': passwordController.text,
                      'transaction_id': widget.transactionId,
                    }),
                  );

                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SignedUpSuccessfullyPage(),
                        ),
                      );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Sign up failed: ${response.statusCode}'),
                        ),
                      );
                    }
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match'),
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
