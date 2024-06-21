import 'package:flutter/material.dart';
import 'OtpVerificationSuccessScreen.dart'; // Import the OTP success screen
import 'OtpVerificationErrorScreen.dart'; // Import the OTP error screen
import 'package:flutter/services.dart'; // Import for TextInputFormatter
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpVerificationScreen extends StatefulWidget {
  final String transactionId; // Add transactionId parameter

  OtpVerificationScreen({required this.transactionId});

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

  Future<bool> verifyOtp() async {
    String otp = _controllers.map((controller) => controller.text).join();
    var url = Uri.https('auth.jarvishome.in', '/auth/verify_otp');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json'
      },
      body: jsonEncode({
        'transaction_id': widget.transactionId,
        'code': otp,
      }),
    );
    print(response.body);
    print(widget.transactionId);

    if (response.statusCode == 200) {
      var sessionUrl =
          Uri.https('auth.jarvishome.in', '/auth/login/complete-login');
      var sessionResponse = await http.post(sessionUrl,
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json'
          },
          body: jsonEncode({
            'transaction_id': widget.transactionId,
          }));
      print(sessionResponse.statusCode);
      return sessionResponse.statusCode == 200;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.primaryColour, // Use your primary color here
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
              onPressed: () async {
                bool isOtpCorrect = await verifyOtp();

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
                color: Colors.primaryColour,
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
                    fillColor: Colors.primaryColour,
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
}

void main() {
  runApp(MaterialApp(
    home: OtpVerificationScreen(transactionId: 'your_transaction_id_here'),
  ));
}
