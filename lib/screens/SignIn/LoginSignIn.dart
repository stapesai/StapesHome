import 'package:flutter/material.dart';
import 'package:jarvis/widgets/button.dart'; // Import the CustomButton widget
import 'EmailSignUp.dart'; // Import the EmailSignUp screen
import 'OtpVerification.dart'; // Import the OTP Verification screen
import 'package:jarvis/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'OtpVerificationErrorScreen.dart';
import 'package:jarvis/Cache/sessions_model.dart'; // Import your session model
import 'package:jarvis/Cache/HiveService.dart'; // Import your Hive service

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final HiveService hiveService = HiveService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161622), // Set your primary color here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                              transactionId: transactionId,
                              onSuccess: () async {
                                var completeLoginUrl = Uri.https(
                                    'auth.jarvishome.in',
                                    '/auth/login/complete-login');
                                var completeLoginResponse = await http.post(
                                  completeLoginUrl,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'accept': 'application/json'
                                  },
                                  body: jsonEncode({
                                    'transaction_id': transactionId,
                                  }),
                                );

                                if (completeLoginResponse.statusCode == 200) {
                                  var sessionResponseBody =
                                      json.decode(completeLoginResponse.body);
                                  var sessionData = SessionsModel(
                                    sessionId: sessionResponseBody['session']
                                        ['session_id'],
                                    userId: sessionResponseBody['session']
                                        ['user_id'],
                                    ipAddress: sessionResponseBody['session']
                                        ['ip_address'],
                                    createdAt: DateTime.parse(
                                        sessionResponseBody['session']
                                            ['created_at']),
                                    lastActiveAt: DateTime.parse(
                                        sessionResponseBody['session']
                                            ['last_active_at']),
                                  );

                                  await hiveService
                                      .addBoxes([sessionData], "SessionBox");

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainScreen(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OtpVerificationErrorScreen(),
                                    ),
                                  );
                                }
                              },
                              onError: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OtpVerificationErrorScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
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
}
