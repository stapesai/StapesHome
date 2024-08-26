import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jarvis/constants/api_routes.dart';
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

  Future<void> handleverifyOtp() async {
    setState(() {
      _isLoading = true;
    });
  
  String otp = _controllers.map((controller) => controller.text).join();
    var response = await http.post(
      AuthRoutes.verifyOtp,
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

  String _RemainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;

    String minuteString = minutes > 0 ? '$minutes min' : '';
    String secondString = seconds > 0 ? '$seconds sec' : '';
    return '$minuteString $secondString';
  }

  void _onOtpComplete(String otp) {
    String otp = _controllers.map((controller) => controller.text).join();
    print('OTP Submitted: $otp');
    handleverifyOtp();
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: AppColor.whiteColor, fontWeight: FontWeight.w600),
      margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF292B30), Color(0xFF26272C), Color(0xFF1A1B1E)],
        ),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.whiteColor, width: 2),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: AppColor.backgroundColorgradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: AppColor.whiteColor,
                  ))
                : SafeArea(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenSize.height * 0.08),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'OTP Verification',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 44,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            SizedBox(
                              child: Text(
                                'Enter the verification code sent to your email address.',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 20,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.04),
                            SizedBox(
                              child: Center(
                                child: Pinput(
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
                                  onCompleted: _onOtpComplete,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            Center(
                              child: Text(
                                'Your verification code will expire in ${_RemainingTime()} ',
                                style: const TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const Spacer(),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              margin: EdgeInsets.only(
                                bottom: keyboardHeight > 0
                                    ? keyboardHeight + screenSize.height * 0.02
                                    : screenSize.height * 0.1,
                              ),
                              child: Center(
                                child: CustomButton(
                                  text: "Next",
                                  onPressed: () => handleverifyOtp(),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
          )),
    );
  }
}
