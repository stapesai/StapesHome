// Path: lib/presentation/auth/pages/otp_verification.dart
// Description: This file contains the OTP verification screen UI.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/presentation/auth/cubit/otp_verification_cubit.dart';
import 'package:stapes_home/presentation/auth/states/otp_verification_state.dart';
import 'package:stapes_home/service_locator.dart';
import "package:stapes_home/widgets/button.dart";

class OtpVerificationScreen extends StatefulWidget {
  final String transactionId;
  final VoidCallback onSuccess;
  final DateTime expiryTime;

  const OtpVerificationScreen({
    super.key,
    required this.transactionId,
    required this.onSuccess,
    required this.expiryTime,
  });

  @override
  createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.expiryTime.difference(DateTime.now()).inSeconds;
    _startTimer();
  }

  Future<void> handleverifyOtp(BuildContext context) async {
    String otp = _controllers.map((controller) => controller.text).join();
    context.read<OtpVerificationCubit>().verifyOtp(
          transactionId: widget.transactionId,
          otp: otp,
        );
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
          // TODO: Enable resend button when timer expires
        });
      }
    });
  }

  String _remainingTime() {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;

    String minuteString = minutes > 0 ? '$minutes min' : '';
    String secondString = seconds > 0 ? '$seconds sec' : '';
    return '$minuteString $secondString';
  }

  // void _onOtpComplete(String otp) {
  //   String otp = _controllers.map((controller) => controller.text).join();
  //   print('OTP Submitted: $otp');
  //   handleverifyOtp();
  // }

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
      textStyle:
          TextStyle(fontSize: AppFontSizes.pageSubHeading, color: AppColor.whiteColor, fontWeight: FontWeight.w600),
      margin: EdgeInsets.symmetric(horizontal: screenSize.width > 640 ? 12 : 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: const [Color(0xFF292B30), Color(0xFF26272C), Color(0xFF1A1B1E)],
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
          child: BlocProvider(
            create: (context) => OtpVerificationCubit(
              otpVerificationUsecase: serviceLocator<OtpVerificationUsecase>(),
            ),
            child: BlocListener<OtpVerificationCubit, OtpVerificationState>(
              listener: (context, state) {
                if (state is OtpVerificationSuccess) {
                  widget.onSuccess();
                } else if (state is OtpVerificationError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColor.errorColor,
                    ),
                  );
                } else if (state is OtpVerificationLoading) {}
              },
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Padding(
                      padding: AppPadding.pagePadding(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenSize.height * 0.05),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'OTP Verification',
                              style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: AppFontSizes.pageHeading,
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
                                fontSize: AppFontSizes.pageSubHeading,
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
                                // onCompleted: _onOtpComplete
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          Center(
                            child: Text(
                              'Your verification code will expire in ${_remainingTime()} ',
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
                              child: BlocBuilder<OtpVerificationCubit, OtpVerificationState>(
                                builder: (context, state) {
                                  return CustomButton(
                                    text: "Next",
                                    isLoading: state is OtpVerificationLoading,
                                    onPressed: () => handleverifyOtp(context),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          )),
    );
  }
}
