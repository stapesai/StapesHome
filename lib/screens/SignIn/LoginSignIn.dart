import 'package:flutter/material.dart';
import '../../Widgets/button.dart'; // Import the CustomButton widget
import '../../main.dart'; // Import the MainScreen
import 'EmailSignUp.dart'; // Import the EmailSignUp screen
import 'LoginOtpVerification.dart'; // Import the OTP Verification screen
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  // Define your controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.primaryColour, // Set your primary color here
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40.0),
                  const Text(
                    'Welcome to JARVIS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  _buildTextField(
                    hintText: 'Email address',
                    icon: Icons.email,
                    controller: emailController,
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20.0),
                  CustomButton(
                    text: 'Continue',
                    onPressed: () async {
                      var url = Uri.https(
                          'auth.jarvishome.in', '/auth/login/request-login');
                      var response = await http.post(
                        url,
                        headers: {
                          'Content-Type': 'application/json',
                          'accept': 'application/json'
                        },
                        body: jsonEncode({
                          'email': emailController.text,
                          'password': passwordController.text,
                        }),
                      );
                      if (response.statusCode == 200) {
                        var responseBody = json.decode(response.body);
                        String transactionId = responseBody['transaction_id'];
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpVerificationScreen(
                                  transactionId: transactionId)),
                        );
                      } else {
                        print('Login failed');
                        print('Response status: ${response.statusCode}');
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmailSignUp()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildSocialButton({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Updated parameter
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
