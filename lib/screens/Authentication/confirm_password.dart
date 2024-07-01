import 'package:flutter/material.dart';
import 'SuccessScreens/SignedUpSuccessfullyPage.dart'; // Import the next screen
import 'package:jarvis/widgets/TextField.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmPasswordPage extends StatefulWidget {
  final String transactionId;
  final String firstName;
  final String lastName;
  final String dob;

  const ConfirmPasswordPage({super.key, 
    required this.transactionId,
    required this.firstName,
    required this.lastName,
    required this.dob,
  });

  @override
  _ConfirmPasswordPageState createState() => _ConfirmPasswordPageState();
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
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(
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
                        'gender':
                            'Male', // Replace with actual gender from previous screen
                      },
                      'password': passwordController.text,
                      'transaction_id': widget.transactionId,
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignedUpSuccessfullyPage(),
                      ),
                    );
                  } else {
                    print('Sign up failed');
                    print('Response status: ${response.statusCode}');
                  }
                } else {
                  print('Passwords do not match');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
