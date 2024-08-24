import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/constants/colors.dart';
import "package:jarvis/widgets/button.dart";

class OtpVerificationScreen extends StatefulWidget {
  final String transactionId;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  final DateTime time;

  const OtpVerificationScreen({
    super.key,
    required this.transactionId,
    required this.onSuccess,
    required this.onError,
    required this.time,
  });

  @override
  createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late int _remainingTime;
  late Timer _timer;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.time.difference(DateTime.now()).inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && mounted) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer.cancel();
        setState(() {
          _isResendEnabled = true; // Enable resend button when timer expires
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer.cancel();

    super.dispose();
  }

  Future<void> verifyOtp() async {
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

    if (response.statusCode == 200) {
      widget.onSuccess();
    } else {
      widget.onError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent, // Use your primary color here
            body: Container(
              child: Stack(
                children: [
                  Positioned(
                      child: IconButton(
                          color: AppColor.whiteColor,
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () => Navigator.pop(context)),
                      top: 50,
                      left: 20),
                  Positioned(
                    top: 150,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 380,
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 380,
                            child: Text(
                              'Enter the verification code sent to your email address.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Ubuntu',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: 50,

                                margin: EdgeInsets.only(
                                    right: index < 6 ? 10 : 0), // Spacing
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment(0.00, -1.00),
                                    end: Alignment(0, 1),
                                    colors: [
                                      Color(0xFF292B30),
                                      Color(0xFF26272C),
                                      Color(0xFF1A1B1E)
                                    ],
                                  ),
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  cursorColor: AppColor.whiteColor,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: TextStyle(
                                      color: AppColor.whiteColor, fontSize: 24),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor.whiteColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor.whiteColor),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColor.whiteColor),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your verification code will expire in $_remainingTime seconds',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 250,
                          ),
                          CustomButton(text: "NEXT", onPressed: verifyOtp)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }
}
