import 'package:flutter/material.dart';
import 'OtpVerificationSuccessScreen.dart'; // Import the OTP success screen
import 'OtpVerificationErrorScreen.dart'; // Import the OTP error screen

class OtpVerificationScreen extends StatelessWidget {
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
            const SizedBox(height: 40.0),
            const Text(
              'Enter the 6-digit verification code sent to your email.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40.0),
            _buildOtpFields(),
            const SizedBox(height: 20.0),
            const Text(
              'Your code will expire in X seconds',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Assume OTP verification logic here
                bool isOtpCorrect =
                    verifyOtp(); // Change this based on actual OTP logic

                if (isOtpCorrect) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerificationSuccessScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtpVerificationErrorScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Container(
          width: 40.0,
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white24,
            ),
            style: const TextStyle(color: Colors.white, fontSize: 24.0),
          ),
        );
      }),
    );
  }

  bool verifyOtp() {
    // Add your OTP verification logic here
    // For example, compare the entered OTP with the actual OTP
    // Return true if correct, false otherwise
    return false; // Placeholder, change based on actual logic
  }
}
