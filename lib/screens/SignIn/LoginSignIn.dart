import 'package:flutter/material.dart';
import '../../Widgets/button.dart'; // Import the CustomButton widget
import '../../main.dart'; // Import the HomeScreen
import 'EmailSignUp.dart'; // Import the EmailSignUp screen

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.primaryColour,
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
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    hintText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  CustomButton(
                    text: 'Continue',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
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
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  // const SizedBox(height: 20.0),
                  // _buildSocialButton(
                  //   text: 'Continue with Google',
                  //   color: Colors.black,
                  //   icon: Icons.g_translate,
                  // ),
                  // const SizedBox(height: 10.0),
                  // _buildSocialButton(
                  //   text: 'Continue with Microsoft',
                  //   color: Colors.black,
                  //   // icon: Icons.microsoft,
                  // ),
                  // SizedBox(height: 10.0),
                  // _buildSocialButton(
                  //   text: 'Continue with Apple',
                  //   color: Colors.black,
                  //   icon: Icons.apple,
                  // ),
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
  }) {
    return TextField(
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
