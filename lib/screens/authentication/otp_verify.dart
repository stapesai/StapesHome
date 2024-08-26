import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
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
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  late int _remainingSeconds;
  late Timer _timer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.time.difference(DateTime.now()).inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && mounted) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        setState(() {
          // Enable resend button when timer expires
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
    setState(() {
      _isLoading = true;
    });
    String otp = _controllers.map((controller) => controller.text).join();
    var url = Uri.https('auth.jarvishome.in', '/auth/verify_otp');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
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
    setState(() {
      _isLoading = false;
    });
  }

  String _RemainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;

    String minuteString = minutes > 0 ? '$minutes min' : '';
    String secondString = seconds > 0 ? '$seconds sec' : '';
    return '$minuteString $secondString';
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: AppColor.whiteColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF292B30), Color(0xFF26272C), Color(0xFF1A1B1E)],
        ),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.white, width: 2),
    );
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColor.whiteColor,
              ))
            : Scaffold(
                backgroundColor: Colors.transparent, // Use your primary color here
                body: Container(
                  child: Stack(
                    children: [
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
                              Pinput(
                                length: 6,
                                showCursor: false,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: focusedPinTheme,
                                focusNode: _focusNodes[0],
                                controller: _controllers[0],
                                onChanged: (String value) {
                                  if (value.length == 1) {
                                    _focusNodes[1].requestFocus();
                                  }
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Your verification code will expire in ${_RemainingTime()} ',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 250,
                              ),
                              CustomButton(text: "Next", onPressed: verifyOtp)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )));
  }
}
