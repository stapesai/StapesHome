import 'package:flutter/material.dart';
import 'ConfirmPasswordPage.dart'; // Ensure the import is correct
import '../../Widgets/CircularImagePicker.dart'; // Import the CircularImagePicker widget
import '../../Widgets/TextField.dart'; // Import the CustomTextField widget
import '../../Widgets/Button.dart'; // Import the CustomButton widget

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircularImagePicker(), // Use the CircularImagePicker widget
            const SizedBox(height: 20.0),
            const Text(
              'Sign Up',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            CustomTextField(hintText: 'First Name'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(hintText: 'Last Name'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(hintText: 'Date of Birth'), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPasswordPage(),
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
