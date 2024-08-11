import 'package:flutter/material.dart';
import 'package:jarvis/widgets/circular_image_picker.dart'; // Import the CircularImagePicker widget
import 'package:jarvis/widgets/text_field.dart'; // Import the CustomTextField widget
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget

import 'confirm_password.dart'; // Ensure the import is correct

class SignUpPage extends StatefulWidget {
  final String transactionId;

  const SignUpPage({super.key, required this.transactionId});

  @override
  createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  DateTime? _selectedDate;

  // Method to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date to today's date
      firstDate: DateTime(1900), // Set the first date the user can pick
      lastDate: DateTime(2101), // Set the last date the user can pick
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
            const CircularImagePicker(), // Use the CircularImagePicker widget
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
            CustomTextField(
              hintText: 'First Name',
              controller: firstNameController,
            ), // Use CustomTextField
            const SizedBox(height: 20.0),
            CustomTextField(
              hintText: 'Last Name',
              controller: lastNameController,
            ), // Use CustomTextField
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () =>
                  _selectDate(context), // Show the date picker when tapped
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: _selectedDate == null
                      ? 'Date of Birth'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
              ),
            ), // Use CustomTextField with date picker
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Continue',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmPasswordPage(
                      transactionId: widget.transactionId,
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      dob: _selectedDate != null
                          ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                          : '',
                    ),
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
