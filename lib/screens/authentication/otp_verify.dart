import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jarvis/constants/colors.dart';

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
            body:Container(child: Stack(children: [
              Positioned(child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)), top: 50, left: 20),
            ],),)
          ));
  }
}
