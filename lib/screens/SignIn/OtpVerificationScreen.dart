import 'package:flutter/material.dart';
// import 'OtpVerificationSuccessScreen.dart'; // Import the OTP success screen
// import 'OtpVerificationErrorScreen.dart'; // Import the OTP error screen
import 'package:flutter/services.dart'; // Import for TextInputFormatter

class OtpVerificationScreen extends StatefulWidget {
  final String transactionId;
  final String email; // Add email parameter
  final VoidCallback onSuccess;
  final VoidCallback onError;

  OtpVerificationScreen({
    required this.transactionId,
    required this.email, // Add email parameter
    required this.onSuccess,
    required this.onError,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161622), // Use your primary color here
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40.0),
            _buildOtpFields(context), // Pass context to _buildOtpFields
            const SizedBox(height: 20.0),
            const Text(
              'Your code will expire in X seconds',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Assume OTP verification logic here
                bool isOtpCorrect =
                    verifyOtp(); // Change this based on actual OTP logic

                if (isOtpCorrect) {
                  widget.onSuccess();
                } else {
                  widget.onError();
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

  Widget _buildOtpFields(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return Expanded(
          child: RawKeyboardListener(
            focusNode: FocusNode(), // Unique focus node for RawKeyboardListener
            onKey: (event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: const Color(0xFF161622),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Color(0xFFFFA404), width: 1.0),
              ),
              child: Center(
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0, // Larger font size to cover the box
                    fontWeight: FontWeight.bold, // Thicker text
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: EdgeInsets
                        .zero, // Set padding to zero to center text and cursor
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF161622),
                  ),
                  onChanged: (value) {
                    if (value.length == 1 && index < 5) {
                      FocusScope.of(context)
                          .requestFocus(_focusNodes[index + 1]);
                    }
                  },
                  onSubmitted: (value) {
                    if (index < 5) {
                      FocusScope.of(context)
                          .requestFocus(_focusNodes[index + 1]);
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  bool verifyOtp() {
    // Add your OTP verification logic here
    // For example, compare the entered OTP with the actual OTP
    // Return true if correct, false otherwise
    return true; // Placeholder, change based on actual logic
  }
}

void main() {
  runApp(MaterialApp(
    home: OtpVerificationScreen(
        transactionId: 'example-transaction-id',
        email: 'example-email@example.com',
        onSuccess: () {},
        onError: () {}),
  ));
}
