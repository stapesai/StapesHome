import 'package:flutter/material.dart';
import 'SignedUpSuccessfullyPage.dart'; // Import the next screen
import '../../Widgets/TextField.dart'; // Import the CustomTextField widget
import '../../Widgets/Button.dart'; // Import the CustomButton widget

class ConfirmPasswordPage extends StatefulWidget {
  @override
  _ConfirmPasswordPageState createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
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
            CustomTextField(hintText: 'Email ID'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(hintText: 'Password'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(
                hintText: 'Confirm Password'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Sign Up',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignedUpSuccessfullyPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
